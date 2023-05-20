-- set role, db, schema
    use role semi_structured_demo;
    use warehouse compute_wh;
    use schema semi_structured_demo.stg;


-- 1) see what the raw data looks like - json
--    note - 1 json object per row since we used "strip_outer_array"
    select $1
    from @s3_stage_json/import/application_log.json
    limit 10;


-- 2) use lateral flatten() to view all of the unique paths in the json
--    use recursive otherwise it will just flatten the top level
--    note - key names are in [brackets] if the key name contains a space
--    order by will "group" related objects together
    select 
        regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"  -- use regex to remove array index to allow for correct grouping
        , count(1) as cnt
    from (
        select $1 as var_data
        from @s3_stage_json/import/application_log.json
    )x ,
    lateral flatten(var_data, recursive => true) y
    group by 1
    order by 1
    ;


-- 3) now that we have an idea of they keys
--    remove the group by to view the values
--    note that some of the values contain arrays or objects rather than simple values 
    select 
        y.*
        -- , is_object(y.value) as is_object
        -- , is_array(y.value) as is_array
    from (
        select $1 as var_data
        from @s3_stage_json/import/application_log.json
    )x ,
    lateral flatten( var_data, recursive => true ) y
;
-- 4) use is_object() to filter out the rows where the value contains other json rather than
--    a simple value.  Note there appears to be sensitive data such as account numbers
    select 
        y.*
    from (
        select $1 as var_data
        from @s3_stage_json/import/application_log.json
    )x ,
    lateral flatten( var_data, recursive => true ) y
    where 
        is_object(y.value) = false  -- use this filter to ignore rows that are not flattened
        and is_array(y.value) = false
    ;

-- 5) create a view and apply data masking to protect sensitive data
-- 5) We can convert this query to a view to make the data easier to use for downstream consumers
create or replace view v_application_log as 
    select 
        y.key :: varchar as key
        , y.value :: varchar as value
        , y.path :: varchar as path
    from (
        select $1 as var_data
        from @s3_stage_json/import/application_log.json
    )x ,
    lateral flatten( var_data, recursive => true ) y
    where 
        is_object(y.value) = false  -- use this filter to ignore rows that are not flattened
        and is_array(y.value) = false
    ;

    create or replace masking policy account_mask
        as (value varchar, key varchar) returns varchar ->
        case
            when is_role_in_session('sensitive_read_only') then value
            else iff(key in ('Account Number', 'Customer ID'), '***', value)
        end
    ;

    alter view v_application_log modify column value 
        set masking policy account_mask using (value, key);

    -- Test the view 
    select * from v_application_log;

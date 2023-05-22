-- set role, db, schema
    use role semi_structured_demo;
    use warehouse compute_wh;
    use schema semi_structured_demo.stg;

/*  Step 1: View raw data 

    Let's see what the raw data looks like - json
    Note the following: 
        1) There's one json object per row since we used "strip_outer_array"
        2) In Snowflake, the JSON is newline delimited (ND) and therefore is easier to read than the non-ND raw file
        3) There appear to be structual differences between the records; not every record follows the same format
 */
    select $1
    from @s3_stage_json/import/application_log.json
    limit 10;

/*  Step 2: View distinct keys

    We will use lateral flatten() to get a distinct list of keys and key paths within the file
    to give us a better idea of what the structure looks like.
    Note the following:
        1) The recursive option of lateral flatten() is set to true.  Otherwise the function
           would only flatten the top level object and not any nested arrays or objects.
        2) Lateral flatten has moved each key onto a separate row, even for nested objects like 
           "Event Details" and arrays like "Recent Txns."
        3) Anything with IS_ARRAY = True is a candidate for normalizing 
        4) Note which records are flagged true for IS_OBJECT and IS_ARRAY; this will be relevant in a later step.
*/
    select 
        count(1) as cnt
        , regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"  -- use regex to remove array index to allow for correct grouping
        , is_object(y.value)
        , is_array(y.value)
    from  @s3_stage_json/import/application_log.json x ,
    lateral flatten( x.$1, recursive => true ) y
    group by 2, 3, 4
    order by 2
    ;

/* Step 4: View flattened data
   
   Now that we have an idea of they keys, we'll remove the group by to view the values.
   Note the following:
     1) The SEQ column indicates the row number in the original file that each row corresponds to.
     2) A row is created for each key/value pair in the outermost object 
*/
    select 
        y.*
        , is_object(y.value) as is_object
        , is_array(y.value) as is_array
    from  @s3_stage_json/import/application_log.json x ,
    lateral flatten( x.$1:"Event Details", recursive => true ) y
    limit 100
;
-- -- 4) use is_object() to filter out the rows where the value contains other json rather than
-- --    a simple value.  Note there appears to be sensitive data such as account numbers
--     select 
--         y.*
--     from (
--         select $1 as var_data
--         from @s3_stage_json/import/application_log.json
--     )x ,
--     lateral flatten( var_data, recursive => true ) y
--     where 
--         is_object(y.value) = false  -- use this filter to ignore rows that are not flattened
--         and is_array(y.value) = false
--     ;
/* Step 5: Create view 
   
   Now that we have an idea of they keys, we can create a view at the grain of the original file.
   This will make the data easier to work with for downstream consumers.
   Note the following:
     1) The SEQ column indicates the row number in the original file that each row corresponds to.
     2) A row is created for each key/value pair in the outermost object 
*/
create or replace view v_application_log as 
    select 
        x.$1:Application :: varchar as Application
        , to_timestamp(x.$1:Date || ' ' || x.$1:Time) as Timestamp
        , x.$1:Username :: varchar as UserName
        , x.$1:"Event Type" :: varchar as EventType
        , x.$1:"Event Details"."Primary Phone"."Previous Value" :: varchar as PhonePreviousValue
        , x.$1:"Event Details"."Primary Phone"."New Value" :: varchar as PhoneNewValue
        , x.$1['Event Details']['Account Type'] :: varchar as AccountType
        , x.$1['Event Details']['Account Number'] :: varchar as AccountNumber
        , x.$1['Event Details']['Recent Txns'] as RecentTxns  -- This is still an array and can be flattened to denormalize the data
   from @s3_stage_json/import/application_log.json x
    ;

    create or replace masking policy account_mask
        as (value varchar, key varchar) returns varchar ->
        case
            when is_role_in_session('sensitive_read_only') then value
            else iff(key in ('Account Number', 'Customer ID'), '***', value)
        end
    ;

    -- alter view v_application_log modify column value 
    --     set masking policy account_mask using (value, key);

    -- Test the view 
    select * 
    from v_application_log
    limit 10

;

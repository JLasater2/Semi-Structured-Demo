use role semi_structured_demo;
use warehouse compute_wh;
use schema semi_structured_demo.stg;

-- see what the raw data looks like - json
select $1
from @s3_stage_json/import/application_log.json;

-- see what the raw data looks like - xml
select $1
from @s3_stage_xml/import/application_log.xml
file_format=(type=xml);



------------------------------------------------------------
-- xml
------------------------------------------------------------
-- Have to cast as varchar for VS Code to work
-- xml
-- create or replace temporary table sample_xml(src variant);

-- copy into sample_xml
-- from @s3_stage_xml/import/application_log.xml
-- file_format = (type=xml /*strip_outer_element = true*/) on_error='continue' ;
-- ;

-- raw xml data; no transformation
select 
    $1::varchar
from  @s3_stage_xml/import/application_log.xml
;

-- Flatten/unpivot the contents of <application_logs> (i.e. move <log> elements to individual rows)
-- This produces one row per <log>; however, there are still attributes within <log>
select 
    log.value :: varchar as raw_data  
 from @s3_stage_xml/import/application_log.xml
    , lateral flatten($1:"$") log 
;

-- Flatten the log record to give each log attribue on its own row
select 
    log.value :: varchar as raw_data       -- raw xml (i.e. the record)
    , log_deets.value :: varchar as raw_flattened_data -- the record flattened/ unpivoted to put a log attribute on every row
    , get(log_deets.value, '@')  :: varchar as flattened_tag_name -- tag name
    , get(log_deets.value, '$')  :: varchar as flattened_content  -- contents of value between tag
from @s3_stage_xml/import/application_log.xml
    , lateral flatten($1:"$") log  -- need this if there is no strip_outer_array; i.e. there is one outer tag
    , lateral flatten(log.value:"$") log_deets  -- unpivots the contents of the <log> tag
;

-- view all of the unique paths in the json
select 
    regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"
    , count(1) as cnt
   -- y.*
from (
    select $1 as var_data
    from @s3_stage/import/application_log.json
)x ,
lateral flatten(var_data, recursive=>true) y
group by 1
;

select 
    regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"
    , count(1) as cnt
   -- y.*
from (
    select $1 as var_data
    from @s3_stage_json/import/fake_nested_data.json
)x ,
lateral flatten(var_data, recursive=>true) y
group by 1
;

------------------------------------------------------------
-- xml
------------------------------------------------------------
-- Have to cast as varchar for VS Code to work
-- raw xml data; no transformation
-- Notice only one row is returned due there only being one 
--     occurance of the outermost tag, <application_logs>

-- See what the raw data looks like 
select 
    $1::varchar
from  @s3_stage_xml/import/application_log.xml
;

-- Flatten/unpivot the contents of <application_logs> (i.e. move <log> elements to individual rows)
-- This produces one row per <log>; however, there are still attributes within <log>
select 
    log.value :: varchar as raw_data  
 from @s3_stage_xml/import/application_log.xml
    , lateral flatten($1:"$", recursive=> true) log 
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

-- Get a distinct list of tags and the # of occurances of each tag
select 
    count(1) 
    , VALUE
 from @s3_stage_xml/import/application_log.xml
    , lateral flatten($1:"$", recursive=> true) log
where log.key = '@'
group by value
;

select 
    log.value :: varchar as raw_data 
    , get(log.value, '@')  :: varchar as flattened_tag_name -- tag name
    , get(log.value, '$')  :: varchar as flattened_tag_name -- tag name
    , log.path :: varchar
 from @s3_stage_xml/import/application_log.xml
    , lateral flatten($1:"$", recursive=> true) log 
;







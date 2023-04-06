use role semi_structured_demo;
use WAREHOUSE compute_wh;
use schema semi_structured_demo.stg;

-- See what the raw data looks like
select $1
from @s3_stage/import/application_log.json;

-- View all of the keys in the JSON

select 
    REGEXP_REPLACE(y.path, '\\[[0-9]+\\]', '[]') AS "Path"
    , count(1) as cnt
   -- y.*
from (
    select TO_VARIANT($1) as var_data
    from @s3_stage/import/application_log.json
)x ,
lateral FLATTEN(var_data, recursive=>true) y
group by 1
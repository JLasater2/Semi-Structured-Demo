use role semi_structured_demo;
use warehouse compute_wh;
use schema semi_structured_demo.stg;

-- see what the raw data looks like
select $1
from @s3_stage/import/application_log.json;

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
    from @s3_stage/import/fake_nested_data.json
)x ,
lateral flatten(var_data, recursive=>true) y
group by 1
;

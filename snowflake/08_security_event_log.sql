--
 select $1
    from @s3_stage_json/import/security_event_log.json
    limit 10;

-- Profile security event log
select 
    regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"  -- use regex to remove array index to allow for correct grouping
    , count(1) as cnt
from (
    select $1 as var_data
    from @s3_stage_json/import/security_event_log.json
)x ,
lateral flatten(var_data, recursive => true) y
group by 1
order by 1
;
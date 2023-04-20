use role semi_structured_demo;
use warehouse compute_wh;
use schema semi_structured_demo.stg;

-- Regular view, mat view, data masking, row access policy
-- Need external table?
-- Could partially expose data and only mask sensitive fields

create or replace view v_application_log as 
    select 
        regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"
    , y.*
    from (
        select $1 as var_data
        from @s3_stage_json/import/application_log.json
    )x ,
    lateral flatten( var_data, recursive => true ) y
    order by seq --path
;

select * 
from v_application_log
;

CREATE OR REPLACE MASKING POLICY acct_no_mask AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '*********'
  END;
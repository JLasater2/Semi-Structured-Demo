
-- Create a parquet file format to query the parquet data in
-- the external stage
create or replace file format ff_parquet
  type = 'PARQUET'
  compression = 'AUTO'
;

-- View raw parquet data 
-- Notice the data looks uniform - no nesting, etc.
-- This type of data is a good candidate for using Snowflake's infer_schema() and template functionality 
-- to automatically structure the data.
SELECT $1
FROM @s3_stage_unformatted/import/security_event_log.parquet
(FILE_FORMAT => ff_parquet)
limit 100
;

-- Use Snowflake's template() and infer_schema() functionality to 
-- automatically structure the parquet data in an external table.
create or replace external table security_event_log_parquet
    using template (
        select array_agg(object_construct(*))
          from table(
            infer_schema(
              location=>'@s3_stage_unformatted/import/security_event_log.parquet'
              , file_format=>'ff_parquet'
            )
        )    
        where filenames = 'snowflake/import/security_event_log.parquet' -- Specify filename since multiple parquet files exist in this location 
    )
    location = @s3_stage_json/import
    file_format = ff_parquet
;

-- View the data
select *
from security_event_log_parquet
limit 100;

-- Would be really useful if we knew where the logins were occurring from...
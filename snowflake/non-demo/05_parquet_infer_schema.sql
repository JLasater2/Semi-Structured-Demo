-- Compare the same data in XML or Parquet format
show stages;
list @s3_stage_unformatted/import/application_log.parquet;

-- create file formats for parquet and xml
create or replace file format ff_parquet
  type = 'PARQUET'
  compression = 'AUTO'
;
create or replace file format ff_xml
    type = 'xml'
     compression = auto 
;

-- parquet
SELECT $1
FROM @s3_stage_unformatted/import/security_event_log.parquet
-- FROM @s3_stage_unformatted/import/application_log.parquet
(FILE_FORMAT => ff_parquet)
limit 100
-- where $1:"Event_Details"."Customer ID" = 'TX-674354928' 
;

-- json
SELECT $1
FROM @s3_stage_json/import/application_log.json
-- where $1:"Event Details"."Account Number" = '1252796893'
;

-- xml
SELECT $1
FROM @s3_stage_json/import/application_log.xml
(FILE_FORMAT => ff_xml)
-- where $1:"Event Details"."Account Number" = '1252796893'
limit 100
;

-- Demonstrate infer schema capability for parquet, avro, and orc
-- Create the table 
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

select * from security_event_log_parquet
limit 100;

select * from v_security_event_log
limit 100;

select 
  *
  from security_event_log_parquet
limit 100;

select 
  --Source_Port, Protocol, Source_IP, Destination_IP, Destination_Port, Action
  *
from v_security_event_log
limit 100;
-- Compare the same data in XML or Parquet format
show stages;
list @s3_stage_unformatted/import/application_log.parquet;

-- create file formats for parquet and xml
CREATE or replace FILE FORMAT ff_parquet
  TYPE = 'PARQUET'
  COMPRESSION = 'AUTO'
;
create or replace file format ff_xml
    type = 'XML'
     COMPRESSION = AUTO 
;

-- parquet
SELECT $1
FROM @s3_stage_unformatted/import/application_log.parquet
(FILE_FORMAT => ff_parquet)
limit 100
-- where $1:"Event_Details"."Customer ID" = 'TX-674354928' 
;

-- json
SELECT $1
FROM @s3_stage_json/import/application_log.json
where $1:"Event Details"."Account Number" = '1252796893'
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
create or replace external table application_log_parquet
    using template (
        select array_agg(object_construct(*))
          from table(
            infer_schema(
              location=>'@s3_stage_json/import'
              , file_format=>'ff_parquet'
            )
        )     
    )
    location = @s3_stage_json/import
    file_format = ff_parquet
;

-- View the data
select 
  *
  , "Event_Details":"Account Number"
  , object_insert("Event_Details", 'Account Number', '***', true)
from application_log_parquet
limit 100;
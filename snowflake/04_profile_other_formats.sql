-- Compare the same data in XML or Parquet format
show stages;
list @s3_stage_unformatted/import/application_log.parquet;

-- create file formats
CREATE or replace FILE FORMAT ff_parquet
  TYPE = 'PARQUET'
  COMPRESSION = 'AUTO'
  -- Add any additional options as needed
;
create or replace file format ff_xml
    type = 'XML'
     COMPRESSION = AUTO 
;

-- parquet
SELECT $1, $1:"Event_Details"."Current Balance"::numeric(15,2)
FROM @s3_stage_unformatted/import/application_log.parquet
(FILE_FORMAT => ff_parquet)
-- where $1:"Event_Details"."Customer ID" = 'TX-674354928'
where $1:"Event_Details"."Account Number" = '1252796893'   
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
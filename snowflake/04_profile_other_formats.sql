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
SELECT $1, $1:"Event_Details"."Current Balance"::numeric(15,2)
FROM @s3_stage_unformatted/import/application_log.parquet
(FILE_FORMAT => ff_parquet)
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
;

-- Try out infer schema - works for parquet, avro, ORC
-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@s3_stage_json/import'
      , FILE_FORMAT=>'ff_parquet'
      )
    );
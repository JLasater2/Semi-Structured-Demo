-- Configure roles/user
use role useradmin;
create or replace role semi_structured_demo;
GRANT ROLE SEMI_STRUCTURED_DEMO TO ROLE SYSADMIN;
grant role semi_structured_demo to user johnlasater2;

-- Setup database 
USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE SEMI_STRUCTURED_DEMO;
GRANT OWNERSHIP ON DATABASE SEMI_STRUCTURED_DEMO TO ROLE SEMI_STRUCTURED_DEMO;
USE ROLE SEMI_STRUCTURED_DEMO;
CREATE OR REPLACE SCHEMA SEMI_STRUCTURED_DEMO.STG;

-- Setup stage
-- Create external stage

-- create or replace stage semi_structured_demo.stg.S3_STAGE 
--     url = 's3://sf-bucket-290/snowflake/'
--     storage_integration = S3_INTEGRATION
--     comment = 'External s3 stage for importing semi-structured data'
--     directory = (enable = true)
--     ;

-- list @s3_stage/import/;
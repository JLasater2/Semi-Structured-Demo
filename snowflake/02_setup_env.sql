-- configure roles/user
use role useradmin;
create or replace role semi_structured_demo;
grant role semi_structured_demo to role sysadmin;
grant role semi_structured_demo to user johnlasater2;

-- setup 
use role accountadmin;
grant usage on integration s3_integration to role semi_structured_demo; 

use role sysadmin;
create or replace database semi_structured_demo;
grant all on database semi_structured_demo to role semi_structured_demo;
grant usage on warehouse compute_wh to role semi_structured_demo;

use role semi_structured_demo;
create or replace schema semi_structured_demo.stg;

-- setup stage
-- create external stage

create or replace stage semi_structured_demo.stg.s3_stage 
    url = 's3://sf-bucket-290/snowflake/'
    storage_integration = s3_integration
    comment = 'external s3 stage for importing semi-structured data'
    directory = (enable = true)
    file_format = (type = json strip_outer_array = true)
    ;

-- show stage properties
desc stage stg.s3_stage;
-- list files available in the stage
list @s3_stage/import/;

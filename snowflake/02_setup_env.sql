-- configure roles/user
use role useradmin;
create or replace role semi_structured_demo;
grant role semi_structured_demo to role sysadmin;
grant role semi_structured_demo to user johnlasater2;

-- setup integration
use role accountadmin;
grant usage on integration s3_integration to role semi_structured_demo; 

-- setup db & warehouse
use role sysadmin;
create or replace database semi_structured_demo;
grant all on database semi_structured_demo to role semi_structured_demo;
grant usage on warehouse compute_wh to role semi_structured_demo;

-- setup schema
use role semi_structured_demo;
create or replace schema semi_structured_demo.stg;

-- setup stage
create or replace stage semi_structured_demo.stg.s3_stage_json
    url = 's3://sf-bucket-290/snowflake/'
    storage_integration = s3_integration
    comment = 'external s3 stage for importing semi-structured data'
    directory = (enable = true)
    file_format = (type = json strip_outer_array = true file_extension = '.json')
    ;

create or replace stage semi_structured_demo.stg.s3_stage_xml
    url = 's3://sf-bucket-290/snowflake/'
    storage_integration = s3_integration
    comment = 'external s3 stage for importing semi-structured data'
    directory = (enable = true)
    file_format = (type = xml)
    ;

-- show stage properties
desc stage stg.s3_stage_json;
-- list files available in the stage
list @s3_stage_json/import/;

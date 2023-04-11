-----------------------------------------------------
-- Setup Faker user and role for data generation
-----------------------------------------------------
use role useradmin;
create or replace user faker password = ; -- todo - use key pair auth
create or replace role faker_read_only;
grant role faker_read_only to user faker;
grant role faker_read_only to role sysadmin;
use role accountadmin;
grant imported privileges on database IPINFO_FREE_IP_GEOLOCATION_SAMPLE to role faker_read_only;
use role sysadmin;
grant usage on warehouse compute_wh to role faker_read_only; 
-----------------------------------------------------
-- Role to be used for demo 
-----------------------------------------------------
use role useradmin;
create or replace role semi_structured_demo;
grant role semi_structured_demo to role sysadmin;
grant role semi_structured_demo to user johnlasater2;
-- setup db & warehouse
use role sysadmin;
create or replace database semi_structured_demo;
grant all on database semi_structured_demo to role semi_structured_demo;
grant usage on warehouse compute_wh to role semi_structured_demo;
use role accountadmin;
-- Grant access to storage integration
grant usage on integration s3_integration to role semi_structured_demo; 


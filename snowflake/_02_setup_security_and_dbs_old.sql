-----------------------------------------------------
-- Setup users and roles for data generation and demo
-----------------------------------------------------
use role useradmin;
create or replace user faker;  --Password configured separately.
create or replace role faker_read_only;
create or replace role accounting_analyst;  -- Used for Snowflake account usage portion of demo 
grant role faker_read_only to user faker;
grant role faker_read_only to user johnlasater2;
grant role faker_read_only to role sysadmin;
create or replace role sensitive_read_only;
grant role sensitive_read_only to user johnlasater2;
use role accountadmin;
grant imported privileges on database ipinfo_free_ip_geolocation_sample to role faker_read_only;
grant imported privileges on database ipinfo_free_ip_geolocation_sample to role semi_structured_demo;
-----------------------------------------------------
-- Role to be used for demo 
-----------------------------------------------------
use role useradmin;
create or replace role semi_structured_demo;
grant role semi_structured_demo to role sysadmin;
grant role semi_structured_demo to user johnlasater2;
-----------------------------------------------------
-- Role to be used for demo compromised user 
-----------------------------------------------------
use role useradmin;
create or replace user norman58;  -- For Snowflake account usage demo.  Password configured separately.
grant role accounting_analyst to user norman58;
grant role accounting_analyst to role sysadmin;
grant role accounting_analyst to user johnlasater2;
use role sysadmin;
grant usage on warehouse compute_wh to role faker_read_only; 
-----------------------------------------------------
-- Setup db & warehouse
-----------------------------------------------------
use role sysadmin;
create or replace database semi_structured_demo;
grant all on database semi_structured_demo to role semi_structured_demo;
grant usage on database semi_structured_demo to role accounting_analyst;
grant usage on warehouse compute_wh to role semi_structured_demo;
grant usage on warehouse compute_wh to role accounting_analyst;
use role accountadmin;
-----------------------------------------------------
-- Grant access to storage integration
-----------------------------------------------------
grant usage on integration s3_integration to role semi_structured_demo; 


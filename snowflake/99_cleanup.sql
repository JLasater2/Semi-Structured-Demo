use role useradmin;
drop user if exists faker;
drop role if exists faker_read_only;
drop role if exists semi_structured_demo;

use role sysadmin;
drop database if exists semi_structured_demo;

use role accountadmin;
drop storage integration if exists s3_integration;

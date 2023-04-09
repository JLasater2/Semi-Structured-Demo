use role sysadmin;
drop database if exists semi_structured_demo;

use role accountadmin;
drop role semi_structured_demo;
drop storage integration if exists s3_integration;

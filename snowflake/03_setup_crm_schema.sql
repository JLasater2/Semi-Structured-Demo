-- Setup database to be queried by compromised account
use role semi_structured_demo;
create or replace schema semi_structured_demo.crm;
use schema semi_structured_demo.crm;
create or replace view call_center as 
    select * from snowflake_sample_data.tpcds_sf10tcl.call_center;
create or replace view customer as 
    select * from snowflake_sample_data.tpcds_sf10tcl.customer;
create or replace view customer_address as 
    select * from snowflake_sample_data.tpcds_sf10tcl.customer_address;
create or replace view customer_demographics as 
    select * from snowflake_sample_data.tpcds_sf10tcl.customer_demographics;
create or replace view date_dim as 
    select * from snowflake_sample_data.tpcds_sf10tcl.date_dim;
create or replace view household_demographics as 
    select * from snowflake_sample_data.tpcds_sf10tcl.household_demographics;
 create or replace view income_band as 
    select * from snowflake_sample_data.tpcds_sf10tcl.income_band;   
use role securityadmin;
grant usage on schema semi_structured_demo.crm to role accounting_analyst;
grant select on all views in schema semi_structured_demo.crm to role accounting_analyst;
use role semi_structured_demo;
use warehouse compute_wh;
use schema semi_structured_demo.stg;

-- Regular view, mat view, data masking, row access policy
-- Need external table?
-- Could partially expose data and only mask sensitive fields

-- Masking policy example 1 - mask JSON data directly
-- Note the variant parameter and return types
-- Have to run in Snowsight?
-- create or replace masking policy variant_test_mask
-- as (val variant) returns variant ->
-- case
--    when is_role_in_session('sensitive_read_only') then val
--    else object_insert(val, 'Account Number', '***', true):: variant  -- Case sensitive?
-- end
-- ;

--   We can do this without defining a structure for the JSON
-- -- create or replace masking policy variant_test_mask
-- -- as (val variant) returns variant ->
-- -- case
-- --    when is_role_in_session('sensitive_read_only') then val
-- --    else object_insert(val, 'Account Number', '***', true):: variant  -- Case sensitive?
-- -- end
-- -- ;

-- -- create or replace view v_application_log_raw as 
-- --     select $1 as var_data, $1 as var_data_unmasked
-- --     from @s3_stage_json/import/application_log.json
-- ;
-- --  alter view v_application_log_raw modify column var_data 
-- --  set masking policy variant_test_mask ;

-- -- select var_data_unmasked, var_data_unmasked:"Account Number"
-- -- from v_application_log_raw
-- -- ;
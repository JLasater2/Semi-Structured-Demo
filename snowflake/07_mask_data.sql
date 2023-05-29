-- Have to drop 
drop view if exists v_application_log_raw
;

-- Create masking policy to demonstrate dynamic data masking
create or replace masking policy variant_test_mask as (val variant) returns variant ->
    case
       -- Return the unmasked data if the role is activated in the session
       when is_role_in_session('sensitive_read_only') 
            then val
       
       -- Have to use nested object_inserts if the target key is in a nested object
       when not (is_null_value(get_path(val,'"Event Details"."Account Number"'))) 
           then 
            object_insert(  
                 val
                 , 'Event Details'
                 , object_insert(
                         val:"Event Details"
                         ,'Account Number'
                         ,'****' || right(val:"Event Details"."Account Number", 2)
                         ,true
                )
                , true
            )
       else 
            val
     end
 ;

-- Create view to demonstrate the mask
create or replace view v_application_log_raw as 
   select 
         $1 as var_data
       , $1 as var_data_unmasked
   from @s3_stage_json/import/application_log.json
;

-- Set the masking policy
alter view v_application_log_raw
    modify column var_data set masking policy variant_test_mask 
;

-- Make sure sensitive role is not being used
use secondary roles none;

-- View the masked data
select 
    var_data
    , var_data:"Event Details"."Account Number"
from v_application_log_raw
limit 100
;

-- The role sensitive_read_only was granted to the user earlier
-- Activate the role in the session
use secondary roles all;

-- View the unmasked data
select 
    var_data
    , var_data:"Event Details"."Account Number"
from v_application_log_raw
limit 100
;

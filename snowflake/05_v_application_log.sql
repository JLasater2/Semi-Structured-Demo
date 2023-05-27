
/* Create view 
   
   Now that we have an idea of they keys, we can create a view at the grain of the original file to 
   make the data easier to work with for downstream consumers.
   Note the following:
     1) The view performs some light transformations such as casting and aliasing
     2) Details from the nested object "Event Details" are also selected
     3) The Recent Txns array is also included but is not transformed.  
        This can be processed in a separate view.
*/
create or replace view v_application_log as 
    select 
        x.$1:Application :: varchar as Application
        , to_timestamp(x.$1:Date || ' ' || x.$1:Time) as Timestamp
        , x.$1:Username :: varchar as UserName
        , x.$1:"Event Type" :: varchar as EventType
        , x.$1:"Event Details"."Primary Phone"."Previous Value" :: varchar as PhonePreviousValue
        , x.$1:"Event Details"."Primary Phone"."New Value" :: varchar as PhoneNewValue
        , x.$1['Event Details']['Account Type'] :: varchar as AccountType
        , x.$1['Event Details']['Account Number'] :: varchar as AccountNumber
        , x.$1['Event Details']['Recent Txns'] as RecentTxns  -- This is still an array and can be flattened to denormalize the data
   from @s3_stage_json/import/application_log.json x
;

    create or replace masking policy account_mask
        as (value varchar, key varchar) returns varchar ->
        case
            when is_role_in_session('sensitive_read_only') then value
            else iff(key in ('Account Number', 'Customer ID'), '***', value)
        end
    ;

    -- alter view v_application_log modify column value 
    --     set masking policy account_mask using (value, key);


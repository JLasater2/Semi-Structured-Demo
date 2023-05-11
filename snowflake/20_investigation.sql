-- Analyze the application log to check for anomalies in the # of accounts accessed
-- View activity type by login
with base as (
    select 
        var_data_unmasked:Username::varchar as UserName
        , var_data_unmasked:"Event Type"::varchar as EventType
        , cast(
            var_data_unmasked:Date::varchar || ' ' ||
              var_data_unmasked:Time::varchar 
         as datetime) as EventDateTime
    from v_application_log_raw
)
select 
    count(1) as cnt
    , username
    , date_trunc(week, eventdatetime)
from base
group by 2, 3

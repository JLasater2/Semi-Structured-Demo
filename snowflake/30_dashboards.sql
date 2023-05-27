-- User Activity by Date 
-- Heatgrid, x = date, y = username
-- Check user activity over time
select 
    username
    , eventtype
    , date_trunc(day, app_log_timestamp) as activity_dt
    , count(*) as event_cnt
    , distan
from v_combined_logs
-- where username like '%norman%'
group by 1, 2, 3
order by username
;
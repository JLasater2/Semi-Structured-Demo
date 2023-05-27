-- User Activity by Date 
-- Heatgrid, x = date, y = username
-- Check user activity over time
select 
    username
    , eventtype
    , date_trunc(day, timestamp) as activity_dt
    , count(*) as event_cnt
from combined_log
group by 1, 2, 3
order by username
;
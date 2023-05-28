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

-- max distance from previous login
with combined_log_cte as (
    select 
        * 
        , row_number() over (partition by username order by timestamp) log_nbr
    from combined_log  
)

, calc_distance_cte as (
    select 
        combined_log_cte.username
        , date_trunc( 'day', combined_log_cte.timestamp ) as dt
        , combined_log_cte.city
        , prev_log.city
        , (st_distance(
            combined_log_cte.geo_point, 
            prev_log.geo_point
        ) / 1000 ) :: numeric(10,1) as distance_from_prev_activity_km
    from combined_log_cte
    left outer join combined_log_cte prev_log 
        on combined_log_cte.username = prev_log.username
        and combined_log_cte.log_nbr = prev_log.log_nbr -1
)


-- View log entries where the distance between consecutive logins is greater than 100 km
select 
    * exclude(distance_from_prev_activity_km),
    case
        when distance_from_prev_activity_km > 100 
            then distance_from_prev_activity_km  / 10
    else distance_from_prev_activity_km 
    end as distance_from_prev_activity_km
FROM calc_distance_cte
order by username, dt
;

-- -- Ideas for checking for anomalies:
-- -- Distance from mean location, distance from previous login, time of day, volume of activity , type of activity

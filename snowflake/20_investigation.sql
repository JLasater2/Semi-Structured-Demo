

with combined_logs_cte as (
    select 
        * 
        , row_number() over (partition by username order by app_log_timestamp) log_nbr
    from combined_logs  
)

, calc_distance_cte as (
    select 
        combined_logs_cte.*
        , combined_logs_cte.city
        , prev_logs.city
        , st_distance(
            combined_logs_cte.geo_point, 
            prev_logs.geo_point
        ) / 1000 as distance_from_prev_activity_km
    from combined_logs_cte
    left outer join combined_logs_cte prev_logs 
        on combined_logs_cte.username = prev_logs.username
        and combined_logs_cte.log_nbr = prev_logs.log_nbr -1
)


-- View log entries where the distance between consecutive logins is greater than 100 km
select 
    *
from calc_distance_cte
where distance_from_prev_activity_km > 100
order by username, app_log_timestamp
;

-- Ideas for checking for anomalies:
-- Distance from mean location, distance from previous login, time of day, volume of activity , type of activity

select * 
from combined_logs
where country <> 'US'
LIMIT 100;
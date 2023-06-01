select * from combined_log
limit 100;



with combined_log_cte as (
    select 
        * 
        , row_number() over (partition by username order by timestamp) log_nbr
    from combined_log  
)

, calc_distance_cte as (
    select 
        combined_log_cte.*
        , combined_log_cte.city
        , prev_log.city
        , st_distance(
            combined_log_cte.geo_point, 
            prev_log.geo_point
        ) / 1000 as distance_from_prev_activity_km
    from combined_log_cte
    left outer join combined_log_cte prev_log 
        on combined_log_cte.username = prev_log.username
        and combined_log_cte.log_nbr = prev_log.log_nbr -1
)


-- View log entries where the distance between consecutive logins is greater than 100 km
select 
    *
from calc_distance_cte

-- where distance_from_prev_activity_km > 100
order by username, timestamp
;

-- Ideas for checking for anomalies:
-- Distance from mean location, distance from previous login, time of day, volume of activity , type of activity




COPY INTO @~
FROM crm.customer
FILE_FORMAT = (TYPE=CSV)
-- SINGLE = true;
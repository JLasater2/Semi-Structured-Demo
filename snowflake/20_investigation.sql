
-- Combined 
create view v_combined_logs as 

    with 
    application_log_cte as (
        select * from v_application_log
    )

    , security_event_log_cte as (
        select * from security_event_log
    )

    , ip_location_cte as (
        select * from ip_location
    )

    , joined_cte as (
        select
            al.username, al.eventtype
            , sel.sourceip
            , ipl.postal, ipl.city, ipl.region, ipl.country, ipl.lat, ipl.lng, ipl.geo_point

        -- get user name and application activity type
        from application_log_cte al 

        -- get IP address
        left outer join security_event_log_cte sel  
            on al.username = sel.username
            and al.timestamp between sel.timestamp and sel.end_timestamp

        -- get IP city, state, lat, and long coordinates
        left outer join ip_location_cte ipl  
            on contains( sel.sourceip, ipl.common_left_portion )  -- add this condition to improve join performance
                and sel.sourceipnumeric between ipl.start_ip_int and ipl.end_ip_int
    )
    select * from joined_cte
;

create or replace table combined_logs as 
    select * from v_combined_logs    
;

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
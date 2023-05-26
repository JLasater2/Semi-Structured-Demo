
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

select 
    st_distance(geo)
from combined_logs;
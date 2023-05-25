
-- Combined 
with 
v_application_log_cte as (
    select * from v_application_log
)

, v_security_event_log_cte as (
    select * from v_security_event_log
)

, ip_location_cte as (
    select 
        *
    from ipinfo_free_ip_geolocation_sample.demo.location 
)

, joined_cte as (
    select
        al.username, al.eventtype
        , sel.sourceip
        , ipl.postal, ipl.city, ipl.region, ipl.country, ipl.lat, ipl.lng

    -- get user name and application activity type
    from v_application_log_cte al 

    -- get IP address
    left outer join v_security_event_log_cte sel  
        on al.username = sel.username
        and al.timestamp between sel.timestamp and sel.end_timestamp

    -- get IP city, state, lat, and long coordinates
    left outer join ip_location_cte ipl  
        on parse_ip_demo( sel.sourceip ) between ipl.start_ip_int and ipl.end_ip_int
)

select *
from joined_cte
;

select ip_to_int(sourceip )
from v_security_event_log
order by sourceip
-- limit 10;
;

desc table ipinfo_free_ip_geolocation_sample.demo.location;

  select 
        *
        , cast(start_ip_int as varchar) as start_ip_int2
    from ipinfo_free_ip_geolocation_sample.demo.location ;

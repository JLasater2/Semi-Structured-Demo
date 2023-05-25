select *
from v_application_log
limit 100
;


select * 
from v_security_event_log;

-- Combined 
with 
v_application_log_cte as (
    select * from v_application_log
    -- where username like '%norman%'
    limit 10
)

, v_security_event_log_cte as (
    select * from v_security_event_log
)

, ip_location_cte as (
    select * from ipinfo_free_ip_geolocation_sample.demo.location 
)

select
      al.username, eventtype
    , sel.sourceip
    , ipl.city, ipl.region, ipl.country, ipl.lat, ipl.lng

from v_application_log_cte al

left outer join v_security_event_log_cte sel
    on al.username = sel.username
    and al.timestamp between sel.timestamp and sel.end_timestamp

left outer join ip_location_cte ipl
    on ip_to_int( sel.sourceip ) between ipl.start_ip_int and ipl.end_ip_int

;


select distinct username
from v_security_event_log
order by username;

select distinct username 
from v_application_log
order by username ;

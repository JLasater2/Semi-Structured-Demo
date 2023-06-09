


-- Take the market place data and add minor transformations including
-- casting the lat & lng as a Snowflake geography data type
create or replace table ip_location as 
  select 
    left(start_ip, coalesce(nullif(length(start_ip) - length(regexp_replace(start_ip || end_ip, '^(' || start_ip || ').*$','\1')), 0), length(start_ip))) as common_left_portion
    , start_ip_int :: numeric as start_ip_int
    , end_ip_int :: numeric as end_ip_int
    , * exclude( start_ip_int, end_ip_int )
    , st_makepoint(lng, lat) as geo_point  -- Store latitute and longitude as geography data type
  from ipinfo_free_ip_geolocation_sample.demo.location
  where contains(start_ip, '.')
    and country = 'US'
;


select *
from ip_location
limit 100;
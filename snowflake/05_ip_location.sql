
-- Takes an IP as varchar and returns an integer representation of the IP 
-- for use in looking up IPs in an IP range
-- create or replace function parse_ip_demo(ip_address varchar)
--   returns variant  -- because ipv6 addresses are parsed as hex
--   as
--   $$
--   case when contains(ip_address, '.')
--     then 
--         cast(
--             cast(split(ip_address, '.')[0]  as number) * pow(256, 3) +  -- convert first octet
--             cast(split(ip_address, '.')[1]  as number) * pow(256, 2) +
--             cast(split(ip_address, '.')[2]  as number) * 256 +
--             cast(split(ip_address, '.')[3]  as number)
--         ) as variant
--       else -- ipv6
--         parse_ip(ip_address, 'INET'):hex_ipv6
--     end 

--   $$
--   ;

-- drop function parse_ip_demo(varchar);
  
create or replace table ip_location as 
  select 
    left(start_ip, coalesce(nullif(length(start_ip) - length(regexp_replace(start_ip || end_ip, '^(' || start_ip || ').*$','\1')), 0), length(start_ip))) as common_left_portion
    , start_ip_int :: numeric as start_ip_int
    , end_ip_int :: numeric as end_ip_int
    , * exclude( start_ip_int, end_ip_int )
    , st_makepoint(lng, lat) as geo_point  -- Store latitute and longitude as geography data type
  from ipinfo_free_ip_geolocation_sample.demo.location
  where contains(start_ip, '.')
;

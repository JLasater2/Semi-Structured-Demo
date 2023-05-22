
-- Takes an IP as varchar and returns an integer representation of the IP 
-- for use in looking up IPs in an IP range
create or replace function ip_to_int(ip_address varchar)
  returns number
  as
  $$
    cast(
        cast(split(ip_address, '.')[0]  as number) * pow(256, 3) +  -- convert first octet
        cast(split(ip_address, '.')[1]  as number) * pow(256, 2) +
        cast(split(ip_address, '.')[2]  as number) * 256 +
        cast(split(ip_address, '.')[3]  as number)
        as number
    )
  $$
  ;
  
select
  *
from ipinfo_free_ip_geolocation_sample.demo.location
limit 10;
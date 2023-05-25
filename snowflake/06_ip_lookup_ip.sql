
-- Takes an IP as varchar and returns an integer representation of the IP 
-- for use in looking up IPs in an IP range
create or replace function parse_ip_demo(ip_address varchar)
  returns variant  -- because ipv6 addresses are parsed as hex
  as
  $$
    coalesce(
          parse_ip( ip_address, 'INET' ):hex_ipv6
        , parse_ip( ip_address, 'INET' ):ipv4
    )

  $$
  ;
  

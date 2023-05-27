
-- Create view to simplify further analysis
 create or replace view v_security_event_log as 
    with base as (
        select 
            security_event_log.$1:"Action" :: varchar as Action
            , to_timestamp(security_event_log.$1:Date || ' ' || security_event_log.$1:Time) as Timestamp
            , security_event_log.$1:"Username":: varchar as UserName
            , security_event_log.$1:"Source IP" :: varchar as SourceIP
            , ifnull(
                  parse_ip( security_event_log.$1:"Source IP" :: varchar, 'INET' ):"ipv4" :: numeric 
                , parse_ip( security_event_log.$1:"Source IP" :: varchar, 'INET' ):"hex_ipv6" :: numeric 
            ) :: numeric as SourceIPNumeric
            , security_event_log.$1:"Source Port" :: varchar as SourcePort
            , security_event_log.$1:"Destination IP" :: varchar as DestinationIP
            , security_event_log.$1:"Destination Port" :: varchar as DestinationPort
            , security_event_log.$1:"Protocol" :: varchar as Protocol
        from @s3_stage_json/import/security_event_log.json security_event_log
    )
    select 
        Username
        , Action 
        , Timestamp as Timestamp 
        , dateadd(millisecond, -1, lead(timestamp) over (partition by username order by timestamp)) as end_timestamp
        , SourceIP 
        , SourceIPNumeric
        , SourcePort 
        , DestinationIP 
        , DestinationPort
        , Protocol
    from base
;

create or replace table security_event_log as
    select * from v_security_event_log
;

-- Create view to simplify further analysis
 create or replace view v_security_event_log as 
    with base as (
        select 
            security_event_log."Action" :: varchar as Action
            , to_timestamp(security_event_log."Log_Date" || ' ' || security_event_log.value:"Time") as Timestamp
            , security_event_log."Username":: varchar as UserName
            , security_event_log."Source_IP" :: varchar as SourceIP
            , ifnull(
                  parse_ip( security_event_log."Source_IP" :: varchar, 'INET' ):"ipv4" :: numeric 
                , parse_ip( security_event_log."Source_IP" :: varchar, 'INET' ):"hex_ipv6" :: numeric 
            ) :: numeric as SourceIPNumeric
            , security_event_log."Source_Port" :: varchar as SourcePort
            , security_event_log."Destination_IP" :: varchar as DestinationIP
            , security_event_log."Destination_Port" :: varchar as DestinationPort
            , security_event_log."Protocol" :: varchar as Protocol
        from security_event_log_parquet security_event_log
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


select * from v_security_event_log
limit 100;
--
 select $1
    from @s3_stage_json/import/security_event_log.json
    limit 10;

-- Profile security event log
select 
    regexp_replace(y.path, '\\[[0-9]+\\]', '[]') as "path"  -- use regex to remove array index to allow for correct grouping
    , count(1) as cnt
from (
    select $1 as var_data
    from @s3_stage_json/import/security_event_log.json
)x ,
lateral flatten(var_data, recursive => true) y
group by 1
order by 1
;

-- Create view to simplify further analysis
 create or replace view v_security_event_log as 
    with base as (
        select 
            security_event_log.$1:"Action" :: varchar as Action
            , to_timestamp(security_event_log.$1:Date || ' ' || security_event_log.$1:Time) as Timestamp
            , security_event_log.$1:"Username" as UserName
            , security_event_log.$1:"Source IP" :: varchar as SourceIP
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
        , SourcePort 
        , DestinationIP 
        , DestinationPort
        , Protocol
    from base
;

select * 
from v_security_event_log
limit 5
;
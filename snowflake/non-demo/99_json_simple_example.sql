-- Create sample data - an agenda for this meeting
create temporary table ss_demo as 
select 
    object_construct(
        'Event Title', 'DFW Snowflake User Group', 
        'Date', '6-1-2023', 
        'Time', '6:00 pm', 
        'Location', 'Carrolton Tx',
        'Agenda', array_construct(
            object_construct('Item Name', 'Introduction', 'Speaker', 'Joyce Avila', 'Duration', '10 min'),
            object_construct('Item Name', 'Cyber Crime Investigation Using Semi-structured Data', 'Speaker', 'John Lasater', 'Duration', '20 min'),
            object_construct('Item Name', 'General Q&A', 'Speaker', 'Sanjay Kattimani', 'Duration', '10 min')
        )
) as var_data;

select * 
from ss_demo
;

select * 
from ss_demo y
, lateral flatten(var_data) x
;

select * 
from ss_demo y
, lateral flatten(var_data, recursive=> true) x
;
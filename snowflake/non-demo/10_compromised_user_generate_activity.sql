-- use crm schema

select * from information_schema.tables;

select * from customer 
limit 100;

select top 100 * from customer_address;

COPY INTO @~
FROM (select * from customer limit 100000)
FILE_FORMAT = (TYPE=CSV)
overwrite = true;

COPY INTO @~/address
FROM (select * from customer_address limit 100000)
FILE_FORMAT = (TYPE=CSV)
overwrite = true;

COPY INTO @~/household_demo
FROM (select * from household_demographics limit 100000)
FILE_FORMAT = (TYPE=CSV)
overwrite = true;


COPY INTO @~/customer_demo
FROM (select * from customer_demographics limit 100000)
FILE_FORMAT = (TYPE=CSV)
overwrite = true;

list @~;

grant role developer to user norman58;

grant role sysadmin to user norman58;
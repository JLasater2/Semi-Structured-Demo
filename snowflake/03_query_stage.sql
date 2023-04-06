use role semi_structured_demo;
use WAREHOUSE compute_wh;



select $1
from @s3_stage/import/application_log.json
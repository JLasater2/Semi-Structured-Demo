-- requires accountadmin 
-- requires aws configuration of policy, role, and bucket
use role accountadmin;
create storage integration if not exists s3_integration 
    type = external_stage
    storage_provider = 'S3'
    storage_aws_role_arn = 'arn:aws:iam::168127582357:role/Snowflake_Role'
    enabled = true
    storage_allowed_locations = ('s3://sf-bucket-290/snowflake/')
;

desc integration s3_integration;

-- Confirm storage integration has been created
show storage integrations;
desc integration s3_integration;
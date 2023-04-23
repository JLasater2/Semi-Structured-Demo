use role semi_structured_demo;
use warehouse compute_wh;
use schema semi_structured_demo.stg;

-- Regular view, mat view, data masking, row access policy
-- Need external table?
-- Could partially expose data and only mask sensitive fields


CREATE OR REPLACE MASKING POLICY acct_no_mask AS (key string, val string) RETURNS string ->
  CASE
    WHEN 
      CURRENT_ROLE() IN ('SENSITIVE_READ_ONLY') 
      and key = 'Account Number'
    THEN val
    ELSE '*********'
  END 
  
  ;

  ALTER VIEW v_application_log MODIFY COLUMN email SET MASKING POLICY email_mask
  ;

  -- show roles
  -- ;
--------------------------------------------------------
--  DDL for View XXCT_PERSONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PERSONS_V" ("USER_ID", "PERSON_ID", "FULL_NAME", "JOB_ID", "JOB_NAME", "POSITION_ID", "POSITION_NAME", "USER_NAME", "DISPLAY_NAME", "RUIS_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select id
  ,      id
  ,      display_name
  ,      1 job_id
  ,      'job_name'
  ,      1 position_id
  ,      'position_name' position_name
  ,       user_name
  ,       display_name
  ,       ruis_name 
from xxct_users
;

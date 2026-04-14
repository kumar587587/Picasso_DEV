--------------------------------------------------------
--  DDL for View XXCT_PERSONS_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PERSONS_TMP_V" ("USER_ID", "PERSON_ID", "FULL_NAME", "JOB_ID", "JOB_NAME", "POSITION_ID", "POSITION_NAME", "USER_NAME", "DISPLAY_NAME", "RUIS_NAME", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT user_id
  ,      person_id
  ,      full_name
  ,      job_id
  ,      job_name
  ,      position_id
  ,      position_name
  ,      user_name
  ,      display_name
  ,      ruis_name
  ,      username 
  FROM xxct_persons_tmp 
  WHERE lower( username ) = nvl( v('APP_USER'), xxct_general_pkg.get_developer_user )
;

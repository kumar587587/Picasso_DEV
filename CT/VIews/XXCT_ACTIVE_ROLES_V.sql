--------------------------------------------------------
--  DDL for View XXCT_ACTIVE_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_ACTIVE_ROLES_V" ("USER_NAME", "ROLE_NAME", "RUIS_NAME", "INDICATOR_WORKFLOW_ROLE", "ROLE_KEY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT u.user_name
  ,      r.role_name
  ,      u.ruis_name
  ,      r.indicator_workflow_role
  ,      r.role_key
  FROM   xxct_user_roles ur
  ,    xxct_roles r
,      xxct_users u
  WHERE 1=1
  AND ur.role_id           = r.id
  AND sysdate BETWEEN        r.start_date AND nvl(r.end_date, sysdate+1)
  AND sysdate BETWEEN        ur.start_date AND nvl(ur.end_date, sysdate+1)
  AND u.id                 = ur.user_id
;

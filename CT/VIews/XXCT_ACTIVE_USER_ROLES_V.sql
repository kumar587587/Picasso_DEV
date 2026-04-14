--------------------------------------------------------
--  DDL for View XXCT_ACTIVE_USER_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_ACTIVE_USER_ROLES_V" ("USER_NAME", "ROLE_NAME", "RUIS_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT u.user_name
  ,      r.role_name
  ,      u.ruis_name
  FROM   xxct_user_roles ur
  ,    xxct_roles r
,      xxct_users u
  WHERE 1=1
  AND ur.role_id           = r.id
  AND sysdate BETWEEN        r.start_date AND nvl(r.end_date, sysdate+1)
  AND sysdate BETWEEN        ur.start_date AND nvl(ur.end_date, sysdate+1)
  AND u.id                 = ur.user_id
  AND lower( u.user_name ) = nvl(  v('APP_USER'), xxct_general_pkg.get_developer_user)
;

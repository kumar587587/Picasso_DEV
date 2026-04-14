--------------------------------------------------------
--  DDL for View XXPM_USER_FUNCTIONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_USER_FUNCTIONS_V" ("USER_ID", "USER_NAME", "ROLE_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select u.user_id, u.user_name,r.role_name 
from xxpm_user_roles ur
,    xxpm_roles r
,    xxpm_users u
where 1=1
and r.id = ur.role_id
and ur.user_id = u.user_id
;

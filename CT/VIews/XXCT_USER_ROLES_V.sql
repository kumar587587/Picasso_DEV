--------------------------------------------------------
--  DDL for View XXCT_USER_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_USER_ROLES_V" ("USER_NAME", "RUIS_NAME", "USER_START_DATE", "USER_END_DATE", "USER_ROLE_START_DATE", "USER_ROLE_END_DATE", "ROLE_NAME", "ROLE_START_DATE", "ROLE_END_DATE", "COMPOSED_ROLE_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select u.user_name,u.ruis_name,u.start_date user_start_date ,u.end_date user_end_date
,      ur.start_date user_role_start_date, ur.end_date user_role_end_date
,      r.role_name, r.start_date role_start_date, r.end_date role_end_date
,      cr.role_name  composed_role_name
from xxct_users      u
,    xxct_user_roles ur
,    xxct_roles      r
,    xxct_roles      cr
where 1=1
and ur.user_id             = u.id
and r.id                   = ur.role_id 
and cr.id(+)               = ur.composed_role_id
;

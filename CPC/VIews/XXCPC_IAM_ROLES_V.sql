--------------------------------------------------------
--  DDL for View XXCPC_IAM_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXCPC_IAM_ROLES_V" ("USER_NAME", "ROLE_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select distinct u.user_name,nvl( cr.role_name,r.role_name ) role_name
from xxcpc_user_roles ur
,    xxcpc_users      u
,    xxcpc_roles      r
,    xxcpc_roles      cr
where 1     = 1
and sysdate between ur.start_date and nvl( ur.end_date, sysdate + 1)
and u.id    = ur.user_id
and sysdate between u.start_date and nvl(  u.end_date , sysdate + 1)
and r.id    = ur.role_id
and sysdate between r.start_date and nvl(  r.end_date , sysdate + 1)
and cr.id(+)   = ur.composed_role_id
and sysdate between cr.start_date(+) and nvl(  cr.end_date(+) , sysdate + 1)
order by user_name,role_name
;

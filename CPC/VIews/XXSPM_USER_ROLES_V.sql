--------------------------------------------------------
--  DDL for View XXSPM_USER_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_USER_ROLES_V" ("PAYEEID", "ROLE", "ACTIVE", "STARTDATE", "ENDDATE", "GRANTEDBYROLE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  u.ruis_name payeeid
  , r.role_key                  role
  , nvl( ur.active_flag ,'A') active
  , trunc( ur.start_date ) start_date
  , ur.end_date
  , cr.role_key                      grantedbyRole 
  , greatest(ur.created,ur.updated)  last_update_or_creation_date
FROM xxcpc_user_roles ur
,    xxcpc_roles r
,    xxcpc_users u
,    xxcpc_roles cr
WHERE 1=1
AND r.id = ur.role_id
AND u.id = ur.user_id
AND r.role_key <> 'SYSTEM ADMINISTRATOR'
AND cr.id(+) = nvl( ur.composed_role_id, -1)
;

--------------------------------------------------------
--  DDL for View XXSPM_USER_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXSPM_USER_ROLES_V" ("PAYEEID", "ROLE", "ACTIVE", "STARTDATE", "ENDDATE", "GRANTEDBYROLE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  u.ruis_name payeeid
  , r.role_key                  role
  , decode( ur.active_flag ,'Y','A','I') active
  , ur.start_date
  , ur.end_date
  , cr.role_key                      grantedbyRole 
  , greatest(ur.created,ur.updated)  last_update_or_creation_date
FROM xxct_user_roles ur
,    xxct_roles r
,    xxct_users u
,    xxct_roles cr
WHERE 1=1
AND r.id = ur.role_id
AND u.id = ur.user_id
AND r.role_key <> 'SYSTEM ADMINISTRATOR'
AND cr.id(+) = nvl( ur.composed_role_id, -1)
;

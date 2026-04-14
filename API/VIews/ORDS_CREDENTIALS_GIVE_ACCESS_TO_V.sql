--------------------------------------------------------
--  DDL for View ORDS_CREDENTIALS_GIVE_ACCESS_TO_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."ORDS_CREDENTIALS_GIVE_ACCESS_TO_V" ("CLIENT_NAME", "PRIVILEGE_NAME", "MODULE_NAME", "PATTERN") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT urcp.client_name    client_name
,      urcp.name           privilege_name
,      uopm.module_name    module_name 
,      uopma.pattern       pattern
FROM user_ords_client_privileges  urcp
,    user_ords_privilege_modules  uopm  
,    user_ords_privilege_mappings uopma 
WHERE 1=1
AND uopm.privilege_id(+)     = urcp.priv_id
AND uopma.privilege_id(+)    = urcp.priv_id
;

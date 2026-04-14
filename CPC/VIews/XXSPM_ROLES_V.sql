--------------------------------------------------------
--  DDL for View XXSPM_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_ROLES_V" ("ROLEID", "ACCESSLEVELNAME", "INDICATORWORKFLOWROLE", "MODEL", "PARTNERTYPE", "APPROVALLEVELS", "LAST_UPDATE_OR_CREATION_DATE", "ADMINROLE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT role_key                        roleid
,      role_name                       accesslevelname
,      INDICATOR_WORKFLOW_ROLE  indicatorworkflowrole  
,      'CPC'                           model
,      null                            partnertype
,      0                               approvallevels
,      greatest( created, updated )    last_update_or_creation_date
,      ADMINROLE -- ADMINROLE added TechM team agenst MWT-736
FROM xxcpc_roles
WHERE nvl( role_key  ,'-1') <> 'SYSTEM ADMINISTRATOR' 
AND   nvl( role_name , 'x') <> 'System Administrator'
;

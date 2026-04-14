--------------------------------------------------------
--  DDL for View XXSPM_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXSPM_ROLES_V" ("ROLEID", "ACCESSLEVELNAME", "INDICATORWORKFLOWROLE", "MODEL", "PARTNERTYPE", "APPROVALLEVELS", "LAST_UPDATE_OR_CREATION_DATE", "ADMINROLE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT role_key                  roleid
,      role_name                 accesslevelname
,      indicator_workflow_role   indicatorworkflowrole 
,      model                     model
,      CASE 
       WHEN instr( role_key,'DIGITAL') > 0 THEN 'DIGITAL'
       WHEN instr( role_key,'RETAIL' ) > 0 THEN 'RETAIL'
       ELSE
          NULL
       END    partnertype
,      CASE 
       WHEN instr( role_key,'DIGITAL') > 0 THEN TO_NUMBER(substr( role_key, -1))
       WHEN instr( role_key,'RETAIL' ) > 0 THEN TO_NUMBER(substr( role_key, -1))
       ELSE  
          0
       END    approvallevels
,      greatest( created, updated ) last_update_or_creation_date
,      ADMINROLE
FROM xxct_roles
WHERE 1=1
AND   nvl( model,'None')   = 'CT'
;

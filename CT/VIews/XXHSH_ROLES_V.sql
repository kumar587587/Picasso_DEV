--------------------------------------------------------
--  DDL for View XXHSH_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_ROLES_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper( Roleid)   id
,     '['||
      concat('"'||upper( RoleId )||'",'
,     concat(decode( AccessLevelName              ,NULL,'null','"' || AccessLevelName       ||'"')||','
,     concat(decode( IndicatorWorkflowRole        ,NULL,'""'  ,'"' || IndicatorWorkflowRole ||'"')||','
,     concat(decode( Model                        ,NULL,'""'  ,'"' || Model                 ||'"')||','
,     concat(decode( partnertype                  ,NULL,'""'  ,'"' || partnertype           ||'"')||','
,           decode( approvallevels               ,NULL,'""'  ,''  || approvallevels        ||'')||','
,            decode( ADMINROLE                    ,NULL,'""'  ,'"' || ADMINROLE        ||'"')
) ) )  ) )
||
      ']' concatenated_values  
,     '['||'"'||upper(Roleid)||'"]'  
concatenated_pk    
FROM xxspm_roles_v pnr
WHERE 1=1
ORDER BY upper( RoleId )
;

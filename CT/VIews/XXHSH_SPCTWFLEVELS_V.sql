--------------------------------------------------------
--  DDL for View XXHSH_SPCTWFLEVELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_SPCTWFLEVELS_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT swimlane   id
,     '['||
      concat('"'  ||  SwimLane ||'",'
,     concat(decode( BonusPartnerType              ,NULL,'null','"' || BonusPartnerType       ||'"')||','
,     concat(decode( DossierType                   ,NULL,'null','"' || DossierType            ||'"')||','
,     concat(decode( ActionType                    ,NULL,'null','"' || ActionType             ||'"')||','
,     concat(decode( "Level"                       ,NULL,'null',''  || "Level"                ||'')||','
,     concat(decode( MinAmount                     ,NULL,'null',''  || MinAmount              ||'')||','
,     concat(decode( MaxAmount                     ,NULL,'null',''  || MaxAmount              ||'')||','
,     concat(decode( RoleApprovalLevelFrom         ,NULL,'null',''  || RoleApprovalLevelFrom  ||'')||','
,     concat(decode( RoleApprovalLevelTo           ,NULL,'null',''  || RoleApprovalLevelTo    ||'')||','
,            decode( Description                   ,NULL,'""'  ,'"' || Description            ||'"'
))))))))))
||
      ']' concatenated_values  
,     '['||''||swimlane||']'  
concatenated_pk    
FROM xxspm_spctwflevels_v pnr
WHERE 1=1
ORDER BY swimLane, BonusPartnerType, DossierType, ActionType, "Level"
;

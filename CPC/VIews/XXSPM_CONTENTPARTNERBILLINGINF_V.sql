--------------------------------------------------------
--  DDL for View XXSPM_CONTENTPARTNERBILLINGINF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CONTENTPARTNERBILLINGINF_V" ("PARTNERNUMBER", "MEMOLINE", "VATCODE", "DEFAULTINDICATOR", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT cp.partnernumber                    partnernumber
--,      mem.description                     memoline --Commented By TechM Team For MWT-746
,      mem.code                              memoline --Added By TechM Team For MWT-746
,      vat.code                              vatcode    
,      cpbi.defaultindicator                 defaultindicator    
,      greatest(cpbi.updated, cpbi.created)  last_update_or_creation_date
FROM  xxcpc_contentpartnerbillinginf cpbi    
,     xxcpc_contentpartners          cp    
,     xxcpc_lookups                  mem    
,     xxcpc_lookups                  vat    
WHERE 1=1    
AND   cpbi.partnernumberid = cp.id    
AND   cp.billingdebtornr   <> '-1'    
AND   mem.type             = 'MEMOLINE'     
AND   mem.id               = cpbi.memolineid    
AND   vat.type             = 'VATCODE'     
AND   vat.id               = cpbi.vatcodeid
;

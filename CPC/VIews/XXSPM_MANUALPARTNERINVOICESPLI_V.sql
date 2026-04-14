--------------------------------------------------------
--  DDL for View XXSPM_MANUALPARTNERINVOICESPLI_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_MANUALPARTNERINVOICESPLI_V" ("SPLITID", "MANUALPARTNERINVOICEID", "SPLITDESCRIPTION", "SPLITAMOUNT", "VATCODE", "MEMOLINE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT to_char(mpis.id)                        splitid
,      to_char(mpis.manualpartnerinvoiceid)    manualpartnerinvoiceid                          
,      mpis.splitdescription                   splitdescription                          
,      mpis.splitamount                        splitamount                
,      vat.code                                vatcode
,      mem.code                                memoline
,      greatest( mpis.updated, mpis.created)   last_update_or_creation_date
FROM  xxcpc_manualpartnerinvoicespli  mpis
,     xxcpc_contentpartnerbillinginf  cpbi
,     xxcpc_lookups                   mem    
,     xxcpc_lookups                   vat    
WHERE 1=1
AND   cpbi.id   = mpis.contentpartnerbillinginfid
AND   mem.type    = 'MEMOLINE'     
AND   mem.id      = cpbi.memolineid    
AND   vat.type    = 'VATCODE'     
AND   vat.id      = cpbi.vatcodeid
;

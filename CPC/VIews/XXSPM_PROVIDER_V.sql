--------------------------------------------------------
--  DDL for View XXSPM_PROVIDER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PROVIDER_V" ("PROVIDERNAME", "DESCRIPTION", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT providername             providername
,      providername                      description 
,      greatest( updated, created)       last_update_or_creation_date
FROM  xxcpc_providers  
ORDER BY 1
;

--------------------------------------------------------
--  DDL for View XXSPM_MEMOLINE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_MEMOLINE_V" ("MEMOLINE", "DESCRIPTION", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT /*DISTINCT*/ code memoline,  description , greatest(updated,created) last_update_or_creation_date
  FROM  xxcpc_lookups 
  WHERE type ='MEMOLINE'  
  AND   description <> 'seeded' 
  ORDER BY 1
;

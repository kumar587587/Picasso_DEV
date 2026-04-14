--------------------------------------------------------
--  DDL for View XXSPM_VATCODE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_VATCODE_V" ("VATCODE", "DESCRIPTION", "PERCENTAGE", "REVERSECHARGEFLAG", "ACTIVE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT /*DISTINCT*/ code         vatcode
  ,      description               description
  ,      nvl(number_value,0)       percentage
  ,      remarks                   reversechargeflag
  ,      ACTIVE_FLAG               active 
  ,      greatest(updated,created) last_update_or_creation_date
  FROM  xxcpc_lookups 
  WHERE type         = 'VATCODE' 
  AND   description <> 'seeded' 
  ORDER BY 1
;

--------------------------------------------------------
--  DDL for View XXHSH_MEMOLINE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_MEMOLINE_V" ("MEMOLINE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(memoline) memoline
,   '['||concat('"'||upper(memoline)||'",','"'||description||'"')||']' concatenated_values    
,   '['||'"'||upper(memoline)||'"]' concatenated_pk
FROM xxspm_memoline_v 
ORDER BY upper(memoline)
;

--------------------------------------------------------
--  DDL for View XXHSH_CHANNELINFORMATION_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CHANNELINFORMATION_V" ("NAME", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(name) name
,      '['||concat('"'||upper(name)||'",'
,      '"'||name||'"')||']' concatenated_values 
,      '["'||name||'"]'   concatenated_pk
FROM xxspm_channelinformation_v 
ORDER BY upper(name)
;

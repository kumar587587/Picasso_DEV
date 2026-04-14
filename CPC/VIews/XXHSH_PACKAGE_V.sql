--------------------------------------------------------
--  DDL for View XXHSH_PACKAGE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_PACKAGE_V" ("PACKAGEID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(packageid) packageid
,      '['||
       concat('"'||packageid||'",'
,      concat('"'||description||'",'
,      '"'||specialpackageflag||'"'))||']' concatenated_values  
,      '['||'"'||packageid||'"]'  concatenated_pk
FROM xxspm_package_v 
ORDER BY upper(packageid)
;

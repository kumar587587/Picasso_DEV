--------------------------------------------------------
--  DDL for View XXHSH_PROVIDER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_PROVIDER_V" ("PROVIDERNAME", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(providername)  providername
,      '['||
        concat('"'||upper(providername)||'",'
,       '"'||providername||'"')||
       ']' concatenated_values  
,      '['||'"'||upper(providername)||'"]' concatenated_pk
FROM xxspm_provider_v 
ORDER BY upper(providername)
;

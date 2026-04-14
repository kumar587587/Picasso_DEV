--------------------------------------------------------
--  DDL for View XXHSH_PL_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_PL_CONTRACTS_V" ("CONTRACTID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(contractid)  contractid
,     '['||
      concat('"'||upper(contractid)||'",'
      ,'"'||contractname||'"')||']' concatenated_values  
,     '['||'"'||upper(contractid)||'"]' concatenated_pk     
FROM xxspm_pl_contracts_v 
ORDER BY upper(contractid)
;

--------------------------------------------------------
--  DDL for View XXHSH_CONTENTPARTNERBILLINGINF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CONTENTPARTNERBILLINGINF_V" ("PARTNERNUMBER", "MEMOLINE", "VATCODE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(partnernumber),upper(memoline),upper(vatcode)
  , '['||concat('"'||upper(partnernumber)||'",'
  ,concat('"'||upper(memoline)||'",'
  ,concat('"'||upper(vatcode)||'",'
  ,'"'||defaultindicator||'"')))||']' concatenated_values 
  , '['||concat('"'||upper(partnernumber)||'",'
  ,concat('"'||upper(memoline)||'",'
  ,concat('"'||upper(vatcode)||'",'
  ,'"'||defaultindicator||'"')))||']' concatenated_pk 
FROM xxspm_contentpartnerbillinginf_v ORDER BY upper(partnernumber),upper(memoline),upper(vatcode)
;

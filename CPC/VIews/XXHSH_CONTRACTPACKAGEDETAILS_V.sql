--------------------------------------------------------
--  DDL for View XXHSH_CONTRACTPACKAGEDETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CONTRACTPACKAGEDETAILS_V" ("CONTRACTID", "PACKAGENAME", "STARTPERIOD", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(contractid)
  ,      upper(packagename)
  ,      startperiod
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      concat(decode(startperiod           ,NULL,'null','"'||to_char(startperiod,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat(decode(endperiod             ,NULL,'null','"'||to_char(endperiod  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      '"'||comments||'"'))))||']' concatenated_values  
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      decode(startperiod           ,NULL,'null','"'||to_char(startperiod,'YYYY-MM-DD')          ||'T00:00:00"')))||']'
  FROM xxspm_contractpackagedetails_v 
  ORDER BY upper(contractid)
  ,        upper(packagename)
  ,        startperiod
;

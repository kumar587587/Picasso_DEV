--------------------------------------------------------
--  DDL for View XXHSH_CONTRACTPACKAGECHANNELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CONTRACTPACKAGECHANNELS_V" ("CONTRACTID", "PACKAGENAME", "CHANNELNAME", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(contractid)
  ,      upper(packagename)
  ,      upper(channelname)
  ,      startdate
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      concat('"'||upper(channelname)||'",'
  ,      concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||''))))||']' concatenated_values  
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      concat('"'||upper(channelname)||'",'
  ,      decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||'')))||']' concatenated_pk  
  FROM xxspm_contractpackagechannels_v 
  ORDER BY upper(contractid)
  ,        upper(packagename)
  ,        upper(channelname)
  ,        startdate
;

--------------------------------------------------------
--  DDL for View XXHSH_SPECIALPACKAGESDETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_SPECIALPACKAGESDETAILS_V" ("SPECIALPACKAGENAME", "PACKAGENAME", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(specialpackagename),upper(packagename),startdate
  ,      '['||concat('"'||upper(specialpackagename)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      concat('"'||operation||'",'
  ,      concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      '"'||remarks||'"')))))||']' concatenated_values  
  ,      '['||concat('"'||upper(specialpackagename)||'",'
  ,      concat('"'||upper(packagename)||'",'
  ,      decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')))||']' concatenated_pk
  FROM xxspm_specialpackagesdetails_v
  ORDER BY upper(specialpackagename)
  ,        upper(packagename)
  ,        startdate
;

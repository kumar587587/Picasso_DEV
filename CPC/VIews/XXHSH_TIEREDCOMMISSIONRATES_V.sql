--------------------------------------------------------
--  DDL for View XXHSH_TIEREDCOMMISSIONRATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_TIEREDCOMMISSIONRATES_V" ("CONTRACTID", "STARTDATE", "TIERID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(contractid)
  ,      startdate
  ,      tierid
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat('"'||tierid||'",'
  ,      concat(''||min||','
  ,      concat(''||max||','
  ,      concat(''||rtrim(ltrim(to_char(rateamount,'fm999999999999999990D9999999999')),'.')||','
  ,      '"'||remarks||'"')))))))||']' concatenated_values  
  ,      '['||concat('"'||upper(contractid)||'",'
  ,      concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      '"'||tierid)))||'"]'  concatenated_pk
  FROM xxspm_tieredcommissionrates_v 
  ORDER BY upper(contractid)
  ,        startdate
  ,        tierid
;

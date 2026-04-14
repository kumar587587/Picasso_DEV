--------------------------------------------------------
--  DDL for View XXHSH_PROVIDERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_PROVIDERS_V" ("PROVIDERNAME", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(providername),startdate
  ,     '['||concat('"'||upper(providername)||'",'
  ,     concat('"'||detailsonspec||'",'
  ,     concat('"'||hideflag||'",'
  ,     concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,     concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,     '"'||sequenceno||'"')))))||']' concatenated_values  
  ,     '['||concat('"'||upper(providername)||'",'
  ,     decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"'))||']' concatenated_pk
  FROM xxspm_providers_v 
  ORDER BY upper(providername),startdate
;

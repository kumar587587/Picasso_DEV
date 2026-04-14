--------------------------------------------------------
--  DDL for View XXHSH_SP_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_SP_CONTRACTS_V" ("CONTRACTID", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT contractid
  ,      startdate
  ,     '['||concat('"'||contractid||'",'
  ,     concat('"'||contractname||'",'
  ,     concat('"'||contentpartnernumber||'",'
  ,     concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,     concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,     concat(decode(endreminderby       ,NULL,'null','"'||to_char(endreminderby,'YYYY-MM-DD')      ||'T00:00:00"')||','
  ,     concat(decode(inflationreminderby ,NULL,'null','"'||to_char(inflationreminderby,'YYYY-MM-DD')||'T00:00:00"')||','
  ,     concat('"'||holdpayment||'",'
  ,     concat('"'||remarks    ||'",'
  ,     concat('"'||contracttype||'",'
  ,     '"'||paywithcomarch||'"'  )))))))))) ||']' concatenated_values  
  ,     '['||concat('"'||contractid||'",'
  ,     decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"'))||']' concatenated_pk
  FROM xxspm_sp_contracts_v
  ORDER BY contractid
  ,        startdate
;

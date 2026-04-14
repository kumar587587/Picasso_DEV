--------------------------------------------------------
--  DDL for View XXHSH_SUBSCRIBER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_SUBSCRIBER_V" ("PROVIDER", "PERIODCOUNTED", "PACKAGE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(provider),periodcounted,upper(package)
   ,     '['||concat('"'||upper(provider)||'",'
   ,     concat(decode(periodcounted           ,NULL,'null','"'||to_char(periodcounted,'YYYY-MM-DD')          ||'T00:00:00"')||','
   ,     concat('"'||upper(package)||'",'
   ,     concat(''||endquantity||','
   ,     concat(''||nvl(startquantity,0)||','
   ,     concat('"'||transactiontype||'",'
   ,     concat('"'||source||'",'
   ,     concat('"'||importdate||'",'
   ,     '"'||sourcefile||'"'))))))))||']' concatenated_values  
   ,     '['||concat('"'||upper(provider)||'",'
   ,     concat(decode(periodcounted           ,NULL,'null','"'||to_char(periodcounted,'YYYY-MM-DD')          ||'T00:00:00"')||','
   ,     '"'||upper(package)))||'"]' concatenated_pk
   FROM xxspm_subscriber_v 
   ORDER BY upper(provider)
   ,        periodcounted
   ,        upper(package)
;

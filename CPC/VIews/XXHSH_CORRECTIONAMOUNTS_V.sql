--------------------------------------------------------
--  DDL for View XXHSH_CORRECTIONAMOUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CORRECTIONAMOUNTS_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT id
  ,'['||
   concat('"'||id||'",'
  ,concat('"'||partnernumber||'",'
  ,concat('"'||partnername||'",'
  ,concat('"'||invoiceno||'",'
  ,concat(decode(invoiceperiod           ,NULL,'null','"'||to_char(invoiceperiod,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,concat('"'||duedateoverride||'",'
  ,concat(''||rtrim(ltrim(to_char(paymentamount,'fm999999999999999990D9999999999')),'.')||','
  ,concat('"'||paymentdescription||'",'
  ,concat('"'||displayonspecification||'",'
  ,concat('"'||referenceonspec||'",'
  ,concat('"'||transactiontype||'",'
  ,concat('"'||source||'",'
  ,concat('"'||decode(importdate           ,NULL,'null',''||to_char(importdate,'YYYY-MM-DD')          ||'T00:00:00"')||','||''
  ,            decode(ENDDATECOMPPERIOD    ,NULL,'null','"'||to_char(ENDDATECOMPPERIOD,'YYYY-MM-DD')   ||'T00:00:00"')||''
  )))))))))))))||']' concatenated_values  
  ,'['||'"'||id||'"]' concatenated_pk
FROM xxspm_correctionamounts_v 
ORDER BY id
;

--------------------------------------------------------
--  DDL for View XXHSH_CONTENTPARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CONTENTPARTNERS_V" ("PARTNERNUMBER", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT partnernumber
  ,      startdate
  ,      '['||concat('"'||partnernumber||'",'
  ,      concat('"'||partnername||'",'
  ,      concat('"'||cpcode||'",'
  ,      concat('"'||billingdebtornr||'",'
  ,      concat('"'||billinglocation||'",'
  ,      concat('"'||partnerlanguage||'",'
  ,      concat('"'||createspecificationindicator||'",'
  ,      concat('"'||holdpaymentsindicator||'",'
  ,      concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,      concat('"'||partnerpaymentterms||'",'
  ,      concat('"'||'CPC'||'",'    --indentifiertype
  ,      concat('"'||billingcity||'",'
  ,      concat('"'||nvl(l.description,NULL)||'",'    --billingcountry
  ,      concat('"'||billingcountrycode||'",'
  --,      concat('"'||NULL||'",'    --billingdeliverto
  ,      concat('"'||partnerbillingname||'",'   --billingdeliverto
  ,      concat('"'||billingiban||'",'
  ,      concat('"'||billingpostalcode||'",'
  ,      concat('"'||NULL||'",'   --billingstate
  ,      concat('"'||billingstreet||'",'
  ,      concat('"'||billingvatnumber||'",'  --BillingVATNumber can be NULL!!!!!
  --,      concat('"'||billingemailaddress||'"'  
  ,      '"'||billingemailaddress||'"'  
  --,      '"'||parent||'"'
  --)
  )))))))))))))))))))))||']' concatenated_values  
  ,      '['||concat('"'||partnernumber||'",' 
  ,      decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"'))||']' concatenated_pk
  FROM xxcpc_contentpartners  c
  ,    xxcpc_lookups l
  WHERE 1=1
  AND l.type(+) = 'ISO_COUNTRY_CODE'
  AND l.code(+) = billingcountrycode
  ORDER BY partnernumber,startdate
;

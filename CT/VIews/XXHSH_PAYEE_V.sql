--------------------------------------------------------
--  DDL for View XXHSH_PAYEE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_PAYEE_V" ("PAYEEID_", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(payeeid_)   payeeid_
,     '['||
      concat('"'||upper(payeeid_)||'",'
,     concat(decode(name_            ,NULL,'null','"'||name_            ||'"')||','
,     concat(decode(parent_          ,NULL,'null','"'||parent_          ||'"')||','
,     concat(decode(salutation_      ,NULL,'null','' ||salutation_      ||'')||','
,     concat(decode(email_           ,NULL,'""'  ,'"'||email_           ||'"')||','
,     concat(decode(phone_           ,NULL,'""'  ,'"'||phone_           ||'"')||','
,     concat(decode(extension_       ,NULL,'""'  ,'"'||extension_       ||'"')||','
,     concat(decode(titleid_         ,NULL,'null','' ||titleid_         ||'')||','
,     concat(decode(reports_to_      ,NULL,'null','' ||reports_to_      ||'')||','
,     concat(decode(payee_currency_  ,NULL,'null','' ||payee_currency_  ||'')||','
,     concat(decode(date_of_hire_    ,NULL,'null','' ||date_of_hire_    ||'')||','
,     concat(decode(termination_date_,NULL,'null','' ||termination_date_||'')||','
,     concat(decode(comment_         ,NULL,'""'  ,'"'||comment_         ||'"')||','
,     concat(decode(status           ,NULL,'null','' ||status           ||'')||','
,     concat(decode(admin            ,NULL,'null','' ||admin            ||'')||','
,     concat(decode(language         ,NULL,'null','"'||language         ||'"')||','
,     concat(decode(centrecode       ,NULL,'""','"'||centrecode       ||'"')||','
,     concat(decode(role             ,NULL,'""'  ,'"B'||role            ||'"')||','
,     concat(decode(admintyperole    ,NULL,'null',''  ||admintyperole   ||'')||','
,     concat(decode(payeetype        ,NULL,'null','"' ||payeetype       ||'"')||','
,     concat(decode(name_            ,NULL,'null','"' ||name_||'('||ltrim(payeeid_)||')'  ||'"')||','
,     'null')))))))))))))))))))))||
      ']' concatenated_values  
,     '['||'"'||upper(payeeid_)||'"]'  concatenated_pk    
FROM xxspm_payee_v 
ORDER BY upper( payeeid_ )
;

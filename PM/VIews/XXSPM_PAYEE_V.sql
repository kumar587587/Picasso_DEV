--------------------------------------------------------
--  DDL for View XXSPM_PAYEE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXSPM_PAYEE_V" ("PAYEEID_", "NAME_", "PARENT_", "SALUTATION_", "EMAIL_", "PHONE_", "EXTENSION_", "TITLEID_", "REPORTS_TO_", "PAYEE_CURRENCY_", "DATE_OF_HIRE_", "TERMINATION_DATE_", "COMMENT_", "STATUS", "ADMIN", "LANGUAGE", "CENTRECODE", "ROLE", "ADMINTYPEROLE", "PAYEETYPE", "PAYEENAMEID", "HOLDPAYMENT", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT partner_vcode       payeeid_
,      partner_name                  name_
,      'null'                       parent_
,      'null'                       salutation_
,      email_address          email_
,      NULL                         phone_
,      NULL                         extension_
,      'null'                       titleid_
,      'null'                       reports_to_
,      'null'                       payee_currency_
,      'null'                       date_of_hire_
,      'null'                       termination_date_
,      NULL                         comment_
,      'null'                       status
,      'null'                       admin  
,      'NL'                         language
,      center_code                  centrecode
,      NULL                         role
,      'null'                       admintyperole
,      'PARTNER'            payeetype
,      partner_name||'('||partner_vcode||')'  payeenameid  
--,      '""'        holdpayment 
,      'null'        holdpayment 
,      greatest(creation_date,last_update_date)    last_update_or_creation_date
FROM xxpm_partners_v pnr
WHERE 1=1
AND   pnr.partner_type                    = 'Hoofd-Partner'     
AND   TO_NUMBER(pnr.partner_classification_code)     > 0
AND   TO_NUMBER(pnr.partner_classification_code)    != 99
AND   TO_NUMBER(pnr.partner_classification_code)    in  (1,5,8)
AND   nvl(pnr.end_date,sysdate+10000)     > TO_DATE('01-01-2022','DD-MM-YYYY')
AND   pnr.indicator_in_ex_code                 = 'E'
AND   upper(pnr.partner_name) NOT LIKE '%IVR%'
AND   upper(pnr.partner_name) NOT LIKE '%TEST%'
AND   upper(pnr.partner_vcode) NOT LIKE 'AA%'
UNION
SELECT DISTINCT partner_vcode       payeeid_
,      partner_name                  name_
,      'null'                       parent_
,      'null'                       salutation_
,      email_address          email_
,      NULL                         phone_
,      NULL                         extension_
,      'null'                       titleid_
,      'null'                       reports_to_
,      'null'                       payee_currency_
,      'null'                       date_of_hire_
,      'null'                       termination_date_
,      NULL                         comment_
,      'null'                       status
,      'null'                       admin  
,      'NL'                         language
,      center_code                  centrecode
,      NULL                         role
,      'null'                       admintyperole
,      'PARTNER'            payeetype
,      partner_name||'('||partner_vcode||')'  payeenameid  
--,      '""'        holdpayment 
,      'null'        holdpayment 
,      greatest(creation_date,last_update_date)    last_update_or_creation_date
FROM xxpm_partners_v pnr
WHERE 1=1
AND   pnr.partner_type                    = 'Hoofd-Partner'     
AND   TO_NUMBER(pnr.partner_classification_code)     > 0
AND   TO_NUMBER(pnr.partner_classification_code)    != 99
AND   TO_NUMBER(pnr.partner_classification_code)    = 9
AND   nvl(pnr.end_date,sysdate+10000)     > TO_DATE('01-01-2022','DD-MM-YYYY')
AND   pnr.indicator_in_ex_code                 = 'E'
AND   upper(pnr.partner_name) NOT LIKE '%IVR%'
AND   upper(pnr.partner_name) NOT LIKE '%TEST%'
AND   upper(pnr.partner_vcode) NOT LIKE 'AA%'
UNION
SELECT DISTINCT partner_vcode       payeeid_
,      partner_name                  name_
,      'null'                       parent_
,      'null'                       salutation_
,      email_address          email_
,      NULL                         phone_
,      NULL                         extension_
,      'null'                       titleid_
,      'null'                       reports_to_
,      'null'                       payee_currency_
,      'null'                       date_of_hire_
,      'null'                       termination_date_
,      NULL                         comment_
,      'null'                       status
,      'null'                       admin  
,      'NL'                         language
,      center_code                  centrecode
,      NULL                         role
,      'null'                       admintyperole
,      'PARTNER'            payeetype
,      partner_name||'('||partner_vcode||')'  payeenameid  
--,      '""'        holdpayment 
,      'null'        holdpayment 
,      greatest(creation_date,last_update_date)    last_update_or_creation_date
FROM xxpm_partners_v pnr
WHERE 1=1
AND   pnr.partner_type                    = 'Hoofd-Partner'     
AND   TO_NUMBER(pnr.partner_classification_code)     > 0
AND   TO_NUMBER(pnr.partner_classification_code)    != 99
AND   TO_NUMBER(pnr.partner_classification_code)    = 8
AND   nvl(pnr.end_date,sysdate+10000)     > TO_DATE('01-01-2022','DD-MM-YYYY')
AND   pnr.indicator_in_ex_code                 = 'E'
AND   upper(pnr.partner_name) NOT LIKE '%IVR%'
AND   upper(pnr.partner_name) NOT LIKE '%TEST%'
AND   upper(pnr.partner_vcode) NOT LIKE 'AA%'
ORDER BY 1
;

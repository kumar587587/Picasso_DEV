--------------------------------------------------------
--  DDL for View XXSPM_PAYEE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXSPM_PAYEE_V" ("PAYEEID_", "NAME_", "PARENT_", "SALUTATION_", "EMAIL_", "PHONE_", "EXTENSION_", "TITLEID_", "REPORTS_TO_", "PAYEE_CURRENCY_", "DATE_OF_HIRE_", "TERMINATION_DATE_", "COMMENT_", "STATUS", "ADMIN", "LANGUAGE", "CENTRECODE", "ROLE", "ADMINTYPEROLE", "PAYEETYPE", "PAYEENAMEID", "HOLDPAYMENT", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT v_code       payeeid_
,      partner_name                  name_
,      null                       parent_
,      'null'                       salutation_
,      email_address_invoice          email_
,      NULL                         phone_
,      NULL                         extension_
,      'null'                       titleid_
,      'null'                       reports_to_
,      'null'                       payee_currency_
,      'null'                       date_of_hire_
,      'null'                       termination_date_
,      NULL                         comment_
,      '"A"'                       status
,      'null'                       admin  
,      'NL'              language
,      null                       centrecode
,      NULL                         role
,      'null'                       admintyperole
,      'PARTNER'            payeetype
,      partner_name||'('||v_code||')'  payeenameid  
,      null        holdpayment 
,      greatest(sysdate,sysdate)    last_update_or_creation_date
FROM xxct_partners_tmp 
ORDER BY 1
;

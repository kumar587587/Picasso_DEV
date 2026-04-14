--------------------------------------------------------
--  DDL for View XXSPM_PAYEE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PAYEE_V" ("PAYEEID_", "NAME_", "PARENT_", "SALUTATION_", "EMAIL_", "PHONE_", "EXTENSION_", "TITLEID_", "REPORTS_TO_", "PAYEE_CURRENCY_", "DATE_OF_HIRE_", "TERMINATION_DATE_", "COMMENT_", "STATUS", "ADMIN", "LANGUAGE", "CENTRECODE", "ROLE", "ADMINTYPEROLE", "PAYEETYPE", "PAYEENAMEID", "HOLDPAYMENT", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT partnernumber       payeeid_
,      partnername                  name_
,      parent                       parent_
,      'null'                       salutation_
,      billingemailaddress          email_
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
,      partnerlanguage              language
,      cpcode                       centrecode
,      NULL                         role
,      'null'                       admintyperole
,      'CONTENT PARTNER'            payeetype
,      partnername||'('||partnernumber||')'  payeenameid  
,      holdpaymentsindicator        holdpayment 
,      greatest(created,updated)    last_update_or_creation_date
FROM xxcpc_contentpartners 
ORDER BY 1
;

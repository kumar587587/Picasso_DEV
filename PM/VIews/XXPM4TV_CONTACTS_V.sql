--------------------------------------------------------
--  DDL for View XXPM4TV_CONTACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM4TV_CONTACTS_V" ("PARTNER_ID", "CONTACT_ID", "CONTACT_ID_SALESFORCE", "CONTACT_FIRST_NAME", "CONTACT_INITIALS", "CONTACT_PREFIX", "CONTACT_LAST_NAME", "CONTACT_TITLE", "CONTACT_PHONE_NUMBER", "CONTACT_PHONE_NUMBER_MOBILE", "CONTACT_DATE_OF_BIRTH", "CONTACT_EMAIL_ADDRESS", "CONTACT_TYPE", "CONTACT_TYPE_OTHER", "CONTACT_FUNCTION", "CONTACT_REMARKS", "CONTACT_ACTIVE_INDICATOR", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  c.partner_id
  ,       c.contact_id
  ,       c.contact_id_salesforce
  ,       c.contact_first_name
  ,       c.contact_initials
  ,       c.contact_prefix
  ,       c.contact_last_name
  ,       c.contact_title
  ,       c.contact_phone_number
  ,       c.contact_phone_number_mobile
  ,       decode(contact_date_of_birth,null,null, to_char(c.contact_date_of_birth,'YYYY-MM-DD')||'T00:00:00Z')           contact_date_of_birth
  ,       c.contact_email_address
  ,       c.contact_type
  ,       c.contact_type_other
  ,       c.contact_function
  ,       c.contact_remarks
  ,       c.contact_active_indicator
  ,       to_char(c.creation_date,'YYYY-MM-DD')||'T'||to_char(creation_date,'HH24:MI:SS')||'Z'                   creation_date
  ,       c.created_by
  ,       to_char(c.last_update_date,'YYYY-MM-DD')||'T'||to_char(last_update_date,'HH24:MI:SS')||'Z'                last_update_date
  ,       c.last_updated_by
  ----
FROM xxpm_contacts       c
WHERE c.partner_id in (select partner_id from xxpm4tv_partners_v )
;

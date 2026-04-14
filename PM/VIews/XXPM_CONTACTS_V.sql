--------------------------------------------------------
--  DDL for View XXPM_CONTACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_CONTACTS_V" ("CONTACT_ID", "CONTACT_ID_EDIT", "CONTACT_ID_VIEW", "CONTACT_FIRST_NAME", "CONTACT_INITIALS", "CONTACT_PREFIX", "CONTACT_LAST_NAME", "CONTACT_TITLE", "CONTACT_PHONE_NUMBER", "CONTACT_DATE_OF_BIRTH", "CONTACT_EMAIL_ADDRESS", "CONTACT_TYPE", "CONTACT_PARTNER_ID", "CONTACT_ACTIVE_INDICATOR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contact_id, 
  c.contact_id, 
  c.contact_id, 
          c.contact_first_name, 
          c.contact_initials, 
          c.contact_prefix, 
          c.contact_last_name, 
          a.meaning contact_title, 
          c.contact_phone_number, 
          c.contact_date_of_birth, 
          c.contact_email_address, 
          r.meaning contact_type, 
          c.partner_id contact_partner_id, 
          DECODE (c.contact_active_indicator, 
                  'Y', 'Ja', 
                  'N', 'Nee', 
                  NULL, 'Ja') 
             contact_active_indicator 
     FROM xxpm_contacts c, 
          XXPM_LOOKUP_VALUES r, 
          XXPM_LOOKUP_VALUES a 
    WHERE     1 = 1 
          AND r.lookup_type(+) = 'RELATIE_TYPES' 
          AND LTRIM (TO_CHAR (c.contact_title)) = r.code(+) 
          AND a.lookup_type(+) = 'AANHEF' 
          AND LTRIM (TO_CHAR (c.contact_title)) = a.code(+)
;

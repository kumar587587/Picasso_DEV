--------------------------------------------------------
--  DDL for View XXHSH_PM_CONTACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_PM_CONTACTS_V" ("CONTACT_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select contact_id,
CONCAT ('"' || c.partner_id||'",',            --partner_id
CONCAT ('"' || c.contact_id||'",',            --contact_id
CONCAT ('"' || c.contact_id_salesforce||'",',            --contact_id_salesforce
CONCAT ('"' || c.contact_first_name||'",',            --contact_first_name
CONCAT ('"' || c.contact_initials||'",',            --contact_initials
CONCAT ('"' || c.contact_prefix||'",',            --contact_prefix
CONCAT ('"' || c.contact_last_name||'",',            --contact_last_name
CONCAT ('"' || c.contact_title||'",',            --contact_title
CONCAT ('"' || c.contact_phone_number||'",',            --contact_phone_number
CONCAT ('"' || c.contact_phone_number_mobile||'",',            --contact_phone_number_mobile
CONCAT ('"' || to_char( c.contact_date_of_birth,'MONYYYYDD')||'",',            --contact_date_of_birth
CONCAT ('"' || c.contact_email_address||'",',            --contact_email_address
CONCAT ('"' || c.contact_type||'",',            --contact_type
CONCAT ('"' || c.contact_type_other||'",',            --contact_type_other
CONCAT ('"' || c.contact_function||'",',            --contact_function
CONCAT ('"' || c.contact_remarks||'",',            --contact_remarks
CONCAT ('"' || to_char( c.creation_date,'MONYYYYDD')||'",',            --creation_date
CONCAT ('"' || c.created_by||'",',            --created_by
CONCAT ('"' || to_char( c.last_update_date,'MONYYYYDD') ||'",',            --last_update_date
CONCAT ('"' || c.last_updated_by||'",',            --last_updated_by
'"' || c.contact_active_indicator||'"')            --contact_active_indicator
)))))))))))))))))))  concatenated_values
--select *
from XXPM_CONTACTS c
;

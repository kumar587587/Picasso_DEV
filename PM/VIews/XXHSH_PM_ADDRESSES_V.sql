--------------------------------------------------------
--  DDL for View XXHSH_PM_ADDRESSES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_PM_ADDRESSES_V" ("ADDRESS_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select address_id,
CONCAT ('"' || c.address_id||'",',            --address_id
CONCAT ('"' || c.address_street||'",',            --address_street
CONCAT ('"' || c.address_house_number||'",',            --address_house_number
CONCAT ('"' || c.address_house_number_suffix||'",',            --address_house_number_suffix
CONCAT ('"' || c.address_zip_code||'",',            --address_zip_code
CONCAT ('"' || replace( c.address_residence,'''','#APOSTROF#') ||'",',            --address_residence
CONCAT ('"' || c.address_type||'",',            --address_type
CONCAT ('"' || c.address_type_other||'",',            --address_type_other
CONCAT ('"' || c.partner_id||'",',            --partner_id
CONCAT ('"' || c.postbus||'",',            --postbus
CONCAT ('"' || c.address_country||'",',            --address_country
CONCAT ('"' || c.address_function||'",',            --address_function
CONCAT ('"' || to_char( c.creation_date,'MONYYYYDD') ||'",',            --creation_date
CONCAT ('"' || c.created_by||'",',            --created_by
CONCAT ('"' || to_char( c.last_update_date, 'MONYYYYDD') ||'",',            --last_update_date
'"' || c.last_updated_by||'"'            --last_updated_by
))))))))))))))) concatenated_values
from XXPM_ADDRESSES c

--select * from xxpm_addresses;
;

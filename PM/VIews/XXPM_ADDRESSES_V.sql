--------------------------------------------------------
--  DDL for View XXPM_ADDRESSES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_ADDRESSES_V" ("ADDRESS_ID", "ADDRESS_ID_EDIT", "ADDRESS_ID_VIEW", "ADDRESS_STREET", "ADDRESS_STREET_READ_ONLY", "ADDRESS_HOUSE_NUMBER", "ADDRESS_HOUSE_NUMBER_SUFFIX", "ADDRESS_ZIP_CODE", "ADDRESS_RESIDENCE", "ADDRESS_TYPE", "PARTNER_ID", "ADDRESS_COUNTRY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.address_id, 
  a.address_id, 
  a.address_id, 
          a.address_street, 
          a.address_street address_street_read_only, 
          a.address_house_number, 
          a.address_house_number_suffix, 
          a.address_zip_code, 
          a.address_residence, 
          t.meaning address_type, 
          a.partner_id, 
          a.address_country
     FROM xxpm_addresses a, xxpm_lookup_values t 
     WHERE     1 = 1 
          AND t.lookup_type = 'ADRES_TYPEN' 
          AND t.enabled_flag = 'Y' 
          AND to_char (a.address_type) = t.code
;

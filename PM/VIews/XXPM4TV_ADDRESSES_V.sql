--------------------------------------------------------
--  DDL for View XXPM4TV_ADDRESSES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM4TV_ADDRESSES_V" ("ADDRESS_ID", "PARTNER_ID", "ADDRESS_STREET", "ADDRESS_HOUSE_NUMBER", "ADDRESS_HOUSE_NUMBER_SUFFIX", "ADDRESS_ZIP_CODE", "ADDRESS_RESIDENCE", "ADDRESS_TYPE", "ADDRESS_TYPE_OTHER", "POSTBUS", "ADDRESS_COUNTRY", "ADDRESS_FUNCTION", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        a.address_id
      , a.partner_id
      , a.address_street
      , a.address_house_number
      , a.address_house_number_suffix
      , a.address_zip_code
      , a.address_residence
      , a.address_type
      , a.address_type_other
      , a.postbus
      , a.address_country
      , a.address_function
      , to_char(a.creation_date, 'YYYY-MM-DD')
          || 'T'
          || to_char(a.creation_date, 'HH24:MI:SS')
          || 'Z' creation_date
      , a.created_by
      , to_char(a.last_update_date, 'YYYY-MM-DD')
          || 'T'
          || to_char(a.last_update_date, 'HH24:MI:SS')
          || 'Z' last_update_date
      , a.last_updated_by
    FROM
        xxpm_addresses a
    WHERE
        a.partner_id IN (
            SELECT
                partner_id
            FROM
                xxpm4tv_partners_v
        )
;

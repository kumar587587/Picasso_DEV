--------------------------------------------------------
--  DDL for View XXPM_PARTNER_ADDRESS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_PARTNER_ADDRESS_V" ("PARTNER_ID", "ADDRESS_COUNTRY", "ADDRESS_ID", "ADDRESS_STREET", "ADDRESS_HOUSE_NUMBER", "ADDRESS_HOUSE_NUMBER_SUFFIX", "ADDRESS_ZIP_CODE", "ADDRESS_RESIDENCE", "ADDRESS_TYPE", "ADDRESS_TYPE_OTHER", "POSTBUS", "ADDRESS_FUNCTION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a1.partner_id, a2.address_country,a2.address_id,a2.address_street, a2.address_house_number, a2.address_house_number_suffix, a2.address_zip_code,a2.address_residence, a2.address_type,a2.address_type_other
, a2.postbus,a2.address_function
from 
(
WITH  invoice_address   AS ( SELECT * FROM xxpm_addresses WHERE address_type = 4 )
,     vestiging_address AS ( SELECT * FROM xxpm_addresses WHERE address_type = 1 )  
,     hoofd_address     AS ( SELECT * FROM xxpm_addresses WHERE address_type = 2 )  
,     post_address      AS ( SELECT * FROM xxpm_addresses WHERE address_type = 3 )   
SELECT distinct pnr1.partner_id                                                        partner_id
,      coalesce (adr4.address_id, adr1.address_id, adr2.address_id, adr3.address_id)   address_id
FROM   invoice_address   adr4
,      vestiging_address adr1
,      hoofd_address     adr2
,      post_address      adr3
,      xxpm_partners     pnr1
WHERE  1=1
AND       pnr1.partner_id  = adr4.partner_id (+)
AND       pnr1.partner_id  = adr1.partner_id (+)
AND       pnr1.partner_id  = adr2.partner_id (+)
AND       pnr1.partner_id  = adr3.partner_id (+)
AND       pnr1.partner_classification          > 0
AND       pnr1.partner_classification          not in (99,-1) /*99 = Sub-partners zonder hoofdpartner, -1 = Oude Troep */
AND       pnr1.partner_type                    = 'M' 
) a1
, xxpm_addresses a2
where a1.address_id = a2.address_id
;

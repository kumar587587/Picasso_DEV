--------------------------------------------------------
--  DDL for View XXHSH_PM_PARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_PM_PARTNERS_V" ("PARTNER_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT partner_id,
CONCAT (
'"' || c.partner_id || '",',                       --partner_id
CONCAT (
'"' || c.partner_id_salesforce || '",', --partner_id_salesforce
CONCAT (
'"' || c.partner_name || '",',             --partner_name
CONCAT (
'"' || c.partner_vcode || '",',        --partner_vcode
CONCAT (
'"' || c.partner_number || '",',   --partner_number
CONCAT (
'"' || c.partner_number_residential || '",', --partner_number_residential
CONCAT (
'"' || c.partner_classification || '",', --partner_classification
CONCAT (
'"' || c.oracle_customer_nr || '",', --oracle_customer_nr
CONCAT (
'"' || c.kvk_number || '",', --kvk_number
CONCAT (
'"' || c.vat_code || '",', --vat_code
CONCAT (
'"' || c.partner_type || '",', --partner_type
CONCAT (
'"'
|| c.indicator_in_ex
|| '",',     --indicator_in_ex
CONCAT (
'"'
|| c.email_address
|| '",',    --email_address
CONCAT (
'"'
|| c.email_address_invoice
|| '",', --email_address_invoice
CONCAT (
'"'
|| c.phone_number
|| '",', --phone_number
CONCAT (
'"'
|| c.iban_number
|| '",', --iban_number
CONCAT (
'"'
|| c.vamo_type
|| '",', --vamo_type
CONCAT (
'"'
|| c.chain_id
|| '",', --chain_id
CONCAT (
'"'
|| c.main_partner_id
|| '",', --main_partner_id
CONCAT (
'"'
|| to_char( c.start_date,'MONYYYYDD')
|| '",', --start_date
CONCAT (
'"'
|| to_char( c.end_date,'MONYYYYDD')
|| '",', --end_date
CONCAT (
'"'
|| c.channel_manager
|| '",', --channel_manager
CONCAT (
'"'
|| c.retail_support_manager
|| '",', --retail_support_manager
CONCAT (
'"'
|| c.business_partner_manager
|| '",', --business_partner_manager
CONCAT (
'"'
|| c.business_partner_sales_manager
|| '",', --business_partner_sales_manager
CONCAT (
'"'
|| c.bpo_region
|| '",', --bpo_region
CONCAT (
'"'
|| c.compensation_plan
|| '",', --compensation_plan
CONCAT (
'"'
|| c.ivr_code
|| '",', --ivr_code
CONCAT (
'"'
|| c.partner_channel
|| '",', --partner_channel
CONCAT (
'"'
|| c.ip_whitelist
|| '",', --ip_whitelist
CONCAT (
'"'
|| c.telfort_code
|| '",', --telfort_code
CONCAT (
'"'
|| c.tabo_code
|| '",', --tabo_code
CONCAT (
'"'
|| to_char( c.certificate_date,'MONYYYYDD')  
|| '",', --certificate_date
CONCAT (
'"'
|| c.partner_url
|| '",', --partner_url
CONCAT (
'"'
|| c.indicator_attribute_1
|| '",', --indicator_attribute_1
CONCAT (
'"'
|| c.indicator_attribute_2
|| '",', --indicator_attribute_2
CONCAT (
'"'
|| c.indicator_attribute_3
|| '",', --indicator_attribute_3
CONCAT (
'"'
|| c.indicator_attribute_4
|| '",', --indicator_attribute_4
CONCAT (
'"'
|| c.indicator_attribute_5
|| '",', --indicator_attribute_5
CONCAT (
'"'
|| c.indicator_attribute_6
|| '",', --indicator_attribute_6
CONCAT (
'"'
|| c.indicator_attribute_7
|| '",', --indicator_attribute_7
CONCAT (
'"'
|| c.indicator_attribute_8
|| '",', --indicator_attribute_8
CONCAT (
'"'
|| c.indicator_attribute_9
|| '",', --indicator_attribute_9
CONCAT (
'"'
|| c.indicator_attribute_10
|| '",', --indicator_attribute_10
CONCAT (
'"'
|| c.flex_attribute_1
|| '",', --flex_attribute_1
CONCAT (
'"'
|| c.flex_attribute_2
|| '",', --flex_attribute_2
CONCAT (
'"'
|| c.flex_attribute_3
|| '",', --flex_attribute_3
CONCAT (
'"'
|| c.flex_attribute_4
|| '",', --flex_attribute_4
CONCAT (
'"'
|| c.flex_attribute_5
|| '",', --flex_attribute_5
CONCAT (
'"'
|| c.flex_attribute_6
|| '",', --flex_attribute_6
CONCAT (
'"'
|| c.flex_attribute_7
|| '",', --flex_attribute_7
CONCAT (
'"'
|| c.flex_attribute_8
|| '",', --flex_attribute_8
CONCAT (
'"'
|| c.flex_attribute_9
|| '",', --flex_attribute_9
CONCAT (
'"'
|| c.flex_attribute_10
|| '",', --flex_attribute_10
CONCAT (
'"'
|| c.MESSAGE
|| '",', --message
CONCAT (
'"'
|| c.excel_row_number
|| '",', --excel_row_number
CONCAT (
'"'
|| c.import_changes
|| '",', --import_changes
CONCAT (
'"'
|| to_char( c.creation_date,'MONYYYYDD')
|| '",', --creation_date
CONCAT (
'"'
|| c.created_by
|| '",', --created_by
CONCAT (
'"'
|| to_char( c.last_update_date,'MONYYYYDD')
|| '",', --last_update_date
CONCAT (
'"'
|| c.last_updated_by
|| '",', --last_updated_by
CONCAT (
'"'
|| c.main_partner_vcode
|| '",', --main_partner_vcode
CONCAT (
'"'
|| c.gpg_public_key_id
|| '",', --gpg_public_key_id
CONCAT (
'"'
|| c.partner_flow_type
|| '",', --partner_flow_type
CONCAT (
'"'
|| c.name_on_invoice
|| '",', --name_on_invoice
CONCAT (
'"'
|| c.share_documents
|| '",', --share_documents
CONCAT (
'"'
|| c.iphone
|| '",', --iphone
CONCAT (
'"'
|| c.vamos_mol
|| '",', --vamos_mol
CONCAT (
'"'
|| c.excellent_partner
|| '",', --excellent_partner
CONCAT (
'"'
|| c.kpn_een
|| '",', --kpn_een
CONCAT (
'"'
|| c.point_of_sale
|| '",', --point_of_sale
CONCAT (
'"'
|| c.vat_reverse_charge
|| '",', --vat_reverse_charge
CONCAT (
'"'
|| c.tv_mail_specification
|| '",', --tv_mail_specification
CONCAT (
   '"'
|| c.use_in_credittool_cm
|| '",', --use_in_credittool_cm
   '"Y'
--|| null
|| '"' --payee_active
      ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
concatenated_values
FROM XXPM_PARTNERS c
ORDER BY 1
;

--------------------------------------------------------
--  DDL for View XXCT_PARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PARTNERS_V" ("PARTNER_ID", "PARTNER_NAME", "V_CODE", "CHANNEL_MANAGER", "RESOURCE_ID", "CHANNEL_MANAGER_PERSON_ID", "PARTNER_NUMBER", "EMAIL_ADDRESS_INVOICE", "PARTNER_FLOW_TYPE", "ORACLE_CUSTOMER_NR", "VAT_REVERSE_CHARGE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT partner_id
  ,      partner_name
  ,      v_code
  ,      channel_manager
  ,      resource_id
  ,      channel_manager_person_id
  ,      partner_number
  ,      email_address_invoice
  ,      partner_flow_type 
  ,      oracle_customer_nr
  ,      vat_reverse_charge
  FROM TABLE(xxct_gen_rest_apis.get_partners)
;

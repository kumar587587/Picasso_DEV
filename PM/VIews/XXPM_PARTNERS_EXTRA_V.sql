--------------------------------------------------------
--  DDL for View XXPM_PARTNERS_EXTRA_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_PARTNERS_EXTRA_V" ("PARTNER_ID", "PARTNER_ID_SALESFORCE", "PARTNER_NAME", "PARTNER_VCODE", "PARTNER_NUMBER", "PARTNER_NUMBER_RESIDENTIAL", "PARTNER_CLASSIFICATION", "ORACLE_CUSTOMER_NR", "ORACLE_CUSTOMER_NR_BPO", "KVK_NUMBER", "VAT_CODE", "PARTNER_TYPE", "INDICATOR_IN_EX", "EMAIL_ADDRESS", "EMAIL_ADDRESS_INVOICE", "PHONE_NUMBER", "IBAN_NUMBER", "VAMO_TYPE", "CHAIN_ID", "CHAIN_ID_BPO", "CHAIN_ID_BPO_NON_ESMEE", "MAIN_PARTNER_ID", "START_DATE", "END_DATE", "CHANNEL_MANAGER", "CHANNEL_MANAGER_OTHER", "RETAIL_SUPPORT_MANAGER", "RETAIL_SUPPORT_MANAGER_OTHER", "BUSINESS_PARTNER_MANAGER", "BUSINESS_PARTNER_MANAGER_BPO", "BUSINESS_PARTNER_SALES_MANAGER", "BUSINESS_PARTNER_SALES_MANAGER_BPO", "BPO_REGION", "COMPENSATION_PLAN", "IVR_CODE", "PARTNER_CHANNEL", "IP_WHITELIST", "TELFORT_CODE", "TABO_CODE", "CERTIFICATE_DATE", "PARTNER_URL", "MAIN_PARTNER_VCODE", "ADDRESS_STREET", "ADDRESS_HOUSE_NUMBER", "ADDRESS_HOUSE_NUMBER_SUFFIX", "ADDRESS_ZIP_CODE", "ADDRESS_RESIDENCE", "ADDRESS_TYPE", "POSTBUS", "CONTACT_FIRST_NAME", "CONTACT_INITIALS", "CONTACT_PREFIX", "CONTACT_LAST_NAME", "CONTACT_TITLE", "CONTACT_PHONE_NUMBER", "CONTACT_DATE_OF_BIRTH", "CONTACT_EMAIL_ADDRESS", "CONTACT_TYPE", "CONTACT_FUNCTION", "GPG_PUBLIC_KEY_ID", "PARTNER_FLOW_TYPE", "USE_IN_CREDITTOOL_CM", "SHARE_DOCUMENTS", "NAME_ON_INVOICE", "VAT_REVERSE_CHARGE", "ADDRESS_COUNTRY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT p.partner_id, 
          p.partner_id_salesforce, 
          p.partner_name, 
          p.partner_vcode, 
          p.partner_number, 
          p.partner_number_residential, 
          p.partner_classification, 
          p.oracle_customer_nr, 
          p.oracle_customer_nr oracle_customer_nr_bpo, 
          p.kvk_number, 
          p.vat_code, 
          p.partner_type, 
          p.indicator_in_ex, 
          p.email_address, 
          p.email_address_invoice, 
          p.phone_number, 
          p.iban_number, 
          p.vamo_type, 
          p.chain_id, 
          p.chain_id chain_id_bpo, 
          p.chain_id chain_id_bpo_non_esmee, 
          p.main_partner_id, 
          p.start_date, 
          p.end_date, 
          p.channel_manager, 
          p.channel_manager   channel_manager_other,  -- Channel_manager_other added on 12-1-2024
          p.retail_support_manager, 
          p.retail_support_manager  retail_support_manager_other, -- Retail Support Manager Other added on 02-12-2024
          p.business_partner_manager, 
          p.business_partner_manager business_partner_manager_bpo, 
          p.business_partner_sales_manager, 
          p.business_partner_sales_manager business_partner_sales_manager_bpo, 
          p.bpo_region, 
          p.compensation_plan, 
          p.ivr_code, 
          p.partner_channel, 
          p.ip_whitelist, 
          p.telfort_code, 
          p.tabo_code, 
          p.certificate_date, 
          p.partner_url, 
          p.main_partner_vcode, 
          '                                                                      '  address_street, 
          '           '  address_house_number, 
          '           '  address_house_number_suffix, 
          '           '  address_zip_code, 
          '           '  address_residence, 
          '           '  address_type,
          '           '  postbus, 
          '           '  contact_first_name, 
          '           '  contact_initials, 
          '           '  contact_prefix, 
          '           '  contact_last_name, 
          '           '  contact_title, 
          '           '  contact_phone_number, 
          '           '  contact_date_of_birth, 
          '           '  contact_email_address, 
          '           '  contact_type, 
          '           '  contact_function 
          ,p.gpg_public_key_id 
          ,p.partner_flow_type
          ,p.use_in_credittool_cm
         , p.share_documents
         , p.name_on_invoice
         --, p.payee_active
         , p.vat_reverse_charge
         ,'                              '  address_country  --MWT-897
     FROM xxpm_partners p
;
  GRANT SELECT ON "WKSP_XXPM"."XXPM_PARTNERS_EXTRA_V" TO "WKSP_XXCT";

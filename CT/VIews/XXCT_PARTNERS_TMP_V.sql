--------------------------------------------------------
--  DDL for View XXCT_PARTNERS_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PARTNERS_TMP_V" ("PARTNER_ID", "PARTNER_NAME", "V_CODE", "CHANNEL_MANAGER", "RESOURCE_ID", "CHANNEL_MANAGER_PERSON_ID", "PARTNER_NUMBER", "EMAIL_ADDRESS_INVOICE", "PARTNER_FLOW_TYPE", "ORACLE_CUSTOMER_NR", "VAT_REVERSE_CHARGE", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT p.partner_id                    partner_id 
  ,      p.partner_name                  partner_name 
  ,      p.v_code                        v_code 
  ,      u.display_name                  channel_manager
  ,      p.resource_id                   resource_id
  ,      p.channel_manager_person_id     channel_manager_person_id
  ,      p.partner_number                partner_number
  ,      p.email_address_invoice         email_address_invoice  
  ,      p.partner_flow_type             partner_flow_type  
  ,      p.oracle_customer_nr            oracle_customer_nr
  ,      p.vat_reverse_charge            vat_reverse_charge
  ,      p.username                      username 
FROM xxct_partners_tmp p
,    xxct_users u
WHERE lower( p.username )   = nvl(  v('APP_USER') , xxct_general_pkg.get_developer_user )
AND   u.ruis_name  = p.channel_manager
--AND  '1'           = xxct_gen_debug_pkg.debug('XXCT_PARTNERS_TMP_V','running view V(APP_USER) = '||v('APP_USER'))
;

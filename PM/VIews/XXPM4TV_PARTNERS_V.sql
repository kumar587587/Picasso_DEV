--------------------------------------------------------
--  DDL for View XXPM4TV_PARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM4TV_PARTNERS_V" ("PARTNER_ID", "PARTNER_VCODE", "PARTNER_TYPE", "PARTNER_NAME", "INDICATOR_IN_EX", "EMAIL_ADDRESS", "EMAIL_ADDRESS_INVOICE", "PARTNER_NUMBER", "PARTNER_NUMBER_RESIDENTIAL", "START_DATE", "END_DATE", "ORACLE_CUSTOMER_NR", "PARTNER_FLOW_TYPE", "PARTNER_CHANNEL", "VAT_CODE", "IBAN_NUMBER", "LAST_UPDATE_DATE", "CREATION_DATE", "FLEX_ATTRIBUTE_2", "PARTNER_CLASSIFICATION", "CHAIN_ID", "MAIN_PARTNER_ID", "VAT_REVERSE_CHARGE", "STATUTORYNAME", "CHANNEL_MANAGER", "RETAIL_SUPPORT_MANAGER") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT p.partner_id
  ,      p.partner_vcode                                                        partner_vcode
  ,      p.partner_type                                                         partner_type
  ,      p.partner_name                                                         partner_name
  ,      p.indicator_in_ex                                                      indicator_in_ex
  ,      p.email_address                                                        email_address
  ,      p.email_address_invoice                                                email_address_invoice
  ,      p.partner_number                                                       partner_number
  ,      p.partner_number_residential                                           partner_number_residential
  ,      to_char(p.start_date,'YYYY-MM-DD')||'T00:00:00Z'                       start_date
  ,      decode(p.end_date,null,null,to_char(p.end_date,'YYYY-MM-DD')||'T00:00:00Z')                         end_date
  ,      p.oracle_customer_nr                                                   oracle_customer_nr
  ,      p.partner_flow_type                                                    partner_flow_type	   
  ,      p.partner_channel                                                      partner_channel 
  ,      p.vat_code                                                             vat_code
  ,      p.iban_number                                                          iban_number
  ,      to_char(p.last_update_date,'YYYY-MM-DD')||'T'||to_char(p.last_update_date,'HH24:MI:SS')||'Z'        last_update_date  
  ,      to_char(p.creation_date,'YYYY-MM-DD')||'T'||to_char(p.creation_date,'HH24:MI:SS')||'Z'        creation_date
  ,      p.flex_attribute_2                                                     flex_attribute_2 
  ,      p.partner_classification  
  ,      p.chain_id
  ,      p.main_partner_id
  ,      p.vat_reverse_charge
  --,      p.payee_active
  ,     p.name_on_invoice
  ,     p.channel_manager       
  ,     p.retail_support_manager
FROM xxpm_partners       p 
,    xxpm_partners       mpr
,    xxpm_chains         c
,    xxpm_chains         c2
WHERE     1=1  
AND       mpr.chain_id                      = c.chain_id (+)
AND       p.chain_id                        = c2.chain_id (+)
AND       p.main_partner_id                 = mpr.partner_id (+)
AND       p.indicator_in_ex                 = 'E'   
AND       nvl(p.end_date,sysdate+10000)     >= TO_DATE('01-01-2022','DD-MM-YYYY')  
AND       upper(p.partner_name)             NOT LIKE '%IVR%'
AND       upper(p.partner_name)             NOT LIKE '%TEST%'
AND       upper(p.partner_vcode)            NOT LIKE 'AA%'
AND       p.partner_classification          NOT IN (99,-1)
AND       p.partner_classification          IN (1,2,5,8,9)
AND       (mpr.CHAIN_ID                     NOT IN (22896) OR mpr.CHAIN_ID IS NULL)
;

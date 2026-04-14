--------------------------------------------------------
--  DDL for View XXHSH_PARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_PARTNERS_V" ("PARTNER_ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(partner_id)   partner_id
,     '{'||
      concat('"partner_id":'                ||partner_id                                                                            ||','
,     concat('"partner_name":'              ||decode(partner_name                   ,NULL,'null' ,'"' ||partner_name                ||'"' )||','
,     concat('"partner_vcode":'             ||decode(partner_vcode                  ,NULL,'null' ,'"' ||partner_vcode               ||'"' )||','      
,     concat('"partner_number":'            ||decode(partner_number                 ,NULL,'null' ,''  ||partner_number              ||''  )||','
,     concat('"partner_number_residential":'||decode(partner_number_residential     ,NULL,'null' ,''  ||partner_number_residential  ||''  )||','
,     concat('"partner_classification":'    ||decode(partner_classification         ,NULL,'""'   ,''  ||partner_classification      ||''  )||','
,     concat('"oracle_customer_nr":'        ||decode(oracle_customer_nr             ,NULL,'null' ,'"' ||oracle_customer_nr          ||'"' )||','
,     concat('"vat_code":'                  ||decode(vat_code                       ,NULL,'null' ,'"' ||vat_code                    ||'"' )||','
,     concat('"partner_type":'              ||decode(partner_type                   ,NULL,'null' ,'"' ||partner_type                ||'"' )||','
,     concat('"indicator_in_ex":'           ||decode(indicator_in_ex                ,NULL,'""'   ,'"' ||indicator_in_ex             ||'"' )||','
,     concat('"email_address":'             ||decode(email_address                  ,NULL,'null' ,'"' ||email_address               ||'"' )||','
,     concat('"email_address_invoice":'     ||decode(email_address_invoice          ,NULL,'null' ,'"' ||email_address_invoice       ||'"' )||','
,     concat('"iban_number":'               ||decode(iban_number                    ,NULL,'null' ,'"' ||TRIM(iban_number)           ||'"' )||','
,     concat('"start_date":'                ||decode(start_date                     ,NULL,'null' ,'"' ||start_date                  ||'"' )||','
,     concat('"end_date":'                  ||decode(end_date                       ,NULL,'null' ,'"' ||end_date                    ||'"' )||','
,     concat('"partner_channel":'           ||decode(partner_channel                ,NULL,'null' ,'"' ||partner_channel             ||'"' )||','
,     concat('"flex_attribute_2":'          ||decode(flex_attribute_2               ,NULL,'null' ,'"' ||flex_attribute_2            ||'"' )||','
,     concat('"creation_date":'             ||decode(creation_date                  ,NULL,'null' ,'"' ||creation_date               ||'"' )||','
,     concat('"last_update_date":'          ||decode(last_update_date               ,NULL,'null' ,'"' ||last_update_date            ||'"' )||','
,     concat('"partner_flow_type":'         ||decode(partner_flow_type              ,NULL,'null' ,'"' ||partner_flow_type           ||'"' )||','
,     concat('"main_partner_id":'           ||decode(main_partner_id                ,NULL,'null' ,''  ||main_partner_id             ||''  )||','
,     concat('"chain_id":'                  ||decode(chain_id                       ,NULL,'null' ,''  ||chain_id                    ||''  )||','
,     concat('"vat_reverse_charge":'        ||decode(vat_reverse_charge             ,NULL,'null' ,'"' ||vat_reverse_charge          ||'"'  )||','
,     concat('"statutoryname":'             ||decode(statutoryname                  ,NULL,'null' ,'"' ||statutoryname               ||'"'  )||','
,     concat('"channel_manager":'           ||decode(channel_manager                ,NULL,'null' ,'"' ||channel_manager             ||'"'  )||','
,     '"retail_support_manager":'           ||decode(retail_support_manager         ,NULL,'null' ,'"' ||retail_support_manager      ||'"' )
)))))))))))))))))))))))))
||
      '}' concatenated_values  
,     '['||'"'||upper(partner_vcode)||'"]'  concatenated_pk    
FROM xxpm4tv_partners_v pnr
WHERE 1=1
--and upper(partnervcode)  = 'CT117'
ORDER BY  partner_id
;

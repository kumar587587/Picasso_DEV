--------------------------------------------------------
--  DDL for View XXHSH_CONTACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_CONTACTS_V" ("CONTACT_ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT contact_id   contact_id
,     '{'||
     concat('"contact_id":'                 ||contact_id                                                                         ||','
,     concat('"contact_id_salesforce":'      ||decode(contact_id_salesforce       ,NULL,'null' ,'"' ||contact_id_salesforce       ||'"')||','      
,     concat('"contact_first_name":'         ||decode(contact_first_name          ,NULL,'null' ,'"' ||contact_first_name          ||'"')||','
,     concat('"contact_initials":'           ||decode(contact_initials            ,NULL,'null' ,'"' ||contact_initials            ||'"')||','
,     concat('"contact_prefix":'             ||decode(contact_prefix              ,NULL,'null' ,'"' ||contact_prefix              ||'"')||','
,     concat('"contact_last_name":'          ||decode(contact_last_name           ,NULL,'null' ,'"' ||contact_last_name           ||'"')||','
,     concat('"contact_title":'              ||decode(contact_title               ,NULL,'null' ,''  ||contact_title               ||'')||','
,     concat('"contact_phone_number":'       ||decode(contact_phone_number        ,NULL,'null' ,'"' ||contact_phone_number        ||'"')||','
,     concat('"contact_phone_number_mobile":'||decode(contact_phone_number_mobile ,NULL,'null' ,'"' ||contact_phone_number_mobile ||'"')||','
,     concat('"contact_date_of_birth":'      ||decode(contact_date_of_birth       ,NULL,'null' ,'"' ||contact_date_of_birth       ||'"')||','
,     concat('"contact_email_address":'      ||decode(contact_email_address       ,NULL,'null' ,'"' ||contact_email_address       ||'"')||','
,     concat('"contact_type":'               ||decode(contact_type                ,NULL,'null' ,''  ||TRIM(contact_type)          ||'' )||','
,     concat('"contact_type_other":'         ||decode(contact_type_other          ,NULL,'null' ,'"' ||contact_type_other          ||'"' )||','
,     concat('"contact_function":'           ||decode(contact_function            ,NULL,'null' ,'"' ||contact_function            ||'"' )||','
,     concat('"contact_remarks":'            ||decode(contact_remarks             ,NULL,'null' ,'"' ||contact_remarks             ||'"')||','
,     concat('"contact_active_indicator":'   ||decode(contact_active_indicator    ,NULL,'null' ,'"' ||contact_active_indicator    ||'"')||','
,     concat('"creation_date":'              ||decode(creation_date               ,NULL,'null' ,'"' ||creation_date               ||'"' )||','
,     concat('"created_by":'                 ||decode(created_by                  ,NULL,'null' ,'"' ||created_by                  ||'"' )||','
,     concat('"last_update_date":'           ||decode(last_update_date            ,NULL,'null' ,'"' ||last_update_date            ||'"' )||','
,     concat('"last_updated_by":'            ||decode(last_updated_by             ,NULL,'null' ,'"' ||last_updated_by             ||'"' )||','
,     '"partner_id":'                        ||decode(partner_id                  ,NULL,'null' ,''  ||partner_id                  ||'')
))))))))))))))))))))
||
      '}' concatenated_values  
,     '['||'"'||contact_id||'"]'  concatenated_pk    
FROM xxpm4tv_contacts_v pnr
WHERE 1=1
--and upper(partnervcode)  = 'CT117'
ORDER BY  contact_id
;

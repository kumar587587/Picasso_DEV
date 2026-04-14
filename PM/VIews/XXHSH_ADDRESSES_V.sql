--------------------------------------------------------
--  DDL for View XXHSH_ADDRESSES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_ADDRESSES_V" ("ADDRESS_ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT address_id   address_id
,     '{'||
      concat('"address_id":'                   ||address_id                                                                                   ||','
,     concat('"address_street":'               ||decode(address_street                ,NULL,'null' ,'"' ||address_street                ||'"')||','      
,     concat('"address_house_number":'         ||decode(address_house_number          ,NULL,'null' ,'"' ||address_house_number          ||'"')||','
,     concat('"address_house_number_suffix":'  ||decode(address_house_number_suffix   ,NULL,'null' ,'"' ||address_house_number_suffix   ||'"')||','
,     concat('"address_zip_code":'             ||decode(address_zip_code              ,NULL,'null'   ,'"' ||address_zip_code              ||'"')||','
,     concat('"address_residence":'            ||decode(address_residence             ,NULL,'null' ,'"' ||address_residence             ||'"')||','
,     concat('"address_type":'                 ||decode(address_type                  ,NULL,'null' ,''  ||address_type                  ||'')||','
,     concat('"address_type_other":'           ||decode(address_type_other            ,NULL,'null' ,'"' ||address_type_other            ||'"')||','
,     concat('"postbus":'                      ||decode(postbus                       ,NULL,'null' ,'"' ||postbus                       ||'"')||','
,     concat('"address_country":'              ||decode(address_country               ,NULL,'null' ,'"' ||address_country               ||'"')||','
,     concat('"address_function":'             ||decode(address_function              ,NULL,'null' ,'"' ||address_function              ||'"')||','
,     concat('"creation_date":'                ||decode(creation_date                 ,NULL,'null' ,'"' ||creation_date                 ||'"' )||','
,     concat('"created_by":'                   ||decode(created_by                    ,NULL,'null' ,'"' ||created_by                    ||'"' )||','
,     concat('"last_update_date":'             ||decode(last_update_date              ,NULL,'null' ,'"' ||last_update_date              ||'"' )||','
,     concat('"last_updated_by":'              ||decode(last_updated_by               ,NULL,'null' ,'"' ||last_updated_by               ||'"' )||','
,     '"partner_id":'                          ||partner_id
)))))))))))))))
||
      '}' concatenated_values  
,     '['||'"'||address_id||'"]'  concatenated_pk    
FROM xxpm4tv_addresses_v pnr
WHERE 1=1
--and upper(partnervcode)  = 'CT117'
ORDER BY  address_id
;

--------------------------------------------------------
--  DDL for View XXPM_ROW_COUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_ROW_COUNTS_V" ("SEQNR", "TV_NAME", "PM_COUNT", "PM_HASH", "TV_COUNT", "TV_HASH", "PM_HASH_VIEW_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 10                                                 seqnr
  ,'XXTV_CHAINS'                                            tv_name
  , COUNT(*)                                                  pm_count
  , xxpm_synchronize_api.hash_value( 'XXHSH_CHAINS_V')      pm_hash
  , xxpm_gen_rest_apis.get_table_count('XXTV_CHAINS' )      tv_count  
  , xxpm_synchronize_api.get_hash_on_table_via_api( 'XXTV_CHAINS')  tv_hash
  ,'XXHSH_CHAINS_V'                                         pm_hash_view_name  
  FROM xxpm4tv_chains_v 
union
  SELECT 20                                                   seqnr
  ,'XXTV_PARTNERS'                                            tv_name
  , COUNT(*)                                                  pm_count
  , xxpm_synchronize_api.hash_value( 'XXHSH_PARTNERS_V')      pm_hash
  , xxpm_gen_rest_apis.get_table_count('XXTV_PARTNERS' )      tv_count  
  , xxpm_synchronize_api.get_hash_on_table_via_api( 'XXTV_PARTNERS')  tv_hash
  ,'XXHSH_PARTNERS_V'                                         pm_hash_view_name  
  FROM xxpm4tv_partners_v 
  union
    SELECT 30                                                 seqnr
  ,'XXTV_CONTACTS'                                            tv_name
  , COUNT(*)                                                  pm_count
  , xxpm_synchronize_api.hash_value( 'XXHSH_CONTACTS_V')      pm_hash
  , xxpm_gen_rest_apis.get_table_count('XXTV_CONTACTS' )      tv_count  
  , xxpm_synchronize_api.get_hash_on_table_via_api( 'XXTV_CONTACTS')  tv_hash
  ,'XXHSH_CONTACTS_V'                                         pm_hash_view_name  
  FROM xxpm4tv_contacts_v 
union
    SELECT 40                                                 seqnr
  ,'XXTV_ADDRESSES'                                            tv_name
  , COUNT(*)                                                  pm_count
  , xxpm_synchronize_api.hash_value( 'XXHSH_ADDRESSES_V')      pm_hash
  , xxpm_gen_rest_apis.get_table_count('XXTV_ADDRESSES' )      tv_count  
  , xxpm_synchronize_api.get_hash_on_table_via_api( 'XXTV_ADDRESSES')  tv_hash
  ,'XXHSH_ADDRESSES_V'                                         pm_hash_view_name  
  FROM xxpm4tv_addresses_v 
  ORDER BY 1
;

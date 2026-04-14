--------------------------------------------------------
--  DDL for View XXCT_ROW_COUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_ROW_COUNTS_V" ("SEQNR", "SPM_NAME", "APEX_COUNT", "APEX_HASH", "SPM_COUNT", "VARICENT_HASH", "HASH_VIEW_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 90 seqnr
  ,'plIAMRole' spm_name
  , COUNT(*) apex_count
  , xxct_synchronize_api.hash_value( 'XXHSH_ROLES_V') apex_hash
  , xxct_gen_rest_apis.get_table_count( 'plIAMRole' )  spm_count  
  , xxct_synchronize_api.get_hash_on_varicent_table('plIAMRole' ) varicent_hash
  , 'XXHSH_ROLES_V'
  FROM XXSPM_ROLES_V
UNION  
  SELECT 100 seqnr
  ,'spCTWFLevels' spm_name
  , COUNT(*) apex_count
  , xxct_synchronize_api.hash_value( 'XXHSH_SPCTWFLEVELS_V') apex_hash
  , xxct_gen_rest_apis.get_table_count( 'spCTWFLevels' ) spm_count  
  , xxct_synchronize_api.get_hash_on_varicent_table('spCTWFLevels' ) varicent_hash
  , 'XXHSH_SPCTWFLEVELS_V'
  FROM XXSPM_SPCTWFLEVELS_V  
--union
-- SELECT -100 seqnr
--  ,'Payee_' spm_name
--  , COUNT(*) apex_count
--  , xxct_synchronize_api.hash_value( 'XXHSH_PAYEE_V' ) apex_hash
--  , xxct_gen_rest_apis.get_table_count('Payee_' ) spm_count  
--  , xxct_synchronize_api.get_hash_on_varicent_table( 'Payee_') varicent_hash
--  ,'XXHSH_PAYEE_V' hash_view_name
--  FROM xxspm_payee_v 
--  where 1=2
UNION  
  SELECT 100 seqnr
  ,'spUserRole' spm_name
  , COUNT(*) apex_count
  , xxct_synchronize_api.hash_value( 'XXHSH_USER_ROLES_V') apex_hash
  , xxct_gen_rest_apis.get_table_count( 'spUserRole' ) spm_count  
  , xxct_synchronize_api.get_hash_on_varicent_table('spUserRole' ) varicent_hash
  , 'XXHSH_USER_ROLES_V'
  FROM XXSPM_USER_ROLES_V  
UNION  
  SELECT 100 seqnr
  ,'spUserDelegates' spm_name
  , COUNT(*) apex_count
  , xxct_synchronize_api.hash_value( 'XXHSH_SPUSERSDELEGATES_V') apex_hash
  , xxct_gen_rest_apis.get_table_count( 'spUserDelegates' ) spm_count  
  , xxct_synchronize_api.get_hash_on_varicent_table('spUserDelegates' ) varicent_hash
  , 'XXHSH_SPUSERSDELEGATES_V'
  FROM XXSPM_SPUSERSDELEGATES_V  
  ORDER BY 1
;

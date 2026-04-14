--------------------------------------------------------
--  DDL for View XXCPC_ROW_COUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXCPC_ROW_COUNTS_V" ("SEQNR", "SPM_NAME", "APEX_COUNT", "APEX_HASH", "SPM_COUNT", "VARICENT_HASH", "HASH_VIEW_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT -100 seqnr
  ,'Payee_' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PAYEE_V' ) apex_hash
  , xxcpc_gen_rest_apis.get_table_count('Payee_' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'Payee_') varicent_hash
  ,'XXHSH_PAYEE_V' hash_view_name
  FROM xxspm_payee_v 
  UNION 
  SELECT -90 seqnr
  ,'plChannelInformation' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CHANNELINFORMATION_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plChannelInformation' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plChannelInformation') varicent_hash
  ,'XXHSH_CHANNELINFORMATION_V'
  FROM xxspm_channelinformation_v 
  UNION 
  SELECT -80 seqnr
  ,'plContract' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PL_CONTRACTS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plContract' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plContract') varicent_hash
  ,'XXHSH_PL_CONTRACTS_V'
  FROM xxspm_pl_contracts_v 
  UNION 
  SELECT -70 seqnr
  ,'plPackage' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PACKAGE_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plPackage' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plPackage') varicent_hash
  ,'XXHSH_PACKAGE_V'
  FROM xxspm_package_v 
  UNION 
  SELECT -60 seqnr
  ,'plProvider' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PROVIDER_V') apex_hash  
  , xxcpc_gen_rest_apis.get_table_count('plProvider' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plProvider') varicent_hash
  ,'XXHSH_PROVIDER_V'
  FROM xxspm_provider_v  
  UNION
  SELECT 13 seqnr
  ,'spCPCChannel' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CHANNELS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spCPCChannel' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spCPCChannel') varicent_hash
  ,'XXHSH_CHANNELS_V'
  FROM xxspm_channels_v   
  UNION 
  SELECT 29 seqnr
  ,'spContentPartnerBillingInformation' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CONTENTPARTNERBILLINGINF_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spContentPartnerBillingInformation' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spContentPartnerBillingInformation') varicent_hash
  ,'XXHSH_CONTENTPARTNERBILLINGINF_V'
  FROM xxspm_contentpartnerbillinginf_v 
  UNION 
  SELECT 28 seqnr
  ,'spContentPartner' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CONTENTPARTNERS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spContentPartner' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spContentPartner') varicent_hash
  ,'XXHSH_CONTENTPARTNERS_V'
  FROM xxspm_contentpartners_v 
  UNION 
  SELECT 60 seqnr
  ,'spContractPackageChannel' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CONTRACTPACKAGECHANNELS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spContractPackageChannel' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spContractPackageChannel') varicent_hash
  ,'XXHSH_CONTRACTPACKAGECHANNELS_V'
  FROM xxspm_contractpackagechannels_v 
  UNION 
  SELECT 32 seqnr
  ,'spContractPackageDetails' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CONTRACTPACKAGEDETAILS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spContractPackageDetails' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spContractPackageDetails') varicent_hash
  ,'XXHSH_CONTRACTPACKAGEDETAILS_V'
  FROM xxspm_contractpackagedetails_v 
  UNION 
  SELECT 31 seqnr
  ,'spContracts' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_SP_CONTRACTS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spContracts' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spContracts') varicent_hash
  ,'XXHSH_SP_CONTRACTS_V'
  FROM xxspm_sp_contracts_v 
  UNION 
  SELECT 16 seqnr
  ,'spPackage' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PACKAGES_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spPackage' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spPackage') varicent_hash
  ,'XXHSH_PACKAGES_V'
  FROM xxspm_packages_v 
  UNION 
  SELECT 26 seqnr
  ,'spProvider' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_PROVIDERS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spProvider' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spProvider') varicent_hash
  ,'XXHSH_PROVIDERS_V'
  FROM xxspm_providers_v 
  UNION 
  SELECT 20 seqnr
  ,'spSpecialPackagesDetails' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_SPECIALPACKAGESDETAILS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spSpecialPackagesDetails' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spSpecialPackagesDetails') varicent_hash
  ,'XXHSH_SPECIALPACKAGESDETAILS_V'
  FROM xxspm_specialpackagesdetails_v 
  UNION 
  SELECT 85 seqnr
  ,'spCPCTieredCommissionRate' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_TIEREDCOMMISSIONRATES_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spCPCTieredCommissionRate' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spCPCTieredCommissionRate') varicent_hash
  ,'XXHSH_TIEREDCOMMISSIONRATES_V'
  FROM xxspm_tieredcommissionrates_v 
  UNION 
  SELECT 5 seqnr
  ,'plMemoLine' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_MEMOLINE_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plMemoLine' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plMemoLine') varicent_hash
  ,'XXHSH_MEMOLINE_V'
  FROM xxspm_memoline_v 
--  UNION 
--  SELECT 10 seqnr
--  ,'plVATCode' spm_name
--  , COUNT(*) apex_count
--  , xxcpc_synchronize_api.hash_value( 'XXHSH_VATCODE_V') apex_hash
--  , xxcpc_gen_rest_apis.get_table_count('plVATCode' ) spm_count  
--  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plVATCode') varicent_hash
--  FROM xxspm_vatcode_v 
  UNION 
  SELECT 110 seqnr
  ,'dtCPCPartnerInvoices' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_CORRECTIONAMOUNTS_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('dtCPCPartnerInvoices' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'dtCPCPartnerInvoices') varicent_hash
  ,'XXHSH_CORRECTIONAMOUNTS_V'
  FROM xxspm_correctionamounts_v 
  UNION 
  SELECT 100 seqnr
  ,'spCPCManualPartnerInvoice' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_MANUALPARTNERINVOICE_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spCPCManualPartnerInvoice' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spCPCManualPartnerInvoice') varicent_hash
  ,'XXHSH_MANUALPARTNERINVOICE_V'
  FROM xxspm_manualpartnerinvoice_v 
  UNION 
  SELECT 105 seqnr
  ,'spCPCManualPartnerInvoiceSplit' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_MANUALPARTNERINVOICESPLI_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spCPCManualPartnerInvoiceSplit' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spCPCManualPartnerInvoiceSplit') varicent_hash
  ,'XXHSH_MANUALPARTNERINVOICESPLI_V'
  FROM xxspm_manualpartnerinvoicespli_v 
  UNION 
  SELECT 115 seqnr
  ,'dtCPCSubscriberV2' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_SUBSCRIBER_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('dtCPCSubscriberV2' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'dtCPCSubscriberV2') varicent_hash
  ,'XXHSH_SUBSCRIBER_V'
  FROM xxspm_subscriber_v
  UNION 
  SELECT 116 seqnr
  ,'plIAMRole' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_ROLES_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plIAMRole' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plIAMRole') varicent_hash
  ,'XXHSH_ROLES_V'
  FROM XXHSH_ROLES_V
  UNION 
  SELECT 117 seqnr
  ,'spUserRole' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_USER_ROLES_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spUserRole' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spUserRole') varicent_hash
  ,'XXHSH_USER_ROLES_V'
  FROM XXHSH_USER_ROLES_V
  --Below VatCode added by TechM Team for MWT-581
  UNION 
  SELECT 118 seqnr
  ,'plVATCode' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_VATCODE_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('plVATCode' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'plVATCode') varicent_hash
  ,'XXHSH_VATCODE_V'
  FROM XXHSH_VATCODE_V
--Below spUserDelegates added by TechM Team for MWT-735
  UNION 
  SELECT 119 seqnr
  ,'spUserDelegates' spm_name
  , COUNT(*) apex_count
  , xxcpc_synchronize_api.hash_value( 'XXHSH_USERSDELEGATES_V') apex_hash
  , xxcpc_gen_rest_apis.get_table_count('spUserDelegates' ) spm_count  
  , xxcpc_synchronize_api.get_hash_on_varicent_table( 'spUserDelegates') varicent_hash
  ,'XXHSH_USERSDELEGATES_V'
  FROM XXHSH_USERSDELEGATES_V
  ORDER BY 1
;

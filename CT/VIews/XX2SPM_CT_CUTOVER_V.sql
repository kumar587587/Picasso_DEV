--------------------------------------------------------
--  DDL for View XX2SPM_CT_CUTOVER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XX2SPM_CT_CUTOVER_V" ("VIEW_NAME", "NUMBER_OF_RECORDS", "HASH_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 'XXHSH_CT_DOSSIERS_V' view_name,
          COUNT (*) number_of_records,
          xx2spm_hash_value ('XXHSH_CT_DOSSIERS_V') hash_value
     FROM XXHSH_CT_DOSSIERS_V
union     
   SELECT 'XXHSH_CT_DSSR_PRDCT_GROUPS_V' view_name,
          COUNT (*) number_of_records,
          xx2spm_hash_value ('XXHSH_CT_DSSR_PRDCT_GROUPS_V') hash_value
     FROM XXHSH_CT_DSSR_PRDCT_GROUPS_V
union     
   SELECT 'XXHSH_CT_DSSR_PRDCT_GRPS_HST_V' view_name,
          COUNT (*) number_of_records,
          xx2spm_hash_value ('XXHSH_CT_DSSR_PRDCT_GRPS_HST_V') hash_value
     FROM XXHSH_CT_DSSR_PRDCT_GRPS_HST_V
union     
   SELECT 'XXHSH_CT_MANDATES_V' view_name,
          COUNT (*) number_of_records,
          xx2spm_hash_value ('XXHSH_CT_MANDATES_V') hash_value
     FROM XXHSH_CT_MANDATES_V
   ORDER BY 1
;

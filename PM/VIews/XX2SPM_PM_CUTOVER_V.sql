--------------------------------------------------------
--  DDL for View XX2SPM_PM_CUTOVER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XX2SPM_PM_CUTOVER_V" ("VIEW_NAME", "NUMBER_OF_RECORDS", "HASH_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select 'xx2spm_02_partners'             view_name, count(*) number_of_records, xx2spm_hash_value('XXHSH_PM_PARTNERS_V')           hash_value from XXHSH_PM_PARTNERS_V union
select 'xx2spm_04_addresses'            view_name, count(*) number_of_records, xx2spm_hash_value('XXHSH_PM_ADDRESSES_V')          hash_value from XXHSH_PM_ADDRESSES_V union
select 'xx2spm_03_Contacts'             view_name, count(*) number_of_records, xx2spm_hash_value('XXHSH_PM_CONTACTS_V')           hash_value from XXHSH_PM_CONTACTS_V union
select 'xx2spm_01_chains'               view_name, count(*) number_of_records, xx2spm_hash_value('XXHSH_PM_CHAINS_V')             hash_value from XXHSH_PM_CHAINS_V 
order by 1
;

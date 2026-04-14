--------------------------------------------------------
--  DDL for View XXCT_DSSR_PRDCT_GRPS_HST_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DSSR_PRDCT_GRPS_HST_TMP_V" ("DOSSIER_ID", "DOSSIER_STATUS_OLD", "DOSSIER_STATUS_NEW", "CURRENT_AMOUNT", "PREVIOUS_AMOUNT", "PRODUCT_GROUP_CODE", "MANDATE_CYCLE", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT dossier_id
  ,      dossier_status_old
  ,      dossier_status_new
  ,      current_amount
  ,      previous_amount
  ,      product_group_code
  ,      mandate_cycle
  ,      username 
  FROM xxct_dssr_prdct_grps_hst_tmp 
  WHERE lower (username)  = nvl(  v('APP_USER') ,xxct_general_pkg.get_developer_user )
;

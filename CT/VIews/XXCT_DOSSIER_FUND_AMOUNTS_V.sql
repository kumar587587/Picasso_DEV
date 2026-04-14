--------------------------------------------------------
--  DDL for View XXCT_DOSSIER_FUND_AMOUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIER_FUND_AMOUNTS_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "FUNDED") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT dpg.dossier_id
                                     ,      dpg.product_group_code
                                     ,      SUM (amount) funded
                                     FROM xxct_dossier_product_groups dpg
                                     GROUP BY dpg.dossier_id, dpg.product_group_code
;

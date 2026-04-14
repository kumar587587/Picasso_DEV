--------------------------------------------------------
--  DDL for View XXCT_REP_2_MAX_ID_BCED_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP_2_MAX_ID_BCED_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "DSSR_PRDCT_GRP_HST_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT pgh2.dossier_id dossier_id,
            pgh2.product_group_code product_group_code,
            MAX (pgh2.dssr_prdct_grp_hst_id) dssr_prdct_grp_hst_id
       FROM xxct_dssr_prdct_grps_hst pgh2
      WHERE 1 = 1
        AND TRUNC (pgh2.status_date) <= TO_DATE (NVL (v ('P111_CHANGE_END_DATE'), '31-12-4712'),'DD-MM-YYYY')
        --AND TRUNC (pgh2.status_date) <= TO_DATE (NVL ( ('31-03-2025'), '31-12-4712'),'DD-MM-YYYY')
   GROUP BY pgh2.dossier_id, pgh2.product_group_code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP_2_MAX_ID_BCED_V"  IS '$Id: vw_XXCT_REP_2_MAX_ID_BCED_V.sql,v 1.1 2019/02/12 09:23:02 rikke493 Exp $'
;

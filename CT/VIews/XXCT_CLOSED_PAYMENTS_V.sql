--------------------------------------------------------
--  DDL for View XXCT_CLOSED_PAYMENTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CLOSED_PAYMENTS_V" ("PARENT_DOSSIER_ID", "PRODUCT_GROUP_CODE", "SUM_PAYMENTS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT xd.parent_dossier_id
  ,      pgh1.product_group_code
  ,      SUM (pgh1.amount) sum_payments
  FROM xxct_dossiers xd
  ,    xxct_dssr_prdct_grps_hst pgh1
  WHERE     1 = 1
  AND xd.dossier_type = 'PAYMENT'
  AND pgh1.dossier_status_new = 'AFGESLOTEN'
  AND pgh1.dossier_id = xd.dossier_id
  AND TRUNC (pgh1.status_date) <= LAST_DAY (SYSDATE)
  AND pgh1.dssr_prdct_grp_hst_id = (
                                    SELECT MAX (pgh2.dssr_prdct_grp_hst_id)
                                    FROM xxct_dssr_prdct_grps_hst pgh2
                                    WHERE     pgh2.dossier_id     = pgh1.dossier_id
                                    AND pgh2.product_group_code   = pgh1.product_group_code
                                    AND pgh2.dossier_status_new   = 'AFGESLOTEN'
                                    AND TRUNC (pgh2.status_date) <= LAST_DAY (SYSDATE)
                                    )
  GROUP BY xd.parent_dossier_id, pgh1.product_group_code
;

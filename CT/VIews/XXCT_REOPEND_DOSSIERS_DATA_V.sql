--------------------------------------------------------
--  DDL for View XXCT_REOPEND_DOSSIERS_DATA_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REOPEND_DOSSIERS_DATA_V" ("DOSSIER_ID", "PARTNER_ID", "FINANCIAL_CLOSE", "ACTION_START_DATE", "ACTION_END_DATE", "DOSSIER_TYPE", "PRODUCT_GROUP_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT xd.dossier_id
               ,      xd.partner_id --resource_id,
               ,      xd.financial_close
               ,      xd.action_start_date
               ,      xd.action_end_date
               ,      xd.dossier_type
               ,      pgh1.product_group_code
               FROM xxct_dossiers xd
               ,    xxct_dssr_prdct_grps_hst pgh1
               ,    xxct_reopend_dossiers_v reopend
               WHERE     1 = 1
               AND xd.dossier_id = reopend.dossier_id
               AND reopend.reopend = 'YES'
               AND pgh1.dossier_id = xd.dossier_id
               AND TRUNC (pgh1.status_date) <= LAST_DAY (SYSDATE)
               AND pgh1.dssr_prdct_grp_hst_id = (
                                                      SELECT MAX (pgh2.dssr_prdct_grp_hst_id)
                                                      FROM xxct_dssr_prdct_grps_hst pgh2
                                                      WHERE     1                   = 1
                                                      AND pgh2.dossier_id           = pgh1.dossier_id
                                                      AND pgh2.product_group_code   = pgh1.product_group_code
                                                      AND TRUNC (pgh2.status_date) <= LAST_DAY (SYSDATE)
                                                      )
;

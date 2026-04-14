--------------------------------------------------------
--  DDL for View XXCT_REP2_INCREASE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_INCREASE_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "AMOUNT_IN_PERIOD", "AMOUNT_BEFORE_PERIOD", "INCREASE", "DECREASE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT ip.dossier_id dossier_id,
          ip.product_group_code product_group_code,
          ip.amount amount_in_period,
          bp.amount amount_before_period,
          CASE WHEN ip.amount - bp.amount > 0 THEN ip.amount - bp.amount ELSE 0 END increase,
          CASE WHEN ip.amount - bp.amount <= 0 THEN bp.amount - ip.amount ELSE 0 END decrease
          
     FROM (SELECT dgh1.dossier_id, dgh1.product_group_code, dgh1.amount
             FROM xxct_dssr_prdct_grps_hst dgh1
            WHERE 1 = 1
            /*  AND EXISTS (SELECT 1 FROM xxct_dssr_prdct_grps_hst dgh2 WHERE 1 = 1 AND dgh2.dossier_id = dgh1.dossier_id
                                 AND dgh2.dossier_status_new = 'HEROPEND' 
                                 and   trunc(dgh2.status_date) <= to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                                                         )
              AND EXISTS (SELECT 1 FROM xxct_dssr_prdct_grps_hst dgh2 WHERE 1 = 1 AND dgh2.dossier_id = dgh1.dossier_id
                             AND dgh2.dossier_status_OLD = 'AFGESLOTEN'
                             --AND TRUNC (dgh2.status_date) < TO_DATE (NVL (v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                             )--*/ --Closed by TechM Team for MWT-546
              AND EXISTS (SELECT 1 FROM xxct_dssr_prdct_grps_hst dgh2 WHERE 1 = 1 AND dgh2.dossier_id = dgh1.dossier_id
                                 AND dgh2.dossier_status_new = 'HEROPEND' 
                                 and   trunc(dgh2.status_date) BETWEEN to_date(NVL(v ('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                                                   AND to_date(nvl(v ('P111_CHANGE_END_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                                                         )
              AND EXISTS (SELECT 1 FROM xxct_dssr_prdct_grps_hst dgh2 WHERE 1 = 1 AND dgh2.dossier_id = dgh1.dossier_id
                             AND dgh2.dossier_status_new = 'AFGESLOTEN'
                             --AND TRUNC (dgh2.status_date) < TO_DATE (NVL (('01-02-2025'),'01-01-1900'),'DD-MM-YYYY')
                             )--Added by TechM Team for MWT-546

              AND dgh1.dssr_prdct_grp_hst_id = (SELECT MAX (dgh2.dssr_prdct_grp_hst_id) FROM xxct_dssr_prdct_grps_hst dgh2
                                                 WHERE dgh2.dossier_id = dgh1.dossier_id 
                                                   AND dgh2.product_group_code = dgh1.product_group_code
                                                   --AND TRUNC (dgh2.status_date) BETWEEN TO_DATE (NVL (v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                                      --            AND TO_DATE (NVL(V('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY'))--Type changes by TechM Team for MWT-546
                                                                )  ) ip,
          (SELECT dgh1.dossier_id, dgh1.product_group_code, dgh1.amount
             FROM xxct_dssr_prdct_grps_hst dgh1
            WHERE 1 = 1
              AND dgh1.dssr_prdct_grp_hst_id = (SELECT MAX (dgh2.dssr_prdct_grp_hst_id) FROM xxct_dssr_prdct_grps_hst dgh2
                           WHERE dgh2.dossier_id = dgh1.dossier_id
                             AND dgh2.product_group_code = dgh1.product_group_code
                                 AND TRUNC (dgh2.status_date) < TO_DATE ( NVL (v('P111_CHANGE_START_DATE'),'31-12-4712'),'DD-MM-YYYY'))
                                 --and dossier_id = 3812
                                 ) bp
    WHERE 1 = 1
      AND ip.dossier_id = bp.dossier_id
      AND ip.product_group_code = bp.product_group_code
;

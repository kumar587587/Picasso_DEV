--------------------------------------------------------
--  DDL for View XXCT_REP2_PRV_PAYMENTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_PRV_PAYMENTS_V" ("PARENT_DOSSIER_ID", "DSSR_PRDCT_GRP_HST_ID", "PRODUCT_GROUP_CODE", "PAYMENTS_BEFORE_PERIOD_END", "CHANGE_START_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT xd1.parent_dossier_id parent_dossier_id,
         dgh1.dssr_prdct_grp_hst_id dssr_prdct_grp_hst_id,
         dgh1.product_group_code product_group_code,
         SUM (dgh1.amount) payments_before_period_end,
         TO_DATE (NVL(v('P111_CHANGE_START_DATE'), '01-01-1900'),'DD-MM-YYYY') change_start_date
    FROM xxct_dssr_prdct_grps_hst dgh1,
         xxct_dossiers xd1,
         xxct_rep_2_max_id_bced_v mid
   WHERE 1 = 1
     AND xd1.dossier_id = dgh1.dossier_id(+)
     AND xd1.dossier_type = 'PAYMENT' --'UITBETALING' --Type changes by TechM Team for MWT-546
     AND TRUNC (dgh1.status_date) <= TO_DATE (NVL(v('P111_CHANGE_END_DATE'), '31-12-4712'),'DD-MM-YYYY')
     AND dgh1.dossier_status_new IN ('CONTROLE','PROCURATIE','FACTURATIE','AFGESLOTEN')
     AND mid.dossier_id = dgh1.dossier_id
     AND mid.product_group_code = dgh1.product_group_code
     AND mid.dssr_prdct_grp_hst_id = dgh1.dssr_prdct_grp_hst_id
   GROUP BY xd1.parent_dossier_id,dgh1.dssr_prdct_grp_hst_id,dgh1.product_group_code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP2_PRV_PAYMENTS_V"  IS '$Id: vw_XXCT_REP2_PRV_PAYMENTS_V.sql,v 1.2 2019/02/12 09:26:22 rikke493 Exp $'
;

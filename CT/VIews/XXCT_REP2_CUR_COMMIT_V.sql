--------------------------------------------------------
--  DDL for View XXCT_REP2_CUR_COMMIT_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_CUR_COMMIT_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "FUNDING_BEFORE_PERIOD_END", "PAYMENTS_IN_PERIOD", "NEW_COMMITMENT", "CHANGE_END_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select xd1.dossier_id                                                         dossier_id
,      dgh1.product_group_code                                                  product_group_code
,      max(nvl(dgh1.amount,0))                                                  funding_before_period_end
,      sum(nvl(pay.payments_before_period_end,0))                               payments_in_period
,      max(nvl(dgh1.amount,0)) - sum(nvl(pay.payments_before_period_end,0))     new_commitment
,      to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')        change_end_date
from xxct_dssr_prdct_grps_hst      dgh1
,    xxct_dossiers                 xd1
,    xxct_rep2_prv_payments_v      pay
,    xxct_rep_2_max_id_bced_v      mid
where 1                            = 1
and   xd1.dossier_id               = dgh1.dossier_id
and   xd1.dossier_type             = 'RESERVATION'  --'RESERVERING' --Type changes by TechM Team for MWT-546
and   trunc(dgh1.status_date)      <= to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
and   mid.dossier_id               = xd1.dossier_id
and   mid.product_group_code       = dgh1.product_group_code
and   mid.dssr_prdct_grp_hst_id    = dgh1.dssr_prdct_grp_hst_id
and   pay.parent_dossier_id(+)     = xd1.dossier_id
and   pay.product_group_code(+)    = dgh1.product_group_code
--and   pay.dssr_prdct_grp_hst_id(+) = dgh1.dssr_prdct_grp_hst_id
group by xd1.dossier_id,dgh1.product_group_code,to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY');

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP2_CUR_COMMIT_V"  IS '$Id: vw_XXCT_REP2_CUR_COMMIT_V.sql,v 1.4 2019/07/12 19:57:48 engbe502 Exp $'
;

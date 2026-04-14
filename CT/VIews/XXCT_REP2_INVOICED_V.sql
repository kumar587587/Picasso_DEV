--------------------------------------------------------
--  DDL for View XXCT_REP2_INVOICED_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_INVOICED_V" ("PARENT_DOSSIER_ID", "PRODUCT_GROUP_CODE", "SUM_PAYMENTS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select xd.parent_dossier_id
,        dpg.product_group_code
,        sum(amount) sum_payments
from xxct_dossiers              xd
,    xxct_dssr_prdct_grps_hst   dpg
,    xxct_rep_2_max_id_bced_v     mid
where 1                         = 1
and   xd.dossier_type           = 'PAYMENT'
and   xd.status                 = 'AFGESLOTEN'
and   dpg.dossier_id            = xd.dossier_id
and   trunc(dpg.status_date)    <= to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
and   mid.dossier_id            = dpg.dossier_id
and   mid.product_group_code    = dpg.product_group_code
and   mid.dssr_prdct_grp_hst_id = dpg.dssr_prdct_grp_hst_id
group by xd.parent_dossier_id,dpg.product_group_code
;

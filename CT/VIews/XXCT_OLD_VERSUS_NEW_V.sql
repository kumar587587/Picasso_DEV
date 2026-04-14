--------------------------------------------------------
--  DDL for View XXCT_OLD_VERSUS_NEW_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_OLD_VERSUS_NEW_V" ("DOSSIER_ID", "DSSR_PRDCT_GRP_HST_ID_HIST", "DOSSIER_PRODUCT_GROUP_ID", "PRODUCT_GROUP", "PRODUCT_GROUP_CODE", "AMOUNT_OLD", "AMOUNT_NEW") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select cus.dossier_id                  dossier_id
,      cus.dssr_prdct_grp_hst_id_hist    dssr_prdct_grp_hst_id_hist
,      cus.dossier_product_group_id      dossier_product_group_id
,      flv.meaning                       product_group
,      flv.code                          product_group_code
,      cus.amount_old                    amount_old
,      cus.amount_new                    amount_new
from xxct_lookup_values  flv
,    (
     select x1.dossier_id
     ,      x1.dssr_prdct_grp_hst_id dssr_prdct_grp_hst_id_hist
     ,      dpg1.dossier_product_group_id
     ,      x1.product_group_code
     ,      x1.amount amount_old
     ,      nvl(dpg1.amount,0) amount_new
     from xxct_dssr_prdct_grps_hst    x1
     ,    xxct_dossier_product_groups dpg1
     where 1=1
     and   dpg1.product_group_code(+) = x1.product_group_code
     and   dpg1.dossier_id(+)         = x1.dossier_id
     and   x1.dossier_status_new      = 'HEROPEND'
     and   x1.mandate_cycle      = (
                                   select max(x2.mandate_cycle)
                                   from xxct_dssr_prdct_grps_hst x2
                                   where x2.dossier_status_new = 'HEROPEND'
                                   and x2.dossier_id           = x1.dossier_id
                                   )
     and nvl(x1.reopend_sequence,0) = (
                                      select nvl(max(x2.reopend_sequence),0)
                                      from xxct_dssr_prdct_grps_hst x2
                                      where x2.dossier_status_new = 'HEROPEND'
                                      and   x2.dossier_id         = x1.dossier_id
                                      and   x2.mandate_cycle      = x1.mandate_cycle
                                      )
     and (x1.product_group_code||':'||to_char(x1.amount)) not in (
                                                                  select (dpg2.product_group_code||':'||to_char(dpg2.amount))
                                                                  from xxct_dossier_product_groups dpg2
                                                                  where dpg2.dossier_id = x1.dossier_id
                                                                 )
     union
     select dpg1.dossier_id
     ,      -2 dssr_prdct_grp_hst_id_hist
     ,      dossier_product_group_id
     ,      dpg1.product_group_code
     ,      dpg1.amount amount_old
     ,      0 amount_new
     from xxct_dossier_product_groups dpg1
     where 1=1
     and not exists (select 1
                     from xxct_dssr_prdct_grps_hst x1
                     where 1                     = 1
                     and   x1.dossier_id         = dpg1.dossier_id
                     and   x1.product_group_code = dpg1.product_group_code
                     )
     ) cus
where flv.lookup_type        = 'PRODUCT_GROUPS'
and   cus.product_group_code = flv.code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_OLD_VERSUS_NEW_V"  IS '$Id: vw_XXCT_OLD_VERSUS_NEW_V.sql,v 1.3 2019/03/20 11:52:32 rikke493 Exp $'
;

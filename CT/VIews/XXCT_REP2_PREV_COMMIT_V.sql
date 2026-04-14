--------------------------------------------------------
--  DDL for View XXCT_REP2_PREV_COMMIT_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_PREV_COMMIT_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "FUNDING_BEFORE_PERIOD", "PAYMENTS_BEFORE_PERIOD", "PREVIOUS_COMMITMENT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with max_id as (select * from xxct_rep_2_max_id_bcsd_v)
select fbp.dossier_id                                                           dossier_id
,      fbp.product_group_code                                                   product_group_code
,      sum(nvl(fbp.funding_before_period,0))                                         funding_before_period
,      sum(nvl(pbp.payments_before_period,0))                                        payments_before_period
,      sum(nvl(fbp.funding_before_period,0)) - sum(nvl(pbp.payments_before_period,0))     previous_commitment
from (
     select xd1.dossier_id                                                      dossier_id
     ,      dgh1.product_group_code                                             product_group_code
     ,      sum(dgh1.amount)                                                    funding_before_period
     from xxct_dssr_prdct_grps_hst    dgh1
     ,    xxct_dossiers               xd1
     ,    max_id                             mid
     where 1                          = 1
     and   xd1.dossier_id             = dgh1.dossier_id
     and   xd1.dossier_type           = 'RESERVATION'   --'RESERVERING' --Type changes by TechM Team for MWT-546
     --and   trunc(dgh1.status_date)    < to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')--commented BY Techm Team for MWT-586
     and   trunc(dgh1.status_date)    < to_date(nvl(v('P111_CHANGE_END_DATE'),'01-01-1900'),'DD-MM-YYYY')--Added BY Techm Team for MWT-586
     and   mid.dossier_id             = xd1.dossier_id
     and   mid.product_group_code     = dgh1.product_group_code
     and   mid.dssr_prdct_grp_hst_id  = dgh1.dssr_prdct_grp_hst_id
     group by xd1.dossier_id,dgh1.product_group_code
     )                                                                          fbp
,    (
     select --xd1.parent_dossier_id                                               parent_dossier_id--commented BY Techm Team for MWT-586
            xd1.dossier_id                                                      dossier_id --Added BY Techm Team for MWT-586
     ,      dgh1.product_group_code                                             product_group_code
     ,      sum(dgh1.amount)                                                    payments_before_period
     from xxct_dssr_prdct_grps_hst    dgh1
     ,    xxct_dossiers               xd1
     ,    max_id                             mid
     where 1                          = 1
     and   xd1.dossier_id             = dgh1.dossier_id
     and   xd1.dossier_type           = 'PAYMENT' --'UITBETALING' --Type changes by TechM Team for MWT-546
     --and   trunc(dgh1.status_date)   < to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')--commented BY Techm Team for MWT-586
     and   trunc(dgh1.status_date)   < to_date(nvl(v('P111_CHANGE_END_DATE'),'01-01-1900'),'DD-MM-YYYY')--Added BY Techm Team for MWT-586
     and   dgh1.dossier_status_new   in ('CONTROLE', 'PROCURATIE', 'FACTURATIE','AFGESLOTEN')
     and   mid.dossier_id             = xd1.dossier_id
     and   mid.product_group_code     = dgh1.product_group_code
     and   mid.dssr_prdct_grp_hst_id  = dgh1.dssr_prdct_grp_hst_id
      --group by xd1.parent_dossier_id,dgh1.product_group_code--commented BY Techm Team for MWT-586
      group by xd1.dossier_id,dgh1.product_group_code--ADDED BY Techm Team for MWT-586
      )                                                                         pbp
where 1                      = 1
--and   fbp.dossier_id         = pbp.parent_dossier_id(+)--commented BY Techm Team for MWT-586
and   fbp.dossier_id         = pbp.dossier_id(+)--ADDED BY Techm Team for MWT-586
and   fbp.product_group_code = pbp.product_group_code(+)
group by fbp.dossier_id
,        fbp.product_group_code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP2_PREV_COMMIT_V"  IS '$Id: vw_XXCT_REP2_PREV_COMMIT_V.sql,v 1.3 2019/07/12 19:57:50 engbe502 Exp $'
;

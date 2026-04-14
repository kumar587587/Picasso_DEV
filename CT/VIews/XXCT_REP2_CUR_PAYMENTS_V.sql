--------------------------------------------------------
--  DDL for View XXCT_REP2_CUR_PAYMENTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP2_CUR_PAYMENTS_V" ("PARENT_DOSSIER_ID", "PRODUCT_GROUP_CODE", "PAYMENTS_IN_PERIOD", "ZEUS_PAYMENTS_IN_PERIOD") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select xd1.parent_dossier_id                                                  parent_dossier_id
,      dgh1.product_group_code                                                  product_group_code
,      sum(dgh1.amount)                                                         payments_in_period
,      sum(case when xd1.invoice_number is null then 0 else dgh1.amount end )   zeus_payments_in_period
from xxct_dssr_prdct_grps_hst    dgh1
,    xxct_dossiers               xd1
where 1                          = 1
and   xd1.dossier_id             = dgh1.dossier_id
and   xd1.dossier_type           = 'PAYMENT' --'UITBETALING'  --Type changes by TechM Team for MWT-546
and   trunc(dgh1.status_date)    between to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                     and to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
and   dgh1.dossier_status_new    in ('CONTROLE', 'PROCURATIE', 'FACTURATIE','AFGESLOTEN')
and   dgh1.dssr_prdct_grp_hst_id = (
                                   select max(dgh2.dssr_prdct_grp_hst_id)
                                   from  xxct_dssr_prdct_grps_hst        dgh2
                                   where dgh2.dossier_id         = dgh1.dossier_id
                                   and   dgh2.product_group_code = dgh1.product_group_code
                                   and   trunc(dgh2.status_date) between to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
                                                                     and to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
                                   )
group by xd1.parent_dossier_id,dgh1.product_group_code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP2_CUR_PAYMENTS_V"  IS '$Id: vw_XXCT_REP2_CUR_PAYMENTS_V.sql,v 1.2 2020/07/15 07:35:56 engbe502 Exp $'
;

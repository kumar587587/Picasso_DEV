--------------------------------------------------------
--  DDL for View XXCT_PAY_PER_PROD_GROUP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PAY_PER_PROD_GROUP_V" ("DOSSIER_ID", "PARENT_DOSSIER_ID", "PRODUCT_PP", "EPP1", "FUNDED_AMOUNT_PP", "EPP2", "AMOUNT_PAID_PP", "EPP3", "AMOUNT_OUTSTANDING_PP", "COLOR_FOR_NEGATIVES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select fund.dossier_id                              dossier_id
,      fund.parent_dossier_id                       parent_dossier_id
,      fund.product_pp                              product_pp
,      '?'                                          epp1
,      fund.funded_amount_pp                        funded_amount_pp
,      '?'                                          epp2
,      nvl(paid.paid_amount_pp,0)                   amount_paid_pp
,      '?'                                          epp3
,      (fund.funded_amount_pp- nvl(paid.paid_amount_pp,0)) amount_outstanding_pp
,       case when fund.funded_amount_pp- nvl(paid.paid_amount_pp,0) < 0 then 'red'
        else 'black'
       end color_for_negatives
from
(
    select flvr.meaning                   product_pp
    ,  xdr.dossier_id                     dossier_id
    ,  xdr.parent_dossier_id              parent_dossier_id
    , sum(nvl(dpgr.amount,0))             funded_amount_pp
    from xxct_dossiers               xdr
    ,    xxct_dossier_product_groups dpgr
    ,    xxct_product_groups         flvr
    where 1                      = 1
    and   xdr.dossier_type       = 'RESERVATION'
    and   dpgr.dossier_id        = xdr.dossier_id
    and   flvr.code       = dpgr.product_group_code
    group by xdr.dossier_id
    ,        xdr.parent_dossier_id
    ,        flvr.meaning
)  fund
, (
    select xdu.parent_dossier_id
    ,      flvu.meaning                   product_pp
    , sum(nvl(dpgu.amount,0))             paid_amount_pp
    from xxct_dossiers               xdu
    ,    xxct_dossier_product_groups dpgu
    ,    xxct_product_groups         flvu
    where 1                      = 1
    and   xdu.dossier_type       = 'PAYMENT'
    and   dpgu.dossier_id        = xdu.dossier_id
    and   flvu.code              = dpgu.product_group_code
    group by xdu.parent_dossier_id
    ,        flvu.meaning
) paid
where 1=1
and paid.parent_dossier_id(+) = nvl( fund.parent_dossier_id, fund.dossier_id)
and fund.product_pp = paid.product_pp(+)
;

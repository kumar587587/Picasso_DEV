--------------------------------------------------------
--  DDL for View XXCT_PAY_PER_BRAND_DB_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PAY_PER_BRAND_DB_V" ("DOSSIER_ID", "PARENT_DOSSIER_ID", "BRAND", "EPB1", "FUNDED_AMOUNT_PB", "EPB2", "AMOUNT_PAID_PB", "EPB3", "AMOUNT_OUTSTANDING_PB", "COLOR_FOR_NEGATIVES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select r.dossier_id
,      u.parent_dossier_id
,      r.brand                                  brand
,      '?'                                       epb1
,       r.funded_amount_pb                       funded_amount_pb
,      '?'                                       epb2
,       u.amount_paid_PB                         amount_paid_PB
,      '?'                                       epb3
,       (r.funded_amount_pb - NVL(u.amount_paid_PB,0))  amount_outstanding_pb
,       case when r.funded_amount_pb - NVL(u.amount_paid_PB,0) < 0 then 'red'
        else 'black'
       end color_for_negatives
from (
    select xdr.dossier_id
    ,     flvr.brand
    ,      sum(dpgr.amount) funded_amount_pb
    from xxct_dossiers               xdr
    ,    xxct_dossier_product_groups dpgr
    ,    xxct_product_groups         flvr
    where 1                      = 1
    and   xdr.dossier_type       = 'RESERVATION'
    and   dpgr.dossier_id        = xdr.dossier_id
    and   flvr.code              = dpgr.product_group_code
    and xdr.dossier_id           = nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID'))
    group by xdr.dossier_id
    ,        flvr.brand
    )                            r
,   (
    select xdu.parent_dossier_id
    ,      flvu.brand
    ,      sum(dpgu.amount) amount_paid_PB
    from xxct_dossiers               xdu
    ,    xxct_dossier_product_groups dpgu
    ,    xxct_product_groups         flvu
    where 1                      = 1
    and   xdu.parent_dossier_id  = nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID'))
    and   xdu.dossier_type       = 'PAYMENT'
    and   dpgu.dossier_id        = xdu.dossier_id
    and   flvu.code              = dpgu.product_group_code
    group by xdu.parent_dossier_id
    ,     flvu.brand
    )                            u
where u.brand(+) = r.brand
;

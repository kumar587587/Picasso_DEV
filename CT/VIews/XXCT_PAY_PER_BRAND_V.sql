--------------------------------------------------------
--  DDL for View XXCT_PAY_PER_BRAND_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PAY_PER_BRAND_V" ("DOSSIER_ID", "PARENT_DOSSIER_ID", "BRAND", "EPB1", "FUNDED_AMOUNT_PB", "EPB2", "AMOUNT_PAID_PB", "EPB3", "AMOUNT_OUTSTANDING_PB", "COLOR_FOR_NEGATIVES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select r.dossier_id
,      u.parent_dossier_id
,      r.brand                                  brand
,      '?'                                       epb1
,       r.funded_amount_pb                       funded_amount_pb
,      '?'                                       epb2
,       u.amount_paid_pb                         amount_paid_pb
,      '?'                                       epb3
,       (r.funded_amount_pb - nvl(u.amount_paid_pb,0))  amount_outstanding_pb
,       case when r.funded_amount_pb - nvl(u.amount_paid_pb,0) < 0 then 'red'
        else 'black'
       end color_for_negatives
from (
    select xdr.dossier_id
    ,      flvr.brand brand
    ,      sum(dpgr.amount) funded_amount_pb
    from xxct_dossiers               xdr
    ,   (select * from table(cast(xxct_page_102_pkg.get_product_group_array as xxct_dssr_prdct_grps_tab))) dpgr
    ,    xxct_product_groups            flvr
    where 1                      = 1
    and   xdr.dossier_type       = 'RESERVATION'
    and   dpgr.dossier_id        = xdr.dossier_id
    and   flvr.code              = dpgr.product_group_code
    and   xdr.dossier_id         = nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID'))
    and 1 = xxct_gen_debug_pkg.debug('XXCT_PAY_PER_BRAND_V','running sub 1 view nvl(v(P102_PARENT_DOSSIER_ID),v(P102_DOSSIER_ID)) = '||nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID')))
    group by xdr.dossier_id
    ,        flvr.brand
    )                            r
,   (
    select xdu.parent_dossier_id
    ,      flvu.brand brand
    ,      sum(dpgu.amount) amount_paid_pb
    from xxct_dossiers               xdu
    ,    xxct_dossier_product_groups dpgu
    ,    xxct_product_groups            flvu
    where 1                      = 1
    and   xdu.parent_dossier_id  = nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID'))
    and   xdu.dossier_type       = 'PAYMENT'
    and   dpgu.dossier_id        = xdu.dossier_id
    and   flvu.code              = dpgu.product_group_code
    and 1 = xxct_gen_debug_pkg.debug('XXCT_PAY_PER_BRAND_V','running sub 2 view nvl(v(P102_PARENT_DOSSIER_ID),v(P102_DOSSIER_ID)) = '||nvl(v('P102_PARENT_DOSSIER_ID'),v('P102_DOSSIER_ID')))
    group by xdu.parent_dossier_id
    ,     flvu.brand
    )                            u
where 1=1
and u.brand(+) = r.brand
and 1 = xxct_gen_debug_pkg.debug('XXCT_PAY_PER_BRAND_V','running main view')
;

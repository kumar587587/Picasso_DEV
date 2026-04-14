--------------------------------------------------------
--  DDL for View XXCT_REPORT4_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT4_V" ("CENTER_CODE", "DIVISION", "CHANNEL", "CATEGORY_NAME", "PRODUCT", "COMMITMENT", "INVOICED_AMOUNT", "DELIVERD_VALUE", "TRANSPOST", "COMPANY_CODE", "ACCOUNTINGCODE", "ACQRET_KEY", "BRANDKEYCODE", "MEMOLINE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  center_code,
          division,
          channel,
          category_name,
          product,
          commitment,
          invoiced_amount,
          deliverd_value,
          transpost,
          --Below Column Added By TechM Team for MWT-231
          100 COMPANY_CODE,
          ACCOUNTING_CODE AccountingCode,
          ACQRET_KEY,
          NVL(BRAND_KEY,3014) BrandKeyCode,
          100||'.'||center_code||'.'||ACCOUNTING_CODE||'.'||ACQRET_KEY||'.'||NVL(BRAND_KEY,3014)||'.'||'000'||'.'||'00000'||'.'||'00000'||'.'||'00000' memoline 
          --End MWT-231
     FROM (
          SELECT DISTINCT 
                 dossier_id                                                          dossier_id  
          ,      center_code                                                         center_code  
          ,      division                                                            division
          ,      partner_name                                                        channel
          ,      category_name                                                       category_name
          ,      product                                                             product
          ,      funded                                                              commitment
          ,      sum_payments                                                        invoiced_amount
          ,      completion / 100 * funded                                           deliverd_value
          ,      (completion / 100 * funded) - NVL (sum_payments, 0)                 transpost
          ,      ACQRET_KEY --Added By TechM Team for MWT-231
          ,      ACCOUNTING_CODE  --Added By TechM Team for MWT-231
          ,      BRAND_KEY --Added By TechM Team for MWT-231
          FROM (
               SELECT xd.dossier_id
               ,      sp.sum_payments
               ,      dpg.funded
               ,      comp.completion
               ,      flv2.meaning product
               ,      flv2.brand   brand
               ,      flv.meaning category_name
               ,      cbp.partner_name
               ,      flv3.meaning division
               ,      abk.center_code
               ,      flv2.ACQRET_KEY --Added By TechM Team for MWT-231
               ,      flv2.ACCOUNTING_CODE  --Added By TechM Team for MWT-231
               ,      xb.BRAND_KEY BRAND_KEY --Added By TechM Team for MWT-231
               FROM xxct_report4_data_v xd
               ,    xxct_dossier_fund_amounts_v dpg               
               ,    xxct_closed_payments_v  sp               
               ,    xxct_product_groups lvv
               ,    xxct_brands xb
               ,    xxct_dossiers_actions_v comp
               ,    xxct_lookup_values flv               
               ,    xxct_categories xc
               ,    xxct_cat_prod_groups cpg
               ,    xxct_cm_business_partners_v cbp               
               ,    xxct_product_groups /*xxct_lookup_values*/ flv2
               ,    xxct_lookup_values flv3
               ,    xxct_partners_tmp_v jrr               
               ,    xxct_apro_booking_keys_v abk
               WHERE     1 = 1
--AND xd.dossier_id = 3828               
               AND xd.dossier_type = 'RESERVATION'
               AND xd.action_start_date <=  LAST_DAY ( TO_DATE (v ('P114_TRANSPOST_PERIOD'), 'YYYYMM'))
               AND NVL (xd.financial_close, 'N') = 'N'
               AND dpg.dossier_id = xd.dossier_id
               AND dpg.product_group_code = xd.product_group_code
               --
               AND sp.parent_dossier_id(+) = xd.dossier_id
               AND sp.product_group_code(+) = dpg.product_group_code
               --
               AND lvv.code = dpg.product_group_code
               --
               AND lvv.brand = xb.code --ffv2.flex_value
               --
               AND comp.dossier_id = xd.dossier_id
               --
               AND flv.lookup_type = 'MAIN_CATEGORIES'
               AND SYSDATE BETWEEN flv.start_date_active AND NVL ( flv.end_date_active, TO_DATE ('31-12-4712', 'DD-MM-YYYY'))               
               AND flv.code = xc.main_category                              
               --
               AND cpg.product_group_code = dpg.product_group_code
               --
               AND xc.category_id = cpg.category_id
               AND cbp.resource_id = xd.partner_id 
               AND cbp.resource_id =  NVL (v ('P114_CHANNEL'), cbp.resource_id)
               AND flv.code =    NVL (v ('P114_TYPE'), flv.code)
               AND flv2.code = dpg.product_group_code
               AND flv2.code = NVL (v ('P114_PRODUCT'), flv2.code)
               AND flv3.lookup_type = 'DIVISIONS'
               AND flv3.attribute2 = xc.division
               AND jrr.partner_flow_type = upper( flv3.attribute1 )
               AND jrr.partner_id = xd.partner_id
               --
               AND abk.brand          = xb.code 
               AND abk.division       = flv3.meaning
               AND abk.category_name  = flv.meaning            	       
               )
         )
    WHERE 1 = 1
    AND center_code = NVL (v ('P114_CENTERCODE'), center_code)
    AND (UPPER (division) LIKE  DECODE (NVL (v ('P114_DIVISION'), 'ALL'),'ALL', '%',v ('P114_DIVISION'))
         OR UPPER (division) = v ('P114_DIVISION'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_DIVISION = '||v('P114_DIVISION'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_TRANSPOST_PERIOD = '||v('P114_TRANSPOST_PERIOD'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_CENTERCODE = '||v('P114_CENTERCODE'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_CHANNEL = '||v('P114_CHANNEL'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_TYPE = '||v('P114_TYPE'))
and   '1' = xxct_gen_debug_pkg.debug('Rapport4',' P114_PRODUCT = '||v('P114_PRODUCT'))
;

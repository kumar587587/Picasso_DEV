--------------------------------------------------------
--  DDL for View XXCT_REPORT1_SUB1_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT1_SUB1_V" ("DOSSIER_ID", "LETTER_NUMBER", "DOSSIER_TYPE_MEANING", "DOSSIER_TYPE", "CATEGORY", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "PRODUCT_NAME", "REMARKS", "AMOUNT", "RESERVED_AMOUNT", "TOTAL_AMOUNT_PAID", "CRS", "STATUS_CHANGE_DATE", "CREATION_DATE", "MODIFY_DATE", "STATUS", "ACTION_BY", "START_DATE", "END_DATE", "YEAR", "SEQUENCE_NUMBER", "PERIOD", "LETTER_SUFFIX", "INVOICE_NUMBER", "PAYMENT_TYPE", "BRAND", "DIVISION", "CHANNEL_MANAGER", "RETAIL_SUPPORT", "MAIN_CATEGORY_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT xd.dossier_id dossier_id
 ,      letter_number letter_number
 ,      dossier_type_meaning dossier_type_meaning
 ,      dossier_type            dossier_type
 ,      category category
 ,      xd.v_code_business_partner v_code_business_partner
 ,      business_partner business_partner
 ,      flv.meaning product_name
 ,      dpg.remarks remarks
 ,      dpg.amount amount
 ,      CASE
        WHEN xd.dossier_type = 'CREDITING'
        THEN
           NULL
        WHEN xd.dossier_type = 'RESERVATION'
        THEN
           dpg.amount
        WHEN xd.dossier_type = 'PAYOUT'
        THEN
           (
           SELECT dpg2.amount
           FROM xxct_dossier_product_groups dpg2
           ,    xxct_dossiers xd2
           WHERE     1 = 1
           AND xd2.dossier_id          = xd.parent_dossier_id
           AND dpg2.dossier_id         = xd2.dossier_id
           AND dpg2.product_group_code = dpg.product_group_code
           )
           END               reserved_amount
 ,         (
           SELECT SUM (total)
           FROM ( 
                SELECT NVL (SUM (dpg3.amount), 0) total
                FROM xxct_dossier_product_groups dpg3
                ,    xxct_dossiers xd3
                WHERE     1 = 1
                AND xd3.dossier_id          = dpg3.dossier_id
                AND xd3.parent_dossier_id   = xd.dossier_id
                AND dpg3.product_group_code = dpg.product_group_code
                UNION
                SELECT NVL (SUM (dpg3.amount), 0)
                FROM xxct_dossier_product_groups dpg3
                ,    xxct_dossiers xd3
                WHERE     1 = 1
                AND xd3.dossier_id = dpg3.dossier_id
                AND xd3.parent_dossier_id = xd.parent_dossier_id
                AND dpg3.product_group_code = dpg.product_group_code
                )
            )              total_amount_paid
 ,          (
            SELECT flv.meaning
            FROM xxct_lookup_values flv
            ,    xxct_cat_prod_groups cpg
            ,    xxct_categories xc
            ,    xxct_dossiers xd
            WHERE flv.lookup_type      = 'MAIN_CATEGORIES'
            AND SYSDATE                BETWEEN flv.start_date_active AND NVL ( flv.end_date_active, TO_DATE ('31-12-4712', 'DD-MM-YYYY'))
            AND xc.category_id         = cpg.category_id
            AND flv.code               = xc.main_category
            AND cpg.product_group_code = dpg.product_group_code
            AND cpg.product_group_code = dpg.product_group_code
            AND xd.dossier_id          = dpg.dossier_id
            AND xd.dossier_category_id = xc.category_id
            )               crs
  ,        xd.status_date status_change_date
  ,        xd.creation_date creation_date
  ,        xd.last_update_date modify_date
  ,        INITCAP (xd.status) status
  ,        action_by action_by
  ,        TO_CHAR (xd.action_start_date, 'DD-MM-YYYY') start_date
  ,        TO_CHAR (xd.action_end_date, 'DD-MM-YYYY') end_date
  ,        xd.letter_number_year year
  ,        xd.letter_number_sequence sequence_number
  ,        xd.letter_number_period period
  ,        xd.letter_suffix letter_suffix
  ,        xd.invoice_number invoice_number
  ,        (
           SELECT flv.meaning
           FROM xxct_lookup_values flv
           WHERE flv.lookup_type = 'PAYMENT_TYPES'
           AND   payment_type    = flv.code
           )              payment_type
  ,        (
           SELECT flvr.brand
           FROM xxct_product_groups flvr
           WHERE     1 = 1
           AND flvr.code        = dpg.product_group_code
           )                                                  brand
  ,        (
           SELECT distinct flv.meaning
           FROM xxct_lookup_values flv
           ,    xxct_categories xc
           ,    xxct_partners_tmp_v jrr
           WHERE lookup_type = 'DIVISIONS'
           AND SYSDATE BETWEEN flv.start_date_active AND NVL ( flv.end_date_active, TO_DATE ('31-12-4712','DD-MM-YYYY'))
           AND xc.category_id = xd.dossier_category_id
           AND flv.attribute2 = xc.division
           AND jrr.partner_flow_type  = upper( flv.attribute1 )
           AND jrr.resource_id = xd.resource_id
           )               division
  ,        (
           SELECT max( channel_manager)
           FROM xxct_cm_business_partners_v cbp 
           WHERE     1 = 1
           AND cbp.resource_id = xd.resource_id
           )              channel_manager
  ,        (
           SELECT MAX  (retail_support)
           FROM xxct_cm_business_partners_v cbp
           WHERE     1 = 1
           AND cbp.resource_id = xd.resource_id
           )                       retail_support
  ,        main_category_code      main_category_code
  FROM xxct_dossiers_v xd
  ,    xxct_dossier_product_groups dpg
  ,    xxct_product_groups flv
  WHERE     1 = 1
  AND dpg.dossier_id = xd.dossier_id
  AND flv.code = dpg.product_group_code
  AND INSTR (NVL (v ('G_TYPE_SELECTION'), '!'), xd.dossier_type) > 0
--  AND dossier_category_id LIKE NVL (v ('P110_CATEGORY_ID'), '%')
--  AND resource_id LIKE NVL (v ('P110_RESOURCE_ID'), '%')
  AND 'YES' =  xxct_page_110_pkg.show_approve_records
               ( xd.status
               , xd.dossier_id
               , xd.mandate_cycle
               )
  AND letter_number_year LIKE NVL (v ('P110_YEAR'), '%')
  and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_SUB1_V','P110_YEAR = '||v('P110_YEAR'))
  and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_SUB1_V','G_TYPE_SELECTION = '||v('G_TYPE_SELECTION'))
;

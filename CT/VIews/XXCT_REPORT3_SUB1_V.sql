--------------------------------------------------------
--  DDL for View XXCT_REPORT3_SUB1_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT3_SUB1_V" ("DOSSIER_ID", "LETTER_NUMBER", "DOSSIER_TYPE_MEANING", "CATEGORY", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "PRODUCT_NAME", "REMARKS", "AMOUNT", "DOSSIER_TYPE_CODE", "RESERVED_AMOUNT", "TOTAL_AMOUNT_PAID", "CRS", "STATUS_CHANGE_DATE", "CREATION_DATE", "MODIFY_DATE", "STATUS", "ACTION_BY", "START_DATE", "END_DATE", "YEAR", "SEQUENCE_NUMBER", "PERIOD", "LETTER_SUFFIX", "INVOICE_NUMBER", "PAYMENT_TYPE", "BRAND", "DIVISION", "CHANNEL_MANAGER", "RETAIL_SUPPORT", "MAIN_CATEGORY_CODE", "CONCATENATED_ACTIONS", "COUNT_MANDATES", "RESOURCE_ID", "MAX_MANDATE_CYCLE", "CHANNEL_MANAGER_USER_ID", "CHANGE_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH  mandates
        AS 
        (
        SELECT DISTINCT xm2.dossier_id                                              dossier_id 
        ,      MAX (mandate_cycle) OVER (PARTITION BY dossier_id)                   max_mandate_cycle
        ,      MIN (mandate_id)    OVER (PARTITION BY dossier_id, approval_status)  min_mandate_id
        ,      approval_status                                                      approval_status
        ,      COUNT (*) OVER (PARTITION BY dossier_id)                             count_mandates
        FROM xxct_mandates_hist                                                     xm2
        where 1=1
        AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-mandates','running view')
        )
SELECT xd.dossier_id                dossier_id
,      letter_number                letter_number
,      dossier_type_meaning         dossier_type_meaning
,      category                     category
,      xd.v_code_business_partner   v_code_business_partner
,      business_partner             business_partner
,      flv.meaning                  product_name
,      dpg.remarks                  remarks
,      dpg.amount                   amount
,      xd.dossier_type              dossier_type_code
,      CASE
       WHEN xd.dossier_type = 'CREDITING' THEN 0
       WHEN xd.dossier_type = 'RESERVATION' THEN dpg.amount
       WHEN xd.dossier_type = 'PAYMENT' THEN
                (
                SELECT dpg2.amount
                FROM xxct_dossier_product_groups dpg2
                ,    xxct_dossiers xd2
                WHERE 1                     = 1
                AND xd2.dossier_id          = xd.parent_dossier_id
                AND dpg2.dossier_id         = xd2.dossier_id
                AND dpg2.product_group_code = dpg.product_group_code
                AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-reserved_amount','running view')
                )
       END                           reserved_amount
,      (
       SELECT SUM (dpg3.amount)
       FROM xxct_dossier_product_groups dpg3
       ,    xxct_dossiers xd3
       WHERE     1 = 1
       AND xd3.dossier_id        = dpg3.dossier_id
       AND xd3.parent_dossier_id = xd.dossier_id
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-total_amount_paid','running view')
       )                             total_amount_paid
,      (
       SELECT flv.meaning
       FROM xxct_lookup_values flv
       ,    xxct_cat_prod_groups cpg
       ,    xxct_categories xc
       WHERE     flv.lookup_type = 'MAIN_CATEGORIES'
       AND SYSDATE BETWEEN flv.start_date_active AND NVL ( flv.end_date_active, TO_DATE ('31-12-4712', 'DD-MM-YYYY'))
       AND xc.category_id = cpg.category_id
       AND flv.code = xc.main_category
       AND cpg.product_group_code = dpg.product_group_code
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-crs','running view')
       )                             crs
,      xd.status_date status_change_date
,      xd.creation_date creation_date
,      xd.last_update_date modify_date
,      xd.status status
,      action_by action_by
,      TO_CHAR (xd.action_start_date, 'DD-MM-YYYY') start_date
,      TO_CHAR (xd.action_end_date, 'DD-MM-YYYY') end_date
,      xd.letter_number_year year
,      xd.letter_number_sequence sequence_number
,      xd.letter_number_period period
,      xd.letter_suffix letter_suffix
,      xd.invoice_number invoice_number
,      payment_type payment_type
,      (
       select brand 
       from xxct_product_groups  
       where code = dpg.product_group_code
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-brand','running view')
       )                              brand
,      (
       SELECT flv.meaning
       FROM xxct_lookup_values flv
       ,    xxct_categories xc
       WHERE     lookup_type = 'DIVISIONS'
       AND SYSDATE BETWEEN start_date_active  AND NVL ( end_date_active, TO_DATE ('31-12-4712', 'DD-MM-YYYY'))
       AND flv.code = xc.division
       AND xc.category_id = xd.dossier_category_id
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-division','running view')
       )                             division
,      (
       SELECT max( channel_manager ) 
       FROM xxct_cm_business_partners_v cbp 
       WHERE     1 = 1
       AND cbp.resource_id = xd.resource_id
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-channel_manager','running view')
       )                            channel_manager
,      (
       SELECT MAX (retail_support)
       FROM xxct_cm_business_partners_v cbp 
       WHERE     1 = 1
       AND cbp.resource_id = xd.resource_id
       AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V-retail_support','running view')
       )                         retail_support
,      main_category_code main_category_code
,      d1.concatenated_actions
,      man.count_mandates
,      xd.resource_id
,      man.max_mandate_cycle
,      xd.channel_manager_user_id
,      xd.change_type
FROM xxct_report3_sub2_v              xd
,    xxct_dossier_product_groups      dpg
,    xxct_product_groups              flv
,    (
     SELECT DECODE (NVL (v ('P113_FUND'), 'N'),'Y', '1', '0')
     ||     DECODE (NVL (v ('P113_CREDIT'), 'N'), 'Y', '2', '0')
     ||     DECODE (NVL (v ('P113_PAYMENT'), 'N'), 'Y', '3', '0')
     ||     DECODE (NVL (v ('P113_DELETED'), 'N'), 'Y', '4', '0')  concatenated_actions
     FROM DUAL
     )                                 d1
,    mandates                          man
WHERE     1 = 1
AND dpg.dossier_id = xd.dossier_id
AND flv.code = dpg.product_group_code
AND INSTR ( d1.concatenated_actions
          ,  DECODE ( xd.dossier_type
                    , 'RESERVATION', '1'
                    , 'CREDITING', '2'
                    , 'PAYMENT', '3'
                    , 'DELETED'    , '4'
                    , '5'
                    )
          ) > 0
AND xd.action_start_date    >= NVL (TO_DATE (v ('P113_START_DATE'), 'DD-MM-YYYY'), SYSDATE - 1000000)
AND xd.action_end_date      <= NVL (TO_DATE (v ('P113_END_DATE'), 'DD-MM-YYYY'),  SYSDATE + 1000000)
AND xd.dossier_category_id  LIKE  NVL (v ('P113_CATEGORY_ID'), '%')
AND xd.resource_id          LIKE NVL (v ('P113_RESOURCE_ID'), '%')
AND xd.letter_number_year   LIKE NVL (v ('P113_YEAR'), '%')
AND man.dossier_id          = xd.dossier_id
AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_SUB1_V','running view')
;

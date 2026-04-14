--------------------------------------------------------
--  DDL for View XXCT_REPORT1_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT1_V" ("DOSSIER_ID", "LETTER_NUMBER", "DOSSIER_TYPE_MEANING", "CATEGORY", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "PRODUCT_NAME", "REMARKS", "AMOUNT", "RESERVED_AMOUNT", "TOTAL_AMOUNT_PAID", "CRS", "STATUS_CHANGE_DATE", "CREATION_DATE", "MODIFY_DATE", "STATUS", "ACTION_BY", "START_DATE", "END_DATE", "YEAR", "SEQUENCE_NUMBER", "PERIOD", "LETTER_SUFFIX", "INVOICE_NUMBER", "PAYMENT_TYPE", "BRAND", "DIVISION", "CHANNEL_MANAGER", "RETAIL_SUPPORT", "TOTAL_AMOUNT_OUTSTANDING") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT base.dossier_id
,      base.letter_number
,      base.dossier_type_meaning
,      base.category
,      base.v_code_business_partner
,      base.business_partner
,      base.product_name
,      base.remarks
,      base.amount
,      base.reserved_amount
,      CASE
          WHEN base.dossier_type_meaning IN ('Uitbetaling', 'Reservering')
          THEN
             base.total_amount_paid
          WHEN base.dossier_type_meaning = 'Creditering'
          THEN
             NULL
       END          total_amount_paid
,      base.crs
,      base.status_change_date
,      base.creation_date
,      base.modify_date
,      base.status
,      DECODE (base.action_by,
               'Controleur', NVL (base.channel_manager, base.action_by),
               base.action_by)          action_by
,      base.start_date
,      base.end_date
,      base.year
,      base.sequence_number
,      DECODE (base.period, 'null', NULL, base.period) period
,      base.letter_suffix
,      base.invoice_number
,      base.payment_type
,      base.brand
,      base.division
,      base.channel_manager
,      base.retail_support
,      CASE
          WHEN base.dossier_type_meaning IN ('Uitbetaling', 'Reservering')
          THEN
             base.reserved_amount - base.total_amount_paid
          WHEN base.dossier_type_meaning = 'Creditering'
          THEN
             NULL
       END          total_amount_outstanding
FROM xxct_report1_sub1_v   base
WHERE     1 = 1
AND INSTR (NVL (v ('G_TYPE_SELECTION'), '!'), base.dossier_type) >  0
AND UPPER (base.crs) LIKE NVL (v ('P110_CRS'), '%')
AND base.amount BETWEEN NVL (v ('P110_AMOUNT_FROM'), -99999999999999) AND NVL (v ('P110_AMOUNT_TO'), 999999999999)
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_TYPE_SELECTION = '||v('P110_TYPE_SELECTION'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','G110_TYPE_SELECTION = '||v('G110_TYPE_SELECTION'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_CATEGORY_ID = '||v('P110_CATEGORY_ID'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_RESOURCE_ID = '||v('P110_RESOURCE_ID'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_CRS = '||v('P110_CRS'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_AMOUNT_FROM = '||v('P110_AMOUNT_FROM'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_AMOUNT_TO = '||v('P110_AMOUNT_TO'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_START_DATE = '||v('P110_START_DATE'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_FUND = '||v('P110_FUND'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_PAYMENT = '||v('P110_PAYMENT'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','P110_CREDIT = '||v('P110_CREDIT'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT1_V','running view')
;

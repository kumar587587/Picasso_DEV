--------------------------------------------------------
--  DDL for View XXCT_REPORT3_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT3_V" ("DOSSIER_ID", "LETTER_NUMBER", "YEAR", "CATEGORY", "DOSSIER_TYPE_MEANING", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "PRODUCT_NAME", "AMOUNT", "REMARKS", "INVOICE_NUMBER", "STATUS_CHANGE_DATE", "STATUS", "START_DATE", "END_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH  decreaseChannelManager as
     ( select u.id  decrease_manager_user_id
      from xxct_lookup_values lv
      ,    xxct_users u
      where 1=1
      and lv.lookup_type = 'VRIJVAL_CONTROLEUR'
      and lv.lookup_type = 'VRIJVAL_CONTROLEUR'
      and u.ruis_name = lv.code
      and sysdate between u.start_date and nvl( end_date, sysdate + 1)
      and rownum < 2 
     ) 
  SELECT base.dossier_id
,      base.letter_number
,      base.year
,      base.category
,      base.dossier_type_meaning
,      base.v_code_business_partner
,      base.business_partner
,      base.product_name
,      base.amount
,      base.remarks
,      base.invoice_number
,      base.status_change_date
,      INITCAP (base.status) status
,      base.start_date
,      base.end_date
FROM   xxct_report3_sub1_v      base
,      decreaseChannelManager  dmid
WHERE  1                     = 1
AND    NVL (base.amount, 0)  BETWEEN NVL (v ('P113_AMOUNT_FROM'), -99999999999)  AND NVL (v ('P113_AMOUNT_TO'),  99999999999)
AND   'YES'                  = XXCT_ONLY_SHOW_CHNL_MNGR_DSSRS --xxct_page_101_pkg.only_show_channel_mngr_dssrs 
                              ( base.dossier_id
                              , v ('P113_OWNED_BY_ME')
                              , v ('EBS_USER_ID')
                              , status
                              , resource_id
                              , count_mandates
                              , max_mandate_cycle
                              , channel_manager_user_id
                              , base.change_type
                              , dmid.decrease_manager_user_id                              
                              )
AND base.main_category_code  LIKE NVL (v ('P113_CRS'), '%')
AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_V','base.dossier_type_code ='||base.dossier_type_code)
AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_V','base.concatenated_actions ='||base.concatenated_actions)
AND '1' = xxct_gen_debug_pkg.debug('XXCT_REPORT3_V','v(P113_FUND) ='||v('P113_FUND'))
;

--------------------------------------------------------
--  DDL for View XXCT_REPORTS3_SUB2_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORTS3_SUB2_V" ("DOSSIER_ID", "DOSSIER_TYPE", "ACTION_START_DATE", "ACTION_END_DATE", "DOSSIER_CATEGORY_ID", "DOSSIER_TYPE_MEANING", "MAIN_CATEGORY_CODE", "PAYMENT_TYPE", "INVOICE_NUMBER", "RESOURCE_ID", "LETTER_NUMBER_YEAR", "LETTER_NUMBER", "LETTER_SUFFIX", "LETTER_NUMBER_PERIOD", "LETTER_NUMBER_SEQUENCE", "ACTION_BY", "STATUS", "STATUS_DATE", "CREATION_DATE", "LAST_UPDATE_DATE", "BUSINESS_PARTNER", "V_CODE_BUSINESS_PARTNER", "CATEGORY", "PARENT_DOSSIER_ID", "FINANCIAL_CLOSE", "CHANNEL_MANAGER_USER_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH dosX
    AS 
    (
    SELECT dossier_id
    ,       dossier_type
    ,       action_start_date
    ,       action_end_date
    ,       dossier_category_id
    ,       dossier_type_meaning
    ,       main_category_code
    ,       payment_type
    ,       invoice_number
    ,       resource_id
    ,       letter_number_year
    ,       letter_number
    ,       letter_suffix
    ,       letter_number_period
    ,       letter_number_sequence
    ,       action_by
    ,       status
    ,       status_date
    ,       creation_date
    ,       last_update_date
    ,       business_partner
    ,       v_code_business_partner
    ,       category
    ,       parent_dossier_id
    ,       financial_close
    ,       channel_manager_user_id
    FROM xxct_dossiers_v
    )
SELECT "DOSSIER_ID","DOSSIER_TYPE","ACTION_START_DATE","ACTION_END_DATE","DOSSIER_CATEGORY_ID","DOSSIER_TYPE_MEANING","MAIN_CATEGORY_CODE","PAYMENT_TYPE","INVOICE_NUMBER","RESOURCE_ID","LETTER_NUMBER_YEAR","LETTER_NUMBER","LETTER_SUFFIX","LETTER_NUMBER_PERIOD","LETTER_NUMBER_SEQUENCE","ACTION_BY","STATUS","STATUS_DATE","CREATION_DATE","LAST_UPDATE_DATE","BUSINESS_PARTNER","V_CODE_BUSINESS_PARTNER","CATEGORY","PARENT_DOSSIER_ID","FINANCIAL_CLOSE","CHANNEL_MANAGER_USER_ID"
FROM dosX
WHERE dossier_type = 'RESERVERING'
AND   NVL (financial_close, 'N') = 'Y'
UNION
SELECT "DOSSIER_ID","DOSSIER_TYPE","ACTION_START_DATE","ACTION_END_DATE","DOSSIER_CATEGORY_ID","DOSSIER_TYPE_MEANING","MAIN_CATEGORY_CODE","PAYMENT_TYPE","INVOICE_NUMBER","RESOURCE_ID","LETTER_NUMBER_YEAR","LETTER_NUMBER","LETTER_SUFFIX","LETTER_NUMBER_PERIOD","LETTER_NUMBER_SEQUENCE","ACTION_BY","STATUS","STATUS_DATE","CREATION_DATE","LAST_UPDATE_DATE","BUSINESS_PARTNER","V_CODE_BUSINESS_PARTNER","CATEGORY","PARENT_DOSSIER_ID","FINANCIAL_CLOSE","CHANNEL_MANAGER_USER_ID"
FROM dosX xdv
WHERE xdv.dossier_type = 'UITBETALING'
AND xdv.status = 'AFGESLOTEN'
AND EXISTS
         (
         SELECT 1
         FROM dosX xd
         WHERE xd.dossier_type = 'RESERVERING'
         AND xd.dossier_id = xdv.parent_dossier_id
         AND NVL (xd.financial_close, 'N') = 'Y'
         )
UNION
SELECT "DOSSIER_ID","DOSSIER_TYPE","ACTION_START_DATE","ACTION_END_DATE","DOSSIER_CATEGORY_ID","DOSSIER_TYPE_MEANING","MAIN_CATEGORY_CODE","PAYMENT_TYPE","INVOICE_NUMBER","RESOURCE_ID","LETTER_NUMBER_YEAR","LETTER_NUMBER","LETTER_SUFFIX","LETTER_NUMBER_PERIOD","LETTER_NUMBER_SEQUENCE","ACTION_BY","STATUS","STATUS_DATE","CREATION_DATE","LAST_UPDATE_DATE","BUSINESS_PARTNER","V_CODE_BUSINESS_PARTNER","CATEGORY","PARENT_DOSSIER_ID","FINANCIAL_CLOSE","CHANNEL_MANAGER_USER_ID"
FROM dosX
WHERE dossier_type = 'CREDITERING'
AND status = 'AFGESLOTEN'


--) xd,
--xxct_dossier_product_groups dpg,
----xxct_lookup_values flv,
--xxct_product_groups flv,
--(SELECT    DECODE (NVL (v ('P113_FUND'), 'N'),
--'Y', '1',
--'0')
--|| DECODE (NVL (v ('P113_CREDIT'), 'N'),
--'Y', '2',
--'0')
--|| DECODE (NVL (v ('P113_PAYMENT'), 'N'),
--'Y', '3',
--'0')
--|| DECODE (NVL (v ('P113_DELETED'), 'N'),
--'Y', '4',
--'0')
--concatenated_actions
--FROM DUAL
;

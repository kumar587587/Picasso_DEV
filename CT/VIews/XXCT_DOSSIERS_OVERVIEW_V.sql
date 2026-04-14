--------------------------------------------------------
--  DDL for View XXCT_DOSSIERS_OVERVIEW_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIERS_OVERVIEW_V" ("LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "START_DATE", "PAYMENT_TYPE_MEANING", "PAYMENT_TYPE", "AMOUNT", "DOSSIER_TYPE_MEANING", "DOSSIER_TYPE", "DOSSIER_ID", "RESOURCE_ID", "CATEGORY", "STATUS_MEANING", "STATUS", "PROCUREUR", "WASTE_BASKET", "DOSSIER_ID_DISPLAY", "CREATION_DATE_DISPLAY", "CREATION_DATE", "ACTION_BY", "CHANNEL_MANAGER_USER_ID", "MAIN_CATEGORY_CODE", "INVOICE_NUMBER", "LETTER_NUMBER_YEAR", "LETTER_NUMBER_SEQUENCE", "LETTER_NUMBER_PERIOD", "LETTER_SUFFIX", "ACTION_START_DATE", "ACTION_END_DATE", "LAST_UPDATE_DATE", "STATUS_DATE", "DOSSIER_CATEGORY_ID", "PARENT_DOSSIER_ID", "FITAR_FILE_NAME", "FITAR_EXTRACT_DATE", "EXPORT_AGAIN", "COUNT_MANDATES", "MAX_MANDATE_CYCLE", "HOLD_PAYMENT", "QUERY_NR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with dossiers as
       ( select * 
       from xxct_dossiers_v
       where 1=1
       --AND dossier_id = 22446      -- Only for debugging specific dossiers            
       --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_OVERVIEW_V','dossiers app_user = '||v('APP_USER'))
       )
  , current_user as
       (select u.id user_id  from xxct_users u where lower(u.user_name) = nvl(  v('APP_USER'  ), 
       xxct_general_pkg.get_developer_user ) )
 
  , decreaseChannelManager as
       ( select u.id  decrease_manager_user_id , u.display_name action_by
         from xxct_lookup_values lv
         ,    xxct_users u
         where 1=1
         and lv.lookup_type = 'VRIJVAL_CONTROLEUR'
         and UPPER(u.ruis_name) = UPPER(lv.code)
         and TO_DATE(sysdate,'DD-MM-YYYY') between 
                    TO_DATE(lv.START_DATE_ACTIVE,'DD-MM-YYYY') and nvl(TO_DATE(lv.END_DATE_ACTIVE,'DD-MM-YYYY'), TO_DATE(sysdate,'DD-MM-YYYY'))--MWT-709
         and LV.ENABLED_FLAG = 'Y'--MWT-709
     )
  , channelManager as
       ( 
       select xd.dossier_id
         , xxct_page_101_pkg.only_show_channel_mngr_dssrs( xd.dossier_id
                                                    , nvl(v('P101_OWNED_BY_ME'),'N')
                                                    , cusr.user_id
                                                    , xd.status
                                                    , xd.resource_id
                                                    , xd.count_mandates
                                                    , xd.max_mandate_cycle
                                                    , xd.channel_manager_user_id
                                                    , xd.change_type
                                                    , dmid.decrease_manager_user_id
                                                    ) yes_no
         from dossiers xd
         ,    current_user cusr
         ,    decreaseChannelManager dmid
         where xd.status ='CONTROLE'
       ),
    --BELOW ADDED BY TECHM TEAM FOR MWT-709
    PREDICTION_V as (SELECT * FROM XXCT_APPROVAL_PREDICTION_V_NEW A),  --XXCT_APPROVAL_PREDICTION_V_NEW View created for MWT-709
    L_PREV_AMOUNT AS (
        SELECT DOSSIER_ID,SUM(AMOUNT) PREV_AMOUNT FROM xxct_dssr_prdct_grps_hst WHERE DOSSIER_STATUS_NEW = 'AFGESLOTEN' AND (DOSSIER_ID,MANDATE_CYCLE) IN (
        SELECT DOSSIER_ID,MAX(MANDATE_CYCLE) FROM (
        SELECT A.DOSSIER_ID,A.MANDATE_CYCLE FROM xxct_dssr_prdct_grps_hst A,XXCT_DOSSIERS B
        WHERE A.DOSSIER_ID = B.DOSSIER_ID AND A.MANDATE_CYCLE < B.MANDATE_CYCLE AND DOSSIER_STATUS_NEW = 'AFGESLOTEN' ORDER BY 1
        ) GROUP BY DOSSIER_ID
        )GROUP BY DOSSIER_ID),
        L_CURR_AMOUNT AS (
        SELECT DOSSIER_ID,SUM(AMOUNT) CURR_AMOUNT FROM xxct_dossier_product_groups GROUP BY DOSSIER_ID
        ),
        prodctgrphist AS (
        SELECT B.DOSSIER_ID,PREV_AMOUNT sum_previous_amount,CURR_AMOUNT sum_current_amount,(NVL(CURR_AMOUNT,0) - NVL(PREV_AMOUNT,0)) CHANGES_AMOUNT
        FROM L_PREV_AMOUNT A,L_CURR_AMOUNT B
        WHERE A.DOSSIER_ID(+) = B.DOSSIER_ID
        ),
    /*prodctgrphist as
     (
     select d.dossier_id, p.dossier_status_old
     ,      p.dossier_status_new
     ,      sum(c.amount) sum_current_amount
     ,      sum(p.amount) sum_previous_amount
     from xxct_dossier_product_groups c
     ,    xxct_dssr_prdct_grps_hst p
     ,    xxct_dossiers            d
     where 1=1
     and p.dossier_id          = c.dossier_id
     and p.product_group_code  = c.product_group_code
     and d.dossier_id          = c.dossier_id
     and d.status            NOT IN ( 'AFGESLOTEN')
     and case                              -- This case add for test case 16
        when d.mandate_cycle > 1 
           and dossier_status_old ='PROCURATIE'
           and dossier_status_new ='AFGESLOTEN'        
        then
          1=1
        when  d.mandate_cycle > 1   -- Test Case  3 als retail support
           and dossier_status_old ='PROCURATIE'
           and dossier_status_new ='OPEN'        
        then
          1=1       
     end          
     group by d.dossier_id, dossier_status_old, dossier_status_new
     ),--*/ 
CONTROLER_ACTION_BY AS (SELECT xd.dossier_id,LISTAGG(distinct (get_approval_on_date ( pd.roleid , sysdate )),',') WITHIN GROUP (ORDER BY XD.dossier_id, pd.roleid)  action_by
            FROM XXCT_DOSSIERS_V XD,
            PREDICTION_V PD,
            prodctgrphist prdgh
            WHERE pd.dossier_id(+) = xd.dossier_id
            and pd.PARTNER_ID(+) = xd.RESOURCE_ID
            and pd.DOSSIERTYPE(+) = xd.DOSSIER_TYPE
            and pd.ACTIONTYPE(+) = NVL(XD.CHANGE_TYPE,DECODE(xd.DOSSIER_TYPE,'PAYMENT','PAYMENT','CREDITING','PAYMENT',xd.ACTION_TYPE))
            AND CASE 
                WHEN xd.DOSSIER_TYPE ='RESERVATION' AND XD.MANDATE_CYCLE > 1
                AND  prdgh.sum_current_amount > prdgh.sum_previous_amount THEN
                     (prdgh.sum_current_amount - prdgh.sum_previous_amount) BETWEEN PD.MINAMOUNT AND PD.MAXAMOUNT
                ELSE    
                     PD.TOTAL_AMOUNT BETWEEN PD.MINAMOUNT AND PD.MAXAMOUNT
                END
            AND prdgh.DOSSIER_ID(+) = XD.DOSSIER_ID
            GROUP BY XD.dossier_id)
    ------END TECHM TEAM CODE FOR MWT-709
  SELECT
        bas.LETTER_NUMBER
      , bas.V_CODE_BUSINESS_PARTNER
      , bas.BUSINESS_PARTNER
      , bas.START_DATE
      , bas.PAYMENT_TYPE_MEANING
      , bas.PAYMENT_TYPE
      , bas.AMOUNT
      , bas.DOSSIER_TYPE_MEANING
      , bas.DOSSIER_TYPE
      , bas.DOSSIER_ID
      , bas.RESOURCE_ID
      , bas.CATEGORY
      , bas.STATUS_MEANING
      , bas.STATUS
      , bas.PROCUREUR
      , bas.WASTE_BASKET
      , bas.DOSSIER_ID_DISPLAY
      , bas.CREATION_DATE_DISPLAY
      , bas.CREATION_DATE
      , bas.ACTION_BY
      , bas.CHANNEL_MANAGER_USER_ID
      , bas.MAIN_CATEGORY_CODE
      , bas.INVOICE_NUMBER
      , bas.LETTER_NUMBER_YEAR
      , bas.LETTER_NUMBER_SEQUENCE
      , bas.LETTER_NUMBER_PERIOD
      , bas.LETTER_SUFFIX
      , bas.ACTION_START_DATE
      , bas.ACTION_END_DATE
      , bas.LAST_UPDATE_DATE
      , bas.STATUS_DATE
      , bas.DOSSIER_CATEGORY_ID
      , bas.PARENT_DOSSIER_ID
      , bas.FITAR_FILE_NAME
      , bas.FITAR_EXTRACT_DATE
      , bas.EXPORT_AGAIN
      , bas.COUNT_MANDATES
      , bas.MAX_MANDATE_CYCLE
      , bas.HOLD_PAYMENT
      , bas.QUERY_NR
    FROM
        (
            SELECT  1                                        query_nr 
              , xd.letter_number                             letter_number
              , xd.v_code_business_partner                   v_code_business_partner
              , xd.business_partner                          business_partner
              , xd.start_date                                start_date
              , xd.payment_type_meaning                      payment_type_meaning
              , xd.payment_type                              payment_type
              , xd.amount                                    amount
              , xd.dossier_type_meaning                      dossier_type_meaning
              , xd.dossier_type                              dossier_type
              , xd.dossier_id                                dossier_id
              , xd.resource_id                               resource_id
              , xd.category                                  category
              , xd.status_meaning                            status_meaning
              , xd.status                                    status
              , NULL                                         procureur
              , xd.dossier_id                                waste_basket
              , xd.dossier_id                                dossier_id_display
              , xd.creation_date_display                     creation_date_display
              , to_char(xd.creation_date, 'DD-MM-YYYY')      creation_date
              --, xd.action_by                                 action_by--COMMENTED BY TECHM TEAM FOR MWT-709
              , CASE WHEN xd.status = 'PROCURATIE' THEN CAB.action_by WHEN xd.status = 'CONTROLE' AND xd.change_type = 'DECREASE' THEN dcm.action_by ELSE xd.action_by END action_by--ADDED BY TECHM TEAM FOR MWT-709
              , xd.channel_manager_user_id                   channel_manager_user_id
              , xd.main_category_code                        main_category_code
              , xd.invoice_number                            invoice_number
              , xd.letter_number_year                        letter_number_year
              , xd.letter_number_sequence                    letter_number_sequence
              , xd.letter_number_period                      letter_number_period
              , xd.letter_suffix                             letter_suffix
              , xd.action_start_date                         action_start_date
              , xd.action_end_date                           action_end_date
              , xd.last_update_date                          last_update_date
              , xd.status_date                               status_date
              , xd.dossier_category_id                       dossier_category_id
              , xd.parent_dossier_id                         parent_dossier_id
              , xd.fitar_file_name
              , xd.fitar_extract_date
              , xd.export_again
              , xd.count_mandates
              , xd.max_mandate_cycle
              , decode(xd.hold_payment, 'Y', 'Ja', 'Nee') hold_payment
              , 'YES'                                     yes_no 
            FROM dossiers               xd
                 , CONTROLER_ACTION_BY    CAB--ADDED BY TECHM TEAM FOR MWT-709
                 , decreaseChannelManager dcm
            WHERE  1 = 1
                --AND xd.dossier_id = 22446      -- Only for debugging specific dossiers            
                AND xd.status = 'PROCURATIE'
                AND instr(nvl(v('P101_TYPE_FILTER'), '!')  , dossier_type) > 0
                AND action_start_date >= nvl(TO_DATE(v('P101_START_DATE') , 'DD-MM-YYYY')  , sysdate - 1000000)
                AND action_end_date <= nvl(TO_DATE(v('P101_END_DATE')     , 'DD-MM-YYYY')  , sysdate + 1000000)
                AND dossier_category_id LIKE nvl(v('P101_CATEGORY_ID')    , '%')
                AND nvl(resource_id, - 9999) = nvl(v('P101_RESOURCE_ID')  , nvl(resource_id, - 9999))
                AND 'YES' = xxct_page_101_pkg.show_approve_records(xd.status
                                                                 , xd.dossier_id
                                                                 , v('P101_TYPE_FILTER')
                                                                 , xd.mandate_cycle)
                AND letter_number_year LIKE nvl(v('P101_YEAR')   , '%')

                and CAB.dossier_id(+) = xd.dossier_id--ADDED BY TECHM TEAM FOR MWT-709


UNION

            SELECT  2                                     query_nr 
              , xd.letter_number                          letter_number
              , xd.v_code_business_partner                v_code_business_partner
              , xd.business_partner                       business_partner
              , xd.start_date                             start_date
              , xd.payment_type_meaning                   payment_type_meaning
              , xd.payment_type                           payment_type
              , xd.amount                                 amount
              , xd.dossier_type_meaning                   dossier_type_meaning
              , xd.dossier_type                           dossier_type
              , xd.dossier_id                             dossier_id
              , xd.resource_id                            resource_id
              , xd.category                               category
              , xd.status_meaning                         status_meaning
              , xd.status                                 status
              , NULL                                      procureur
              , xd.dossier_id                             waste_basket
              , xd.dossier_id                             dossier_id_display
              , xd.creation_date_display                  creation_date_display
              , to_char(xd.creation_date, 'DD-MM-YYYY')   creation_date
              --, xd.action_by                              action_by
              , CASE WHEN xd.status = 'PROCURATIE' THEN CAB.action_by WHEN xd.status = 'CONTROLE' AND xd.change_type = 'DECREASE' THEN dcm.action_by  ELSE xd.action_by END action_by
              , xd.channel_manager_user_id                channel_manager_user_id
              , xd.main_category_code                     main_category_code
              , xd.invoice_number                         invoice_number
              , xd.letter_number_year                     letter_number_year
              , xd.letter_number_sequence                 letter_number_sequence
              , xd.letter_number_period                   letter_number_period
              , xd.letter_suffix                          letter_suffix
              , xd.action_start_date                      action_start_date
              , xd.action_end_date                        action_end_date
              , xd.last_update_date                       last_update_date
              , xd.status_date                            status_date
              , xd.dossier_category_id                    dossier_category_id
              , xd.parent_dossier_id                      parent_dossier_id
              , xd.fitar_file_name
              , xd.fitar_extract_date
              , xd.export_again
              , xd.count_mandates
              , xd.max_mandate_cycle
              , decode(xd.hold_payment, 'Y', 'Ja', 'Nee') hold_payment
              , 'YES'                                     yes_no 
            FROM  dossiers               xd
            ,     CONTROLER_ACTION_BY    CAB--ADDED BY TECHM TEAM FOR MWT-709
            ,     decreaseChannelManager dcm
            WHERE   1 = 1
            AND xd.status <> 'PROCURATIE'         
            AND xd.status <> 'CONTROLE'            
            --AND xd.dossier_id = 22446      -- Only for debugging specific dossiers                        
            AND instr(nvl(v('P101_TYPE_FILTER')                           , '!')                   , dossier_type) > 0
            AND action_start_date >= nvl(TO_DATE(v('P101_START_DATE')     , 'DD-MM-YYYY')          , sysdate - 1000000)
            AND action_end_date <= nvl(TO_DATE(v('P101_END_DATE')         , 'DD-MM-YYYY')          , sysdate + 1000000)
            AND dossier_category_id LIKE nvl(v('P101_CATEGORY_ID')        , '%')
            AND nvl(resource_id, - 9999) = nvl(v('P101_RESOURCE_ID')      , nvl(resource_id, - 9999))
            AND 'YES' = xxct_page_101_pkg.show_approve_records(xd.status
                                                                 , xd.dossier_id
                                                                 , v('P101_TYPE_FILTER')
                                                                 , xd.mandate_cycle)
            AND letter_number_year LIKE nvl(v('P101_YEAR')   , '%')

            and CAB.dossier_id(+) = xd.dossier_id--ADDED BY TECHM TEAM FOR MWT-709

UNION

            SELECT  3                                     query_nr 
              , xd.letter_number                          letter_number
              , xd.v_code_business_partner                v_code_business_partner
              , xd.business_partner                       business_partner
              , xd.start_date                             start_date
              , xd.payment_type_meaning                   payment_type_meaning
              , xd.payment_type                           payment_type
              , xd.amount                                 amount
              , xd.dossier_type_meaning                   dossier_type_meaning
              , xd.dossier_type                           dossier_type
              , xd.dossier_id                             dossier_id
              , xd.resource_id                            resource_id
              , xd.category                               category
              , xd.status_meaning                         status_meaning
              , xd.status                                 status
              , NULL                                      procureur
              , xd.dossier_id                             waste_basket
              , xd.dossier_id                             dossier_id_display
              , xd.creation_date_display                  creation_date_display
              , to_char(xd.creation_date, 'DD-MM-YYYY')   creation_date
              --, xd.action_by                              action_by
              , CASE WHEN xd.status = 'PROCURATIE' THEN CAB.action_by WHEN xd.status = 'CONTROLE' AND xd.change_type = 'DECREASE' THEN dcm.action_by ELSE xd.action_by END action_by
              , xd.channel_manager_user_id                channel_manager_user_id
              , xd.main_category_code                     main_category_code
              , xd.invoice_number                         invoice_number
              , xd.letter_number_year                     letter_number_year
              , xd.letter_number_sequence                 letter_number_sequence
              , xd.letter_number_period                   letter_number_period
              , xd.letter_suffix                          letter_suffix
              , xd.action_start_date                      action_start_date
              , xd.action_end_date                        action_end_date
              , xd.last_update_date                       last_update_date
              , xd.status_date                            status_date
              , xd.dossier_category_id                    dossier_category_id
              , xd.parent_dossier_id                      parent_dossier_id
              , xd.fitar_file_name
              , xd.fitar_extract_date
              , xd.export_again
              , xd.count_mandates
              , xd.max_mandate_cycle
              , decode(xd.hold_payment, 'Y', 'Ja', 'Nee') hold_payment
              , cm.yes_no 
            FROM  dossiers               xd
            ,     channelManager         cm
            ,     CONTROLER_ACTION_BY    CAB--ADDED BY TECHM TEAM FOR MWT-709
            ,     decreaseChannelManager dcm
            WHERE   1 = 1
            AND xd.status = 'CONTROLE'            
            --AND xd.dossier_id = 22446      -- Only for debugging specific dossiers                        
            AND cm.dossier_id = xd.dossier_id
            --AND cm.yes_no = decode( v('P101_OWNED_BY_ME'),null,'NO','N','NO', cm.yes_no)
            AND instr(nvl(v('P101_TYPE_FILTER')                           , '!')                   , dossier_type) > 0
            AND action_start_date >= nvl(TO_DATE(v('P101_START_DATE')     , 'DD-MM-YYYY')          , sysdate - 1000000)
            AND action_end_date <= nvl(TO_DATE(v('P101_END_DATE')         , 'DD-MM-YYYY')          , sysdate + 1000000)
            AND dossier_category_id LIKE nvl(v('P101_CATEGORY_ID')        , '%')
            AND nvl(resource_id, - 9999) = nvl(v('P101_RESOURCE_ID')      , nvl(resource_id, - 9999))
            AND 'YES' = xxct_page_101_pkg.show_approve_records(xd.status
                                                                 , xd.dossier_id
                                                                 , v('P101_TYPE_FILTER')
                                                                 , xd.mandate_cycle)
            AND letter_number_year LIKE nvl(v('P101_YEAR')   , '%')

            and CAB.dossier_id(+) = xd.dossier_id--ADDED BY TECHM TEAM FOR MWT-709
        ) bas
        --, channelManager  cm
    WHERE  1 = 1
        --AND nvl(bas.amount, 0) BETWEEN nvl(v('P101_AMOUNT_FROM')  , - 99999999999) AND nvl(v('P101_AMOUNT_TO'),   99999999999)--commented on 3-2-2025(TechM Team)
        AND nvl(bas.amount, 0) BETWEEN nvl(TO_NUMBER(replace(v('P101_AMOUNT_FROM'),'.',''))  , - 99999999999) AND nvl(TO_NUMBER(replace(v('P101_AMOUNT_TO'),'.','')),   99999999999)--added New line TechM Team (3-2-2025)
        --AND cm.dossier_id = bas.dossier_id
        and bas.yes_no = 'YES'
        AND bas.main_category_code LIKE nvl(v('P101_CRS')         , '%')
        AND nvl(bas.fitar_file_name, 'NIET OPGENOMEN IN FITAR') LIKE nvl(substr(v('P101_HISTORIE_EXPORT_FILE') , 17)   , '%')
and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_OVERVIEW_V','P101_TYPE_FILTER = '||v('P101_TYPE_FILTER'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_OVERVIEW_V','P101_OWNED_BY_ME = '||v('P101_OWNED_BY_ME'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_OVERVIEW_V','G101_ACTIVE_FILTER = '||v('G101_ACTIVE_FILTER'))
and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_OVERVIEW_V','running view')
;

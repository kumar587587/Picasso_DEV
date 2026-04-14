--------------------------------------------------------
--  DDL for View XXCT_DOSSIERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIERS_V" ("LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "START_DATE", "PAYMENT_TYPE_MEANING", "PAYMENT_TYPE", "AMOUNT", "DOSSIER_TYPE_MEANING", "DOSSIER_TYPE", "DOSSIER_ID", "RESOURCE_ID", "CATEGORY", "STATUS_MEANING", "STATUS", "PROCUREUR", "WASTE_BASKET", "DOSSIER_ID_DISPLAY", "CREATION_DATE_DISPLAY", "CREATION_DATE", "ACTION_BY", "CHANNEL_MANAGER_USER_ID", "MAIN_CATEGORY_CODE", "INVOICE_NUMBER", "LETTER_NUMBER_YEAR", "LETTER_NUMBER_SEQUENCE", "LETTER_NUMBER_PERIOD", "LETTER_SUFFIX", "ACTION_START_DATE", "ACTION_END_DATE", "LAST_UPDATE_DATE", "STATUS_DATE", "DOSSIER_CATEGORY_ID", "PARENT_DOSSIER_ID", "MANDATE_CYCLE", "FINANCIAL_CLOSE", "FITAR_FILE_NAME", "FITAR_EXTRACT_DATE", "EXPORT_AGAIN", "COUNT_MANDATES", "MAX_MANDATE_CYCLE", "HOLD_PAYMENT", "CHANGE_TYPE", "PARTNER_FLOW_TYPE", "ADDITION_REMARKS", "REMARKS", "ACTION_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH business_partners AS 
        (
        SELECT cbp.partner_id
        ,      cbp.v_code
        ,      cbp.channel_manager
        ,      cbp.resource_id
        ,      cbp.partner_name
        ,      cbp.channel_manager_person_id    channel_manager_ruis_name
        ,      u.id                             channel_manager_person_id  
        ,      cbp.partner_flow_type
        FROM xxct_partners_tmp_v cbp
        ,    xxct_users          u
        where 1=1
        and u.ruis_name = channel_manager_person_id
        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-business_partners','running view V(APP_USER) = '||V('APP_USER'))
        )
,    mandates1 AS
        (
        SELECT DISTINCT 
               xm2.dossier_id                                                    dossier_id     
        ,      MAX(mandate_cycle) OVER(PARTITION BY dossier_id)                  max_mandate_cycle
        ,      MIN(mandate_id)    OVER(PARTITION BY dossier_id, approval_status) min_mandate_id
        ,      approval_status                                                   approval_status
        ,      COUNT(*) OVER(PARTITION BY dossier_id)                            count_mandates
        FROM xxct_mandates_hist xm2
        WHERE 1=1
        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-mandates1','running view')
        )
,    mandates2 AS 
        (
        SELECT xm1.dossier_id
        ,      xm1.mandate_cycle
        FROM   xxct_mandates_hist xm1
        WHERE 1 = 1
        AND nvl(xm1.change_type, 'INCREASE') = 'DECREASE'
        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-mandates2','running view')
        )
,    mandates3 as   
     ( select distinct xml1.dossier_id, xml1.change_type
     from xxct_mandates_hist xml1
     where mandate_cycle = (select max(xml2.mandate_cycle) from xxct_mandates_hist xml2 where xml2.dossier_id = xml1.dossier_id)
     )
,    categories AS        
        (
        SELECT DISTINCT xc.category_id,flv.code
        FROM xxct_categories    xc
        ,    xxct_lookup_values flv
        WHERE 1 = 1
        AND flv.lookup_type = 'MAIN_CATEGORIES'
        AND sysdate BETWEEN flv.start_date_active AND nvl(flv.end_date_active, TO_DATE('31-12-4712', 'DD-MM-YYYY'))
        AND flv.code = xc.main_category
        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-main_category_code','running view')   
        )
,    approvers AS
        (
        SELECT a.dossierid,approver_name, role
        FROM xxct_approvals_tmp_v a
        ,    xxct_dossiers  xd
        WHERE 1=1
        AND xd.status IN ('PROCURATIE','OPEN','HEROPEND','CONTROLE')
        AND to_char(xd.dossier_id) = a.dossierid
        AND   a.approvalstatus = 'nog tekenen' --xxct_page_101_pkg.get_status_pending
        AND   a.payeeid NOT IN (
                               SELECT h.actor 
                               FROM xxct_wf_ct_appr_hist_tmp_v h
                               WHERE substr( h.initiator, 1, instr(h.initiator ,'-')-1)  = a.dossierid
                               AND   h.action in ('Approve','Reject') --?????? Is reject needed?
                                )
         --AND a.dossierid = '50004'                                
         )
,    procuration AS
        (
        SELECT a.dossierid,LISTAGG(DISTINCT a.approver_name,', ') WITHIN GROUP (ORDER BY a.role)  action_by 
        FROM approvers a
        WHERE 1=1
        AND '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V','procuration app_user = '||v('APP_USER'))                                
        GROUP BY a.dossierid
        UNION 
        SELECT TRIM(to_char(xd.dossier_id)),'wachten op voltooing workflow in Varicent'
        FROM  xxct_dossiers  xd
        WHERE 1=1
        AND xd.status IN ('PROCURATIE','OPEN','HEROPEND','CONTROLE')
        --AND xd.dossier_id = 50004
        AND TRIM(to_char(xd.dossier_id)) NOT IN  ( SELECT dossierid FROM approvers )
        )
SELECT  "LETTER_NUMBER"
,       "V_CODE_BUSINESS_PARTNER"
,       "BUSINESS_PARTNER"
,       "START_DATE"
,       "PAYMENT_TYPE_MEANING"
,       "PAYMENT_TYPE"
,       "AMOUNT"
,       "DOSSIER_TYPE_MEANING"
,       "DOSSIER_TYPE"
,       "DOSSIER_ID"
,       partner_ID
,       "CATEGORY"
,       "STATUS_MEANING"
,       "STATUS"
,       "PROCUREUR"
,       "WASTE_BASKET"
,       "DOSSIER_ID_DISPLAY"
,       "CREATION_DATE_DISPLAY"
,       "CREATION_DATE"
,       "ACTION_BY"
,       "CHANNEL_MANAGER_USER_ID"
,       "MAIN_CATEGORY_CODE"
,       "INVOICE_NUMBER"
,       "LETTER_NUMBER_YEAR"
,       "LETTER_NUMBER_SEQUENCE"
,       "LETTER_NUMBER_PERIOD"
,       "LETTER_SUFFIX"
,       "ACTION_START_DATE"
,       "ACTION_END_DATE"
,       "LAST_UPDATE_DATE"
,       "STATUS_DATE"
,       "DOSSIER_CATEGORY_ID"
,       "PARENT_DOSSIER_ID"
,       "MANDATE_CYCLE"
,       "FINANCIAL_CLOSE"
,       "FITAR_FILE_NAME"
,       "FITAR_EXTRACT_DATE"
,       "EXPORT_AGAIN"
,       "COUNT_MANDATES"
,       "MAX_MANDATE_CYCLE"
,       "HOLD_PAYMENT"
,       "CHANGE_TYPE"
,       "PARTNER_FLOW_TYPE"
,       "ADDITION_REMARKS"
,       "REMARKS"
,       "ACTION_TYPE"--ADDED BY TECHM TEAM FOR MWT-709
--select *
FROM (
     SELECT letter_number_year
            || '-CM-'
            || substr('0000' || letter_number_sequence, - 4)
            --|| substr(dossier_type, 1, 1)
            || decode( dossier_type, 'RESERVATION','R','PAYMENT','U','CREDITING','C')
            || decode(letter_number_period, 'null', '', letter_number_period)
            || letter_suffix                          letter_number
     ,      pi.v_code   v_code_business_partner
     ,      pi.partner_name       business_partner
     ,      to_char(action_start_date, 'DD-MM-YYYY')     start_date
     ,      flv.meaning                                  payment_type_meaning
     ,      xd.payment_type                              payment_type
     ,      amounts.amount
     ,      flv2.meaning                                 dossier_type_meaning
     ,      dossier_type                                 dossier_type
     ,      xd.dossier_id                                dossier_id
     ,      xd.partner_id                                partner_id
     ,      xc.category_name||' ('||xc.process_code||')' category
     ,      initcap(status)                              status_meaning
     ,      status                                       status
     ,      NULL                                         procureur
     ,      xd.dossier_id                                waste_basket
     ,      xd.dossier_id                                dossier_id_display
     ,      to_char(xd.creation_date, 'DD-MM-YYYY')      creation_date_display
     ,      xd.creation_date                             creation_date
     ,      CASE
            WHEN xd.status IN ( 'OPEN', 'AFGEKEURD', 'HEROPEND' ) THEN 'Retail Support'
            WHEN xd.status = 'CONTROLE' THEN
                        ( 
                        SELECT channel_manager
                        FROM
                            (
                            SELECT channel_manager
                            ,      resource_id
                            FROM business_partners
                            WHERE partner_id = xd.partner_id
                 /*           AND EXISTS (                          -- commented by techm for MWT 709
                                           SELECT 1
                                           FROM mandates2 xm1
                                           WHERE xm1.dossier_id = xd.dossier_id
                                           AND xm1.mandate_cycle = (
                                                                   SELECT MAX(max_mandate_cycle)
                                                                   FROM mandates1 xm2
                                                                   WHERE xm2.dossier_id = xm1.dossier_id
                                                                   )
                                           ) */                     -- commented by techm for MWT 709
                            UNION
                            select u.display_name  channel_manager
                            ,      -0       resource_id    
                            from xxct_lookup_values  l
                            ,    xxct_users u
                            where l.lookup_type ='VRIJVAL_CONTROLEUR'
                            and   u.ruis_name = l.code
                            and rownum < 2
                            AND EXISTS (
                                        SELECT 1
                                        FROM mandates2 xm1
                                        WHERE xm1.dossier_id = xd.dossier_id
                                        AND xm1.mandate_cycle = (
                                                                SELECT MAX(max_mandate_cycle)
                                                                FROM mandates1 xm2
                                                                WHERE xm2.dossier_id = xm1.dossier_id
                                                                )
                                       )
                            UNION
                            SELECT 'Controleur'
                            ,      - 1 resource_id
                            FROM dual
                            ORDER BY resource_id DESC
                            )
                        WHERE ROWNUM < 2
                        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-channel_manager','running view')
                        )----control end

         WHEN xd.status = 'FACTURATIE' THEN 'Financedesk'
         WHEN xd.status = 'PROCURATIE' THEN
                        (
                        select action_by
                        from procuration p
                        where p.dossierid =  trim( to_char( xd.dossier_id ) )
                        )
         WHEN xd.status = 'AFGESLOTEN' THEN 'Geen'
         END                                     action_by---rns

     , pi.channel_manager_user_id                channel_manager_user_id
     , cat.code                                  main_category_code         
     , xd.invoice_number                         invoice_number
     , xd.letter_number_year                     letter_number_year
     , xd.letter_number_sequence                 letter_number_sequence
     , xd.letter_number_period                   letter_number_period
     , xd.letter_suffix                          letter_suffix
     , action_start_date                         action_start_date
     , action_end_date                           action_end_date
     , xd.last_update_date                       last_update_date
     , xd.status_date                            status_date
     , xd.dossier_category_id                    dossier_category_id
     , xd.parent_dossier_id                      parent_dossier_id
     , xd.mandate_cycle                          mandate_cycle
     , xd.financial_close                        financial_close
     , 'xai.fitar_file_name'                     fitar_file_name
     , to_date('01-01-1800','DD-MM-YYYY') /*xai.fitar_extract_date*/                    fitar_extract_date
     , decode(xd.extract_to_ar, 'Y', 'Ja', NULL) export_again
     , man.count_mandates
     , man.max_mandate_cycle
     , xd.hold_payment                           hold_payment
     , man3.change_type                          change_type    
     , pi.partner_flow_type
     , xd.addition_remarks
     , xd.remarks
     , XD.ACTION_TYPE--ADDED BY TECHM TEAM FOR MWT-709
--select  xd.*
     FROM xxct_dossiers      xd
     ,    xxct_lookup_values flv
     ,    xxct_cat_pay_types cpt
     ,    xxct_lookup_values flv2
     ,    xxct_categories    xc
     ,    categories         cat
     , (
       SELECT DISTINCT
              dossier_id
       ,      max_mandate_cycle
       ,      count_mandates
       FROM mandates1
       where 1=1
       --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-distinct dossier_id','running view')                                              
       )                  man
,     (  SELECT dpg.dossier_id,SUM(amount) amount
         FROM xxct_dossier_product_groups dpg
         --WHERE dpg.dossier_id = xd.dossier_id
         WHERE 1=1
         --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-amount','running view')
         group by dpg.dossier_id
      ) amounts   
,     ( SELECT  partner_id,v_code, partner_name, channel_manager_person_id channel_manager_user_Id, partner_flow_type
        FROM business_partners
        where 1=1
        --and '1' = xxct_gen_debug_pkg.debug('XXCT_DOSSIERS_V-partner_info','running view')
      )   pi
,     mandates3 man3      
     WHERE 1 = 1
     AND amounts.dossier_id(+) = xd.dossier_id    
     AND pi.partner_id = xd.partner_id
     AND flv.lookup_type = 'PAYMENT_TYPES'
     AND cpt.payment_type = flv.code
     AND cpt.category_id = xd.dossier_category_id
     AND flv.code = xd.payment_type
     AND flv2.lookup_type = 'DOSSIER_TYPES'
     AND flv2.code = xd.dossier_type
     AND xc.category_id = xd.dossier_category_id
     AND man.dossier_id (+) = xd.dossier_id
     AND cat.category_id    = xd.dossier_category_id
     AND man3.dossier_id(+) = xd.dossier_id
     )
WHERE 1 = 1
;

--------------------------------------------------------
--  DDL for View XXCT_REPORT2_V_TST
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT2_V_TST" ("DOSSIER_ID", "LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "ACTION_START_DATE", "ACTION_END_DATE", "PRODUCT_NAME", "CLOSED", "STATUS", "STATUS_DATE", "NEW_PRODUCT_GROUP", "INCREASE", "DECREASE", "PAYMENTS_IN_PERIOD", "PREVIOUS_COMMITMENT", "NEW_COMMITMENT", "FUNDED_AMOUNT", "INVOICED_AMOUNT", "DIFFERENCE", "REMARKS", "PAYMENT_TYPE", "DIVISION", "CHANNEL_MANAGER", "RETAIL_SUPPORT", "HEROPEND", "ZEUS_PAYMENTS_IN_PERIOD") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH emp AS
       (
       select resource_id
       ,        max( channel_manager) channel_manager
       ,        max(retail_support) retail_support
       --,      max(chm.full_name) channel_manager
       --,      max(rsp.full_name)  retail_support
       from xxct_cm_business_partners_v  cbp
       --,    per_all_people_f              rsp
       --,    per_all_people_f              chm
       where 1=1
       --and rsp.person_id   = cbp.retail_support_person_id
       --and sysdate         between rsp.effective_start_date
       --                        and rsp.effective_end_date
       --and chm.person_id   = cbp.channel_manager_person_id
       --and sysdate         between chm.effective_start_date
       --                        and chm.effective_end_date
       group by cbp.resource_id
       )
select xd.dossier_id                                                            dossier_id
,      letter_number                                                            letter_number
,      xd.v_code_business_partner                                               v_code_business_partner
,      business_partner                                                         business_partner
,      xd.action_start_date                                                     action_start_date
,      xd.action_end_date                                                       action_end_date
,      flv.meaning                                                              product_name
,      decode(xd.status,'AFGESLOTEN','Ja','Nee')                                closed
,      initcap(xd.status)                                                       status
,      (
       select max(dpg.status_date)
       from xxct_dssr_prdct_grps_hst dpg
       where dpg.dossier_id  = xd.dossier_id
       )                                                                        status_date
,      nvl(npg.new_product_group,'Ja')                                          new_product_group
,      nvl(inc.increase,0)                                                      increase
,      nvl(inc.decrease,0)                                                      decrease
,      nvl(pay.payments_in_period,0)                                            payments_in_period
,      nvl(pc.previous_commitment,0)                                            previous_commitment
,      nvl(cc.new_commitment,0)                                                 new_commitment
,      nvl(dpg.amount,0)                                                        funded_amount
,      nvl(inv.sum_payments,0)                                                  invoiced_amount
,      nvl(dpg.amount,0)- nvl(inv.sum_payments,0)                               difference
,      dpg.remarks                                                              remarks
,      (
       select flv.meaning
       from xxct_lookup_values flv
       where flv.lookup_type = 'PAYMENT_TYPES'
       and flv.code   = xd.payment_type
       )                                                                        payment_type
,      (
       select flv.meaning
       from xxct_lookup_values    flv
       ,    xxct_categories       xc
       ,    xxct_partners_v       jrr
       where lookup_type     = 'DIVISIONS'
       and sysdate           between flv.start_date_active
                             and nvl(flv.end_date_active, to_date('31-12-4712','DD-MM-YYYY'))
       and xc.category_id    = xd.dossier_category_id
       and flv.attribute2 =  xc.division
       and jrr.partner_flow_type  = upper( flv.attribute1)
       and jrr.partner_id = xd.resource_id
       )                                                                        division
,      chm.channel_manager                                                      channel_manager
,      rs.retail_support                                                        retail_support
--,      dpgh.heropend                                                    heropend
 ,     case
       when xd.status = 'HEROPEND' then 'Ja'
       when dpgh.heropend > 0 then 'Ja'
       else
          'Nee'
       end                                                                      heropend
,      nvl(pay.zeus_payments_in_period,0)                                       zeus_payments_in_period
from xxct_dossiers_v                                                       xd
,    emp                                                                        chm
,    emp                                                                        rs
,    (
     select pgh.dossier_id                    dossier_id
     ,      pgh.product_group_code            product_group_code
     ,      decode(count(*),0,'Ja','Nee')     new_product_group
     from xxct_dssr_prdct_grps_hst pgh
     where 1=1
     and   trunc(pgh.status_date) <  to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
     group by pgh.dossier_id
     ,        pgh.product_group_code
     )                                                                          npg
,    (
     select pgh1.dossier_id
     ,      pgh1.dssr_prdct_grp_hst_id
     ,      pgh1.product_group_code
     ,      pgh1.amount
     ,      pgh1.remarks
     from xxct_dssr_prdct_grps_hst                                       pgh1
     ,    xxct_rep_2_max_id_bced_v                                         mid
     where 1=1
     and trunc(pgh1.status_date) <= to_date(nvl(v('P111_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
     and mid.dossier_id = pgh1.dossier_id
     and mid.product_group_code = pgh1.product_group_code
     and mid.dssr_prdct_grp_hst_id = pgh1.dssr_prdct_grp_hst_id
     )                                                                          dpg
,    xxct_product_groups                                                        flv
,    xxct_rep2_increase_v                                                       inc
,    xxct_rep2_cur_payments_v                                                   pay
,    xxct_rep2_prev_commit_v                                                    pc
,    xxct_rep2_cur_commit_v                                                     cc
,    xxct_rep2_invoiced_v                                                       inv
--,    xxct_rep2_prv_payments_v                                                   pp
,    (select dossier_id, count(*) heropend
     from xxct_dssr_prdct_grps_hst
     where dossier_status_old = 'HEROPEND'
     group by dossier_id )                                                      dpgh
where 1                           = 1
and   chm.resource_id             = xd.resource_id
and   rs.resource_id              = xd.resource_id
and   nvl(xd.financial_close,'N') = 'N'
and   npg.dossier_id(+)           = xd.dossier_id
and   npg.product_group_code(+)   = dpg.product_group_code
and   dpg.dossier_id              = xd.dossier_id
--and   flv.lookup_type             = 'PRODUCT_GROUPS'
and   flv.code                    = dpg.product_group_code
and   xd.dossier_type             = 'RESERVERING'
--and   xd.action_start_date        >= to_date(nvl(v('P111_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
--and   xd.action_end_date          <= to_date(nvl(v('P111_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
--and   xd.dossier_category_id      like nvl(v('P111_CATEGORY_ID'),'%')
--and   xd.resource_id              like nvl(v('P111_RESOURCE_ID'),'%')
--and   xd.letter_number_year       like nvl(v('P111_YEAR'),'%')
and   inc.dossier_id(+)           = xd.dossier_id
and   inc.product_group_code(+)   = dpg.product_group_code
and   pay.parent_dossier_id(+)    = xd.dossier_id
and   pay.product_group_code(+)   = dpg.product_group_code
and   pc.dossier_id(+)            = xd.dossier_id
and   pc.product_group_code(+)    = dpg.product_group_code
and   cc.dossier_id(+)            = xd.dossier_id
and   cc.product_group_code(+)    = dpg.product_group_code
and   inv.parent_dossier_id(+)    = xd.dossier_id
and   inv.product_group_code(+)   = dpg.product_group_code
and   dpgh.dossier_id(+)          = xd.dossier_id
;

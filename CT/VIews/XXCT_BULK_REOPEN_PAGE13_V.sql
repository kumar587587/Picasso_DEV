--------------------------------------------------------
--  DDL for View XXCT_BULK_REOPEN_PAGE13_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_BULK_REOPEN_PAGE13_V" ("DOSSIER_ID", "DOSSIER_TYP", "LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "ACTION_START_DATE", "ACTION_END_DATE", "PRODUCT_NAME", "CLOSED", "STATUS", "STATUS_DATE", "NEW_PRODUCT_GROUP", "INCREASE", "DECREASE", "PAYMENTS_IN_PERIOD", "PREVIOUS_COMMITMENT", "NEW_COMMITMENT", "FUNDED_AMOUNT", "INVOICED_AMOUNT", "DIFFERENCE", "REMARKS", "PAYMENT_TYPE", "DIVISION", "CHANNEL_MANAGER", "RETAIL_SUPPORT", "HEROPEND", "ZEUS_PAYMENTS_IN_PERIOD", "TARGET", "CONTRIBUTION", "DOSSIER_CATEGORY_ID", "RESOURCE_ID", "LETTER_NUMBER_YEAR", "PRODUCT_GROUP_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH emp AS (  select resource_id
               ,      max( channel_manager) channel_manager
               ,      max(retail_support)   retail_support
               from XXCT_CM_BUSINESS_PARTNERS_V  cbp
               where 1=1
               --and   '1' = xxct_gen_debug_pkg.debug('XXCT_BULK_REOPEN_PAGE13_V','running emp')
               group by cbp.resource_id
            )
select xd.dossier_id                                                            dossier_id
,		xd.dossier_type															dossier_typ
,      letter_number                                                            letter_number
,      xd.v_code_business_partner                                               v_code_business_partner
,      business_partner                                                         business_partner
,      xd.action_start_date                                                     action_start_date
,      xd.action_end_date                                                       action_end_date
,      flv.meaning                                                              product_name
,      decode(xd.status,'AFGESLOTEN','Ja','Nee')                                closed
,      initcap(xd.status)                                                       status
,      ( select max(dpg.status_date)
         from XXCT_DSSR_PRDCT_GRPS_HST dpg
         where dpg.dossier_id  = xd.dossier_id
       )                                                                        status_date
,      coalesce(npg.new_product_group,'Ja')                                     new_product_group
,      coalesce(inc.increase,0)                                                 increase
,      coalesce(inc.decrease,0)                                                 decrease
,      coalesce(pay.payments_in_period,0)                                       payments_in_period
,      coalesce(pc.previous_commitment,0)                                       previous_commitment
,      coalesce(cc.new_commitment,0)                                            new_commitment
,      coalesce(dpg.amount,0)                                                   funded_amount
,      coalesce(inv.sum_payments,0)                                             invoiced_amount
,      coalesce(dpg.amount,0)- coalesce(inv.sum_payments,0)                     difference
,      dpg.remarks                                                              remarks
,      ( select flv.meaning
         from   XXCT_LOOKUP_VALUES flv
         where  1=1
         and    flv.lookup_type = 'PAYMENT_TYPES'
         and    flv.code   = xd.payment_type
       )                                                                        payment_type
,      ( select distinct flv.meaning
         from XXCT_LOOKUP_VALUES        flv
         ,    XXCT_CATEGORIES           xc
         ,    XXCT_PARTNERS_TMP_V       jrr
         where 1=1 
         and   lookup_type            = 'DIVISIONS'
         and   sysdate                between flv.start_date_active
                                      and coalesce(flv.end_date_active, to_date('31-12-4712','DD-MM-YYYY'))
         and   xc.category_id         = xd.dossier_category_id
         and   flv.attribute2         = xc.division
         and   jrr.partner_flow_type  = upper( flv.attribute1)
         and   jrr.partner_id = xd.resource_id
       )                                                                        division
,      chm.channel_manager                                                      channel_manager
,      rs.retail_support                                                        retail_support

 ,     case when xd.status = 'HEROPEND' then 'Ja'
            when dpgh.heropend > 0 then 'Ja'
            else 'Nee'
       end                                                                      heropend
,      coalesce(pay.zeus_payments_in_period,0)                                  zeus_payments_in_period
,      TGR_CNBRT.TARGET1                                                        TARGET          
,      TGR_CNBRT.CONTRIBUTION                                                   CONTRIBUTION
,      xd.dossier_category_id                                                   dossier_category_id
,      xd.resource_id                                                           resource_id
,      xd.letter_number_year                                                    letter_number_year
,      dpg.product_group_code
from XXCT_DOSSIERS_V                                                            xd
,    emp                                                                        chm
,    emp                                                                        rs
,   ( select pgh.dossier_id                    dossier_id
      ,      pgh.product_group_code            product_group_code
      ,      decode(count(*),0,'Ja','Nee')     new_product_group
      from  XXCT_DSSR_PRDCT_GRPS_HST pgh
      where 1=1
      and   trunc(pgh.status_date) <  to_date(coalesce(v('P13_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
      --and   '1' = xxct_gen_debug_pkg.debug('XXCT_BULK_REOPEN_PAGE13_V','running npg')
      group by pgh.dossier_id,pgh.product_group_code
    )                                                                           npg
,     ( 
        select pgh2.dossier_id
        ,      pgh2.dssr_prdct_grp_hst_id
        ,      pgh2.product_group_code
        ,      pgh2.amount
        ,      pgh2.remarks
        ,      pgh2.status_date
        from  XXCT_DSSR_PRDCT_GRPS_HST                                       pgh2
        ,     XXCT_REP_2_MAX_ID_BCED_V                                         mid2
        where 1=1 
        and   mid2.dossier_id = pgh2.dossier_id
        and   mid2.product_group_code = pgh2.product_group_code
        and   mid2.dssr_prdct_grp_hst_id = pgh2.dssr_prdct_grp_hst_id   
        --and   '1' = xxct_gen_debug_pkg.debug('XXCT_BULK_REOPEN_PAGE13_V','running dpg')
        and   pgh2.dossier_id in (   select distinct coalesce(dos2.parent_dossier_id,dos2.dossier_id) dossier_id 
                                     from XXCT_DSSR_PRDCT_GRPS_HST                                       pgh1
                                     ,    XXCT_REP_2_MAX_ID_BCED_V                                       mid
                                     ,    XXCT_DOSSIERS_V                                                dos2 
                                     where 1=1
                                     and   dos2.dossier_id = pgh1.dossier_id 
                                     and mid.dossier_id = pgh1.dossier_id
                                     and mid.product_group_code    = pgh1.product_group_code
                                     and mid.dssr_prdct_grp_hst_id = pgh1.dssr_prdct_grp_hst_id
                                     and   trunc(pgh1.status_date) between to_date(coalesce(v('P13_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY') 
                                                                   and     to_date(coalesce(v('P13_CHANGE_END_DATE'),'31-12-4712'),'DD-MM-YYYY')                                     
                                     )
      )                                                                         dpg
     
,    XXCT_PRODUCT_GROUPS                                                        flv
,    XXCT_REP2_INCREASE_V                                                       inc
,    XXCT_REP2_CUR_PAYMENTS_V                                                   pay
,    XXCT_REP2_PREV_COMMIT_V                                                    pc
,    XXCT_REP2_CUR_COMMIT_V                                                     cc
,    XXCT_REP2_INVOICED_V                                                       inv

,    (select dossier_id
      ,      count(*)    heropend
      from  XXCT_DSSR_PRDCT_GRPS_HST
      where 1=1
      and   dossier_status_old = 'HEROPEND'
      group by dossier_id )                                                      dpgh
      
,    (SELECT DOSSIER_ID,PRODUCT_GROUP_CODE,(NVL(TARGET,0)) TARGET1,(NVL(CONTRIBUTION,0)) CONTRIBUTION
        FROM XXCT_DOSSIER_PRODUCT_GROUPS WHERE 1=1) TGR_CNBRT

,    (SELECT A.PARENT_DOSSIER_ID DOSSIER_ID,B.PRODUCT_GROUP_CODE,SUM(NVL(B.TARGET,0)) TARGET,SUM(NVL(CONTRIBUTION,0)) CONTRIBUTION,SUM(NVL(AMOUNT,0)) PAYMENT_AMOUNT
        FROM XXCT_DOSSIERS A,xxct_dossier_product_groups B WHERE A.DOSSIER_ID = B.DOSSIER_ID
        AND A.DOSSIER_TYPE = 'PAYMENT' AND PARENT_DOSSIER_ID IN (
        SELECT DOSSIER_ID FROM XXCT_DOSSIERS WHERE DOSSIER_TYPE = 'RESERVATION' AND STATUS = 'AFGESLOTEN')
        GROUP BY A.PARENT_DOSSIER_ID,B.PRODUCT_GROUP_CODE ) DSSR_PAYMENT
        
where 1 = 1
and   coalesce(xd.financial_close,'N') = 'N'
and   xd.dossier_type                  = 'RESERVATION'
and	  xd.status						   = 'AFGESLOTEN'
and   chm.resource_id                  = xd.resource_id
and   rs.resource_id                   = xd.resource_id
and   npg.dossier_id(+)                = xd.dossier_id
and   npg.product_group_code(+)        = dpg.product_group_code
and   dpg.dossier_id                   = xd.dossier_id
and   flv.code                         = dpg.product_group_code
and   inc.dossier_id(+)                = xd.dossier_id
and   inc.product_group_code(+)        = dpg.product_group_code
and   pay.parent_dossier_id(+)         = xd.dossier_id
and   pay.product_group_code(+)        = dpg.product_group_code
and   pc.dossier_id(+)                 = xd.dossier_id
and   pc.product_group_code(+)         = dpg.product_group_code
and   cc.dossier_id(+)                 = xd.dossier_id
and   cc.product_group_code(+)         = dpg.product_group_code
and   inv.parent_dossier_id(+)         = xd.dossier_id
and   inv.product_group_code(+)        = dpg.product_group_code
and   dpgh.dossier_id(+)               = xd.dossier_id
AND   XD.DOSSIER_ID                    = TGR_CNBRT.DOSSIER_ID (+)       
AND   FLV.CODE                         = TGR_CNBRT.PRODUCT_GROUP_CODE(+)
AND   XD.DOSSIER_ID                    = DSSR_PAYMENT.DOSSIER_ID
AND   FLV.CODE                         = DSSR_PAYMENT.PRODUCT_GROUP_CODE
and coalesce(dpg.amount,0)- coalesce(inv.sum_payments,0) > 0
and coalesce(dpg.amount,0)- coalesce(DSSR_PAYMENT.PAYMENT_AMOUNT,0) > 0
--and   xd.action_start_date             >= to_date(coalesce(v('P13_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
--and   xd.action_end_date               <= to_date(coalesce(v('P13_END_DATE'),'31-12-4712'),'DD-MM-YYYY')
--and   xd.dossier_category_id           like coalesce(v('P13_CATEGORY_ID'),'%')
--and   xd.resource_id                   like coalesce(v('P13_RESOURCE_ID'),'%')
--and   xd.letter_number_year            like coalesce(v('P13_YEAR'),'%')
--and '1' = xxct_gen_debug_pkg.debug('XXCT_BULK_REOPEN_PAGE13_V','P13_CHANGE_START_DATE='||v('P13_CHANGE_START_DATE'))
--and '1' = xxct_gen_debug_pkg.debug('XXCT_BULK_REOPEN_PAGE13_V','P13_CHANGE_END_DATE='||v('P13_CHANGE_END_DATE'))
ORDER BY 1 DESC
;

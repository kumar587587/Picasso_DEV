--------------------------------------------------------
--  DDL for View XXCT_APPROVALS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVALS_V" ("Q", "DOSSIERID", "BONUSPARTNERTYPE", "DOSSIERTYPE", "DESCRIPTION", "ACTIONTYPE", "MINAMOUNT", "MAXAMOUNT", "PAYEEID", "APPROVER_NAME", "APPROVALCYCLE", "APPROVALSTATUS", "APPROVALDATETIME", "COMMENTS", "ROLE", "APPROVALLEVEL", "PARENT_DOSSIER_ID", "STATUS", "DOSSIER_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with workflowlevels as
    ( 
    select * from xxct_workflowlevels_tmp_v
    where 1=1
    --and roleid  not like '%L1'
    --and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-workflowlevels','running view app_user ='||v('APP_USER'))                       
    )
,  prodctgrphist as
     ( 
     select 1 q,dossier_id,mandate_cycle, dossier_status_old,dossier_status_new, sum(current_amount) sum_current_amount, sum(previous_amount) sum_previous_amount
     from xxct_dssr_prdct_grps_hst_tmp_v c
     where 1=1
--and c.dossier_id = 1310171          
     group by      dossier_id,mandate_cycle, dossier_status_old,dossier_status_new
     union
     select 2 q, dossier_id, mandate_cycle, null dossier_status_old, 'OPEN' dossier_status_new , sum(amount) sum_current_amount, 0 sum_previous_amount
     from xxct_dossier_product_groups c
     where 1=1
     and mandate_cycle = 1
--and c.dossier_id = 1310171          
     group by dossier_id, mandate_cycle
     union
     select 3 q, c.dossier_id, c.mandate_cycle, p.dossier_status_old, p.dossier_status_new , sum(c.amount) sum_current_amount, sum(p.amount) sum_previous_amount
     from xxct_dossier_product_groups c
     ,    xxct_dssr_prdct_grps_hst p
     where 1=1
     and p.dossier_id = c.dossier_id
     and p.product_group_code = c.product_group_code
     and p.reopend_sequence  = c.mandate_cycle -1
--and c.dossier_id = 1310171          
     group by c.dossier_id, c.mandate_cycle, dossier_status_old, dossier_status_new     
      ) 
, approval_started as
  (
   select * 
   from xxct_ctpaytapprvlwfdtls_tmp_v
   where 1=1
   and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-approval_started','running view app_user ='||v('APP_USER'))                       
   )
, prdgrp as
  (
  select trim(to_char(dossier_id)) dossierid
  ,      sum(amount) amount 
  from xxct_dossier_product_groups 
  where 1=1
  --and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-prdgrp','running view app_user ='||v('APP_USER'))                       
  group by dossier_id
  )
,  in_varicent   as
   (
   select  pay.dossierid                      dossierid
   ,       w.bonuspartnertype                 bonuspartnertype
   ,       w.dossierType                      dossierType
   ,       w.description                      description  
   ,       w.actionType                       actionType
   ,       w.minamount                        minamount
   ,       w.maxamount                        maxamount
   ,       u.payee                           payeeid  
   ,       nvl( us.display_name,u.payee)      approver_name
   ,       pay.approvalcycle                  approvalcycle 
   --,       decode( pay.approvalstatus,'PENDING',xxct_page_101_pkg.get_status_pending,pay.approvalstatus)        approvalstatus
   ,       decode( pay.approvalstatus,'PENDING','nog tekenen',pay.approvalstatus)        approvalstatus
   ,       approvaldatetime                   approvaldatetime  
   ,       pay.comments                       comments
   ,       w.roleid                           roleid  
   ,       to_number(u.approvallevel)         approvallevel
   ,       to_number(pay.dossierid)
   ,       pay.approverid
   from approval_started                  pay
   ,    prdgrp                            prd
   ,    xxct_dossiers                     d 
   ,    xxct_partners_v                   p
   ,    workflowlevels                    w 
   ,    xxct_ctactiveuserswf_v            u
   ,    xxct_users                        us 
   where 1=1
   and prd.dossierid                = pay.dossierid
   and trim(to_char(d.dossier_id))  = prd.dossierid
   and p.partner_id                 = d.partner_id
   and pay.dossierType(+)           = w.dossierType
   and w.actionType in ('NORMAL','PAYMENT','DECREASE','INCREASE')   -- Not clear yet how we are going to determine the correct action type....
   and pay.actionType(+)            = w.actionType
   and w.bonuspartnertype           = p.partner_flow_type
   and prd.amount between w.minamount and w.maxamount
   and u.roleid                     = w.roleid
   and pay.approverid(+)            = u.payee
   and us.ruis_name(+)              = u.payee
   --and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-in_varicent','running view app_user ='||v('APP_USER'))                       
)
--/* This section is used when dossier is not yet visible in Varicent */
select bas.q
,      bas.DOSSIERID
,      bas.BONUSPARTNERTYPE
,      bas.DOSSIERTYPE
,      bas.DESCRIPTION
,      bas.VARICENTACTIONTYPE ACTIONTYPE
,      bas.MINAMOUNT
,      bas.MAXAMOUNT
,      bas.PAYEEID
,      bas.APPROVER_NAME
,      bas.APPROVALCYCLE
,      bas.APPROVALSTATUS
,      bas.APPROVALDATETIME
,      bas.COMMENTS
,      bas.ROLEID
,      bas.APPROVALLEVEL
,      bas.PARENT_DOSSIER_ID
,      bas.STATUS
,      bas.DOSSIER_ID 
--select bas.*, pgh.dossier_status_old ,pgh.dossier_status_new,dpg.amount, pgh.current_amount, pgh.previous_amount
from ( 
    select  1 q
    ,       pay.dossierid                      dossierid
    ,       w.bonuspartnertype                 bonuspartnertype
    ,       w.dossierType                      dossierType
    ,       w.description                      description  
    ,       w.actionType                       VaricentActionType
    ,       w.minamount                        minamount
    ,       w.maxamount                        maxamount
    ,       au.payee                           payeeid  
    --,       us.display_name                    approver_name
    ,       get_approval_on_date ( w.roleid, sysdate ) approver_name
    ,       nvl(d.mandate_cycle,1)             approvalcycle 
    ,       'nog tekenen'                      approvalstatus
    ,       null                               approvaldatetime  
    ,       null                               comments
    ,       w.roleid                           roleid  
    ,       w.approvallevels                   approvallevel
    ,       d.parent_dossier_id                PARENT_DOSSIER_ID
    ,       d.status                           STATUS
    ,       d.dossier_id                       DOSSIER_ID
    ,       d.dossier_type                     DOSSIER_TYPE
--select  w.actionType ,d.parent_dossier_id ,d.status , d.dossier_Id, d.dossier_type
    from  xxct_dossiers          d
    ,     xxct_dossiers          m
    ,     workflowlevels         w
    ,     prdgrp                 pay
    ,     xxct_partners_v        p
    ,     xxct_ctactiveuserswf_v au    
    ,     xxct_users             us 
    where 1=1
    and d.status <>  'AFGESLOTEN'    
    and m.dossier_id(+)     = d.parent_dossier_id
    and w.dossierType       = nvl( m.dossier_type(+), d.dossier_type)
    and d.dossier_id        = pay.dossierid
    and pay.amount between w.minamount and w.maxamount
    and p.partner_flow_type = w.bonuspartnertype
    and p.partner_id        = d.partner_id
    and w.roleid            = au.roleid
    and us.ruis_name        = au.payee
    and not exists (select 1 from in_varicent iv where iv.dossierid = d.dossier_id and iv.approvalstatus ='nog tekenen' and iv.approverid = au.payee and iv.approvalcycle = d.mandate_cycle )
    --and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-bas','running view app_user ='||v('APP_USER'))
--and d.dossier_id = 1310171
    ) bas
    ,     prodctgrphist               pgh
    ,     xxct_dossier_product_groups dpg
    where 1=1 
    and dpg.dossier_id         = bas.dossier_id
    and pgh.mandate_cycle  = bas.approvalcycle
    and pgh.dossier_id  = bas.dossier_id  -- outer joining pgh will result in very long execution!  !!! DO NOT OUTER JOIN BECAUSE HEROPEND case will go wrong
    ---- If the dossier is not linked to another dossier (parent_dossier_id is null) then this must be a Normal action type
    ---- If the dossier is linked it must be a Payment action type
    and bas.VaricentActionType = case
                       when bas.dossier_type = 'PAYMENT' then 'PAYMENT'
                       when bas.dossier_type = 'CREDITING' then 'PAYMENT'
                       when bas.dossier_type = 'RESERVATION' then 
                           case
                           --when 1=1 then 'NOT NORMAL'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'OPEN||OPEN'                     then  'NORMAL'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'CONTROLE||OPEN'                 then  'NORMAL'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'PROCURATIE||OPEN'               then  'NORMAL'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'AFGESLOTEN|CONTROLE|PROCURATIE'                                                      then  'NO HIERARCHIE NEEDED'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'HEROPEND|AFGESLOTEN|HEROPEND'   and pgh.sum_current_amount = pgh.sum_previous_amount then  'NO HIERARCHIE NEEDED'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'HEROPEND|AFGESLOTEN|HEROPEND'   and pgh.sum_current_amount < pgh.sum_previous_amount then  'DECREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'HEROPEND||OPEN'                 and pgh.sum_current_amount < pgh.sum_previous_amount then  'DECREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'CONTROLE|AFGESLOTEN|HEROPEND'   and pgh.sum_current_amount < pgh.sum_previous_amount then  'DECREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'PROCURATIE|AFGESLOTEN|HEROPEND' and pgh.sum_current_amount < pgh.sum_previous_amount then  'DECREASE'
                           --
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'HEROPEND|AFGESLOTEN|HEROPEND'   and pgh.sum_current_amount > pgh.sum_previous_amount then  'INCREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'HEROPEND||OPEN'                 and pgh.sum_current_amount > pgh.sum_previous_amount then  'INCREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'CONTROLE|AFGESLOTEN|HEROPEND'   and pgh.sum_current_amount > pgh.sum_previous_amount then  'INCREASE'
                           when bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new = 'PROCURATIE|AFGESLOTEN|HEROPEND' and pgh.sum_current_amount > pgh.sum_previous_amount then  'INCREASE'                           
                          end 
                       end
--and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-1','running view app_user ='||v('APP_USER'))      
--and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-1','Dossier_id = '||to_char(bas.dossier_id)||': '||bas.status||'|'||pgh.dossier_status_old||'|'||pgh.dossier_status_new||' sum current amount = '||to_char( pgh.sum_current_amount)||' sum previous amount = '||to_char( pgh.sum_previous_amount))
union
--/* This section is used when dossier is visible in Varicent */
select  2 q
,       iv.dossierid                        dossierid
,       iv.bonuspartnertype                 bonuspartnertype
,       iv.dossierType                      dossierType
,       iv.description                      description  
,       iv.actionType                       actionType
,       iv.minamount                        minamount
,       iv.maxamount                        maxamount
,       iv.payeeid                            payeeid  
,       iv.approver_name                   approver_name
,       iv.approvalcycle                  approvalcycle 
--,       decode( iv.approvalstatus,'PENDING', xxct_page_101_pkg.get_status_pending ,iv.approvalstatus)        approvalstatus
,       decode( iv.approvalstatus,'PENDING', 'nog tekenen' ,iv.approvalstatus)        approvalstatus
,       approvaldatetime                   approvaldatetime  
,       iv.comments                       comments
,       iv.roleid                           roleid  
,       to_number(iv.approvallevel)         approvallevel
,       null                               parent_dossier_id
,       'd.status'
,       to_number(iv.dossierid)
from    in_varicent iv
where 1=1
--and '1' = xxct_gen_debug_pkg.debug('XXCT_APPROVALS_V-2','running view app_user ='||v('APP_USER'))                       
--and iv.dossierid = '1310171';
;

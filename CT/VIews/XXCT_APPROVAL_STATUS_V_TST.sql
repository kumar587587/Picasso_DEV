--------------------------------------------------------
--  DDL for View XXCT_APPROVAL_STATUS_V_TST
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVAL_STATUS_V_TST" ("MANDATE_CYCLE", "DISPLAY_NAME", "ROLE_NAME", "APPROVAL_STATUS", "APPROVAL_DATE", "APPROVAL_COMMENTS", "ROLEID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  WITH prodctgrphist as
     (  
     select d.dossier_id, p.dossier_status_old
     ,      p.dossier_status_new
     ,      sum(c.amount) sum_current_amount
     ,      sum(p.amount) sum_previous_amount
     from xxct_dossier_product_groups c
     ,    xxct_dssr_prdct_grps_hst p
     ,    xxct_dossiers            d
     where 1=1
     and c.dossier_id          = ('4660')     
     and p.dossier_id          = c.dossier_id
     and p.product_group_code  = c.product_group_code
     --and p.reopend_sequence    = d.mandate_cycle -1
     --and p.mandate_cycle       = d.mandate_cycle -1   -- gedeactiveeer ivm test case 16
     and d.dossier_id          = c.dossier_id
     --and d.status              IN ( 'HEROPEND','CONTROLE','OPEN')
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
--        when  d.mandate_cycle > 1   -- Test Case  3 als controleur
--           and dossier_status_old ='OPEN'
--           and dossier_status_new ='CONTROLE'        
--        then
--          1=1          
     end          
     --group by d.dossier_id, c.mandate_cycle, dossier_status_old, dossier_status_new  
     group by d.dossier_id, dossier_status_old, dossier_status_new   -- mandate_cycle removed ivm case 16
     )
, partnerflowtype as
   (
   select partner_flow_type
   from   xxct_dossiers                 d
   ,    xxct_partners_tmp_v             p 
   where 1=1
   and  d.dossier_id  = to_number(  ('4660') )
   and p.partner_id = d.partner_id
   )
select "MANDATE_CYCLE","DISPLAY_NAME","ROLE_NAME","APPROVAL_STATUS","APPROVAL_DATE","APPROVAL_COMMENTS","ROLEID" 
--select *
from 
(
select a.mandate_cycle
--,      a.display_name
,      get_approval_on_date ( a.roleid , sysdate ) display_name
,      a.role_name
,      a.approval_status
,      a.approval_date
,      a.approval_comments
,      a.roleid
--, prdgh.sum_current_amount,  prdgh.sum_previous_amount, d.status
from xxct_approval_prediction_v      a
,    prodctgrphist                   prdgh 
,    xxct_dossiers                   d
,    partnerflowtype                 pft
where 1=1
AND d.dossier_id = a.dossier_id
-- Begin 8-1-2025
-- Waar is deze sectie voor??? Als je een bedrag ophoogt na een eerste keer het dossier afgekeurt te hebben dan zorgt dit stuk er (ongewenst) voor
-- dat alleen de eerst volgende approver getoond wordt... terwijl er 4 zouden moeten zijn.
--AND CASE 
--    WHEN v('P102_DOSSIER_TYPE_CODE') ='RESERVATION' AND v('P102_MANDATE_CYCLE') > 1 
--    AND  prdgh.sum_current_amount > prdgh.sum_previous_amount THEN
--         (prdgh.sum_current_amount - prdgh.sum_previous_amount) BETWEEN A.MINAMOUNT AND A.MAXAMOUNT
--    ELSE    
--         a.TOTAL_AMOUNT    BETWEEN A.MINAMOUNT AND A.MAXAMOUNT
--    END  
-- Eind 8-1-2025
AND prdgh.dossier_id(+)  = a.dossier_id
AND CASE    
   WHEN v('P102_DOSSIER_TYPE_CODE') ='RESERVATION' AND v('P102_MANDATE_CYCLE') = 1 THEN   
  -- WHEN ('RESERVATION') ='RESERVATION' AND 2 = 1 THEN   
        A.ACTIONTYPE ='NORMAL'
    WHEN v('P102_DOSSIER_TYPE_CODE') ='RESERVATION' AND v('P102_MANDATE_CYCLE') > 1 THEN   
   -- WHEN ('RESERVATION') ='RESERVATION' AND 2 > 1 THEN   
        CASE
        WHEN prdgh.sum_current_amount > prdgh.sum_previous_amount THEN
           A.ACTIONTYPE ='INCREASE'        
        WHEN PRDGH.SUM_CURRENT_AMOUNT < PRDGH.SUM_PREVIOUS_AMOUNT THEN
           A.ACTIONTYPE ='DECREASE'        
        WHEN prdgh.sum_current_amount = prdgh.sum_previous_amount and d.status = 'OPEN' THEN  -- Deze is nodig voor case 3 Opnieuw aanbieden. als retail support
           A.ACTIONTYPE ='NORMAL'        
        WHEN prdgh.sum_current_amount = prdgh.sum_previous_amount and d.status = 'CONTROLE' THEN  -- Deze is nodig voor case 3 Opnieuw aanbieden als controleur
           A.ACTIONTYPE ='NORMAL'        
        WHEN prdgh.sum_current_amount = prdgh.sum_previous_amount and d.status = 'PROCURATIE' THEN  -- Deze is nodig voor case 4
           A.ACTIONTYPE ='NORMAL'        
        WHEN prdgh.sum_current_amount = prdgh.sum_previous_amount and d.status = 'CONTROLE' THEN  -- Deze is nodig voor case 7?????
           A.ACTIONTYPE ='xxNORMAL'        -- xxNOrmal omdat er bij case 14 anders teveel approvers werden getoond.
        ELSE
           A.ACTIONTYPE ='NOT NORMAL'        
        END
    ELSE    
        A.ACTIONTYPE = A.ACTIONTYPE
    END   
   and instr( a.roleid , pft.partner_flow_type ) > 0
union
select a.* from  xxct_approval_L1_v a, partnerflowtype      pft where instr( a.roleid , pft.partner_flow_type ) > 0
union
select a.* from  xxct_approval_L2_v a, partnerflowtype      pft where instr( a.roleid , pft.partner_flow_type ) > 0

) bas
where 1=1

ORDER BY mandate_cycle,roleid
;

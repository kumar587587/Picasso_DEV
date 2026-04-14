--------------------------------------------------------
--  DDL for View XXCT_APPROVAL_PREDICTION_V_NEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVAL_PREDICTION_V_NEW" ("MANDATE_CYCLE", "DISPLAY_NAME", "ROLE_NAME", "APPROVAL_STATUS", "APPROVAL_DATE", "APPROVAL_COMMENTS", "ROLEID", "ACTIONTYPE", "MAXAMOUNT", "MINAMOUNT", "TOTAL_AMOUNT", "DOSSIER_ID", "DOSSIERTYPE", "PARTNER_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT d.mandate_cycle   mandate_cycle
,      u.display_name
,      r.role_name
,      'nog tekenen'          approval_status
,      null                   approval_date
,      null                   approval_comments
,      apl.roleid 
,      apl.actiontype
,      apl.maxamount
,      apl.minamount
,      prdg.total_amount
,      prdg.dossier_id
,      apl.dossiertype
,      p.partner_id
FROM xxct_approvallevels_v           apl
,    xxct_partners_tmp_v             p
,    (
     SELECT dossier_id,SUM(amount) total_amount 
     FROM xxct_dossier_product_groups
     GROUP BY dossier_id
     )                               prdg
,    xxct_ctactiveuserswf_v          au
,    xxct_users                      u   
,    xxct_roles                      r
,    xxct_dossiers                   d
WHERE 1=1
and apl.bonuspartnertype    = p.partner_flow_type
and p.partner_id            = p.partner_id --nvl( v('P102_PARTNER_ID'),p.partner_id)
and apl.dossiertype         = apl.dossiertype --nvl( v('P102_DOSSIER_TYPE_CODE'), apl.dossiertype)
and prdg.dossier_id         = prdg.dossier_id --nvl( v('P102_DOSSIER_ID'),prdg.dossier_id)
and prdg.total_amount       BETWEEN apl.minamount AND apl.maxamount
and au.roleid               like 'CT%L%'
and au.roleid               = apl.roleid
and u.ruis_name             = apl.payee    
and r.role_key              = au.roleid
and r.role_key              like 'CT %L%'
and r.role_key              = apl.roleid
and instr( r.role_name, ' - ') > 0 
and d.dossier_id            =  prdg.dossier_id
and d.status                <> 'AFGESLOTEN'
--AND D.DOSSIER_TYPE          = 'RESERVATION'
and case
    when d.status = 'PROCURATIE' and apl.roleid like '%L1'
    then
       case
       --when apl.roleid like '%L1' and exists (select * from xxct_approval_l1_v where approval_status = 'Afgekeurd')  then
       when  exists (select * from xxct_approval_l1_v a where a.approval_status = 'Afgekeurd' and a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
           -- when a record exists in the xxct_approval_l1_v somebody has approved or rejected the L1 and no more 'to be approved need to be shown for L1
           1=2
       when  exists (select * from xxct_approval_l1_v a where a.approval_status = 'Akkoord' and a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
           -- when a record exists in the xxct_approval_l1_v somebody has approved or rejected the L1 and no more 'to be approved need to be shown for L1
           1=2
       else 
          1=1
       end 
    when d.status = 'PROCURATIE' and ( apl.roleid like '%L2' or apl.roleid like '%L3' or apl.roleid like '%L4' )
    then
       case
       when  not exists (select * from xxct_approval_l1_v a where a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
           -- in this case nothnng has been approved or rejected yet, so show everything.
           1=1
       when   exists (select * from xxct_approval_l1_v a where a.approval_status = 'Akkoord' and a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
           -- in this case L1 has been approved
           case
           when exists ( select * from xxct_approval_l2_v a where a.approval_status in ('Afgekeurd')  and a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
               -- Do not show any L2, L3 or L4 if one of these has already been rejected.
               1=2
           when exists ( select * from xxct_approval_l2_v a where a.approval_status in ( 'Akkoord','Afgekeurd') --and a.roleid = apl.roleid  
                         and A.ROLEID in (SELECT ROLEID FROM XXCT_APPROVALLEVELS_V B WHERE B.BONUSPARTNERTYPE = APL.BONUSPARTNERTYPE AND B.DOSSIERTYPE = APL.DOSSIERTYPE AND
                                                B.ACTIONTYPE = APL.ACTIONTYPE AND B.ROLEID = APL.ROLEID)
                         and a.mandate_cycle = trim( to_char( d.mandate_cycle) )  )  then
              -- Do not show this role (with 'nog tekenen', as it has already been approved
              1=2
           else
              -- these L2, L3 or L4 roles have not been approved or rejected yet, so the still need approval or rejection
              1=1
           end
       else 
          1=2
       end 
    when d.status = 'FACTURATIE' --and ( apl.roleid like '%L2' or apl.roleid like '%L3' or apl.roleid like '%L4' )
    then
       1=2
    else
      1=1
    end
;

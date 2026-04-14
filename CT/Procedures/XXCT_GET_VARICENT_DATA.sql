--------------------------------------------------------
--  DDL for Procedure XXCT_GET_VARICENT_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCT"."XXCT_GET_VARICENT_DATA" 
( p_username           IN VARCHAR2
, P_APPROVAL_LINK_FLAG IN VARCHAR2 DEFAULT 'N'
)
AS
  l_routine_name constant varchar2(200) := 'XXCT_GET_VARICENT_DATA';
  l_count                 number;
  pragma autonomous_transaction;
BEGIN
   xxct_gen_debug_pkg.debug(l_routine_name,'(start)');
   xxct_gen_debug_pkg.debug(l_routine_name,'p_username & p_approval_link_flag ='|| p_username||'=='||p_approval_link_flag);
   --
   IF p_approval_link_flag = 'N' THEN
       DELETE FROM xxct_dssr_prdct_grps_hst_tmp WHERE lower(username)  = lower(p_username);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_dssr_prdct_grps_hst_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_approvals_tmp           WHERE lower(username)  = lower(p_username);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_wf_ct_appr_hist_tmp     WHERE lower(username)  = lower(p_username);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_partners_tmp            WHERE TRIM(lower(username)) = TRIM(lower(p_username)); 
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_partners_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_ctpaytapprvlwfdtls_tmp  WHERE TRIM(lower(username))  = lower(p_username); 
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctpaytapprvlwfdtls_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_wf_history_tmp WHERE lower(username)  = lower(p_username);   
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_history_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_workflowlevels_tmp WHERE lower(username)  = lower(p_username);   
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_workflowlevels_tmp rows deleted ='|| SQL%rowcount);
       --   
       DELETE FROM xxct_persons_tmp WHERE lower(username)  = lower(p_username);   
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_persons_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_spuserrole_tmp WHERE lower(username)  = lower(p_username);   
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_spuserrole_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_ctactiveuserswf_tmp WHERE lower(username)  = lower(p_username);   
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctactiveuserswf_tmp rows deleted ='|| SQL%rowcount);
       ---------------------------------------------------
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_dssr_prdct_grps_hst_tmp start');
       INSERT INTO xxct_dssr_prdct_grps_hst_tmp
       SELECT a.dossier_id, dossier_status_old, dossier_status_new,lower( p_username ) , current_amount, previous_amount,product_group_code, mandate_cycle
       FROM (
            SELECT b.dossier_id
            ,      a.dossier_status_old
            ,      dossier_status_new 
            ,      a.dssr_prdct_grp_hst_id
            ,      LAG(a.dssr_prdct_grp_hst_id) OVER  (PARTITION BY a.dossier_id ORDER BY a.dssr_prdct_grp_hst_id) AS previous_row_id
            ,      b.amount current_amount
            ,      LAG(a.amount )               OVER  (PARTITION BY a.dossier_id ORDER BY a.dssr_prdct_grp_hst_id) AS previous_amount
            ,      a.product_group_code        
            ,      a.mandate_cycle
            FROM xxct_dssr_prdct_grps_hst a
            ,    xxct_dossier_product_groups b
            WHERE a.dossier_id = b.dossier_id
            and a.mandate_cycle = b.mandate_cycle        
            ) a
       WHERE a.dssr_prdct_grp_hst_id = (SELECT MAX(b.dssr_prdct_grp_hst_id) FROM xxct_dssr_prdct_grps_hst b WHERE b.dossier_id = a.dossier_id);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_dssr_prdct_grps_hst_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp start');
       INSERT INTO xxct_wf_ct_appr_hist_tmp(id,workflowid,nodename,initiator,initiatorname,actor,actorname,isforcedby,action,dateactioned,webreportname,attachments,documentid,tokenid,username)
       SELECT id,workflowid,nodename,initiator,initiatorname,actor,actorname,isforcedby,action,dateactioned,webreportname,attachments,documentid,tokenid,lower(p_username)
       FROM xxct_wf_ct_dossier_approval_history_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_partners_tmp start');
       INSERT INTO xxct_partners_tmp( partner_id, partner_name, v_code,channel_manager, resource_id, channel_manager_person_id, partner_number, email_address_invoice, partner_flow_type, oracle_customer_nr, vat_reverse_charge, username)
       SELECT                         partner_id, partner_name, v_code,channel_manager, resource_id, channel_manager_person_id, partner_number, email_address_invoice, partner_flow_type, oracle_customer_nr, vat_reverse_charge, lower(p_username)
       FROM xxct_partners_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_partners_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_workflowlevels_tmp start');
       INSERT INTO  xxct_workflowlevels_tmp
       select r.roleid                    roleid  
       ,      l.actionType                actionType
       ,      l.bonuspartnertype          bonuspartnertype 
       ,      l.description               description 
       ,      l.minamount                 minamount
       ,      l.maxamount                 maxamount   
       ,      r.approvallevels            approvallevels
       ,      r.approvallevels            approvallevel
       ,      l.dossierType               dossierType
       ,      r.indicatorworkflowrole     indicatorworkflowrole
       ,      l.roleapprovallevelfrom     roleapprovallevelfrom
       ,      l.roleapprovallevelto       roleapprovallevelto
       ,      lower(p_username)           username
       from xxct_spCTWFLevels_v  l
       ,    xxct_plIAMRoles_v    r
       where 1=1
       and r.model = 'CT' 
       and r.partnerType = l.bonuspartnertype
       and r.approvallevels between l.roleapprovallevelfrom and l.roleapprovallevelto
       and r.indicatorworkflowrole ='Y';
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_workflowlevels_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_persons_tmp start');
       INSERT INTO xxct_persons_tmp
       SELECT a.*, lower( p_username )
       FROM xxct_persons_v a;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_persons_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_spuserrole_tmp start');
       INSERT INTO xxct_spuserrole_tmp
       SELECT a.*, lower( p_username )
       FROM xxct_spuserrole_v a;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_spuserrole_tmp end');
       --
    --   COMMIT;
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctpaytapprvlwfdtls_tmp start');
       INSERT INTO xxct_ctpaytapprvlwfdtls_tmp (dossierkey, approverid, formid, dossierid, approvalcycle, dossiertype, actiontype, approvertype, swimlane, assigneddatetime, approvalstatus, approvaldatetime, comments, commentdate, approvername, username)
       SELECT dossierkey, approverid, formid, dossierid, approvalcycle, dossiertype, actiontype, approvertype, swimlane, assigneddatetime, approvalstatus, approvaldatetime, comments, commentdate, approvername, lower(p_username)
       FROM xxct_ctpayoutapprovalwfdetails_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctpaytapprvlwfdtls_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp start');
       INSERT INTO xxct_approvals_tmp (dossierid,bonuspartnertype,dossiertype,description,actiontype,minamount,maxamount,payeeid,approver_name,approvalcycle,approvalstatus,approvaldatetime,comments,role,approvallevel,username)
       SELECT dossierid,bonuspartnertype,dossiertype,description,actiontype,minamount,maxamount,payeeid,approver_name,approvalcycle,approvalstatus,approvaldatetime,comments,role,approvallevel,lower(p_username)
       FROM xxct_approvals_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp end rowcount = '||sql%rowcount);
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_history_tmp start');
       INSERT INTO xxct_wf_history_tmp
       SELECT a.*, lower(p_username) username
       FROM TABLE(xxct_gen_rest_apis.get_workflow_history('CT Dossier Approval',NULL)) a;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_history_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctactiveuserswf_tmp start');
       INSERT INTO xxct_ctactiveuserswf_tmp
       SELECT a.*, lower(p_username) username
       FROM TABLE(xxct_gen_rest_apis.get_CTActiveUsersWF) a;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctactiveuserswf_tmp end');

       --
    --   xxct_gen_debug_pkg.debug(l_routine_name,'xxct_ctpaytapprvlwfdtls_tmp');
    --   for r_row in (select * from xxct_ctpaytapprvlwfdtls_tmp where lower(username) = lower( p_username) ) loop
    --       --xxct_gen_debug_pkg.debug(l_routine_name,'xxct_mandates_hist');
    --       update xxct_mandates_hist
    --       set approval_status = decode( r_row.approvalstatus,'APPROVED','Akkoord',r_row.approvalstatus)
    --       where trim( to_char(dossier_id) ) = r_row.dossierid
    --       and mandate_cycle = r_row.approvalcycle
    --       ;
    --   end loop;
       COMMIT;
    ELSIF p_approval_link_flag = 'Y' THEN --added by TechM Team
       xxct_gen_debug_pkg.debug(l_routine_name,'(else part) p_username ='|| p_username||'=='||p_approval_link_flag);

       DELETE FROM xxct_approvals_tmp WHERE lower(username)  = lower(p_username);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_wf_ct_appr_hist_tmp     WHERE lower(username)  = lower(p_username);
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp rows deleted ='|| SQL%rowcount);
       --
       DELETE FROM xxct_partners_tmp            WHERE TRIM(lower(username)) = TRIM(lower(p_username)); 

       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp start');
       INSERT INTO xxct_wf_ct_appr_hist_tmp(id,workflowid,nodename,initiator,initiatorname,actor,actorname,isforcedby,action,dateactioned,webreportname,attachments,documentid,tokenid,username)
       SELECT id,workflowid,nodename,initiator,initiatorname,actor,actorname,isforcedby,action,dateactioned,webreportname,attachments,documentid,tokenid,lower(p_username)
       FROM xxct_wf_ct_dossier_approval_history_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_wf_ct_appr_hist_tmp end');
       --
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_partners_tmp start');
       INSERT INTO xxct_partners_tmp( partner_id, partner_name, v_code,channel_manager, resource_id, channel_manager_person_id, partner_number, email_address_invoice, partner_flow_type, oracle_customer_nr, vat_reverse_charge, username)
       SELECT                         partner_id, partner_name, v_code,channel_manager, resource_id, channel_manager_person_id, partner_number, email_address_invoice, partner_flow_type, oracle_customer_nr, vat_reverse_charge, lower(p_username)
       FROM xxct_partners_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_partners_tmp end');

       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp start');
       INSERT INTO xxct_approvals_tmp (dossierid,bonuspartnertype,dossiertype,description,actiontype,minamount,maxamount,payeeid,approver_name,approvalcycle,approvalstatus,approvaldatetime,comments,role,approvallevel,username)
       SELECT dossierid,bonuspartnertype,dossiertype,description,actiontype,minamount,maxamount,payeeid,approver_name,approvalcycle,approvalstatus,approvaldatetime,comments,role,approvallevel,lower(p_username)
       FROM xxct_approvals_v;
       xxct_gen_debug_pkg.debug(l_routine_name,'xxct_approvals_tmp end rowcount = '||sql%rowcount);
       --
       COMMIT;
    END IF;--IF ELSE AND p_approval_link_flag ADDED BY TechM Team
   xxct_gen_debug_pkg.debug(l_routine_name,'(end)');
EXCEPTION 
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug(l_routine_name,'ERROR: '||sqlerrm); 
   RAISE;
END;

/

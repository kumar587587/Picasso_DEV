--------------------------------------------------------
--  DDL for View XXCT_CTPAYOUTAPPROVALWFDETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWFDETAILS_V" ("DOSSIERKEY", "APPROVERID", "FORMID", "DOSSIERID", "APPROVALCYCLE", "DOSSIERTYPE", "ACTIONTYPE", "APPROVERTYPE", "SWIMLANE", "ASSIGNEDDATETIME", "APPROVALSTATUS", "APPROVALDATETIME", "COMMENTS", "COMMENTDATE", "APPROVERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select dossierkey                                           dossierkey 
,      approverid                                           approverid
,      formid                                               formid    
,      dossierid                                            dossierid
,      approvalcycle                                        approvalcycle
,      dossiertype                                          dossiertype
,      actiontype                                           actiontype
,      approvertype                                         approvertype  
,      swimlane                                             swimlane
,      assigneddatetime                                     assigneddatetime  
,      approvalstatus                                       approvalstatus  
,      approvaldatetime                                     approvaldatetime 
,      comments                                             comments
,      commentdate                                          commentdate   
,      nvl(u.display_name,'no match')                       approvername
from table(XXCT_GEN_REST_APIS.get_workflowdetails) w
,    xxct_users u
where 1=1
and u.ruis_name(+) = approverid
and w.swimlane >1
;

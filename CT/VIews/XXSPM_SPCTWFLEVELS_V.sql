--------------------------------------------------------
--  DDL for View XXSPM_SPCTWFLEVELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXSPM_SPCTWFLEVELS_V" ("SWIMLANE", "BONUSPARTNERTYPE", "DOSSIERTYPE", "ACTIONTYPE", "Level", "MINAMOUNT", "MAXAMOUNT", "ROLEAPPROVALLEVELFROM", "ROLEAPPROVALLEVELTO", "DESCRIPTION", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select wf.swimlane
,      bt.code          Bonuspartnertype
,      dt.code          dossiertype
,      at.code          actiontype 
,      wf.approvallevel  "Level"
,      wf.minamount
,      wf.maxamount
,      to_number( substr(rf.role_key,-1))  roleapprovallevelfrom
,      to_number( substr(rt.role_key,-1))  roleapprovallevelto
,      wf.description
,      greatest( WF.creatION_DATE, WF.LAST_UPDATE_DATE ) last_update_or_creation_date
from xxct_SPCTWFLEVELS wf
,    xxct_lookup_values bt
,    xxct_lookup_values dt
,    xxct_lookup_values at
,    xxct_roles         rf
,    xxct_roles         rt
where bt.id = wf.bonuspartnertype_id
and   dt.id = wf.dossiertype_id
and   at.id = wf.actiontype_id
and   rf.id  =wf.roleapprovallevelfrom
and   rt.id  =wf.roleapprovallevelto
order by 1,2,3,4,5
;

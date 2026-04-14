--------------------------------------------------------
--  DDL for View XXCT_APPROVALLEVELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVALLEVELS_V" ("SWIMLANE", "BONUSPARTNERTYPE", "DOSSIERTYPE", "ACTIONTYPE", "APPROVALLEVEL", "MINAMOUNT", "MAXAMOUNT", "ROLEAPPROVALLEVELFROM", "ROLEAPPROVALLEVELTO", "DESCRIPTION", "PAYEE", "ROLEID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT apl.swimlane
,      apl.bonuspartnertype
,      case 
       when apl.actiontype = 'PAYMENT' and apl.dossiertype='RESERVATION' then
         'PAYMENT'
       else  
         apl.dossiertype
       end      dossiertype
,      apl.actiontype
,      apl."LEVEL"  approvallevel
,      apl.minamount
,      apl.maxamount
,      apl.roleapprovallevelfrom
,      apl.roleapprovallevelto
,      apl.description
,      aur.payee
,      aur.roleid
FROM xxct_spctwflevels_v          apl
,    xxct_ctactiveuserswf_tmp_v   aur
WHERE 1=1
AND approvallevel        BETWEEN apl.roleapprovallevelfrom AND apl.roleapprovallevelto
AND apl.bonuspartnertype       = aur.bonuspartnertype
;

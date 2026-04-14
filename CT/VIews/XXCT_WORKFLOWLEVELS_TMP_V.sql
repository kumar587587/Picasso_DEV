--------------------------------------------------------
--  DDL for View XXCT_WORKFLOWLEVELS_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_WORKFLOWLEVELS_TMP_V" ("ROLEID", "ACTIONTYPE", "BONUSPARTNERTYPE", "DESCRIPTION", "MINAMOUNT", "MAXAMOUNT", "APPROVALLEVELS", "APPROVALLEVEL", "DOSSIERTYPE", "INDICATORWORKFLOWROLE", "ROLEAPPROVALLEVELFROM", "ROLEAPPROVALLEVELTO", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT roleid
  ,      actiontype
  ,      bonuspartnertype
  ,      description
  ,      minamount
  ,      maxamount
  ,      approvallevels
  ,      approvallevel
  ,      dossiertype
  ,      indicatorworkflowrole
  ,      roleapprovallevelfrom
  ,      roleapprovallevelto,username
  FROM xxct_workflowlevels_tmp a
  WHERE lower( username ) = nvl( v('APP_USER') , xxct_general_pkg.get_developer_user )
;

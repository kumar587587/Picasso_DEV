--------------------------------------------------------
--  DDL for View XXCT_APPROVALS_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVALS_TMP_V" ("DOSSIERID", "BONUSPARTNERTYPE", "DOSSIERTYPE", "DESCRIPTION", "ACTIONTYPE", "MINAMOUNT", "MAXAMOUNT", "PAYEEID", "APPROVER_NAME", "APPROVALCYCLE", "APPROVALSTATUS", "APPROVALDATETIME", "COMMENTS", "ROLE", "APPROVALLEVEL", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT dossierid
  ,      bonuspartnertype
  ,      dossiertype
  ,      description
  ,      actiontype
  ,      minamount
  ,      maxamount
  ,      payeeid
  ,      approver_name
  ,      approvalcycle
  ,      approvalstatus
  ,      approvaldatetime
  ,      comments
  ,      role
  ,      approvallevel
  ,      username 
  FROM xxct_approvals_tmp
  WHERE lower( username ) = nvl( v('APP_USER') ,xxct_general_pkg.get_developer_user)
;

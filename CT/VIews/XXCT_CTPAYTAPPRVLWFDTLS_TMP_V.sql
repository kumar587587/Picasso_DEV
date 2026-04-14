--------------------------------------------------------
--  DDL for View XXCT_CTPAYTAPPRVLWFDTLS_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CTPAYTAPPRVLWFDTLS_TMP_V" ("DOSSIERKEY", "APPROVERID", "FORMID", "DOSSIERID", "APPROVALCYCLE", "DOSSIERTYPE", "ACTIONTYPE", "APPROVERTYPE", "SWIMLANE", "ASSIGNEDDATETIME", "APPROVALSTATUS", "APPROVALDATETIME", "COMMENTS", "COMMENTDATE", "APPROVERNAME", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT dossierkey
  ,      approverid
  ,      formid
  ,      dossierid
  ,      approvalcycle
  ,      dossiertype
  ,      actiontype
  ,      approvertype
  ,      swimlane
  ,      assigneddatetime
  ,      approvalstatus
  ,      approvaldatetime
  ,      comments
  ,      commentdate
  ,      approvername
  ,      username 
  FROM xxct_ctpaytapprvlwfdtls_tmp
  WHERE lower( username ) = nvl(  v('APP_USER')  ,xxct_general_pkg.get_developer_user )
;

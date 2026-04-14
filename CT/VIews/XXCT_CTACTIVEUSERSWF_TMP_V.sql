--------------------------------------------------------
--  DDL for View XXCT_CTACTIVEUSERSWF_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CTACTIVEUSERSWF_TMP_V" ("ROLEID", "PAYEE", "APPROVERTYPE", "BONUSPARTNERTYPE", "APPROVALLEVEL", "APPROVALDATE", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT roleid
,      payee
,      approvertype
,      bonuspartnertype
,      approvallevel
,      approvaldate
,      username 
FROM xxct_ctactiveuserswf_tmp
WHERE lower( username ) = nvl(  v('APP_USER')  ,xxct_general_pkg.get_developer_user )
;

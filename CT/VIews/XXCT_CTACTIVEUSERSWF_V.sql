--------------------------------------------------------
--  DDL for View XXCT_CTACTIVEUSERSWF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CTACTIVEUSERSWF_V" ("ROLEID", "PAYEE", "APPROVERTYPE", "BONUSPARTNERTYPE", "APPROVALLEVEL", "APPROVALDATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select ROLEID
  ,      PAYEE
  ,      APPROVERTYPE
  ,      BONUSPARTNERTYPE
  ,      APPROVALLEVEL
  ,      APPROVALDATE 
  from table(xxct_gen_rest_apis.get_CTActiveUsersWF)
;

--------------------------------------------------------
--  DDL for View XXCT_PLIAMROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PLIAMROLES_V" ("ROLEID", "ACCESSLEVELNAME", "INDICATORWORKFLOWROLE", "MODEL", "PARTNERTYPE", "APPROVALLEVELS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select "ROLEID","ACCESSLEVELNAME","INDICATORWORKFLOWROLE","MODEL","PARTNERTYPE","APPROVALLEVELS" from table(xxct_gen_rest_apis.get_plIAMRole)
;

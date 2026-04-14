--------------------------------------------------------
--  DDL for View XXCT_DOSSIER_PRODUCT_GROUPS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIER_PRODUCT_GROUPS_V" ("DOSSIER_PRODUCT_GROUP_ID", "DOSSIER_ID", "TARGET", "CONTRIBUTION", "AMOUNT", "MANDATE_CYCLE", "PRODUCT_GROUP_CODE", "PRODUCT_GROUP_CODE_PAYMENTS", "REMARKS", "CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select dossier_product_group_id
,      dossier_id
,      target
,      contribution
,      amount
,      mandate_cycle
,      product_group_code
,      product_group_code          product_group_code_payments
,      remarks
,      creation_date
from xxct_dossier_product_groups;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_DOSSIER_PRODUCT_GROUPS_V"  IS '$Id: vw_XXCT_DOSSIER_PRODUCT_GROUPS_V.sql,v 1.1 2019/03/20 11:59:31 rikke493 Exp $'
;

--------------------------------------------------------
--  DDL for View XXCT_REPORT4_DATA_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT4_DATA_V" ("DOSSIER_ID", "PARTNER_ID", "FINANCIAL_CLOSE", "ACTION_START_DATE", "ACTION_END_DATE", "DOSSIER_TYPE", "PRODUCT_GROUP_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT "DOSSIER_ID","PARTNER_ID","FINANCIAL_CLOSE","ACTION_START_DATE","ACTION_END_DATE","DOSSIER_TYPE","PRODUCT_GROUP_CODE"
               FROM   xxct_not_reopend_dossiers_v
               UNION
               SELECT "DOSSIER_ID","PARTNER_ID","FINANCIAL_CLOSE","ACTION_START_DATE","ACTION_END_DATE","DOSSIER_TYPE","PRODUCT_GROUP_CODE" 
               FROM   xxct_reopend_dossiers_data_v
;

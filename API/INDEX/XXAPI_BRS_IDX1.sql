--------------------------------------------------------
--  DDL for Index XXAPI_BRS_IDX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "WKSP_XXAPI"."XXAPI_BRS_IDX1" ON "WKSP_XXAPI"."XXAPI_BATCH_RUN_SETTINGS" ("BRS_BRN_ID", "BRS_CODE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;

--------------------------------------------------------
--  DDL for Index XXAPI_BRF_IDX3
--------------------------------------------------------

  CREATE UNIQUE INDEX "WKSP_XXAPI"."XXAPI_BRF_IDX3" ON "WKSP_XXAPI"."XXAPI_BATCH_RUN_FILE" ("BRF_BRN_ID", "BRF_FILE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;

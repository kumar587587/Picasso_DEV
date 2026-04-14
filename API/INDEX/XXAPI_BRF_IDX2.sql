--------------------------------------------------------
--  DDL for Index XXAPI_BRF_IDX2
--------------------------------------------------------

  CREATE INDEX "WKSP_XXAPI"."XXAPI_BRF_IDX2" ON "WKSP_XXAPI"."XXAPI_BATCH_RUN_FILE" ("BRF_BRN_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;

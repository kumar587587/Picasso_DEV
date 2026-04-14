--------------------------------------------------------
--  DDL for Index XXCPC_ALL_CALC_UNQ_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "WKSP_XXCPC"."XXCPC_ALL_CALC_UNQ_ID" ON "WKSP_XXCPC"."XXCPC_ALL_CALCULATIONS" ("CALCULATIONID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;

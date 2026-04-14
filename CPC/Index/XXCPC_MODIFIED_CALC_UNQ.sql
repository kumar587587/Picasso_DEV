--------------------------------------------------------
--  DDL for Index XXCPC_MODIFIED_CALC_UNQ
--------------------------------------------------------

  CREATE UNIQUE INDEX "WKSP_XXCPC"."XXCPC_MODIFIED_CALC_UNQ" ON "WKSP_XXCPC"."XXCPC_MODIFIED_CALCULATIONS" ("AUDITID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;

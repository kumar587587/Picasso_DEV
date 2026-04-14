--------------------------------------------------------
--  DDL for View XXSPM_PL_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PL_CONTRACTS_V" ("CONTRACTID", "CONTRACTNAME", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contractnr                                   contractid
,      c.contractname                                 contractname 
,      greatest(c.updated, c.created)                 last_update_or_creation_date
FROM  xxcpc_contracts        c
;

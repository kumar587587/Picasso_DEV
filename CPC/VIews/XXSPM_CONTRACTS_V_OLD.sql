--------------------------------------------------------
--  DDL for View XXSPM_CONTRACTS_V_OLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CONTRACTS_V_OLD" ("CONTRACTID", "DESCRIPTION", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT contractnr           contractid 
,      'Contract for '||contractnr   description 
,      greatest(updated, created)    last_update_or_creation_date
FROM xxcpc_contracts ORDER BY 1
;

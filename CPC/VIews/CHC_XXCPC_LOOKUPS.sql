--------------------------------------------------------
--  DDL for View CHC_XXCPC_LOOKUPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."CHC_XXCPC_LOOKUPS" ("ID", "TYPE", "DESCRIPTION", "CODE", "NUMBER_VALUE", "REMARKS", "START_DATE", "END_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        "ID"
      , "TYPE"
      , "DESCRIPTION"
      , "CODE"
      , "NUMBER_VALUE"
      , "REMARKS"
      , "START_DATE"
      , "END_DATE"
    FROM
        xxcpc_lookups
order by 1,2,3,4
;

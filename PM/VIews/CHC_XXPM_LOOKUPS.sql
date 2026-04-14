--------------------------------------------------------
--  DDL for View CHC_XXPM_LOOKUPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."CHC_XXPM_LOOKUPS" ("LOOKUP_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        lookup_type
    FROM
        xxpm_lookups
    ORDER BY
        1
;

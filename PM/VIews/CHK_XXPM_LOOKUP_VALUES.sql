--------------------------------------------------------
--  DDL for View CHK_XXPM_LOOKUP_VALUES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."CHK_XXPM_LOOKUP_VALUES" ("LOOKUP_TYPE", "MEANING", "CODE", "ENABLED_FLAG", "START_DATE_ACTIVE", "END_DATE_ACTIVE", "ATTRIBUTE1") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        "LOOKUP_TYPE"
      , "MEANING"
      , "CODE"
      , "ENABLED_FLAG"
      , "START_DATE_ACTIVE"
      , "END_DATE_ACTIVE"
      , "ATTRIBUTE1"
    FROM
        xxpm_lookup_values
order by 1,2,3,4
;

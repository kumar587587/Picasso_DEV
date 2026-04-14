--------------------------------------------------------
--  DDL for View CHK_XXPM_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."CHK_XXPM_ROLES" ("ID", "ROLE_NAME", "COMPOSED", "START_DATE", "END_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        "ID"
      , "ROLE_NAME"
      , "COMPOSED"
      , "START_DATE"
      , "END_DATE"
    FROM
        xxpm_roles
    ORDER BY
        2
      , 3
      , 4
      , 5
;

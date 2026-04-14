--------------------------------------------------------
--  DDL for View CHK_XXCPC_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."CHK_XXCPC_ROLES" ("ID", "ROLE_NAME", "COMPOSED", "START_DATE", "END_DATE", "REQUIRES_MANUAL_VARICENT_SETUP") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        "ID"
      , "ROLE_NAME"
      , "COMPOSED"
      , "START_DATE"
      , "END_DATE"
      , "REQUIRES_MANUAL_VARICENT_SETUP"
    FROM
        xxcpc_roles
order by 2,3,4,5,6
;

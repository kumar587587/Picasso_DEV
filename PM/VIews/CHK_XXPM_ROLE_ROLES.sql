--------------------------------------------------------
--  DDL for View CHK_XXPM_ROLE_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."CHK_XXPM_ROLE_ROLES" ("COMPOSED_ROLE_NAME", "ROLE_NAME", "COMPOSED", "START_DATE", "END_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        b.role_name composed_role_name
      , c.role_name
      , c.composed
      , c.start_date
      , c.end_date
    FROM
        xxpm_role_roles a
      , xxpm_roles      b
      , xxpm_roles      c
    WHERE
            a.composed_role_id = b.id
        AND a.role_id = c.id
    ORDER BY
        1
      , 2
      , 3
      , 4
      , 5
;

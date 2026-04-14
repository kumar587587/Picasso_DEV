--------------------------------------------------------
--  DDL for View CHK_XXCPC_ROLE_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."CHK_XXCPC_ROLE_ROLES" ("COMPOSED_ROLE_NAME", "ROLE_NAME", "COMPOSED", "START_DATE", "END_DATE", "REQUIRES_MANUAL_VARICENT_SETUP") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT b.role_name composed_role_name, c.role_name,c.composed,c.start_date, c.end_date, c.requires_manual_varicent_setup
    FROM
        xxcpc_role_roles a
        , xxcpc_roles b
        , xxcpc_roles c
where a.composed_role_id = b.id        
and a.role_id = c.id
order by 1,2,3,4,5,6
;

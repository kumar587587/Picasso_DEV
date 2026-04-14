--------------------------------------------------------
--  DDL for View ORDS_PRIVS_NOT_LINKED_TO_CREDS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."ORDS_PRIVS_NOT_LINKED_TO_CREDS_V" ("PRIVILEGE_ID", "NAME", "PATTERN") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select privilege_id,name,pattern from user_ords_privilege_mappings uopma
where  1=1
and uopma.pattern not like '%metadata%'
and uopma.privilege_id not in (select priv_id from user_ords_client_privileges )
;

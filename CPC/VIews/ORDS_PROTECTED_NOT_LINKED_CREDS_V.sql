--------------------------------------------------------
--  DDL for View ORDS_PROTECTED_NOT_LINKED_CREDS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."ORDS_PROTECTED_NOT_LINKED_CREDS_V" ("TYPE", "OBJECT_ALIAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select oree.type 
,      oree.object_alias  
from ords_privs_not_linked_to_creds_v   opnlc 
,    ords_rest_enabled_entities_v       oree  
where 1=1
and opnlc.pattern like '/'||oree.object_alias||'%'
and oree.type ='Enabled Object'
;

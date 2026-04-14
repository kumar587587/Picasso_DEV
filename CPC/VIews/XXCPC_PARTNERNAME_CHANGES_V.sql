--------------------------------------------------------
--  DDL for View XXCPC_PARTNERNAME_CHANGES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXCPC_PARTNERNAME_CHANGES_V" ("ID", "PARTNERNAME", "UPDATED_OLD", "UPDATED") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select id,partnername,updated_old,updated 
from (
          SELECT DISTINCT a.iud,nvl(a.partnername_old,a.partnername) partnername ,nvl(partnername_old,partnername) partnername_old,id
          --,trunc(a.updated) updated
          ,nvl( a.updated,TO_DATE('01-01-4000','DD-MM-YYYY'))  updated  --17-09-2024
          --, nvl(trunc(a.updated_old)
          , nvl(a.updated_old ,TO_DATE('01-01-1900','DD-MM-YYYY')) updated_old   --17-09-2024
          FROM xxcpc_contentpartners_a a
          WHERE 1=1
          UNION
          /* To always have a record valid in the future*/
          SELECT a.iud, a.partnername partnername,partnername_old, a.id, a.updated+1000000, a.updated updated_old
          FROM xxcpc_contentpartners_a a
          WHERE 1=1
          AND a.audit_id = (
                           SELECT MAX(a2.audit_id) 
                           FROM xxcpc_contentpartners_a a2 
                           WHERE a2.id =a.id
                           ) 
)
;

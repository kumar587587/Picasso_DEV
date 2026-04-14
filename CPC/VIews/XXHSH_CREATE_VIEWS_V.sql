--------------------------------------------------------
--  DDL for View XXHSH_CREATE_VIEWS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CREATE_VIEWS_V" ("TABLE_NAME", "STM", "LAST_FIELD") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a.table_name,'create view '|| replace(max(a.table_name),'XXSPM','XXHSH')||' as '||
replace(
         'select '||max(d.pk_fields)||',''[''||concat('||listagg( q'^'"'||^'||a.column_name||q'^||'",'^',',concat(' ) WITHIN GROUP (ORDER BY a.column_Id)||substr(')))))))))))))))))))))',1,count(*)-1)||'||'']'' concatenated_values '
         || ' from '||max(a.table_name)||' order by '||max(d.pk_fields) ,'concat('|| q'^'"'||^'||max(last_field)||q'^||'",'^',q'^'"'||^'||max(last_field)|| q'^||'"'^' )  stm
, max(c.last_field) last_field
from all_tab_columns   a
,    ( 
   SELECT distinct b.table_name,
       LAST_VALUE(b.column_name) OVER (
           ORDER BY b.column_id
           RANGE BETWEEN UNBOUNDED PRECEDING AND 
                UNBOUNDED FOLLOWING
          )     last_field
   FROM  all_tab_columns b
   where 1=1
   and b.column_name not in ( 'LAST_UPDATE_OR_CREATION_DATE')
   )   c
   , xxcpc_tables d
where a.table_name = c.table_name  
and d.cpc_view_name = a.table_name
and a.column_name not in ( 'LAST_UPDATE_OR_CREATION_DATE')
group by a.table_name
;

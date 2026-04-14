--------------------------------------------------------
--  DDL for View XXPM_SYNCH_RESULTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_SYNCH_RESULTS_V" ("LABEL", "PERCENT", "SLICE_COLOR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with results as (
select trunc( (sum(incorrect) / count(*) ) *100) percent_incorrect, trunc(((count(*)-sum(incorrect)) /count(*))*100) percent_correct
from (
        select decode(pm_hash ,tv_hash  ,0,1)                                        incorrect
        from (
            select distinct seqnr                      seqnr
            ,      tv_name                             tv_name
            ,      pm_count                            pm_count
            ,      nvl(tv_count,0)                     tv_count
            ,      nvl(pm_count,0) - nvl(tv_count,0)   count_difs
            ,      pm_hash                             pm_hash 
            ,      tv_hash                             tv_hash
            ,      status                              status 
            ,      pm_hash_view_name                   pm_hash_view_name
            from xxpm_row_counts_v a
            ,    ( select replace(replace(replace( opname,'updating ',''),'insert into ',''),'delete from ','') xxtv_table_name      
                   ,      decode( time_remaining,0,null,'Running') status from v$session_longops a
                   where 1=1
                   and context = (select max(context) from v$session_longops b where b.opname = a.opname)
                   and time_remaining > 0
                 )  b
            where 1=1 
            --and spm_name like 'spPartner%'
            and  b.xxtv_table_name(+) = a.tv_name
            order by a.seqnr
            )
)  
)
select 'Incorrect' label , percent_incorrect percent, 'RED' slice_color --'#FF0000' slice_color
from results
union
select 'Correct' label , percent_correct     percent,'#00FF00' slice_color
from results
;

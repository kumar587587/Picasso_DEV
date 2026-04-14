--------------------------------------------------------
--  DDL for View XXCPC_SYNCH_RESULTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXCPC_SYNCH_RESULTS_V" ("LABEL", "PERCENT", "SLICE_COLOR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with results as (
select trunc( (sum(incorrect) / count(*) ) *100) percent_incorrect, trunc(((count(*)-sum(incorrect)) /count(*))*100) percent_correct
from (
        select decode(apex_hash,varicent_hash ,0,1)  incorrect
        from (
            select distinct seqnr,spm_name
            ,      apex_count
            ,      spm_count
            ,      apex_count-spm_count count_difs
            ,      apex_hash
            ,      varicent_hash   
            ,      status 
            ,      hash_view_name
            from xxcpc_row_counts_v a
            ,    ( select replace(replace(replace( opname,'updating ',''),'insert into ',''),'delete from ','') spm_table_name      
                   ,      decode( time_remaining,0,null,'Running') status from v$session_longops a
                   where 1=1
                   and context = (select max(context) from v$session_longops b where b.opname = a.opname)
                   and time_remaining > 0
                 )  b
            where 1=1 
            --and spm_name like 'spContentP%'
            --and spm_name = 'spCPCTieredCommissionRate'
            --and spm_name = 'spCPCManualPartnerInvoice'
            and  b.spm_table_name(+) = a.spm_name
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

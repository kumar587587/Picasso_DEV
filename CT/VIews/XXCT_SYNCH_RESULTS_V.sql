--------------------------------------------------------
--  DDL for View XXCT_SYNCH_RESULTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_SYNCH_RESULTS_V" ("LABEL", "PERCENT", "SLICE_COLOR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with results as (
select trunc( (sum(incorrect) / count(*) ) *100) percent_incorrect, trunc(((count(*)-sum(incorrect)) /count(*))*100) percent_correct
from (
        select spm_name
        ,      apex_count
        ,      spm_count
        ,      count_difs
        ,      decode(count_difs,0,'fa fa-check-circle', 'fa fa-times-circle') equal_count
        ,      decode(count_difs,0,'GREEN', 'RED') icon_color_count
        ,      apex_hash
        ,      varicent_hash
        ,      decode(apex_hash,varicent_hash,'fa fa-check-circle', 'fa fa-times-circle') equal
        ,      decode(apex_hash,varicent_hash,'GREEN', 'RED') icon_color
        ,      decode( status,'Running','Show Progress','Synchronize') AS info_link
        --,      decode( :P702_API_STATUS ,'N','is-disabled apex_disabled', decode(apex_hash,varicent_hash ,'is-disabled apex_disabled','') ) disable_button
        ,      decode(apex_hash,varicent_hash ,0,1)  incorrect
        ,      status
        ,      decode( status,'Running','Show differences','Show differences') AS show_differences
        ,      hash_view_name
        from (
            select distinct seqnr,spm_name
            ,      apex_count
            ,      spm_count
            ,      apex_count-spm_count count_difs
            ,      apex_hash
            ,      varicent_hash   
            ,      status 
            ,      hash_view_name
            from xxct_row_counts_v a
            ,    ( select replace(replace(replace( opname,'updating ',''),'insert into ',''),'delete from ','') spm_table_name      
                   ,      decode( time_remaining,0,null,'Running') status from v$session_longops a
                   where 1=1
                   and context = (select max(context) from v$session_longops b where b.opname = a.opname)
                   and time_remaining > 0
                 )  b
            where 1=1 
            --and spm_name like 'plPlanElement'
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

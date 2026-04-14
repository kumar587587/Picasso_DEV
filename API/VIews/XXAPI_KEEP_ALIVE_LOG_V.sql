--------------------------------------------------------
--  DDL for View XXAPI_KEEP_ALIVE_LOG_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_KEEP_ALIVE_LOG_V" ("SEQ_NR", "ROUTINE", "MESSAGE", "DURATION", "MINUTES_SINCE_PREVIOUS_RUN", "TIMESTAMP") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a.seq_nr
,      a.routine
,      a.message
,      duration
,      to_char( a.time_diff * 24 * 60,990.99) minutes_since_previous_run
,      substr( a.message,60) timestamp
from (
select seq_nr
,      routine
,      message
,      duration,to_char(timestamp,'HH24:MI:SS' )timestamp
,      to_char(  LAG(timestamp) OVER (ORDER BY timestamp),'HH24:MI:SS' ) AS prev_timestamp
,      ( timestamp - LAG(timestamp ) OVER (ORDER BY timestamp) )AS time_diff
from xxapi_debug
where 1=1
and ( message like '(end) du%'
or message like 'xxapi_keep_alive_loop_job has been stopped%' )
--and routine ='xxapi_keep_alive'
--and seq_nr > 41292011
--and routine not in ('..../api/user/tvRole' )
--and message like 'A new job has started'
--and routine ='stop_first_job'
--or message like 'A new version of xxapi_keep_alive_loop_job has started'
order by 1 desc
) a
;

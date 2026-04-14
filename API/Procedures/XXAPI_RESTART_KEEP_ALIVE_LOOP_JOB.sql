--------------------------------------------------------
--  DDL for Procedure XXAPI_RESTART_KEEP_ALIVE_LOOP_JOB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXAPI"."XXAPI_RESTART_KEEP_ALIVE_LOOP_JOB" 
AS
   c_routine_name VARCHAR2(100) := 'xxapi_restart_keep_alive_loop_job';
BEGIN
    wksp_xxapi.xxapi_gen_debug_pkg.debug( c_routine_name, '(start)' );
    --
    dbms_scheduler.stop_job('xxapi_keep_alive_loop_job',TRUE);
    dbms_session.sleep(10);
    wksp_xxapi.xxapi_gen_debug_pkg.debug( c_routine_name, 'xxapi_keep_alive_loop_job has been stopped' );
    --
    dbms_scheduler.create_job
    ( job_name    => 'xxapi_keep_alive_loop_job'
    , job_action  => 'begin wksp_xxapi.xxapi_gen_debug_pkg.debug( ''xxapi_keep_alive_loop_job'', ''xxapi_keep_alive_loop_job begins''); xxapi_keep_alive_loop(900);wksp_xxapi.xxapi_gen_debug_pkg.debug( ''xxapi_keep_alive_loop_job'', ''xxapi_keep_alive_loop_job ends'');end;'
    , job_type    => 'plsql_block'
    , enabled     => FALSE 
    , start_date  => systimestamp
    ) ;
    dbms_scheduler.set_attribute( 'xxapi_keep_alive_loop_job' , 'max_run_duration' , INTERVAL '2' hour);
    --
    COMMIT;
    wksp_xxapi.xxapi_gen_debug_pkg.debug( c_routine_name, 'A new version of xxapi_keep_alive_loop_job has started' );
    --dbms_scheduler.enable('xxapi_keep_alive_loop_restart_job');
    dbms_session.sleep(10);
    dbms_scheduler.enable('xxapi_keep_alive_loop_job');
    COMMIT;
    wksp_xxapi.xxapi_gen_debug_pkg.debug( c_routine_name, '(end)' );    
EXCEPTION
WHEN OTHERS THEN
   wksp_xxapi.xxapi_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||sqlerrm );    
   RAISE;
END;

/

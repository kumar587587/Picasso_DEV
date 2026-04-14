--------------------------------------------------------
--  DDL for Procedure XXAPI_KEEP_ALIVE_LOOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXAPI"."XXAPI_KEEP_ALIVE_LOOP" ( p_wait_seconds IN NUMBER)
IS
   c_routine_name     VARCHAR2(200)  :=  'xxapi_keep_alive_loop';
   l_count NUMBER :=0;
BEGIN
   xxapi_gen_debug_pkg.debug( c_routine_name, '(start)');
   WHILE TRUE LOOP
    l_count := l_count +1; 
    xxapi_gen_debug_pkg.debug( c_routine_name, 'l_count = '||l_count);
    xxapi_keep_alive;   
    dbms_session.sleep(p_wait_seconds);
    EXIT WHEN l_count > 1000;
   END LOOP;  
   xxapi_gen_debug_pkg.debug( c_routine_name, '(end)');
EXCEPTION
WHEN OTHERS THEN
   xxapi_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||sqlerrm);
   RAISE;
END;

/

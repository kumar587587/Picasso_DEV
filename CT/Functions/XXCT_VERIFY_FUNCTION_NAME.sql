--------------------------------------------------------
--  DDL for Function XXCT_VERIFY_FUNCTION_NAME
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_XXCT"."XXCT_VERIFY_FUNCTION_NAME" return boolean
is
   c_routine_name varchar2(200) := 'Azure Social Sign-In OpenID (App 501).xxct_verify_function_name';
   l_app_user     varchar2(200) := upper( v('APP_USER')) ;
   l_ruis_name    varchar2(200);
   l_count        number;
begin
   xxct_gen_debug_pkg.debug(c_routine_name ,'(start)');
   xxct_gen_debug_pkg.debug(c_routine_name ,'l_app_user = '||l_app_user );
   select ruis_name
   into l_ruis_name
   from xxct_users
   where upper(user_name) = l_app_user;
   xxct_gen_debug_pkg.debug(c_routine_name ,'l_ruis_name = '||l_ruis_name);

   select count(*)
   into l_count
   from all_scheduler_running_jobs
   where job_name = 'XXCT_GET_VARICENT_DATA_JOB_'||l_ruis_name
   ;

   if l_count = 0 then
       DBMS_SCHEDULER.CREATE_JOB
       ( job_name        => 'XXCT_GET_VARICENT_DATA_JOB_'||l_ruis_name
       , job_type        => 'PLSQL_BLOCK'
       , job_action      => 'BEGIN XXCT_GET_VARICENT_DATA('''||l_app_user||'''); END;'
       , start_date      => SYSTIMESTAMP
       , enabled         => TRUE
       );
   end if;
   xxct_gen_debug_pkg.debug( c_routine_name,'(end)');   
  return true;
end xxct_verify_function_name;

/

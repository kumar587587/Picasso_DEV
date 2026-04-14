--------------------------------------------------------
--  DDL for Package Body XXAPI_POST_CLONE_ACTIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_POST_CLONE_ACTIONS" 
AS
   /********************************************************************************************************************************
   *
   *
   * PROGRAM NAME
   *    XXAPI_POST_CLONE_ACTIONS
   *
   * DESCRIPTION
   *   Program contains steps to update non-prod environment in WKSP_XXAPI after the environment has been cloned.
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        26-09-2024  Initial Version
   *
   ******************************************************************************************************************************/

   -- $Id: XXAPI_POST_CLONE_ACTIONS.pkb,v 1.1 2024/10/17 08:32:46 bakke619 Exp $
   -- $Log: XXAPI_POST_CLONE_ACTIONS.pkb,v $
   -- Revision 1.1  2024/10/17 08:32:46  bakke619
   -- Initial revision
   --

   TYPE T_USERS             IS TABLE  OF VARCHAR2(2000)                INDEX BY BINARY_INTEGER;
   TYPE T_PASSWORDS         IS TABLE  OF VARCHAR2(2000)                INDEX BY VARCHAR2(2000);

   g_users            T_USERS;
   g_passwords        T_PASSWORDS;

   gc_package_body_version         CONSTANT VARCHAR2(200) := '$Id: XXAPI_POST_CLONE_ACTIONS.pkb,v 1.1 2024/10/17 08:32:46 bakke619 Exp $';
   gc_show_debug_start_end         CONSTANT BOOLEAN       := true;
   ---------------------------------------------------------------------------------------------
   -- Procedures to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2 ) IS
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN XXAPI_gen_debug_pkg.debug( gc_package_name||'.'||p_routine, rtrim(p_message));
             ELSE NULL;
         END CASE;
      ELSE
         XXAPI_gen_debug_pkg.debug( gc_package_name||'.'||p_routine, rtrim(p_message));
      END IF;
   END debug;      
   --
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_clob in clob ) IS
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN XXAPI_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine, rtrim(p_message) ,p_clob );
             ELSE NULL;
         END CASE;
      ELSE
         XXAPI_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine, rtrim(p_message), p_clob );
      END IF;
   END debug;
   --
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_blob in blob ) IS
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN XXAPI_gen_debug_pkg.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message) ,p_blob );
             ELSE NULL;
         END CASE;
      ELSE
         XXAPI_gen_debug_pkg.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message), p_blob );
      END IF;
   END debug;   

   ----------------------------------------------------------------------------
   -- Function to return the body version
   ----------------------------------------------------------------------------
   FUNCTION get_package_body_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN gc_package_body_version;
   END get_package_body_version;

   ----------------------------------------------------------------------------
   -- Function to return the spec version
   ----------------------------------------------------------------------------
   FUNCTION get_package_spec_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN gc_package_spec_version;
   END get_package_spec_version;

   -----------------------------------------------------------------------------
   -- Funtion return the lookup value from XXAPI_LOOKUP_VALUES
   -----------------------------------------------------------------------------
   FUNCTION get_lookup_value  ( p_lookup_type  IN VARCHAR2  DEFAULT 'GENERIC'  
                              , p_lookup_code  IN VARCHAR2                            ) RETURN VARCHAR2
   IS
      CURSOR c_lookups  ( b_lookup_type  IN VARCHAR2  
                        , b_lookup_code  IN VARCHAR2 ) IS  
         select meaning          lookup_value
         from   xxapi_lookup_values
         where  1=1
         and    upper(lookup_type) = upper(b_lookup_type)
         and    upper(lookup_code) = upper(b_lookup_code);

      l_meaning           XXAPI_LOOKUP_VALUES.MEANING%TYPE := 'NOT FOUND';
      lc_routine_name     VARCHAR (30)                    := 'get_lookup_value';

   BEGIN
      debug (lc_routine_name, ' Start.');
      FOR r_lookup in c_lookups ( p_lookup_type  , p_lookup_code)  LOOP

         l_meaning := r_lookup.lookup_value;

      END LOOP;
      debug (lc_routine_name, ' End.');

      RETURN l_meaning;

   END get_lookup_value;

   -----------------------------------------------------------------------------
   -- Funtion return the lookup value from XXAPI_LOOKUP_VALUES
   -----------------------------------------------------------------------------
   PROCEDURE set_lookup_value  ( p_lookup_type  IN VARCHAR2  DEFAULT 'GENERIC'                   
                               , p_lookup_code  IN VARCHAR2  
                               , p_lookup_value IN VARCHAR2  DEFAULT NULL )
   IS
      lc_routine_name     VARCHAR (30)                    := 'get_lookup_value';
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug (lc_routine_name, ' Start.');

         update xxapi_lookup_values
         set    meaning  = p_lookup_value
         where  1=1
         and    upper(lookup_type) = upper(p_lookup_type)
         and    upper(lookup_code) = upper(p_lookup_code);

         commit;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
   END set_lookup_value;   

   -------------------------------------------------------------------------
   -- Procedure to set the environment globals
   -------------------------------------------------------------------------
   PROCEDURE set_environment_globals
   IS
      lc_routine_name            VARCHAR2(50)      := 'set_environment_globals';
      l_instance                 VARCHAR2(240);
      l_postfix                  VARCHAR2(30)      := ' Environment';
      l_prefix                   VARCHAR2(30)      := ' - KPN Picasso ';
      E_PROD_ERROR               EXCEPTION;
   BEGIN
         CASE  when instr( sys_context('USERENV', 'DB_NAME') ,'APXDEV') > 0               THEN l_instance:= 'DEVELOPMENT';          g_database_name := 'APXDEV';
               when instr( sys_context('USERENV', 'DB_NAME') ,'APXACC') > 0               THEN l_instance:= 'ACCEPTANCE';           g_database_name := 'APXACC';
               when instr( sys_context('USERENV', 'DB_NAME') ,'APXTST') > 0               THEN l_instance:= 'TEST';                 g_database_name := 'APXTST';
               when instr( sys_context('USERENV', 'DB_NAME') ,gc_production_instance) > 0 THEN l_instance:= 'PRODUCTION';           g_database_name := gc_production_instance;
         ELSE 
               l_instance := substr (  sys_context('USERENV', 'DB_NAME')
                                    ,  coalesce(instr( sys_context('USERENV', 'DB_NAME') ,'_'),0)+1
                                    ,  length(sys_context('USERENV', 'DB_NAME'))
                                    ); 
               g_database_name := l_instance;
         END CASE; 

      g_environment_name       := l_instance;

      IF g_database_name = gc_production_instance THEN
         RAISE E_PROD_ERROR;
      END IF;

   EXCEPTION
      WHEN E_PROD_ERROR THEN
         debug (lc_routine_name ,'ERROR: Script cannot be executed on Production Instance: '||g_database_name);
         RAISE_APPLICATION_ERROR(-20000,'Script cannot be executed on Production Instance: '||g_database_name);
   END set_environment_globals;

   -----------------------------------------------------------------------------
   -- Prodedure to truncate tables
   -----------------------------------------------------------------------------
   PROCEDURE clear_table  ( p_table_name  IN VARCHAR2   )
   IS
      lc_routine_name     VARCHAR (30)                    := 'clear_table';
      l_statement         VARCHAR2(4000)                  := 'TRUNCATE TABLE ';
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug (lc_routine_name, ' Start.');

         l_statement         := l_statement || p_table_name; 
         EXECUTE IMMEDIATE l_statement;

         commit;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         debug (lc_routine_name ,    'Last call: '||l_statement);         
   END clear_table;   

   -----------------------------------------------------------------------------
   -- Prodedure to truncate debug table
   -----------------------------------------------------------------------------
   PROCEDURE clear_debug
   IS
      lc_routine_name     VARCHAR (30)                    := 'clear_debug';
   BEGIN
      debug (lc_routine_name, ' Start.');

      --clear_table  ( p_table_name  => 'XXAPI_DEBUG' )  ;
      delete from  XXAPI_DEBUG;

      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
   END clear_debug;   

   -----------------------------------------------------------------------------
   -- Prodedure to compile all invalid objects
   -----------------------------------------------------------------------------
   PROCEDURE compile_invalids IS 
      lc_routine_name     VARCHAR (30)                    := 'compile_invalids';
      l_statement         VARCHAR2(4000);
      CURSOR c_invalid IS 
         WITH statements AS ( SELECT 'alter trigger '  ||OWNER||'.'||object_name  ||' compile'      run_statement FROM ALL_OBJECTS WHERE status='INVALID' AND object_type ='TRIGGER'      and object_name like 'XX%' UNION ALL
                              SELECT 'alter procedure '||OWNER||'.'||object_name  ||' compile'      run_statement FROM ALL_OBJECTS WHERE status='INVALID' AND object_type ='PROCEDURE'    and object_name like 'XX%' UNION ALL
                              SELECT 'alter package '  ||OWNER||'.'||object_name  ||' compile body' run_statement FROM ALL_OBJECTS WHERE status='INVALID' AND object_type ='PACKAGE BODY' and object_name like 'XX%' UNION ALL
                              SELECT 'alter view '     ||OWNER||'.'||object_name  ||' compile'      run_statement FROM ALL_OBJECTS WHERE status='INVALID' AND object_type ='VIEW'         and object_name like 'XX%' UNION ALL
                              SELECT 'alter function ' ||OWNER||'.'||object_name  ||' compile'      run_statement FROM ALL_OBJECTS WHERE status='INVALID' AND object_type ='FUNCTION'     and object_name like 'XX%' 
                            )
         SELECT * FROM STATEMENTS;
   BEGIN
      debug (lc_routine_name, ' Start.');

      FOR r_invalid in c_invalid loop
         l_statement         := r_invalid.run_statement; 
         BEGIN         
            EXECUTE IMMEDIATE l_statement;
         EXCEPTION
            WHEN OTHERS THEN
               debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
               debug (lc_routine_name ,    'Last call: '||l_statement);               
         END;
      END LOOP;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         debug (lc_routine_name ,    'Last call: '||l_statement);
   END compile_invalids;   

   -----------------------------------------------------------------------------
   -- procedure to set the object sore lookup values
   -----------------------------------------------------------------------------
   PROCEDURE set_object_store_values 
   IS
      lc_routine_name     VARCHAR2(30)  := 'set_object_store_values';

      l_base_url          VARCHAR2(4000);

   BEGIN
      debug (lc_routine_name, ' Start.');

      -- set the object store values
      CASE g_database_name 
         WHEN 'APXDEV'                THEN l_base_url :=  'https://frjfgq8os8is.objectstorage.eu-frankfurt-1.oci.customer-oci.com/n/frjfgq8os8is/b/pm-np-bucket/o/dev/';
         WHEN 'APXACC'                THEN l_base_url :=  'https://frjfgq8os8is.objectstorage.eu-frankfurt-1.oci.customer-oci.com/n/frjfgq8os8is/b/pm-np-bucket/o/acc/';
         WHEN 'APXTST'                THEN l_base_url :=  'https://frjfgq8os8is.objectstorage.eu-frankfurt-1.oci.customer-oci.com/n/frjfgq8os8is/b/pm-np-bucket/o/tst/';
         WHEN gc_production_instance  THEN l_base_url :=  'https://frjfgq8os8is.objectstorage.eu-frankfurt-1.oci.customer-oci.com/n/frjfgq8os8is/b/pm-prd-bucket/o/prd/';
         ELSE l_base_url :=  'https://frjfgq8os8is.objectstorage.eu-frankfurt-1.oci.customer-oci.com/n/frjfgq8os8is/b/pm-np-bucket/o/dev/';
      END CASE;

      -- update the lookup value to N
      set_lookup_value( p_lookup_type  => 'OBJECT_STORE' 
                      , p_lookup_code  => 'BASE_URL'                  
                      , p_lookup_value => l_base_url
                      );

      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
   END set_object_store_values;   

   -------------------------------------------------------------------------
   -- Procedure to reset the @KPN.COM usernames and give random new password/
   -------------------------------------------------------------------------
   PROCEDURE reset_developer_passwords IS   
--      l_username   VARCHAR2(200)  := 'WILJO.BAKKER2@KPN.COM';
--      l_password   VARCHAR2(200)  := '' ;

      l_statement                        VARCHAR2(2000) := null;
      lc_routine_name   CONSTANT         VARCHAR2(50)   := 'reset_developer_passwords';
      CURSOR c_users IS 
         select upper(username) username
         from   all_users 
         where  1=1
         and    upper(username) like '%@KPN.COM';

      FUNCTION f_random ( p_length     in number   default 20 
                        , p_forbidden  in varchar2 default '`~^&*<>()-=_+/\{}''" ' ) RETURN VARCHAR2 
      IS 
      BEGIN
         RETURN TRANSLATE(dbms_random.string('p',p_length),p_forbidden,dbms_random.string('x',1));
      END f_random ;
   BEGIN
      debug (lc_routine_name , ' Start.'); 

      FOR r_users IN c_users LOOP
         g_users(g_users.count+1)      := r_users.username;
         g_passwords(r_users.username) :=  f_random;
         l_statement := 'ALTER USER '||g_users(g_users.count) ||' IDENTIFIED BY ' || g_passwords(g_users(g_users.count));
         --EXECUTE IMMEDIATE l_statement
      END LOOP;

      debug (lc_routine_name , ' End.');       
   EXCEPTION 
      WHEN OTHERS THEN
          debug (lc_routine_name ,'ERROR: updating APEX Passwords. '||SQLCODE||' - '||SQLERRM);
          RAISE; 
   END reset_developer_passwords;


   -----------------------------------------------------------------------------
   -- procedure to set xxapi_batches emailaddresses
   -----------------------------------------------------------------------------
   PROCEDURE set_batch_email 
   IS
      lc_routine_name     VARCHAR2(30)  := 'set_batch_email';

   BEGIN
      debug (lc_routine_name, ' Start.');

     UPDATE XXAPI_BATCHES
     SET BAH_EMAIL_ADDRESS            = gc_email_address_appl
     ,   BAH_EMAIL_ADDRESS_OUTPUT     = NULL
     ,   BAH_EMAIL_ADDRESS_CC         = NULL
     WHERE 1=1 
     AND (    BAH_EMAIL_ADDRESS           IS NOT NULL
          OR  BAH_EMAIL_ADDRESS_OUTPUT    IS NOT NULL
          OR  BAH_EMAIL_ADDRESS_CC        IS NOT NULL
         )
     ;

     debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
   END set_batch_email;   


   -----------------------------------------------------------------------------
   -- Procedure to update the environment for API
   -----------------------------------------------------------------------------
   PROCEDURE update_environment_api
   IS
      lc_routine_name     VARCHAR (30)                    := 'update_environment_api';
   BEGIN
      debug (lc_routine_name, ' Start.');

      -- 1 Set object store to correct location in lookups 
      set_object_store_values;

      -- 2 Reset passwordword for devops team
      reset_developer_passwords;

      -- 3 reset email addresses in batches
      set_batch_email;

      -- compile invalid objects
      compile_invalids;         

      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         RAISE;
   END update_environment_api;   

   -----------------------------------------------------------------------------
   -- Procedure to update the environment for CT 
   -----------------------------------------------------------------------------
   PROCEDURE update_environment_ct
   IS
      lc_routine_name     VARCHAR (30)                    := 'update_environment_ct';
   BEGIN
      debug (lc_routine_name, ' Start.');
      null;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         RAISE;
   END update_environment_ct;      

   -----------------------------------------------------------------------------
   -- Procedure to start or stop all the api's
   -----------------------------------------------------------------------------
   PROCEDURE toggle_all_api  ( p_action  in VARCHAR2 DEFAULT 'ON' ) 
   IS
      lc_routine_name     VARCHAR (30)                    := 'toggle_all_api '||p_action;
   BEGIN
      debug (lc_routine_name, ' Start.');

      case p_action when 'ON' then  
         CASE WHEN g_database_name in  ('APXDEV'                
                                       ,'APXACC'                
                                       ,'APXTST'                
                                       ,gc_production_instance) THEN        
               -- Turn on all API's
               wksp_xxpm.xxpm_post_clone_actions.activate_api;
               wksp_xxtv.xxtv_post_clone_actions.activate_api; 
               wksp_xxcpc.xxcpc_post_clone_actions.activate_api;   
         ELSE 
            --all others keep the API off.
            NULL;
         END CASE; 
      ELSE       
         -- Turn off all API's 
         wksp_xxpm.xxpm_post_clone_actions.deactivate_api;
         wksp_xxtv.xxtv_post_clone_actions.deactivate_api;
         wksp_xxcpc.xxcpc_post_clone_actions.deactivate_api;
      end case;

      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         RAISE;
   END toggle_all_api;      

   ----------------------------------------------------------------------------
   -- Main procedure to start all post-cloning actions for XXAPI
   ----------------------------------------------------------------------------
   PROCEDURE main
   IS
      lc_routine_name            VARCHAR2(50)      := 'main';
   BEGIN
      debug (lc_routine_name, ' Start.');

      -- initialize
      set_environment_globals;

      -- de-activate the API's 
      toggle_all_api ('OFF');

      -- run all actions in WKSP_XXAPI
      update_environment_api;

      -- run all actions in WKSP_XXPM
      wksp_xxpm.xxpm_post_clone_actions.update_environment;

      -- run all actions in WKSP_XXTV
      wksp_xxtv.xxtv_post_clone_actions.update_environment;

      -- run all actions in WKSP_XXCT
      update_environment_ct;

      -- run all actions in WKSP_XXCPC
      wksp_xxcpc.xxcpc_post_clone_actions.update_environment;

      -- activate the API's
      toggle_all_api ('ON');

      -- commit the changes
      commit;

      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
         rollback;
   END main;

   PROCEDURE run
   IS
      lc_routine_name            VARCHAR2(50)      := 'run';
   BEGIN
      -- clear data from the debug table
      wksp_xxapi.xxapi_post_clone_actions.clear_debug;
      wksp_xxtv.xxtv_post_clone_actions.clear_debug;
      wksp_xxpm.xxpm_post_clone_actions.clear_debug;
      wksp_xxcpc.xxcpc_post_clone_actions.clear_debug;
      main;
--   EXCEPTION
--      WHEN OTHERS THEN
----         debug (lc_routine_name ,    'ERROR: '||SQLCODE||' - '||SQLERRM);
--         rollback;
   END run;

END XXAPI_POST_CLONE_ACTIONS;

/

--------------------------------------------------------
--  DDL for Procedure XXCT_PROCESS_BACKLOG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCT"."XXCT_PROCESS_BACKLOG" 
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'xxct_process_backlog';          
      g_synchronize_job_active   BOOLEAN;
      l_count                NUMBER;
      l_row_id               NUMBER;
      l_api_active           VARCHAR2(1);
      l_delete               VARCHAR2(1); 
      l_schedule_list        VARCHAR2(30000);
      --
      CURSOR c_backlog IS      
         SELECT decode( instr( api_url,'scheduleitem'), 0,0,1) schedule_yes_no, u.*
         FROM xxct_unprocessed_records  u
         ORDER BY 1,id 
         ;
   BEGIN  
      --delete from xxct_debug where routine =  'XXCT_PROCESS_BACKLOG_JOB';
      --commit;
      xxct_gen_debug_pkg.debug( c_routine_name, '(start)' );
      --
      SELECT meaning 
      INTO l_api_active 
      FROM xxct_lookup_values 
      WHERE lookup_type ='API' 
      AND code ='VARICENT_API_ACTIVE';
      xxct_gen_debug_pkg.debug( c_routine_name, 'l_api_active = '||l_api_active );  
      --
      IF xxct_gen_rest_apis.g_varicent_api_active THEN
         xxct_gen_debug_pkg.debug( c_routine_name, 'g_varicent_api_active = TRUE' );  
      ELSE   
         xxct_gen_debug_pkg.debug( c_routine_name, 'g_varicent_api_active = FALSE' );  
      END IF
      ;
      -- In order to use the xxct_gen_rest_api routines we need the api to be active.
      xxct_gen_rest_apis.g_varicent_api_active := TRUE;
      xxct_synchronize_api.g_processing_backlog_job_active := TRUE;
      --
      SELECT COUNT(*) 
      INTO l_count 
      FROM xxct_unprocessed_records;
      xxct_gen_debug_pkg.debug( c_routine_name, 'number or records in unprocessed_records table = '||l_count );  
      --
      WHILE l_count > 0 LOOP
        xxct_gen_debug_pkg.debug( c_routine_name, 'outer-loop: there are still records in the unprocessed_records table  l_count = '||l_count);  
        l_delete := 'N';
        FOR r_row IN c_backlog LOOP
            xxct_gen_debug_pkg.debug( c_routine_name, 'inner-loop: start r_row.id = '||r_row.id);  
            l_row_id   := r_row.id;
            -- If the api is not in the current schedule list, then it can be exected
            IF instr(  nvl( l_schedule_list,'not set yet') , r_row.api_url ) = 0 THEN
               xxct_gen_debug_pkg.debug( c_routine_name, 'inner-loop: executing '||r_row.api_url);  
               xxct_gen_rest_apis.make_request
                   ( p_url          => r_row.api_url
                   , p_action       => r_row.api_method
                   , p_body         => r_row.api_body
                   , p_set_2_delete => l_delete  
                   );
               xxct_gen_debug_pkg.debug( c_routine_name, 'inner-loop: returned value for l_delete = '|| l_delete);  
            ELSE
               xxct_gen_debug_pkg.debug( c_routine_name, 'inner-loop: skipping this schedule api: '||r_row.api_url);  
               -- If the api_url is in the list, it has already been executed in this session.
               -- We do not want to reexceute schedules.
               l_delete := 'Y';
            END IF;
            --
            IF l_delete = 'Y'  THEN
               xxct_gen_debug_pkg.debug( c_routine_name , 'inner-loop: this record can be deleted.' );
            END IF;
            --
            IF l_delete = 'Y' and r_row.schedule_yes_no = 1 THEN
               xxct_gen_debug_pkg.debug( c_routine_name , 'inner-loop: 2' );
               IF instr( nvl( l_schedule_list,'not set yet') , r_row.api_url ) = 0 THEN
                  xxct_gen_debug_pkg.debug( c_routine_name , 'inner-loop: 3' );
                  l_schedule_list := l_schedule_list||'|'||r_row.api_url;
                  xxct_gen_debug_pkg.debug( c_routine_name , 'inner-loop: 4' );
               END IF;
            END IF;
            xxct_gen_debug_pkg.debug( c_routine_name , 'inner-loop: last line of inner-loop. ' );                                          
            EXIT; -- Always execute this loop, one row at a time.
        END LOOP;
        IF l_delete = 'Y'  THEN
        xxct_gen_debug_pkg.debug( c_routine_name , 'outer-loop: 5' );
           DELETE FROM xxct_unprocessed_records WHERE id = l_row_id; 
           xxct_gen_debug_pkg.debug( c_routine_name , 'outer-loop: number of unprocessed_records deleted: '||SQL%rowcount );
           COMMIT;
        ELSE
           xxct_gen_debug_pkg.debug( c_routine_name , 'outer-loop: record can not be deleted yet (FGA). Sleeping 10 seconds.' );
           dbms_session.sleep(10);
        END IF;   
        SELECT COUNT(*) 
        INTO l_count 
        FROM xxct_unprocessed_records;
        xxct_gen_debug_pkg.debug( c_routine_name, 'Current unprocessed record count = '||l_count );  
     END LOOP;      
     xxct_gen_debug_pkg.debug( c_routine_name, 'Outside outerloop' );  
     --
     UPDATE xxct_lookup_values
     SET meaning = 'Y'
     WHERE lookup_type ='API'
     AND code ='VARICENT_API_ACTIVE';
     COMMIT;
     --
     xxct_gen_rest_apis.g_varicent_api_active := FALSE;
     g_synchronize_job_active := FALSE;
     xxct_synchronize_api.g_processing_backlog_job_active := FALSE;

     xxct_gen_debug_pkg.debug( c_routine_name, '(end)');    
   EXCEPTION
   WHEN OTHERS THEN
       xxct_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||sqlerrm );    
       g_synchronize_job_active := FALSE;
       xxct_synchronize_api.g_processing_backlog_job_active := FALSE;
       IF sqlerrm = 'ORA-20000: Cannot add unprocessed records twice' THEN 
          NULL;
       ELSE
          RAISE;
       END IF;   
   END xxct_process_backlog;



/

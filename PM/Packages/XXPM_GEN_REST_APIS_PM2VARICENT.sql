--------------------------------------------------------
--  DDL for Package XXPM_GEN_REST_APIS_PM2VARICENT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_GEN_REST_APIS_PM2VARICENT" 
IS
  /****************************************************************
   *
   * PROGRAM NAME
   *  XXPM_GEN_REST_APIS_PM2VARICENT
   *
   * DESCRIPTION
   * Package to support REST-APIS
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Rabindra         26-09-2025     Initial Version
   **************************************************************/
   gc_package_name            CONSTANT    VARCHAR(50) := 'XXPM_GEN_REST_APIS_PM2VARICENT';   
   gc_varicent_date_format    CONSTANT    VARCHAR(50) := 'YYYY-MM-DD';   
   --gc_varicent_url            CONSTANT    VARCHAR(200) := 'https://g1cb1b3dd717dd7-apx###.adb.eu-frankfurt-1.oraclecloudapps.com/ords/tv/';
   g_iso_codes                XXPM_iso_country_table; 
   g_open_period              VARCHAR2(15);
   g_varicent_api_active      BOOLEAN        := FALSE;
   g_varicent_bearer_token    VARCHAR2(200)  ;   
   g_model                    VARCHAR2(200)  ;
   --    
   ---------------------------------------------------------------------------------------------   
   -- Procedure to start SPM import schedule   
   ---------------------------------------------------------------------------------------------        
   FUNCTION run_scheduler_by_id ( p_schedule_id IN NUMBER )  
   RETURN NUMBER;

   PROCEDURE run_scheduler_by_name ( p_schedule_name IN VARCHAR2, p_parent_folder IN VARCHAR2 );
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get list off all schedules.   
   ---------------------------------------------------------------------------------------------        
   FUNCTION get_all_schedulers      
   RETURN CLOB;
   ---------------------------------------------------------------------------------------------   
   -- Function to get all columns of a specific varicent table.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_table_columns (p_table_name IN VARCHAR2 )    
   RETURN CLOB;      
   ---------------------------------------------------------------------------------------------   
   -- Function to    
   ---------------------------------------------------------------------------------------------           
   FUNCTION get_column_value ( p_clob IN CLOB, p_column_name IN VARCHAR2 )     
   RETURN VARCHAR2;   
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to insert a new row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE insert_row  
   ( p_table_name      IN VARCHAR2 
   , p_key_values      IN VARCHAR2
   --, p_apex_id         IN VARCHAR2
   , p_new_values      IN VARCHAR2  
   , p_effective_date  IN DATE    --DEFAULT NULL
   , p_overwrite       IN BOOLEAN --DEFAULT FALSE
   )  
   ;  
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to delete a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE delete_row  
   ( p_table_name   IN VARCHAR2  
   , p_key_values   IN VARCHAR2
   --, p_apex_id      IN VARCHAR2
   , p_old_values   IN VARCHAR2  
   )  
   ;  
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to update a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE update_row  
   ( p_table_name     IN VARCHAR2  
   , p_key_values      IN VARCHAR2
   , p_apex_id         IN VARCHAR2   
   , p_new_values     IN VARCHAR2  
   , p_old_values     IN VARCHAR2  
   , p_old_rowid      IN ROWID
   , p_effective_date IN DATE DEFAULT NULL
   , p_overwrite      IN BOOLEAN DEFAULT FALSE
   )  
   ;  
   --  
      --      
   ---------------------------------------------------------------------------------------------  
   -- Function to see if a row already exists in Varicent  
   ---------------------------------------------------------------------------------------------    
   FUNCTION does_row_with_pk_exist (p_table_name IN VARCHAR2, p_column_names IN VARCHAR2, p_filter IN VARCHAR2, p_mode   IN VARCHAR2 )    
   RETURN BOOLEAN ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to return the number of records in a Varicent table
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_table_count ( p_table_name IN VARCHAR2 )
   RETURN NUMBER;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to get a specific value from a varicent table.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_table_data
   ( p_table_name       IN VARCHAR2
   , p_column_names     IN VARCHAR2
   , p_filter           IN VARCHAR2
   , p_offset           IN NUMBER
   , p_multi_row_filter IN VARCHAR2
   )    
   RETURN CLOB;
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_request 
   ( p_url     IN VARCHAR2
   , p_http_method  IN VARCHAR2
   , p_body    IN CLOB
   )
   RETURN CLOB;
   --      
   FUNCTION inspect_response    
   ( p_clob     IN   CLOB )  
   RETURN VARCHAR2  
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to get all columns of a specific varicent table.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_api_value (p_code IN VARCHAR2 )    
   RETURN CLOB  
   ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to wait until no global action is running.
   ---------------------------------------------------------------------------------------------     
   FUNCTION no_global_action_active
   RETURN BOOLEAN
   ;
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_actual_old_values
   ( p_table_name      IN VARCHAR2
   , p_new_values      IN VARCHAR2 
   , p_old_rowid       IN ROWID
   , p_payeeid         IN VARCHAR2
   )
   RETURN VARCHAR2;   
   ---------------------------------------------------------------------------------------------  
   -- Procedure to insert or delete a new row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE delete_effective_row  
   ( p_table_name       IN VARCHAR2  
   , p_values           IN VARCHAR2  
   , p_effective_date   IN DATE DEFAULT NULL
   , p_overwrite        IN BOOLEAN DEFAULT FALSE
   ) ;    
   --
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to update a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE delete_row_version  
   ( p_table_name     IN VARCHAR2
   , p_key_values     IN VARCHAR2
   , p_value_for_deletion     IN VARCHAR2  
   )  
   ;
   --
   PROCEDURE make_request
   ( p_url     IN VARCHAR2
   , p_action  IN VARCHAR2
   , p_body    IN CLOB
   )
   ;
   --
   ---------------------------------------------------------------------------------------------  
   -- Procedure to 
   ---------------------------------------------------------------------------------------------           
   FUNCTION make_request
   ( p_url     IN VARCHAR2
   , p_action  IN VARCHAR2
   , p_body    IN CLOB
   )
   RETURN CLOB;
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION count_records_in_varicent
   ( p_varicenttablename      IN VARCHAR2 
   , p_filter                 IN VARCHAR2
   )
   RETURN NUMBER
   ;
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION who_is_running_global_action
   RETURN VARCHAR2
   ;
END XXPM_GEN_REST_APIS_PM2VARICENT;

/

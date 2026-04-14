--------------------------------------------------------
--  DDL for Package XXCPC_GEN_REST_APIS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_GEN_REST_APIS" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_GEN_REST_APIS       
   *       
   * DESCRIPTION       
   * Package to support REST-APIS   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name            CONSTANT    VARCHAR(50) := 'XXCPC_GEN_REST_APIS';   
   gc_varicent_date_format    CONSTANT    VARCHAR(50) := 'YYYY-MM-DD';   
   gc_varicent_url            CONSTANT    VARCHAR(200) := 'https://g1cb1b3dd717dd7-apx###.adb.eu-frankfurt-1.oraclecloudapps.com/ords/tv/';
   g_iso_codes                xxcpc_iso_country_table; 
   g_open_period              VARCHAR2(15);
   g_varicent_api_active      BOOLEAN        := FALSE;
   g_varicent_bearer_token   VARCHAR2(200)  ;   
   g_model                   VARCHAR2(200)  ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_number_of_calls 
   RETURN NUMBER;   
   --
   ---------------------------------------------------------------------------------------------   
   FUNCTION escape ( p_text IN VARCHAR2 )
   RETURN VARCHAR2;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to start SPM import schedule   
   ---------------------------------------------------------------------------------------------        
   FUNCTION run_scheduler_by_id ( p_schedule_id IN NUMBER )  
   RETURN NUMBER
   ;   
   PROCEDURE run_scheduler_by_name ( p_schedule_name IN VARCHAR2, p_parent_folder in VARCHAR2 )      
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get list off all schedules.   
   ---------------------------------------------------------------------------------------------        
   FUNCTION get_all_schedulers      
   RETURN CLOB
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to get all columns of a specific varicent table.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_table_columns (p_table_name IN VARCHAR2 )    
   RETURN CLOB  
   ;      
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to    
   ---------------------------------------------------------------------------------------------            
--   PROCEDURE json2text (p_clob IN CLOB )       
--   ;   
   --       
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
   FUNCTION does_row_with_pk_exist 
   ( p_table_name   IN VARCHAR2
   , p_column_names IN VARCHAR2
   , p_filter       IN VARCHAR2
   , p_mode         IN VARCHAR2 )    
   RETURN BOOLEAN  
   ;  
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to set the global contractnr  
   ---------------------------------------------------------------------------------------------    
--   PROCEDURE set_contractnr ( p_contractnr IN VARCHAR2)  
--   ;  
--   --      
--   ---------------------------------------------------------------------------------------------  
--   -- Function to return the contractnr from global memory.  
--   ---------------------------------------------------------------------------------------------    
--   FUNCTION get_contractnr  
--   RETURN VARCHAR2  
--   ;    
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to wait until no global action is running.
   ---------------------------------------------------------------------------------------------     
--   PROCEDURE wait_for_end_global_action
--   ;
   --       
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
   RETURN CLOB   
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to get a specific value from a varicent table.   
      ---------------------------------------------------------------------------------------------     
   FUNCTION get_all_table_data 
   ( p_table_name   IN VARCHAR2
   )    
   RETURN CLOB
   ;
   --
   PROCEDURE register_last_counts
   ;
   --    
--   ---------------------------------------------------------------------------------------------
--   -- Function to get all iso codes from api
--   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_iso_country_codes 
--   RETURN xxcpc_iso_country_table
--   ;    
   -------------------------------------------------------------------------------------------   
   -- Procedure to get EU VAT numbers
   -------------------------------------------------------------------------------------------     
   FUNCTION get_eu_vat_number 
   ( p_country    IN VARCHAR2
   , p_vat_number IN VARCHAR2
   )
   RETURN XXCPC_VAT_TABLE
   ;

   -------------------------------------------------------------------------------------------   
   -- Procedure to get GB VAT numbers
   -------------------------------------------------------------------------------------------     
   FUNCTION get_gb_vat_number 
   ( p_country    IN VARCHAR2
   , p_vat_number IN VARCHAR2
   )
   RETURN XXCPC_VAT_TABLE
   ;   

   -------------------------------------------------------------------------------------------   
   -- Procedure to get EU VAT numbers
   -------------------------------------------------------------------------------------------     
   FUNCTION get_vat_field_value
   ( p_country    IN VARCHAR2
   , p_vat_number IN VARCHAR2
   , p_field      IN VARCHAR2
   )
   RETURN varchar2
   ;
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
   ---------------------------------------------------------------------------------------------  
   -- Procedure to   
   ---------------------------------------------------------------------------------------------           
--   FUNCTION get_keys
--   (  p_value IN CLOB
--   ) 
--   return XXCPC_vat_table
--   ;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to check IBAN number
   ---------------------------------------------------------------------------------------------     
   --FUNCTION check_iban_number 
   --(  p_iban_number IN VARCHAR2
   --) 
   --return varchar2
  -- ;
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to insert or delete a new row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
--   PROCEDURE insert_date  
--   (
--   p_date           IN DATE
--   ) ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------       
--   PROCEDURE update_all_varicent_dates;
   --
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
--   FUNCTION reformat_number
--   ( p_number   in varchar2 )
--   RETURN VARCHAR2
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_end_date_comp_period
--   RETURN date
--   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to return the number of records in a Varicent table
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_active_workflow_rec_count 
   ( p_period in date )
   RETURN NUMBER
   ;
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
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_comp_period
--   RETURN varchar2
--   ;
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE change_app_accessibility  
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
--   PROCEDURE activate_app  
--   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to wait until no global action is running.
   ---------------------------------------------------------------------------------------------     
   FUNCTION no_global_action_active
   RETURN BOOLEAN
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to set the open period
   ---------------------------------------------------------------------------------------------  
--   PROCEDURE set_open_period ( p_period in varchar2 )
--   ;
--   FUNCTION get_open_period
--   RETURN varchar2
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
--   FUNCTION amount2canonical
--   ( p_amount in number )
--   RETURN VARCHAR2
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_locked_period
--   RETURN varchar2
--   DETERMINISTIC
--   ;
--    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
--   PROCEDURE set_varicent_period
--   ( p_period_table_name  in varchar2
--   , p_body               in varchar2
--   )
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
--   PROCEDURE lock_unlock_calendar
--   ( p_calendar  in varchar2
--   , p_body      in varchar2
--   )
--   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
--   PROCEDURE generic_request   
--   ( p_url     in varchar2
--   , p_method  in varchar2
--   , p_body    in varchar2
--   )
--   ; 
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to 
   ---------------------------------------------------------------------------------------------     
--   FUNCTION generic_request   
--   ( p_url     in varchar2
--   , p_method  in varchar2
--   , p_body    in varchar2
--   )
--   RETURN clob
--   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get 
   ---------------------------------------------------------------------------------------------     
--   FUNCTION get_calendar_info
----   ( p_country    IN VARCHAR2
----   , p_vat_number IN VARCHAR2
----   )
--   RETURN varchar2
--   DETERMINISTIC
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_actual_old_values
   ( p_table_name      IN VARCHAR2
   , p_new_values      IN VARCHAR2 
   , p_old_rowid       IN ROWID
   , p_payeeid         IN VARCHAR2
   )
   RETURN VARCHAR2
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_access_token
--   RETURN VARCHAR2
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_table_colums
   ( p_table_name         IN VARCHAR2
   )
   RETURN xxcpc_columns
   DETERMINISTIC
   ;
   --      
--   PROCEDURE store_records_to_be_processed  
--   ( p_table_name      in varchar2
--   , p_col_list        in varchar2
--   , p_old_values      in varchar2
--   , p_id              in varchar2
--   , p_iud             in varchar2
--   )
--   ;
   --      
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
   RETURN CLOB
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION createTempFile  
   ( p_file_name   IN VARCHAR2
   , p_file_size   IN VARCHAR2
   , p_chunk_size  IN VARCHAR2
   )
   RETURN CLOB
   ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION upload_file2varicent 
   ( p_file_id         IN VARCHAR2
   , p_tmp_file_name   IN VARCHAR2
   , p_data            IN CLOB
   )
   RETURN CLOB   
   ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION upload_file2varicent_zbh
   ( p_file_name       IN VARCHAR2
   )
   RETURN CLOB
   ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION upload_file2varicent_other
   ( p_file_name       IN VARCHAR2
   )
   RETURN CLOB
   ;
   ---------------------------------------------------------------------------------------------   
   -- Procedure to start SPM import schedule   
   ---------------------------------------------------------------------------------------------     
   FUNCTION getEffectiveDateRows
   ( p_spm_table_name  IN VARCHAR2
   , p_filter          IN VARCHAR2
   )
   RETURN CLOB
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   PROCEDURE generic_request   
   ( p_url     in varchar2
   , p_method  in varchar2
   , p_body    in varchar2
   )
   ; 
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION generic_request   
   ( p_url     in varchar2
   , p_method  in varchar2
   , p_body    in varchar2
   )
   RETURN clob
   ;   
   PROCEDURE set_open_period ( p_period in varchar2 )
   ;
   FUNCTION get_open_period
   RETURN varchar2
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_comp_period
   RETURN varchar2
   ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE activate_app  
   ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_locked_period
   RETURN varchar2
   DETERMINISTIC   
   ;   
   PROCEDURE set_varicent_period
   ( p_period_table_name  in varchar2
   , p_body               in varchar2
   )
   ;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
   PROCEDURE lock_unlock_calendar
   ( p_calendar  in varchar2
   , p_body      in varchar2
   )
   ;   
   PROCEDURE wait_for_end_global_action;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION reformat_number
   ( p_number   in varchar2 )
   RETURN VARCHAR2
   ;
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to set the global contractnr  
   ---------------------------------------------------------------------------------------------    
   PROCEDURE set_contractnr ( p_contractnr IN VARCHAR2)  
   ;
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to insert or delete a new row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE insert_date  
   (
   p_date           IN DATE
   )  ;   
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to return the contractnr from global memory.  
   ---------------------------------------------------------------------------------------------    
   FUNCTION get_contractnr  
   RETURN VARCHAR2  
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION amount2canonical
   ( p_amount in number )
   RETURN VARCHAR2
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get the end date comp period from Varicent
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_end_date_comp_period
   RETURN date
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get 
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_calendar_info
   RETURN varchar2
   DETERMINISTIC
   ;
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION who_is_running_global_action
   RETURN VARCHAR2
   ;   
END XXCPC_GEN_REST_APIS;

/

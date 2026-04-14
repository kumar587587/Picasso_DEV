--------------------------------------------------------
--  DDL for Package XXCT_SYNCHRONIZE_API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_SYNCHRONIZE_API" 
IS        
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCT_SYNCHRONIZE_API       
   *       
   * DESCRIPTION       
   * Package synchronize data with Varicent.   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/     
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCT_SYNCHRONIZE_API';
   g_processing_backlog_job_active  boolean := false;
   TYPE t_array IS TABLE OF NUMBER INDEX BY VARCHAR2(255);
   TYPE value_t IS TABLE OF VARCHAR2(2000);
   g_arr_rindex t_array;
   g_arr_slno   t_array;
   g_arr_total  t_array;   
   g_finished   NUMBER; 
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to escape values
   ---------------------------------------------------------------------------------------------  
--   FUNCTION esv ( p_value IN VARCHAR2 )
--   RETURN VARCHAR2
--   ;
--   --   
--   ---------------------------------------------------------------------------------------------   
--   -- Procedure that calls the main procedure for all records in XXPM_tables.   
--   ---------------------------------------------------------------------------------------------         
----   PROCEDURE synchronize_all      
----   ;
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Procedure to insert or update payee
--   ---------------------------------------------------------------------------------------------         
--   PROCEDURE handle_payee
--   ( p_partnernr   IN VARCHAR2
--   --
--   , p_partnername_new        IN VARCHAR2
--   , p_language_new           IN VARCHAR2
--   , p_cpcode_new             IN VARCHAR2
--   , p_holdpayment_new        IN VARCHAR2
--   , p_email_new              IN VARCHAR2
--   , p_apex_id                IN NUMBER
--   );   
--   ---------------------------------------------------------------------------------------------
--   -- Function to escape values for body 
--   ---------------------------------------------------------------------------------------------  
--   FUNCTION esvb ( p_value IN VARCHAR2 )
--   RETURN VARCHAR2
--   ;
--   FUNCTION get_run_id
--   RETURN NUMBER;  
--   --
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Function to 
--   ---------------------------------------------------------------------------------------------  
--   FUNCTION get_update_pk_filter
--   ( p_number_of_pk_fields   IN NUMBER
--   , p_key_fields            IN VARCHAR2
--   , p_array                 dbms_utility.lname_array
--   , p_all_pm_values_i     VARCHAR2
--   )
--   RETURN VARCHAR2;
--   --
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Procedure to 
--   ---------------------------------------------------------------------------------------------         
--   FUNCTION create_select_pk_clause 
--   ( p_pm_table          IN     VARCHAR2
--   , p_key_fields         IN     VARCHAR2
--   )
--   RETURN VARCHAR2
--   ;
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Procedure to 
--   ---------------------------------------------------------------------------------------------         
--   FUNCTION create_select_spm_clause 
--   ( p_pm_table       IN     VARCHAR2
--   , p_key_fields      IN     VARCHAR2
--   )
--   RETURN VARCHAR2
--   ;
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Function to 
--   ---------------------------------------------------------------------------------------------  
   FUNCTION hash_value ( p_table_name IN VARCHAR2 )
   RETURN RAW
   ;
--   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_hash_on_varicent_table ( p_spm_table_name  IN VARCHAR2 )
   RETURN RAW;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION bubbel_sort ( p_input_array    IN  xxct_array_varchar_type)
   RETURN xxct_array_varchar_type;
--   --
--   PROCEDURE show_hash_diffs ( p_spm_table_name IN VARCHAR2 );
--   --
--   --PROCEDURE update_spm 
--   --( p_pm__table   IN VARCHAR2
--   --, p_key_fields  IN VARCHAR2
--   --, p_spm_table   IN VARCHAR2
--   --, p_last_run    IN VARCHAR2
--   --, p_record_count in NUmber
--   --, p_context      in number
--   --) ;  
--   --
--   --   
   ---------------------------------------------------------------------------------------------   
   -- Procedure that calls the main procedure for all records in XXPM_tables.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE synchronize( p_spm_table_name IN VARCHAR2, p_pm_number_of_records IN NUMBER, p_context IN NUMBER , p_pm_hash IN VARCHAR2, p_spm_number_of_rows in NUMBER , p_apex_id in number )          
   ;
--   --    
--   ---------------------------------------------------------------------------------------------
--   -- Procedure to log synchronization actions
--   ---------------------------------------------------------------------------------------------         
--   PROCEDURE update_long_operation (p_operation_name IN VARCHAR2, p_status IN NUMBER, p_operation_count IN NUMBER )
--   ;
--   --
--   FUNCTION set_finished_flag ( p_sum IN NUMBER)
--   RETURN NUMBER
--   ;
--   PROCEDURE reset_finish_flag
--   ;
   PROCEDURE create_and_run_job
   ( p_table_name        IN VARCHAR2
   , p_number_of_records IN NUMBER
   , p_context           IN NUMBER
   , p_pm_hash          IN VARCHAR2
   , p_spm_number_of_records in NUMBER   
   );   
--   FUNCTION get_finished_flag 
--   RETURN NUMBER   
--   ;
--   PROCEDURE init_long_operation (p_operation_name IN VARCHAR2, p_rows_to_process IN NUMBER, p_context IN NUMBER );
--   PROCEDURE insert_row
--   ( p_spm_table   IN VARCHAR2
--   , p_all_values  IN VARCHAR2
--   , p_apex_id     IN NUMBER
--   );
--   PROCEDURE get_values  
--   ( p_number_of_pk_fields     IN NUMBER
--   , p_pk_query                IN VARCHAR2  
--   , p_value1                  IN OUT value_t
--   , p_value2                  IN OUT value_t
--   , p_value3                  IN OUT value_t
--   , p_value4                  IN OUT value_t
--   , p_value5                  IN OUT value_t
--   );
--   --
--   FUNCTION get_number_of_pk_fields
--   ( p_key_fields IN VARCHAR2  ) 
--   RETURN number;  
--   --
--   PROCEDURE log_synch_action (p_crud IN VARCHAR2, p_description IN VARCHAR2  );   
--   --
--   PROCEDURE create_select_individ_fields 
--   ( p_pm_table       IN     VARCHAR2
--   , p_key_fields      IN     VARCHAR2
--   , p_select_pk_fields   IN OUT VARCHAR2
--   , p_spm_all_fields      IN OUT VARCHAR2
--   , p_pm_all_fields      IN OUT VARCHAR2
--   );   
--   PROCEDURE get_where_and_filter  
--   ( p_number_of_pk_fields   IN NUMBER
--   , p_filter                IN OUT VARCHAR2
--   , p_where                 IN OUT VARCHAR2
--   , p_array                 IN dbms_utility.lname_array
--   , p_key_fields            IN VARCHAR2  
--   , p_value1                IN VARCHAR2
--   , p_value2                IN VARCHAR2
--   , p_value3                IN VARCHAR2
--   , p_value4                IN VARCHAR2
--   , p_value5                IN VARCHAR2
--   ); 
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_apex_content ( p_table_name IN VARCHAR2 )
   RETURN CLOB
   ;
   --  
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
   --PROCEDURE process_backlog  
   --;
END XXCT_SYNCHRONIZE_API;

/

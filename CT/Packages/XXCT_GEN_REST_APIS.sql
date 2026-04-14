--------------------------------------------------------
--  DDL for Package XXCT_GEN_REST_APIS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_GEN_REST_APIS" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXPM_GEN_REST_APIS       
   *       
   * DESCRIPTION       
   * Package to support REST-APIS   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   --gc_pm_url                  CONSTANT    VARCHAR(200) := 'https://g1cb1b3dd717dd7-apx###.adb.eu-frankfurt-1.oraclecloudapps.com/ords/pm';
   gc_package_name            CONSTANT    VARCHAR(50)  := 'XXCT_GEN_REST_APIS';   
   g_varicent_url                         VARCHAR2(200)  ;      
   g_varicent_api_active                  BOOLEAN        := TRUE;
   g_varicent_bearer_token                VARCHAR2(200)  ;   
   g_model                                VARCHAR2(200)  ;
   g_count_calls             NUMBER         :=0;
   g_count_calls_total       NUMBER         :=0;
   g_start_first_call        DATE           := NULL;
   g_run_id                  NUMBER;


   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_request 
   ( p_url          IN VARCHAR2
   , p_http_method  IN VARCHAR2
   , p_body         IN CLOB
   )
   RETURN CLOB;
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_request 
   ( p_url          IN VARCHAR2
   , p_http_method  IN VARCHAR2
   , p_body         IN CLOB
   , p_set_2_delete IN OUT CLOB
   )
   RETURN CLOB;
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
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
--   PROCEDURE generic_apex_request   
--   ( p_url     in varchar2
--   , p_method  in varchar2
--   , p_body    in varchar2
--   )
--   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_access_token
   RETURN VARCHAR2
   ;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to 
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_partners
   RETURN xxct_partner_table_type PIPELINED
   deterministic
   ;
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
   -- Procedure to insert a new row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE run_scheduler_by_name ( p_schedule_name IN VARCHAR2, p_parent_folder in VARCHAR2 )      
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
   -- Function to get all columns of a specific varicent table.   
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
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_workflowdetails
   RETURN xxct_wf_details_table_type PIPELINED
   DETERMINISTIC
   ;
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to wait until no global action is running.
   ---------------------------------------------------------------------------------------------     
   FUNCTION no_global_action_active
   RETURN BOOLEAN
   ;
   --      
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION who_is_running_global_action
   RETURN VARCHAR2
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_spCTWFLevels
   RETURN xxct_spCTWFLevels_table_type PIPELINED
   DETERMINISTIC
   ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_spUserRole
   RETURN xxct_spUserRole_table_type PIPELINED
   DETERMINISTIC
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_plIAMRole
   RETURN xxct_plIAMRole_table_type PIPELINED
   DETERMINISTIC
   ;
   --
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_CTActiveUsersWF
   RETURN xxct_CTActiveUsersWF_table_type PIPELINED
   DETERMINISTIC
   ;
   FUNCTION get_WorkflowId ( p_workflow_name in varchar2 )
   RETURN number
   ;
   FUNCTION get_workflow_history 
   ( p_workflow_name in varchar2
   , p_dossier_id    in varchar2
   )   
   RETURN xxct_workflow_hist_table_type PIPELINED
   ;
   FUNCTION make_request
   ( p_url        IN VARCHAR2
   , p_action     IN VARCHAR2
   , p_body       IN CLOB
   )
   RETURN CLOB
   ;
   PROCEDURE make_request
   ( p_url           IN VARCHAR2
   , p_action        IN VARCHAR2
   , p_body          IN CLOB
   , p_set_2_delete  IN OUT VARCHAR2
   );
   --      
   ---------------------------------------------------------------------------------------------  
   -- Procedure to delete a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE delete_row  
   ( p_table_name   IN VARCHAR2  
   , p_key_values      IN VARCHAR2
   --, p_apex_id         IN VARCHAR2
   , p_old_values   IN VARCHAR2  
   )
   ;   
   --
   ---------------------------------------------------------------------------------------------  
   -- Procedure to 
   ---------------------------------------------------------------------------------------------           
   PROCEDURE delete_deleted_rows
   ;   
   ---------------------------------------------------------------------------------------------  
   -- Procedure to update a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------           
   PROCEDURE update_row  
   ( p_table_name     IN VARCHAR2
   , p_key_values     IN VARCHAR2
   , p_apex_id        IN VARCHAR2   
   , p_new_values     IN VARCHAR2  
   , p_old_values     IN VARCHAR2  
   , p_old_rowid      IN ROWID
   , p_effective_date IN DATE DEFAULT NULL   
   , p_overwrite      IN BOOLEAN DEFAULT FALSE
   );  
   ---------------------------------------------------------------------------------------------  
   -- Function to...
   ---------------------------------------------------------------------------------------------           
   FUNCTION get_footer_text
   RETURN VARCHAR2
   ;
   FUNCTION get_ctpayoutapprovalwf 
   RETURN xxct_ctpayoutapprovalwf_table_type PIPELINED
   ;
   --
   FUNCTION get_CTApproversCommentsWF  
   RETURN xxct_ctapproverscommentswf_table_type PIPELINED   
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
   -- Procedure to return the number of records in a Varicent table
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_table_count ( p_table_name IN VARCHAR2 )
   RETURN NUMBER;
   --          
   ---------------------------------------------------------------------------------------------  
   -- Function to see if a row already exists in Varicent  
   ---------------------------------------------------------------------------------------------    
   FUNCTION does_row_with_pk_exist (p_table_name IN VARCHAR2, p_column_names IN VARCHAR2, p_filter IN VARCHAR2, p_mode   IN VARCHAR2 )    
   RETURN BOOLEAN;
    ----------------------------------------------------------------------------------------------
   --Function to call the direct Varicent Scheduler (MWT-751)
   ----------------------------------------------------------------------------------------------
   FUNCTION run_scheduler_by_id ( p_schedule_id IN NUMBER )
   RETURN NUMBER;
   
END XXCT_GEN_REST_APIS;

/

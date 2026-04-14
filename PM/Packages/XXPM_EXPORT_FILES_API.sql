--------------------------------------------------------
--  DDL for Package XXPM_EXPORT_FILES_API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_EXPORT_FILES_API" 
IS        
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_EXPORT_FILES_API       
   *       
   * DESCRIPTION       
   * Package export all relevant data to Varicent SPM.   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXPM_EXPORT_FILES_API';   
   --
   TYPE  array_t is table of varchar2(100);
   TYPE spm_field_data IS RECORD  
   ( pk_fields      VARCHAR2(2000)  
   , all_fields     VARCHAR2(2000)  
   , pk_data_types  VARCHAR2(2000)  
   , key_fields     array_t := array_t() 
   , key_field_type array_t := array_t() 
   );    
   --   
   ---------------------------------------------------------------------------------------------   
   -- Main Procedure   
   ---------------------------------------------------------------------------------------------      
   PROCEDURE run_export(ptablename IN VARCHAR2);       
   --   
   ---------------------------------------------------------------------------------------------   
   -- Procedure that calls the main procedure for all records in xxcpc_tables.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE run_all;      
   --    
   ---------------------------------------------------------------------------------------------  
   -- Function to   
   ---------------------------------------------------------------------------------------------    
   FUNCTION get_table_columns ( p_table IN VARCHAR2 )  
   RETURN varchar2 --spm_field_data  
   ;
   --  
END XXPM_EXPORT_FILES_API;




/

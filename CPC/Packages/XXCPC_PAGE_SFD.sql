--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_SFD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_SFD" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXCPC_PAGE_SFD (show file differences)
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXCPC_PAGE_SFD).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       13-06-2023  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_SFD';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedures to support PAGE Show File Differences
   ---------------------------------------------------------------------------------------------     
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_apex_differences
   ( p_cpc_table_name IN VARCHAR2
   , p_spm_table_name IN VARCHAR2
   )
   RETURN CLOB;
   --
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_spm_differences
   ( p_cpc_table_name IN VARCHAR2
   , p_spm_table_name IN VARCHAR2
   )
   RETURN CLOB   
   ;

END XXCPC_PAGE_SFD;

/

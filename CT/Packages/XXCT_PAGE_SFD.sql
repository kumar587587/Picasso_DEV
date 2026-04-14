--------------------------------------------------------
--  DDL for Package XXCT_PAGE_SFD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_SFD" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXCT_PAGE_SFD (show file differences)
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXCT_PAGE_SFD).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       13-06-2023  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCT_PAGE_SFD';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedures to support PAGE Show File Differences
   ---------------------------------------------------------------------------------------------     
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_apex_differences
   ( p_pm_table_name  IN VARCHAR2
   , p_spm_table_name IN VARCHAR2
   )
   RETURN CLOB;
   --
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_spm_differences
   ( p_pm_table_name  IN VARCHAR2
   , p_spm_table_name IN VARCHAR2
   )
   RETURN CLOB   
   ;

END XXCT_PAGE_SFD;

/

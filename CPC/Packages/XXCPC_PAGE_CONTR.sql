--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_CONTR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_CONTR" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_CONTR       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is CONTR).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_CONTR';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to determine if contract can be deleted delete or should be end-dated.   
   ---------------------------------------------------------------------------------------------        
   FUNCTION delete_or_enddate   
   ( p_contractid  IN VARCHAR2, p_startdate IN VARCHAR2 )   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to determine if an item should be rendered.   
   ---------------------------------------------------------------------------------------------        
   FUNCTION server_side_condition   
   ( p_item    IN VARCHAR2 )   
   RETURN BOOLEAN   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to set the end-date equal to the start-date. This is necessary   
   -- for Varicent to exclude this contract in its calculations.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE end_date_contract    
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to determine if an item should be read-only.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION read_only   
   ( p_item    IN VARCHAR2 )      
   RETURN BOOLEAN;      
   --   
END xxcpc_page_contr;  



/

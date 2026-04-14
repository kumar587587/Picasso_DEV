--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_CNPR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_CNPR" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_CNPR       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is CNPR).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_CNPR';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the date are within the Contract dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION checkdatewithcontracts   
   RETURN VARCHAR2   
   ;   
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to check if the memoline is used in a manual partner invoice split line.  
   ---------------------------------------------------------------------------------------------    
   FUNCTION checkusedinmanualprtnrinvoice  
   ( p_id in number)   
   RETURN VARCHAR2;     
   --   
   ---------------------------------------------------------------------------------------------  
   -- Function to check if the content partner has a contract linked to it. 
   ---------------------------------------------------------------------------------------------    
   FUNCTION checkusedincontract
   ( p_id IN NUMBER)   
   RETURN VARCHAR2  
   ;
END xxcpc_page_cnpr;



/

--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_CNTPCKDT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_CNTPCKDT" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_CNTPCKDT       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is CNTPCKDT).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXXXXX';   
   --       
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check for date within package dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION dates_within_package_dates   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check for date within contract dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION dates_within_contract_dates   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get the contract dates and store them into page items.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE get_contract_dates     
   ;   

END xxcpc_page_cntpckdt;  



/

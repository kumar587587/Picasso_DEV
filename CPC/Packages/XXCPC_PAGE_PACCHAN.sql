--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_PACCHAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_PACCHAN" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_PACCHAN       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is PACCHAN).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_PACCHAN';   
   --       
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if dates are within contract dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION dates_within_contract_dates   
   RETURN VARCHAR2    
   ;   
END xxcpc_page_pacchan;  



/

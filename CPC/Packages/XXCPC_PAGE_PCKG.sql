--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_PCKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_PCKG" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_PCKG       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is PCKG).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_PCKG';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the date are within the Contract Package dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION checkdatewithcontractpackages   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to replace EOT with blank field   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE emptyenddatewheneot     
   ;   

END xxcpc_page_pckg;  



/

--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_CHNNL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_CHNNL" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_CHNNL       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is CHNNL).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_CHNNL';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the date are within the package channel dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION checkdatewithpackagechannels   
   RETURN VARCHAR2;   
   --   
   ---------------------------------------------------------------------------------------------   
   -- Procedure to replace EOT with blank field   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE emptyenddatewheneot   
   ;   
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to check if the date are within the package channel dates.  
   ---------------------------------------------------------------------------------------------    
   FUNCTION checkithpackagechannels  
   RETURN VARCHAR2  
   ;
   --
END xxcpc_page_chnnl;



/

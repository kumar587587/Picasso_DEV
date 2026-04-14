--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_PRVDR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_PRVDR" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_PRVDR       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is PRVDR).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_PRVDR';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to replace EOT with blank field   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE emptyenddatewheneot     
   ;   
END xxcpc_page_prvdr;  



/

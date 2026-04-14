--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_SPPA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_SPPA" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_SPPA       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is TRDCMRTS).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_SPPA';       
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to delete special package 'packages'   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE delete_package(ppackagename IN VARCHAR2)   
   ;     
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check is the special package is used in a contract   
   ---------------------------------------------------------------------------------------------     
   FUNCTION check_use_in_contract   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the dates are within the package channels dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION checkdatewithpackagechannels   
   RETURN VARCHAR2   
   ;   
END;  



/

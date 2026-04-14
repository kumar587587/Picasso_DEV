--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_SPCPCDT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_SPCPCDT" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_SPCPCDT       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXCPC_PAGE_SPCPCDT).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_SPCPCDT';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the dates are within the package dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION dates_within_package_dates   
   RETURN VARCHAR2   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to check if the dates are within the special package dates.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION dates_within_spcl_pckg_dates   
   RETURN VARCHAR2   
   ;   
END xxcpc_page_spcpcdt;  



/

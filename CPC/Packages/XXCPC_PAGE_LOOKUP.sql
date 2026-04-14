--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_LOOKUP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_LOOKUP" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXCPC_PAGE_LOOKUP    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is LOOKUP).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_LOOKUP';
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to check if momoline can be deleted.
   ---------------------------------------------------------------------------------------------     
   FUNCTION can_delete_memoline  
   ( p_lookup_id   in number)   
   RETURN VARCHAR2
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to check if vatcode can be deleted.
   ---------------------------------------------------------------------------------------------     
   FUNCTION can_delete_vatcode  
   ( p_lookup_id   in number)   
   RETURN VARCHAR2
   ;   
END XXCPC_PAGE_LOOKUP;    



/

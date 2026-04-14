--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_RATEPER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_RATEPER" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXCPC_PAGE_RATEPER    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXXXXX).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_RATEPER';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   --
   ---------------------------------------------------------------------------------------------
   -- Procedure to be 
   ---------------------------------------------------------------------------------------------
   PROCEDURE get_data( p_id in number , p_startdate out date, p_enddate out date, p_Contractnr out varchar2 )   
   ;
   PROCEDURE update_tierrates  ( p_tierperiod_id in number, p_new_enddate in date, p_old_enddate in date)
   ;
END XXCPC_PAGE_RATEPER;

/

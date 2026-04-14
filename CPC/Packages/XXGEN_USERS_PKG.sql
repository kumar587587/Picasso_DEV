--------------------------------------------------------
--  DDL for Package XXGEN_USERS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXGEN_USERS_PKG" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  xxcpc_users_pkg    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXXXXX).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'xxgen_users_pkg';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE run_create_user_job  
   ( p_user_name in varchar2
   , p_role      in varchar2
   )
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE create_user  
   ( p_user_name in varchar2
   , p_role      in varchar2
   )
   ;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   FUNCTION user_has_access
   ( p_user_name in varchar2
   , p_role      in varchar2
   )
   RETURN BOOLEAN
   DETERMINISTIC
   ;
END xxgen_users_pkg;

/

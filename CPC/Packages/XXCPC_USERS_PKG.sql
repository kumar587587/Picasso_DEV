--------------------------------------------------------
--  DDL for Package XXCPC_USERS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_USERS_PKG" 
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
   gc_package_name   CONSTANT    VARCHAR(50) := 'xxcpc_users_pkg';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
--   PROCEDURE run_create_user_job  
--   ( p_user_name in varchar2
--   , p_role      in varchar2
--   )
--   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
--   PROCEDURE run_process_request_job  
--   ( p_user_name in varchar2
--   , p_role      in varchar2
--   , p_action    in varchar2
--   )
--   ;
   --    

   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE create_user  
   ( p_user_name in varchar2
   , p_ruis_name in varchar2
   , p_role_id   in number
   )
   ;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE process
   ( p_user_name in varchar2
   , p_ruis_name in varchar2
   , p_role      in varchar2
   , p_action    in varchar2
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
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
   PROCEDURE process_iam_request
   ( p_body       in  clob
   , p_status     out   varchar2
   , p_message    out   varchar2
   )
   ;
   PROCEDURE run_schedulers_job
   ;
   PROCEDURE payee_to_group
   ( p_role_name     IN VARCHAR2
   , p_ruis_name     IN VARCHAR2
   , p_action        IN VARCHAR2
   , p_group         IN VARCHAR2 default null
   , p_user_id       IN NUMBER
   )   
   ;   
END xxcpc_users_pkg;

/

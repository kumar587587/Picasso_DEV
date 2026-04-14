--------------------------------------------------------
--  DDL for Package XXCT_USERS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_USERS_PKG" 
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
   gc_package_name   CONSTANT    VARCHAR(50) := 'xxct_users_pkg';
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
   --( p_job_name    in varchar2)
   ;
--   PROCEDURE create_and_run_job  
--   ;
--   PROCEDURE add_payee_to_group
--   ( p_role_name     IN VARCHAR2
--   , p_ruis_name     IN VARCHAR2
--   , p_action        IN VARCHAR2
--   , p_group         IN VARCHAR2 default null
--   )   
--   ;
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
   PROCEDURE payee_to_group
   ( p_role_name     IN VARCHAR2
   , p_ruis_name     IN VARCHAR2
   , p_action        IN VARCHAR2
   , p_group         IN VARCHAR2 default null
   , p_user_id       IN NUMBER
   )   
   ;
END xxct_users_pkg;



/

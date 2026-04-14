--------------------------------------------------------
--  DDL for Package XXSPM_TOOLS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXSPM_TOOLS_PKG" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXSPM_TOOLS_PKG    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXXXXX).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   **************************************************************/    
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXSPM_TOOLS_PKG';
   g_biu_triggers_active         BOOLEAN := true;
   TYPE t_array      IS TABLE OF VARCHAR2(3900) INDEX BY BINARY_INTEGER;
   TYPE wf_info_t    IS RECORD( tokenid VARCHAR2(20), pathid VARCHAR2(20),assignee VARCHAR2(50));
   ---------------------------------------------------------------------------------------------   
   -- Procedure to return the number of records in a Varicent table
   ---------------------------------------------------------------------------------------------     
   PROCEDURE get_modified_calculations 
   ( p_api_key      in varchar2
   , p_from_date    in varchar2
   , p_to_date      in varchar2
   , p_user         in varchar2
   , p_model        in varchar2
   )
   ;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
--   PROCEDURE replay 
--   ( p_first_replay_period  in varchar2
--   , p_undo_or_redo         in varchar2
--   )
--   ; 
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE Test_replay
   ;
procedure trunc_audits;   
procedure delete_all;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE reset_calendars_and_periods  
   ( p_first_replay_period  in varchar2
   , p_lockedperiod         in varchar2
   , p_compperiod           in varchar2
   )
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE delete_workflow_records
   ( p_due_date in date )
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_workflow_info
   RETURN wf_info_t 
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE start_and_approve_workflow
   ;
END XXSPM_TOOLS_PKG;

/

--------------------------------------------------------
--  DDL for Package XXCT_GEN_LOG_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_GEN_LOG_PKG" IS       
       
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_log_PKG       
   *       
   * DESCRIPTION       
   * Package to send log messages to the XXCPC_log table   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/  
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to reset g_level
   ---------------------------------------------------------------------------------------------         
   PROCEDURE reset_level;     
   --       
   ---------------------------------------------------------------------------------------------       
   -- Procedure to delete all records in the log table.   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE delete_log;       
   --       
   ---------------------------------------------------------------------------------------------       
   -- Regular procedure (most used) to write a string to the log table.       
   ---------------------------------------------------------------------------------------------       
   PROCEDURE log                   ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2);      
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write a clob value to the log table.   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE log_cs                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2       
                                     , p_clob         IN     CLOB       
                                     );       
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write a blob value to the log table.      
   ---------------------------------------------------------------------------------------------       
   PROCEDURE log_bs                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2       
                                     , p_blob         IN     BLOB       
                                     );       
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write the call stack to the log table.      
   -- Eexample : xxcpc_log_pkg.log_st( <routine name>,DBMS_UTILITY.format_call_stack);   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE log_st                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2);       
   --                                     
   ---------------------------------------------------------------------------------------------       
   -- Function to write write a string to the log table. Can be used in queries.   
   -- This function always returns the string value '1'   
   -- Example 1:  select a,b,c, xxcpc_log_pkg.log(<Routine>, column_name) d from ........   
   -- Example 2:  select * from xxxx where '1' = xxcpc_log_pkg.log(<Routine>, column_name).   
   ---------------------------------------------------------------------------------------------         
   FUNCTION log                    ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     CLOB               ) RETURN VARCHAR2;       
   --    
   ---------------------------------------------------------------------------------------------         
   FUNCTION log                    ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2        ) RETURN NUMBER;       
   --       
   ---------------------------------------------------------------------------------------------       
   -- Function to prefix a string with 4 times p_level number off spaces      
   ---------------------------------------------------------------------------------------------       
   FUNCTION stuff                    ( p_level        IN     NUMBER             ) RETURN VARCHAR2;       

   --    
   ---------------------------------------------------------------------------------------------       
   -- Function to get the version number from a long (string).   
   -- Example: select xxcpc_log_pkg.get_version_nr_from_long(trigger_body) from all_triggers where...   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_version_nr_from_long ( p_long_value   IN     LONG               ) RETURN VARCHAR2;       
   --    
   ---------------------------------------------------------------------------------------------     
   -- Function to get the version number of a trigger.   
   ---------------------------------------------------------------------------------------------     
   FUNCTION get_trigger_verion_nr    ( p_trigger_name IN     VARCHAR2       
                                     , p_owner        IN     VARCHAR2           ) RETURN VARCHAR2;       
   --       
   ---------------------------------------------------------------------------------------------       
   -- Regular procedure only used by triggers. 
   ---------------------------------------------------------------------------------------------       
   PROCEDURE log_t                 ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2)  
   ;
   --
END XXCT_GEN_LOG_PKG;



/

--------------------------------------------------------
--  DDL for Package XXCPC_GEN_DEBUG_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_GEN_DEBUG_PKG" IS       
       
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_DEBUG_PKG       
   *       
   * DESCRIPTION       
   * Package to send debug messages to the XXCPC_DEBUG table   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/  
   --    
   g_level   NUMBER := 0;          
   ---------------------------------------------------------------------------------------------
   -- Procedure to reset g_level
   ---------------------------------------------------------------------------------------------         
   PROCEDURE reset_level;     
   --       
   ---------------------------------------------------------------------------------------------       
   -- Procedure to delete all records in the debug table.   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE delete_debug;       
   --       
   ---------------------------------------------------------------------------------------------       
   -- Regular procedure (most used) to write a string to the debug table.       
   ---------------------------------------------------------------------------------------------       
   PROCEDURE debug                   ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2);       
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write a clob value to the debug table.   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE debug_cs                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2       
                                     , p_clob         IN     CLOB       
                                     );       
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write a blob value to the debug table.      
   ---------------------------------------------------------------------------------------------       
   PROCEDURE debug_bs                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2       
                                     , p_blob         IN     BLOB       
                                     );       
   --    
   ---------------------------------------------------------------------------------------------       
   -- Procedure to write the call stack to the debug table.      
   -- Eexample : xxcpc_debug_pkg.debug_st( <routine name>,DBMS_UTILITY.format_call_stack);   
   ---------------------------------------------------------------------------------------------       
   PROCEDURE debug_st                ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2);       
   --                                     
   ---------------------------------------------------------------------------------------------       
   -- Function to write write a string to the debug table. Can be used in queries.   
   -- This function always returns the string value '1'   
   -- Example 1:  select a,b,c, xxcpc_debug_pkg.debug(<Routine>, column_name) d from ........   
   -- Example 2:  select * from xxxx where '1' = xxcpc_debug_pkg.debug(<Routine>, column_name).   
   ---------------------------------------------------------------------------------------------         
   FUNCTION debug                    ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     CLOB               ) RETURN VARCHAR2;       
   --    
   ---------------------------------------------------------------------------------------------         
   FUNCTION debug                    ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2        ) RETURN NUMBER;       
   --       
   ---------------------------------------------------------------------------------------------       
   -- Function to prefix a string with 4 times p_level number off spaces      
   ---------------------------------------------------------------------------------------------       
   FUNCTION stuff                    ( p_level        IN     NUMBER             ) RETURN VARCHAR2;       

   --    
   ---------------------------------------------------------------------------------------------       
   -- Function to get the version number from a long (string).   
   -- Example: select xxcpc_debug_pkg.get_version_nr_from_long(trigger_body) from all_triggers where...   
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
   PROCEDURE debug_t                 ( p_routine      IN     VARCHAR2 DEFAULT NULL       
                                     , p_message      IN     VARCHAR2)  
   ;
   --
END xxcpc_gen_debug_pkg;

/

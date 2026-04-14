--------------------------------------------------------
--  DDL for Package XXCPC_GEN_CRUSH_FTP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_GEN_CRUSH_FTP" 
IS     
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_GEN_CRUSH_FTP       
   *       
   * DESCRIPTION       
   * Package to support CRUSH FTP functionality.   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_GEN_CRUSH_FTP';   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to get a new 'Crumb'   
   ---------------------------------------------------------------------------------------------    
   PROCEDURE get_crumb   
   ;   
END xxcpc_gen_crush_ftp;  



/

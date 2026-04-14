--------------------------------------------------------
--  DDL for Package XXCT_DOSSIER_API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_DOSSIER_API" AUTHID DEFINER
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXCT_DOSSIER_API    
   *    
   * DESCRIPTION    
   * Package to support API functions into the Credittool Dossiers
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Wiljo Bakker        08-10-2024   Initial Version    
   **************************************************************/    
   
   gc_package_name                  CONSTANT    VARCHAR(50)   := 'XXCT_DOSSIER_API';
   gc_package_spec_version          CONSTANT    VARCHAR2(200) := '$Id: $';

   ---------------------------------------------------------------------------------------------
   -- FUNCTIONS
   ---------------------------------------------------------------------------------------------        
   FUNCTION get_package_spec_version RETURN VARCHAR2;
   
   FUNCTION get_package_body_version RETURN VARCHAR2;
                                            
  ---------------------------------------------------------------------------------------------
   -- PROCEDURES
   ---------------------------------------------------------------------------------------------        
   PROCEDURE updateStatus ( p_file_content        IN          BLOB      
                          , p_status_code              OUT    VARCHAR2 );
   
END XXCT_DOSSIER_API;

/

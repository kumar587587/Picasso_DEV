--------------------------------------------------------
--  DDL for Package XXPM_OBJECT_STORAGE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_OBJECT_STORAGE_PKG" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  XXXXXX    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is XXXXXX).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   **************************************************************/    
   gc_package_name       CONSTANT    VARCHAR(50)  := 'XXPM_OBJECT_STORAGE_PKG';
   gc_export_directory   CONSTANT    VARCHAR2(50) :=  'PM_EXPORT_DIRECTORY';
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to delete special package 'packages'
   ---------------------------------------------------------------------------------------------     
   PROCEDURE write_to_storage  
   ( p_file_name          in varchar2
   , p_file_content       in blob   
   );   
END xxpm_object_storage_pkg;

/

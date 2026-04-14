--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_TRDCMRTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_TRDCMRTS" 
IS       
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_TRDCMRTS       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is TRDCMRTS).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_TRDCMRTS';       
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE show_collection_members       
   ( prateperiodid IN NUMBER )       
   ;       
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure that will add all records commited in the table to the collection.   
   ---------------------------------------------------------------------------------------------          
   PROCEDURE populate_collection       
   ( prateperiodid                IN NUMBER       
   );       
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to update values in the collection.   
   ---------------------------------------------------------------------------------------------          
   PROCEDURE update_collection       
   ( pid               IN VARCHAR2       
   , ptierperiodid     IN NUMBER        
   , pmin              IN VARCHAR2           
   , pmax              IN VARCHAR2       
   , ptiernr           IN VARCHAR2       
   , precstatus        IN VARCHAR2       
   ) ;           
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION  cross_record_validations       
   ( ptierperiodid  IN NUMBER )       
   RETURN VARCHAR2;       
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to remove an element from the collection.   
   ---------------------------------------------------------------------------------------------          
   PROCEDURE removeelement       
   ( pelementids IN VARCHAR2      
   );      
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to temp id  page item.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE set_p57_temp_id   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to remove an element from the collection.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE removefromarray     
   ;   
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to check for cross record validations.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE cross_validation     
   ;     
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to update the collection in a validation process (obsolete?)   
   ---------------------------------------------------------------------------------------------     
   FUNCTION update_collection_validation   
   RETURN BOOLEAN   
   ;   
   --   
END xxcpc_page_trdcmrts;  



/

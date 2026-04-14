--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_BILINF
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_BILINF" 
IS       
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_BILINF       
   *       
   * DESCRIPTION       
   * Package to support functionality for the billing info apex page (page-alias is BILINF).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_BILINF';       
   --   
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE show_collection_members       
   ( ppartnerid IN NUMBER )       
   ;       
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure that will add all records commited in the table to the collection.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE populate_collection       
   ( ppartnerid                IN NUMBER       
   );       
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to update values in the collection.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE update_collection       
   ( pid               IN VARCHAR2       
   , ppartnerid  IN NUMBER        
   , pmemoline       IN VARCHAR2           
   , pvatcode        IN VARCHAR2       
   , pdefaultindicator IN VARCHAR2       
   , precstatus        IN VARCHAR2       
   ) ;           
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure that will check invalid cross record values.   
   ---------------------------------------------------------------------------------------------         
   FUNCTION  cross_record_validations       
   ( ppartnerid  IN NUMBER       
   )       
   RETURN VARCHAR2;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to update the collection.     
   ---------------------------------------------------------------------------------------------            
   PROCEDURE rowaftersubmitprocess     
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure that will add all records commited in the table to the collection.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE populate_collection_ajax_callback     
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure that will add all records commited in the table to the collection.   
   ---------------------------------------------------------------------------------------------         
   PROCEDURE set_temp_id_ajax_callback   
   ;   
   --      
   ---------------------------------------------------------------------------------------------  
   -- Function to check if the memoline is used in a manual partner invoice split line.  
   ---------------------------------------------------------------------------------------------    
   FUNCTION checkusedinmanualprtnrinvoice
   ( p_id in number)
   RETURN VARCHAR2;
   --
END xxcpc_page_bilinf;




/

--------------------------------------------------------
--  DDL for Package XXCPC_PAGE_MANPARINV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_PAGE_MANPARINV" 
AS      
  /****************************************************************       
   *       
   * PROGRAM NAME       
   *  XXCPC_PAGE_MANPARINV       
   *       
   * DESCRIPTION       
   * Package to support functionality for the manual partner invoice apex page (page-alias is MANPARINV).   
   *       
   * CHANGE HISTORY       
   * Who                 When         What       
   * -------------------------------------------------------------       
   * Geert Engbers       08-12-2022  Initial Version       
   **************************************************************/       
   gc_package_name   CONSTANT    VARCHAR(50) := 'XXCPC_PAGE_MANPARINV';       
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION count_invoicenumbers ( ppartnerid IN NUMBER,pinvoicenumber IN VARCHAR2, pid IN NUMBER)      
   RETURN NUMBER      
   ;      
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION read_only( pinvoicestatusid IN NUMBER)      
   RETURN BOOLEAN      
   ;      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION check_conditional_display  ( p_page_item_name    IN VARCHAR2  )       
   RETURN BOOLEAN      
   ;      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION split_allowed        ( ppartnerid          IN NUMBER      
                                 , ppartnerinvoiceid   IN NUMBER DEFAULT 0 )       
   RETURN BOOLEAN         
   ;      
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   PROCEDURE removeelement       
   ( pelementids IN VARCHAR2      
   )      
   ;      
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   FUNCTION cross_record_validations       
   ( ppartnerinvoiceid  IN VARCHAR2      
   )          
   RETURN VARCHAR2      
   ;      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------          
   PROCEDURE populate_collection       
       ( ppartnerinvoiceid                IN NUMBER       
       )       
    ;         
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------           
   PROCEDURE update_collection       
   ( pids               IN VARCHAR2       
   , pamounts           IN VARCHAR2      
   , pdeleted           IN VARCHAR2      
   );    
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to remove an element from the collection.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE removefromarray     
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to start the cross validation check.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE crossvalidate   
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Procedure to update the collection.   
   ---------------------------------------------------------------------------------------------            
   PROCEDURE updatecollection     
   ;   
   --       
   ---------------------------------------------------------------------------------------------   
   -- Function to get the invoice status for a specific invoice.   
   ---------------------------------------------------------------------------------------------            
   FUNCTION get_invoice_status    
      ( p_partnerid IN VARCHAR2   
      , p_invoicenumber IN VARCHAR2   
      , p_currentstatus IN VARCHAR2   
      )   
      RETURN VARCHAR2   
      ;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE update_all_invoice_status
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   procedure duplicate_code 
   ( p_duplicate_id           IN number
   , p_current_open_period    IN VARCHAR2 
   );   
   --      
   ---------------------------------------------------------------------------------------------   
   -- Procedure to write all the current values of the collection to the debug table.   
   ---------------------------------------------------------------------------------------------         
   FUNCTION read_only( p_field IN VARCHAR2, p_invoiceId in number)      
   RETURN BOOLEAN      
   ;   

END xxcpc_page_manparinv;

/

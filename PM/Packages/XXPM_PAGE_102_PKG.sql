--------------------------------------------------------
--  DDL for Package XXPM_PAGE_102_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_PAGE_102_PKG" 
IS 
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXPM_PAGE_102_PKG.pks,v 1.2 2021/02/10 12:56:04 engbe502 Exp $'; 
   g_partner_id                  NUMBER;
   g_chain_id_old                NUMBER;
   g_chain_id_new                NUMBER;
   g_partner_number_old          NUMBER;
   g_partner_number_new          NUMBER;
   g_partner_name_old            VARCHAR2(50);
   g_partner_name_new            VARCHAR2(50);
   g_email_address_invoice_old   VARCHAR2(200);
   g_email_address_invoice_new   VARCHAR2(200);
   g_rowid_old                   number;
   g_new_values_string           VARCHAR2(30000);
   g_new_values_string_template  VARCHAR2(30000);
   g_old_values_string           VARCHAR2(30000);


   --------------------------------------------------------------------------------------------- 
   -- Procedure to be used for debugging purposes. 
   --------------------------------------------------------------------------------------------- 
   procedure debug 
           ( p_routine in varchar2 
           , p_message in varchar2 
           ); 
   --------------------------------------------------------------------------------------------- 
   function get_package_body_version 
   return varchar2 
   ; 
   --------------------------------------------------------------------------------------------- 
   function get_package_spec_version 
   return varchar2 
   ; 
   --------------------------------------------------------------------------------------------- 
   procedure insert_record 
   ; 

   --------------------------------------------------------------------------------------------- 
   procedure delete_record 
          ( p_partner_id              in     number 
          ) 
   ; 
   --------------------------------------------------------------------------------------------- 
   function read_only 
          ( p_business_rule_number              in     varchar2 
          , p_partner_classification            in     varchar2           
          , p_end_date                          in     varchar2 
          ) 
   return boolean 
   ; 
   --------------------------------------------------------------------------------------------- 
   function server_side_condition 
          ( p_business_rule_number              in     varchar2 
          , p_partner_classification            in     varchar2           
          , p_end_date                          in     varchar2           
          ) 
   return boolean 
   ; 
   -- 
   --------------------------------------------------------------------------------------------- 
   -- 
   ---------------------------------------------------------------------------------------------     
   function validate_chain_main_partners
   ( p_partner_type           in varchar2
   , p_partner_classification in varchar2
   , p_chain_id_bpo_non_esmee in varchar2
   , p_chain_id_bpo           in varchar2
   , p_chain_id_other         in varchar2
   ) return boolean;
   -- 
   --------------------------------------------------------------------------------------------- 
   -- 
   ---------------------------------------------------------------------------------------------       
   function validate_chain_sub_partners
   ( p_partner_type           in varchar2
   , p_partner_classification in varchar2
   , p_chain_id_bpo           in varchar2
   , p_chain_id_other         in varchar2
   , p_chain_id_sub           in varchar2
   ) return boolean;   
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to 
   ---------------------------------------------------------------------------------------------         
   /*FUNCTION update_data_after_commit  ( p_request in varchar2 ) 
   RETURN varchar2;   */
   --
   PROCEDURE set_partner_id ( p_partner_id  in number );
   FUNCTION get_partner_id return number;    
   --
--   PROCEDURE set_rowid_old ( p_rowid  in number );
--   FUNCTION get_rowid_old return number;    

   --
   PROCEDURE set_chain_id_old ( p_chain_id  in number );
   FUNCTION get_chain_id_old return number;    
   --
   PROCEDURE set_chain_id_new ( p_chain_id  in number );
   FUNCTION get_chain_id_new return number;    
   --
   PROCEDURE set_partner_number_new ( p_partner_number  in number );
   FUNCTION get_partner_number_new return number;    
   --
   PROCEDURE set_partner_number_old ( p_partner_number  in number );
   FUNCTION get_partner_number_old return number;    
   --
   PROCEDURE set_partner_name_new ( p_partner_name  in varchar2 );
   FUNCTION get_partner_name_new return varchar2;    
   --
   PROCEDURE set_partner_name_old ( p_partner_name  in varchar2 );
   FUNCTION get_partner_name_old return varchar2;    
   --
   PROCEDURE set_email_address_invoice_new ( p_email_address_invoice  in varchar2 );
   FUNCTION get_email_address_invoice_new return varchar2;    
   --
   PROCEDURE set_email_address_invoice_old ( p_email_address_invoice  in varchar2 );
   FUNCTION get_email_address_invoice_old return varchar2;    

   PROCEDURE set_new_values_string (p_new_values_string in varchar2);
   PROCEDURE set_old_values_string (p_old_values_string in varchar2);

   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_partner_info 
   ( p_partner_id    in number
   , p_partner_type  in varchar2
   )
   RETURN xxpm_partner_info_rec
   ;
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_payee_values_string
   ( p_payee_id               in varchar2
   , p_partner_name           in varchar2
   , p_email_address_invoice  in varchar2
   , p_center_code            in varchar2  
   , p_partner_vcode          in varchar2
   )
   RETURN VARCHAR2
   ;

END XXPM_PAGE_102_PKG;

/

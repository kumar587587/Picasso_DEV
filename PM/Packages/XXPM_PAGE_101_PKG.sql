--------------------------------------------------------
--  DDL for Package XXPM_PAGE_101_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_PAGE_101_PKG" 
IS 
  /**************************************************************** 
   * 
   * PROGRAM NAME 
   *  XXPM_PAGE_101_PKG 
   * 
   * DESCRIPTION 
   * Program to support apex functionality for page 101 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Geert Engbers       09-02-2021  Initial Version. 
   **************************************************************/ 
   -- 
   -- $Id: XXPM_PAGE_101_PKG.pks,v 1.1 2021/02/10 13:09:39 engbe502 Exp $ 
   -- $Log: XXPM_PAGE_101_PKG.pks,v $ 
   -- Revision 1.1  2021/02/10 13:09:39  engbe502 
   -- Initial revision 
   -- 
   -- 
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXPM_PAGE_101_PKG.pks,v 1.1 2021/02/10 13:09:39 engbe502 Exp $'; 
   g_partner_id                  NUMBER;
   g_chain_id_old                NUMBER;
   g_chain_id_new                NUMBER;
   g_partner_number_old          NUMBER;
   g_partner_number_new          NUMBER;
   g_partner_name_old            VARCHAR2(50);
   g_partner_name_new            VARCHAR2(50);
   g_email_address_invoice_old   VARCHAR2(200);
   g_email_address_invoice_new   VARCHAR2(200);
   g_rowid_old                   rowid;
   g_new_values_string           VARCHAR2(30000);
   g_new_values_string_template  VARCHAR2(30000);
   g_old_values_string           VARCHAR2(30000);

   --------------------------------------------------------------------------------------------- 
   -- Procedure to be used for debugging purposes. 
   --------------------------------------------------------------------------------------------- 
   procedure debug 
           ( p_routine in varchar2 
           , p_message in varchar2 ) 
   ; 
   --------------------------------------------------------------------------------------------- 
   function get_package_body_version 
   return varchar2 
   ; 
   --------------------------------------------------------------------------------------------- 
   function get_package_spec_version 
   return varchar2 
   ; 
   --------------------------------------------------------------------------------------------- 
   function server_side_condition 
          ( p_business_rule_number              in     varchar2 
          ) 
   return boolean 
   ; 
   ---------------------------------------------------------------------------------------------         
   PROCEDURE update_data_after_commit;-- ( p_partner_id in number ) 

END XXPM_PAGE_101_PKG;




/

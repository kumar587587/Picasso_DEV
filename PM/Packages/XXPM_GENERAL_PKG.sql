--------------------------------------------------------
--  DDL for Package XXPM_GENERAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_GENERAL_PKG" 
IS 
  /**************************************************************** 
   * 
   * PROGRAM NAME 
   *  PM000 - XXPM_GENERAL_PKG 
   * 
   * DESCRIPTION 
   * Program to support generic Partner Maintenance functionality 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Geert Engbers       21-04-2020   Initial Version. 
   * Wiljo Bakker        20-09-2024   Rebuild for use logging in Cloud   
   **************************************************************/

   -- $Id: XXPM_GENERAL_PKG.pks,v 1.9 2024/10/17 08:23:47 bakke619 Exp $
   -- $Log: XXPM_GENERAL_PKG.pks,v $
   -- Revision 1.9  2024/10/17 08:23:47  bakke619
   -- Added PostClone Actions
   --
   -- Revision 1.8  2024/09/20 15:44:51  bakke619
   -- updated for Cloud and added batch logging
   --

   -- PL-SQL Array Collection Types
   TYPE T_INDICATORS        IS TABLE  OF VARCHAR2(10)                 INDEX BY BINARY_INTEGER;
   TYPE T_INDICATOR_COUNT   IS TABLE  OF NUMBER                       INDEX BY VARCHAR2(100);   
   g_INDICATORS             T_INDICATORS;
   g_INDICATOR_COUNT        T_INDICATOR_COUNT;   
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXPM_GENERAL_PKG.pks,v 1.9 2024/10/17 08:23:47 bakke619 Exp $'; 
   c_PM_Administration           CONSTANT VARCHAR2(200) := 'PM Administration'; 
   c_PM_BPO_Partners             CONSTANT VARCHAR2(200) := 'PM BPO Partners'; 
   c_PM_Retail_Partners          CONSTANT VARCHAR2(200) := 'PM Retail Partners'; 
   c_PM_Maintenance              CONSTANT VARCHAR2(200) := 'PM Maintenance'; 
   c_PM_View_Partners            CONSTANT VARCHAR2(200) := 'PM View Partners'; 
   c_PM_KPN_Callcenters          CONSTANT VARCHAR2(200) := 'PM KPN Callcenters'; 
   c_PM_KPN_Shops                CONSTANT VARCHAR2(200) := 'PM KPN Shops'; 

   gc_production_instance        CONSTANT VARCHAR2(200) := 'APXPRD';   
   --------------------------------------------------------------------------------------------- 
   g_file_id_to_be_deleted        NUMBER := 0; 
   g_iso_codes                    xxpm_iso_country_table; 
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
   function pm_error_handling 
          (  p_error in apex_error.t_error ) 
   return apex_error.t_error_result 
   ; 
   --------------------------------------------------------------------------------------------- 
   procedure write_blob_to_unix 
           ( p_location    IN VARCHAR2 
           , p_filename    IN VARCHAR 
           , p_blob_length IN NUMBER 
           , p_blob        IN BLOB 
           ) 
   ; 
   --------------------------------------------------------------------------------------------- 
   --function getDirectory 
   --return varchar2 
   --; 
   --------------------------------------------------------------------------------------------- 
   procedure delete_document 
          ( p_file_id              in     number 
          ) 
   ; 
   --------------------------------------------------------------------------------------------- 
   procedure set_file_to_be_deleted 
          ( p_file_id              in     number 
          ) 
   ; 
   --------------------------------------------------------------------------------------------- 
   function get_file_id_to_be_deleted 
   return number 
   ; 
   --------------------------------------------------------------------------------------------- 
   function read_only 
          ( p_partner_classification in varchar2 
          ) 
   return boolean 
   ; 
   --------------------------------------------------------------------------------------------- 
   function read_only 
          ( p_partner_classification in number 
          ) 
   return boolean 
   ; 
   --------------------------------------------------------------------------------------------- 
   function server_side_condition 
          ( p_partner_classification in number 
          ) 
   return boolean 
   ; 
   -- 
   function get_PM_Administration return varchar2; 
   function get_PM_BPO_Partners return varchar2; 
   function get_PM_Retail_Partners return varchar2; 
   function get_PM_Maintenance return varchar2; 
   function get_PM_View_Partners return varchar2; 
   function get_PM_KPN_Callcenters return varchar2; 
   function get_PM_KPN_Shops return varchar2; 
   -- 
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to get all iso codes from api
   ---------------------------------------------------------------------------------------------  
   FUNCTION get_iso_country_codes  RETURN xxpm_iso_country_table    deterministic;
 
   function get_role    return varchar2 ;
   
   function set_role 
   ( p_po_role_name in varchar2
   , p_g_role_name  in varchar2
   )
   return number   ;
   
   FUNCTION get_database_name RETURN VARCHAR2;
   
END XXPM_GENERAL_PKG;

/

--------------------------------------------------------
--  DDL for Package XXCT_PAGE_114_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_114_PKG" 
AS
/****************************************************************
*
* PROGRAM NAME
*  CPC601 - XXCT_PAGE_114_PKG
*
* DESCRIPTION
* Program to support Credit Tool (CT) functionality
*
* CHANGE HISTORY
* Who                 When         What
* -------------------------------------------------------------
* Geert Engbers        08-02-2019  Initial Version (ODO-524)
* Geert Engbers        20-03-2019  Changes required as result of APEX 18 migration.
**************************************************************/
--
-- $Id: XXCT_PAGE_114_PKG.pks,v 1.2 2019/03/20 12:05:19 rikke493 Exp $
-- $Log: XXCT_PAGE_114_PKG.pks,v $
-- Revision 1.2  2019/03/20 12:05:19  rikke493
-- Apex 18 upgrade
--
-- Revision 1.1  2019/02/11 13:41:22  rikke493
-- Initial revision
--
--
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_114_PKG.pks,v 1.2 2019/03/20 12:05:19 rikke493 Exp $';
   ----------------------------------------------------------------------------------
   function get_package_body_version return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version return varchar2;
   ---------------------------------------------------------------------------------------------
   function region_updateable
          ( p_region_name   in varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function show_region
          ( p_region_name   in varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function show_button
          ( p_button_name   in varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function check_condition
          ( p_condition_name in varchar2
          )
    return boolean;
   ---------------------------------------------------------------------------------------------
   function default_value
          ( p_field_name        in     varchar2
          )
   return varchar2;
   ---------------------------------------------------------------------------------------------
   function is_read_only
          ( p_field_name           in     varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function show_field
          ( p_field_name              in     varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function ct_error_handling
          (  p_error in apex_error.t_error )
   return apex_error.t_error_result;
   ---------------------------------------------------------------------------------------------
   function show_checkbox
          ( p_checkbox_name         in     varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function show_approve_records
          ( p_status         in     varchar2
          , p_dossier_id     in     number
          , p_mandate_cycle  in     number
          )
   return varchar2;
   ---------------------------------------------------------------------------------------------
   procedure generate_excel_file
           ( p_division_code            in     varchar2
           , p_transpost_period         in     varchar2
           , p_centercode               in     varchar2
           , p_channel_id               in     varchar2
           , p_type                     in     varchar2
           , p_product_code             in     varchar2
           , p_user                     in     varchar2
           );
   ---------------------------------------------------------------------------------------------
   procedure reset_xxct_excel_output_files
   ;
   --
END XXCT_PAGE_114_PKG;




/

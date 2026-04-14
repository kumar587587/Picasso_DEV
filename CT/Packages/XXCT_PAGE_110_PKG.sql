--------------------------------------------------------
--  DDL for Package XXCT_PAGE_110_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_110_PKG" 
AS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CPC601 - XXCT_PAGE_110_PKG
   *
   * DESCRIPTION
   * Program to support Credit Tool (CT) functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        04-12-2018  Initial Version
   * Geert Engbers        24-12-2018  Added new functionality
   **************************************************************/
   --
-- $Id: XXCT_PAGE_110_PKG.pks,v 1.2 2019/01/24 12:33:26 rikke493 Exp $
-- $Log: XXCT_PAGE_110_PKG.pks,v $
-- Revision 1.2  2019/01/24 12:33:26  rikke493
-- Added new functionality
--
-- Revision 1.1  2018/12/05 15:07:48  rikke493
-- Initial revision
--
--
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_110_PKG.pks,v 1.2 2019/01/24 12:33:26 rikke493 Exp $';
--   G110_RESOURCE_ID    number;
--   G110_YEAR           varchar2(5);
--   G110_CRS            varchar2(25);
--   G110_CATEGORY_ID    NUMBER;
--   G110_FUND           varcHAR2(5);
--   G110_PAYMENT        varcHAR2(5);
--   G110_CREDIT         varcHAR2(5);
--   G110_OWNED_BY_ME    varcHAR2(5);
--   G110_TYPE_SELECTION varcHAR2(500);
--   G110_AMOUNT_FROM    NUMBER;
--   G110_AMOUNT_TO      NUMBER;
   ----------------------------------------------------------------------------------
   function get_package_body_version return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version return varchar2;
   ----------------------------------------------------------------------------------
   --type T_totals is record( total_count number,akkoord_count number, nog_tekenen_count number, afgekeurd_count number);
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
--   function get_global( p_global_name in varchar2)
--   return varchar2;
--   ---------------------------------------------------------------------------------------------
--   procedure set_global( p_global_name in varchar2, p_value in varchar2
--   ) ;
END XXCT_PAGE_110_PKG;





/

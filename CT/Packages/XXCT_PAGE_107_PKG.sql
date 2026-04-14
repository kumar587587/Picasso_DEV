--------------------------------------------------------
--  DDL for Package XXCT_PAGE_107_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_107_PKG" 
AS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CPC601 - XXCT_PAGE_107_PKG
   *
   * DESCRIPTION
   * Program to support Credit Tool (CT) functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        04-12-2018  Initial Version
   **************************************************************/
   --
-- $Id: XXCT_PAGE_107_PKG.pks,v 1.1 2018/12/05 15:07:03 rikke493 Exp $
-- $Log: XXCT_PAGE_107_PKG.pks,v $
-- Revision 1.1  2018/12/05 15:07:03  rikke493
-- Initial revision
--

   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_107_PKG.pks,v 1.1 2018/12/05 15:07:03 rikke493 Exp $';
   ----------------------------------------------------------------------------------
   function get_package_body_version return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version return varchar2;
   ----------------------------------------------------------------------------------
   function region_updateable
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shw_region
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shbutton
          ( p_button_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function condition
          ( p_condition_name in varchar2
          )
    return boolean;
   ----------------------------------------------------------------------------------
   function default_value
          ( p_field_name        in     varchar2
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   function is_read_only
          ( p_field_name           in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shfield
          ( p_field_name              in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function validation_function
          ( p_validation_name           in     varchar2
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   function  execute_validation ( p_validation_name in varchar2)
   return boolean;
   ----------------------------------------------------------------------------------
   function execute_dynamic_actions
          ( p_dynamic_action_name in varchar2)
   return boolean;
   --
END XXCT_PAGE_107_PKG;





/

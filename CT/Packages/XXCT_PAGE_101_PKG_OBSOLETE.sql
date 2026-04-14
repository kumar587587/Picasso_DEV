--------------------------------------------------------
--  DDL for Package XXCT_PAGE_101_PKG_OBSOLETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_101_PKG_OBSOLETE" 
AS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CPC601 - XXCT_PAGE_101_PKG_OBSOLETE
   *
   * DESCRIPTION
   * Program to support Credit Tool (CT) functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        04-12-2018  Initial Version
   * Geert Engbers        11-02-2019  Added delete_export_file (ODO-439).
   * Geert Engbers        30-07-2019  ODO-835 Changed queries and procedure to improve performance.
   **************************************************************/
   --
-- $Id: XXCT_PAGE_101_PKG_OBSOLETE.pks,v 1.3 2019/07/30 12:27:14 engbe502 Exp $
-- $Log: XXCT_PAGE_101_PKG_OBSOLETE.pks,v $
-- Revision 1.3  2019/07/30 12:27:14  engbe502
-- ODO-835
--
-- Revision 1.2  2019/02/11 13:39:05  rikke493
-- ODO-439
--
-- Revision 1.1  2018/12/05 15:07:19  rikke493
-- Initial revision
--

   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_101_PKG_OBSOLETE.pks,v 1.3 2019/07/30 12:27:14 engbe502 Exp $';
   c_status_pending              CONSTANT VARCHAR2(20)  := 'nog tekenen';
   c_status_approved             CONSTANT VARCHAR2(20)  := 'Goedgekeurd';
   c_status_rejected             CONSTANT VARCHAR2(20)  := 'Afgekeurd';
   ----------------------------------------------------------------------------------
   function get_package_body_version return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version return varchar2;
   ----------------------------------------------------------------------------------
   type T_totals is record( total_count number,akkoord_count number, nog_tekenen_count number, afgekeurd_count number);
   ----------------------------------------------------------------------------------
   function region_updateable
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function show_region
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function show_button
          ( p_button_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function dossier_validation
          ( p_dossier_id     in     number
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   procedure delete_dossier
          ( p_dossier_id         in     number
          );
   ----------------------------------------------------------------------------------
   function check_condition
          ( p_condition_name in varchar2
          )
    return boolean;
   ----------------------------------------------------------------------------------
   function default_value
          ( p_field_name        in     varchar2
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   procedure set_accordeurs_defaults;
   ----------------------------------------------------------------------------------
   function is_read_only
          ( p_field_name           in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function show_field
          ( p_field_name              in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function ct_error_handling
          (  p_error in apex_error.t_error )
   return apex_error.t_error_result;
   ----------------------------------------------------------------------------------
   function show_approve_records
          ( p_status         in     varchar2
          , p_dossier_id     in     number
          , p_active_filter  in     varchar2
          , p_mandate_cycle  in     number
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   function only_show_channel_mngr_dssrs
          ( p_dossier_id              in     number
          , p_owned_by_me             in     varchar2
          , p_user_id                 in     number
          , p_status                  in     varchar2
          , p_resource_id             in     number
          , p_count_mandates          in     number
          , p_max_mandate_cycle       in     number
          , p_channel_manager_user_id in     number
          , p_change_type             in     varchar2
          , p_decrease_user_id        in     number
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   procedure count_all_status;
   ----------------------------------------------------------------------------------
   function show_checkbox
          ( p_checkbox_name         in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   procedure Set_Values_on_Page_Load;
   ----------------------------------------------------------------------------------
   procedure delete_export_file
          ( p_delete_export_file_name    in     varchar2
          );
   --
   function get_status_pending
   return varchar2
   ;
END XXCT_PAGE_101_PKG_OBSOLETE;





/

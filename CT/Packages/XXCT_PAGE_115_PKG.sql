--------------------------------------------------------
--  DDL for Package XXCT_PAGE_115_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_115_PKG" 
IS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CPC601 - XXCT_PAGE_115_PKG
   *
   * DESCRIPTION
   * Program to support ttttt functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        xxxxx  Initial Version.
   **************************************************************/
   --
   -- $Id: XXCT_PAGE_115_PKG.pks,v 1.2 2019/10/15 19:42:14 engbe502 Exp $
   -- $Log: XXCT_PAGE_115_PKG.pks,v $
   -- Revision 1.2  2019/10/15 19:42:14  engbe502
   -- ODO-701
   --
   -- Revision 1.1  2019/10/02 18:21:27  engbe502
   -- Initial revision
   --
   --
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_115_PKG.pks,v 1.2 2019/10/15 19:42:14 engbe502 Exp $';   ---------------------------------------------------------------------------------------------
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
   procedure Set_Values_on_Page_Load
   ;
   ---------------------------------------------------------------------------------------------
   function default_value
          ( p_field_name        in     varchar2
          )
   return varchar2
   ;

END XXCT_PAGE_115_PKG;





/

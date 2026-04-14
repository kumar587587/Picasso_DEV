--------------------------------------------------------
--  DDL for Package XXCT_PAGE_108_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_108_PKG" 
IS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CT602 - XXCT_PAGE_108_PKG
   *
   * DESCRIPTION
   * Program to support APEX CT functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        03-05-2019  Initial Version.
   **************************************************************/
   --
   -- $Id: XXCT_PAGE_108_PKG.pks,v 1.2 2019/05/29 08:51:01 engbe502 Exp $
   -- $Log: XXCT_PAGE_108_PKG.pks,v $
   -- Revision 1.2  2019/05/29 08:51:01  engbe502
   -- ODO-461
   --
   -- Revision 1.1  2019/05/07 12:15:09  engbe502
   -- Initial revision
   --
   --
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_108_PKG.pks,v 1.2 2019/05/29 08:51:01 engbe502 Exp $';
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
   function dv_dossier_number_full
   return varchar2
   ;
   function shw_region
          ( p_region_name   in varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
   function dv_dossier_number
   return varchar2
   ;
   ---------------------------------------------------------------------------------------------
   function shfield
          ( p_field_name              in     varchar2
          )
   return boolean
   ;
   function shf_letter_suffix
   return boolean
   ;
END XXCT_PAGE_108_PKG;





/

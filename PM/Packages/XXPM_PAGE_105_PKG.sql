--------------------------------------------------------
--  DDL for Package XXPM_PAGE_105_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_PAGE_105_PKG" 
IS 
  /**************************************************************** 
   * 
   * PROGRAM NAME 
   *  XXPM_PAGE_105_PKG 
   * 
   * DESCRIPTION 
   * Program to support apex functionality for page 105 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Geert Engbers       08-02-2021  Initial Version. 
   **************************************************************/ 
   -- 
   -- $Id: XXPM_PAGE_105_PKG.pks,v 1.1 2021/02/10 13:09:47 engbe502 Exp $ 
   -- $Log: XXPM_PAGE_105_PKG.pks,v $ 
   -- Revision 1.1  2021/02/10 13:09:47  engbe502 
   -- Initial revision 
   -- 
   -- 
   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXPM_PAGE_105_PKG.pks,v 1.1 2021/02/10 13:09:47 engbe502 Exp $'; 
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
          ( p_business_rule              in     varchar2 
          ) 
   return boolean 
   ; 
   --------------------------------------------------------------------------------------------- 
   function read_only 
          ( p_business_rule              in     varchar2 
          ) 
   return boolean 
   ; 
END XXPM_PAGE_105_PKG; 





/

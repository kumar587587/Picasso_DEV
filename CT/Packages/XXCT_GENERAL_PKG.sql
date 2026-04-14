--------------------------------------------------------
--  DDL for Package XXCT_GENERAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_GENERAL_PKG" 
AS
/****************************************************************
*
* PROGRAM NAME
*  CPC601 - XXCT_GENERAL_PKG
*
* DESCRIPTION
* Program to support Credit Tool (CT) functionality
*
* CHANGE HISTORY
* Who                 When         What
* -------------------------------------------------------------
* Geert Engbers        04-12-2018  Initial Version
* Geert Engbers        16-12-2018  Added read_fileToBlob
* Geert Engbers        19-12-2018  Added global for scenario creation functionality (not needed in production)
* Geert Engbers        11-02-2019  Added clob2blob and get_ebs_user_name (ODO-524)
**************************************************************/
   --
-- $Id: XXCT_GENERAL_PKG.pks,v 1.4 2019/02/11 13:38:44 rikke493 Exp $
-- $Log: XXCT_GENERAL_PKG.pks,v $
-- Revision 1.4  2019/02/11 13:38:44  rikke493
-- ODO-524
--
-- Revision 1.3  2018/12/19 19:35:26  rikke493
-- Added global for scenario creation functionality (not needed in production).
--
-- Revision 1.2  2018/12/16 13:54:41  rikke493
-- Added read_fileToBlob.
--
-- Revision 1.1  2018/12/05 15:06:42  rikke493
-- Initial revision
--

   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_GENERAL_PKG.pks,v 1.4 2019/02/11 13:38:44 rikke493 Exp $';
   --g_circumvent_insert_actns     boolean := false;  /* global for scenario creation functionality (not needed in production) */
   ----------------------------------------------------------------------------------
   function get_package_body_version return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version return varchar2;
   ----------------------------------------------------------------------------------
   function verify_session
   return boolean;
   ----------------------------------------------------------------------------------
   function ct_error_handling
          (  p_error in apex_error.t_error )
   return apex_error.t_error_result;
   ----------------------------------------------------------------------------------
   function get_responsibility
   return varchar2;
   --
   function read_fileToBlob
          ( p_filename            in varchar2
          , p_directory           in varchar2
          )
   return blob;
   ----------------------------------------------------------------------------------
   procedure apps_ct_initialize;
   ----------------------------------------------------------------------------------
   function clob2blob
          ( p_clob              in     clob
          )
   return blob
   ;
   ----------------------------------------------------------------------------------
   function get_user_name
   return varchar2;
   --
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------        
   FUNCTION count_active_user_roles  
   RETURN number
   ;
   --  
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------        
   FUNCTION get_developer_user  
   RETURN varchar2
   DETERMINISTIC
   ;
   --  
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
   procedure set_developer_user  ( p_developer_user in varchar2 )
   ;     
END XXCT_GENERAL_PKG;

/

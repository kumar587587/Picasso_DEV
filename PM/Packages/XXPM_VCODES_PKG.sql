--------------------------------------------------------
--  DDL for Package XXPM_VCODES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_VCODES_PKG" AUTHID DEFINER AS 
   /*************************************************************************** 
   * 
   * PROGRAM NAME 
   *    PM301 - XXPM_VCODES_PKG 
   * 
   * DESCRIPTION 
   *    Package for Generating a new vcode 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Geert Engbers       08-10-2020   Initial Version. 
   * W.J. Bakker         29-12-2020   Updated for new Vcode generator 
   * Wiljo Bakker        16-09-2024   Rebuild for use logging in Cloud   
   **************************************************************/

   -- $Id: XXPM_VCODES_PKG.pks,v 1.4 2024/09/20 15:45:16 bakke619 Exp $
   -- $Log: XXPM_VCODES_PKG.pks,v $
   -- Revision 1.4  2024/09/20 15:45:16  bakke619
   -- updated for Cloud and added batch logging
   --

   -- GLOBALS 
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXPM_VCODES_PKG'; 
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXPM_VCODES_PKG.pks,v 1.4 2024/09/20 15:45:16 bakke619 Exp $'; 

   g_user_id                              NUMBER                         := -1; 
   g_session_id                           NUMBER                         := -1; 

   -- GLOBAL CONSTANTS 
   gc_bah_code                   CONSTANT VARCHAR2(20)      := 'PM301'; 
   gc_test                       CONSTANT BOOLEAN                        := FALSE; 

   gc_lu_current_letter_code     CONSTANT VARCHAR2(200)                  := 'VCODE_LETTERS'; 
   gc_lu_exception_list          CONSTANT VARCHAR2(200)                  := 'VCODE_LETTER_EXCEPTIONS'; 
   gc_YES                        CONSTANT VARCHAR2(10)                   := 'Y'; 

   TYPE T_EXCLUDE                         IS TABLE  OF VARCHAR2(5)      INDEX BY VARCHAR2(5) ; 

   FUNCTION generate_vcode                                  RETURN VARCHAR2; 

END XXPM_VCODES_PKG;

/

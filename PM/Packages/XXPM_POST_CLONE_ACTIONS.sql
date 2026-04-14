--------------------------------------------------------
--  DDL for Package XXPM_POST_CLONE_ACTIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_POST_CLONE_ACTIONS" AUTHID DEFINER
AS
   /********************************************************************************************************************************
   *
   *
   * PROGRAM NAME
   *    XXPM_POST_CLONE_ACTIONS
   *
   * DESCRIPTION
   *   Program contains steps to update non-prod environment in WKSP_XXPM after the environment has been cloned.
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        26-09-2024  Initial Version
   *
   ******************************************************************************************************************************/

   -- $Id: XXPM_POST_CLONE_ACTIONS.pks,v 1.1 2024/10/17 08:37:36 bakke619 Exp $
   -- $Log: XXPM_POST_CLONE_ACTIONS.pks,v $
   -- Revision 1.1  2024/10/17 08:37:36  bakke619
   -- Initial revision
   -- 

   ----------------------------------------------------------------------------
   --  GLOBALS
   ----------------------------------------------------------------------------
   g_fail_on_production     BOOLEAN                              := wksp_xxapi.fail_on_production;
   g_environment_name       VARCHAR2(240)                        := NULL;
   g_database_name          VARCHAR2(240)                        := NULL;

   ----------------------------------------------------------------------------
   --  GLOBAL CONSTANTS
   ----------------------------------------------------------------------------
   gc_package_spec_version  CONSTANT        VARCHAR2(200)        := '$Id: XXPM_POST_CLONE_ACTIONS.pks,v 1.1 2024/10/17 08:37:36 bakke619 Exp $';
   gc_package_name          CONSTANT        VARCHAR2(200)        := 'XXPM_POST_CLONE_ACTIONS';

   gc_production_instance   CONSTANT        VARCHAR2(200)        := 'APXPRD';

   gc_search_text           CONSTANT        VARCHAR2(200)        := '@@^^@@';
   gc_empty                 CONSTANT        VARCHAR2(200)        := '@@^^@@';
   
   gc_default_password      CONSTANT        VARCHAR2(100)        := 'Welcome-456!';

   gc_default_sender        CONSTANT        VARCHAR2(100)        := 'noreply@kpn.com';
   gc_email_address_appl    CONSTANT        VARCHAR2(200)        := 'Picasso@kpn.com';

   gc_message_1             CONSTANT        VARCHAR2(200)        := '-- THIS MESSAGE IS SEND FROM '||gc_search_text||' !! --';

   gc_quote                 CONSTANT        VARCHAR2(1)          := CHR(39);
   gc_double_quote          CONSTANT        VARCHAR2(1)          := CHR(34);
   gc_space                 CONSTANT        VARCHAR2(1)          := CHR(32);


   FUNCTION get_package_body_version      RETURN VARCHAR2;

   FUNCTION get_package_spec_version      RETURN VARCHAR2;

   PROCEDURE deactivate_api;
   
   PROCEDURE activate_api;   

   PROCEDURE update_environment;
   
   PROCEDURE clear_debug;

   PROCEDURE main;

END XXPM_POST_CLONE_ACTIONS;

/

  GRANT EXECUTE ON "WKSP_XXPM"."XXPM_POST_CLONE_ACTIONS" TO "WKSP_XXAPI";

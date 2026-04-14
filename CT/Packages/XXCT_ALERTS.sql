--------------------------------------------------------
--  DDL for Package XXCT_ALERTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_ALERTS" AUTHID CURRENT_USER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    CT401 - XXCT_ALERTS
   *
   * DESCRIPTION
   *    Package to check for and send alerts and send notifications to users
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         07/12/2018  Initial Version
   * W.J. Bakker         17/12/2018  Fixed Defects
   * W.J. Bakker         19/12/2018  Added new triggering
   * W.J. Bakker         20/12/2018  Fixed defects from TE020
   * W.J. Bakker         28/12/2018  Fixed defect 185 and 188
   * Wiljo Bakker        03/01/2019  Added status for notifications
   * Wiljo Bakker        26/03/2019  Added partner-id as this can be updated with status change.
   * Wiljo Bakker        04/06/2019  Added extra globals for Vrijval notificaltion.
   * Wiljo Bakker        25-09-2024  Rebuild for use in Cloud   
   **************************************************************/
   --
   -- $Id: $
   -- $Log: $

   -- GLOBALS VARIABLES
   g_org_id                       NUMBER              := 82;
   g_user_id                      NUMBER              := -1;
   g_session_id                   NUMBER              := -1;
   g_email_template               VARCHAR2 (50)       := 'CT_EMAIL_APPROVED';
   g_default_sender               VARCHAR2 (500)      :=  nvl(wksp_xxapi.xxapi_batch.get_settings_value('SENDER_EMAIL','BATCH_EMAIL'),'noreply@kpn.com');

   -- GLOBAL CONSTANTS
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXCT_ALERTS';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXCT_ALERTS.pks,v 1.16 2019/06/05 13:41:36 bakke619 Exp $';

   gc_test                       CONSTANT BOOLEAN                        := FALSE;
   gc_tab                        CONSTANT VARCHAR2(1)                    := CHR(9);
   gc_eol                        CONSTANT VARCHAR2(1)                    := CHR(10);
   gc_date_format                CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY';
   gc_date_format2               CONSTANT VARCHAR2 (30)                  := 'DD-MON-YYYY';
   gc_date_format_long           CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY HH24:MI:SS';
   gc_EMPTY                      CONSTANT VARCHAR2 (30)                  := '_@@NULL@@_';

   -- list replacements
   gc_list_start                 CONSTANT VARCHAR2 (30)                  := '{list}';
   gc_list_end                   CONSTANT VARCHAR2 (30)                  := '{/list}';

   gc_APEX_URL_PO                CONSTANT VARCHAR2 (50)                  := 'FND_APEX_URL';
   gc_EBS_URL_PO                 CONSTANT VARCHAR2 (50)                  := 'AMS_SERVER_URL';
   gc_PROFILE_VRIJVAL_ACCORDEUR  CONSTANT VARCHAR2 (50)                  := 'XXCT_VRIJVAL_CONTROLEUR';

   -- Mandate statussed
   gc_DECLINED                   CONSTANT VARCHAR2 (50)                  := 'AFGEKEURD';
   gc_APPROVED                   CONSTANT VARCHAR2 (50)                  := 'AKKOORD';
   gc_TO_SIGN                    CONSTANT VARCHAR2 (50)                  := 'NOG TEKENEN';
   gc_DECREASED                  CONSTANT VARCHAR2 (50)                  := 'DECREASED';


   -- Case statusses to act on
   gc_status_PROCURATIE          CONSTANT VARCHAR2 (50)                  := 'PROCURATIE';
   gc_status_CONTROLE            CONSTANT VARCHAR2 (50)                  := 'CONTROLE';
   gc_status_OPEN                CONSTANT VARCHAR2 (50)                  := 'OPEN';
   gc_status_HEROPEND            CONSTANT VARCHAR2 (50)                  := 'HEROPEND';
   gc_status_AFGESLOTEN          CONSTANT VARCHAR2 (50)                  := 'AFGESLOTEN';

   -- Mail templates setup in Lookups
   gc_APPROVAL_A                 CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_APPROVAL_A';
   gc_REJECTION_A                CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_REJECTION_A';
   gc_REJECTION_B                CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_REJECTION_B';
   gc_CHANNEL_M_A                CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_CHANNEL_MGR_A';
   gc_APPROVER_A                 CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_APPROVER_A';

   -- html layout
   gc_row_header_color           CONSTANT VARCHAR2(20)                   := '#d8d8d8';
   gc_row_odd_color              CONSTANT VARCHAR2(20)                   := '#ffffff';
   gc_row_even_color             CONSTANT VARCHAR2(20)                   := '#f2f2f2';

   -- TYPES
   TYPE T_ROW_REC                IS RECORD     ( cell1       VARCHAR2(2000)
                                               , cell2       VARCHAR2(2000)
                                               , cell3       VARCHAR2(2000)
                                               , cell4       VARCHAR2(2000)
                                               , cell5       VARCHAR2(2000)
                                               , cell6       VARCHAR2(2000)
                                               , cell7       VARCHAR2(2000)
                                               , cell8       VARCHAR2(2000)
                                               , cell9       VARCHAR2(2000)
                                               , cell10      VARCHAR2(2000)
                                               );

   TYPE T_EMAIL_REC              IS RECORD     ( mailfrom      VARCHAR2(2000)
                                               , mailto        VARCHAR2(2000)
                                               , cc            VARCHAR2(2000)
                                               , bcc           VARCHAR2(2000)
                                               );

   TYPE T_REPLACE_TYPE           IS TABLE OF VARCHAR2(240)   INDEX BY VARCHAR2(240);
   TYPE T_BODY_TEXT              IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;

   g_replace_table               t_replace_type;

   -- FUNCTIONS
   FUNCTION get_package_body_version      RETURN VARCHAR2;

   FUNCTION get_package_spec_version      RETURN VARCHAR2;

   -- PROCEDURES
--   PROCEDURE send_notification              ( p_dossier_id       in      NUMBER
--                                            , p_status_old       in      VARCHAR2 DEFAULT NULL
--                                            , p_status_new       in      VARCHAR2
--                                            , p_resource_id_new  in      NUMBER   DEFAULT NULL
--                                            );

   PROCEDURE send_action_list_notification   ( p_person_id       in      NUMBER
                                            , p_email_template   in      VARCHAR2
                                            );

   PROCEDURE make_action_list_and_send  ( p_email_template   in      VARCHAR2 DEFAULT NULL );


   FUNCTION is_number ( p_value IN VARCHAR2 ) RETURN NUMBER;

END XXCT_ALERTS;


/

--------------------------------------------------------
--  DDL for Package XXCT_PARTNER_COMMUNICATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PARTNER_COMMUNICATION" AUTHID CURRENT_USER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    CT302 - XXCT_PARTNER_COMMUNICATION
   *
   * DESCRIPTION
   *    Package to check for and send partner letter and upload documents to portal
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         17-12-2018  Initial Version
   * Wiljo Bakker        03-01-2019  Added status for notifications
   * Wiljo Bakker        04-01-2019  Added BUSY status
   * Wiljo Bakker        28-01-2019  Added resend option
   * Wiljo Bakker        26-04-2021  Added seperate templates for Retail/Digital
   * Wiljo Bakker        28-04-2021  Added check on instance, only send emails to partners on PRD.
   * Wiljo Bakker        06-10-2022  Added function to get partner specific export directory from salesrep table
   **************************************************************/

   -- $Id: XXCT_PARTNER_COMMUNICATION.pks,v 1.14 2022/10/06 15:03:34 bakke619 Exp $
   -- $Log: XXCT_PARTNER_COMMUNICATION.pks,v $
   -- Revision 1.14  2022/10/06 15:03:34  bakke619
   -- ODO-1600 - Move files to partner specific location
   --
   -- Revision 1.13  2021/04/28 15:51:36  bakke619
   -- ODO-1419
   --
   -- Revision 1.12  2021/04/26 15:56:24  bakke619
   -- ODO-1419
   --
   -- Revision 1.11  2021/04/26 14:25:04  bakke619
   -- ODO-1419
   --
   -- Revision 1.10  2019/01/30 13:14:29  bakke619
   -- Added new status
   --
   -- Revision 1.9  2019/01/28 09:05:10  bakke619
   -- Added resend option
   --
   -- Revision 1.8  2019/01/04 19:45:52  bakke619
   -- Added retry procedure
   --
   -- Revision 1.7  2019/01/03 22:53:22  bakke619
   -- Added status to notifications table
   --
   -- Revision 1.5  2018/12/21 14:42:44  bakke619
   -- *** empty log message ***
   --
   -- Revision 1.4  2018/12/21 14:21:53  bakke619
   -- removed test parameter
   --
   -- Revision 1.3  2018/12/21 13:51:44  bakke619
   -- added partner letter and exhibits
   --
   -- Revision 1.2  2018/12/20 10:23:45  bakke619
   -- removed debug
   --
   -- Revision 1.1  2018/12/19 14:38:44  bakke619
   -- Initial revision
   --

   -- GLOBAL CONSTANTS
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXCT_PARTNER_COMMUNICATION';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXCT_PARTNER_COMMUNICATION.pks,v 1.14 2022/10/06 15:03:34 bakke619 Exp $';

   gc_bah_code                   VARCHAR2(20) /*CONSTANT ICE_BATCHES.BAH_CODE%TYPE */     := 'CT302';

   gc_directory_test             CONSTANT VARCHAR2(30)                   := 'XXICE_TV_DIGISPEC_TEST';
   gc_directory_export           CONSTANT VARCHAR2(30)                   := 'XXICE_TV_DIGISPEC_EXPORT_CM';
   gc_directory_working          CONSTANT VARCHAR2(30)                   := 'XXICE_TV_DIGISPEC_WORKING';
   gc_directory_archive          CONSTANT VARCHAR2(30)                   := 'XXICE_TV_DIGISPEC_ARCHIVE';
   gc_directory_error            CONSTANT VARCHAR2(30)                   := 'XXICE_TV_DIGISPEC_ERROR';

   gc_temp_directory             CONSTANT VARCHAR2 (50)                  := 'XXICE_TEMP';

   gc_test                       CONSTANT BOOLEAN                        := FALSE;
   gc_tab                        CONSTANT VARCHAR2(1)                    := CHR(9);
   gc_eol                        CONSTANT VARCHAR2(1)                    := CHR(10);

   gc_production_instance        CONSTANT VARCHAR2 (30)                  := 'D2597P';
   gc_default_mail_to            CONSTANT VARCHAR2 (240)                 := 'odis-apps-mail@kpn.com';

   gc_number_format              CONSTANT VARCHAR2 (30)                  := '999G999G999G999G990D00';
   gc_date_format                CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY';
   gc_date_format2               CONSTANT VARCHAR2 (30)                  := 'DD-MON-YYYY';
   gc_date_format_long           CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY HH24:MI:SS';
   gc_empty                      CONSTANT VARCHAR2 (30)                  := '_@@NULL@@_';

   gc_wait                       CONSTANT NUMBER                         := 5;
   gc_tries                      CONSTANT NUMBER                         := 20;
   gc_max_days_try               CONSTANT NUMBER                         := 1;

   -- list replacements
   gc_list_start                 CONSTANT VARCHAR2 (30)                  := '{list}';
   gc_list_end                   CONSTANT VARCHAR2 (30)                  := '{/list}';

   -- Mail templates setup in Lookups
   gc_LETTER_TEMPLATE            CONSTANT VARCHAR2 (50)                  := 'CT_EMAIL_PNR_LETTER_A';

   gc_RETAIL                     CONSTANT VARCHAR2 (50)                  := UPPER('Retail');
   gc_DIGITAL                    CONSTANT VARCHAR2 (50)                  := UPPER('Digital');

   -- Case statusses to act on
   gc_status_PROCURATIE          CONSTANT VARCHAR2 (50)                  := 'PROCURATIE';
   gc_status_CONTROLE            CONSTANT VARCHAR2 (50)                  := 'CONTROLE';
   gc_status_OPEN                CONSTANT VARCHAR2 (50)                  := 'OPEN';
   gc_status_HEROPEND            CONSTANT VARCHAR2 (50)                  := 'HEROPEND';
   gc_status_AFGESLOTEN          CONSTANT VARCHAR2 (50)                  := 'AFGESLOTEN';
   gc_status_FACTURATIE          CONSTANT VARCHAR2 (50)                  := 'FACTURATIE';

   -- notification status
   gc_status_NEW                 CONSTANT VARCHAR2 (50)                  := 'NEW';
   gc_status_BUSY                CONSTANT VARCHAR2 (50)                  := 'BUSY';
   gc_status_RETRY               CONSTANT VARCHAR2 (50)                  := 'RETRY';
   gc_status_SEND                CONSTANT VARCHAR2 (50)                  := 'SEND';
   gc_status_NOT_SEND            CONSTANT VARCHAR2 (50)                  := 'NOT_SEND';
   gc_status_ERROR               CONSTANT VARCHAR2 (50)                  := 'ERROR';
   gc_status_OBSOLETE            CONSTANT VARCHAR2 (50)                  := 'OBSOLETE';

   -- html layout
   gc_row_header_color           CONSTANT VARCHAR2(20)                   := '#d8d8d8';
   gc_row_odd_color              CONSTANT VARCHAR2(20)                   := '#ffffff';
   gc_row_even_color             CONSTANT VARCHAR2(20)                   := '#f2f2f2';

   -- GLOBALS VARIABLES
   g_org_id                               NUMBER                         := 82;
   g_user_id                              NUMBER                         := -1;
   g_session_id                           NUMBER                         := -1;
   g_instance                             VARCHAR2(100)                  := NULL;
   g_email_template                       VARCHAR2 (50)                  := gc_LETTER_TEMPLATE||'_'||gc_RETAIL;
   --g_default_sender                       VARCHAR2 (500)                 := NVL(xxice_utils.get_ice_settings('ICE_ADMIN_EMAIL'),'noreply@accept1.safemailtest.nl');
   g_default_sender                       VARCHAR2 (500)                 := 'noreply@accept1.safemailtest.nl';
   g_empty_clob                           CLOB;
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
   PROCEDURE set_notification       ( p_dossier_id        in  NUMBER
                                    , p_status_old        in  VARCHAR2  DEFAULT NULL
                                    , p_status_new        in  VARCHAR2  );

   PROCEDURE check_actions          ( p_notification_type in  VARCHAR2  DEFAULT 'CT_EMAIL%LETTER');

   PROCEDURE resend_partner_letter  ( p_dossier_id        in  NUMBER
                                    , p_email_address_to  in  VARCHAR2
                                    );

END XXCT_PARTNER_COMMUNICATION;



/

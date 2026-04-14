--------------------------------------------------------
--  DDL for Package XXCT_NOTIFICATIONS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_NOTIFICATIONS_PKG" AUTHID CURRENT_USER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    CT-GENERIC - XXCT_NOTIFICATIONS_PKG
   *
   * DESCRIPTION
   *    Package to register notification history
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         19/12/2018  Initial Version
   * Wiljo Bakker        03/01/2019  Added status for notifications 
   * Wiljo Bakker        30/01/2019  Added statusupdate on obsolete notifications
   * Wiljo Bakker        25-09-2024  Rebuild for use in Cloud   
   **************************************************************/
   --
   -- $Id: $
   -- $Log: $

   -- GLOBAL CONSTANTS
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXCT_NOTIFICATIONS_PKG';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: $';

   gc_date_format                CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY';
   gc_date_format2               CONSTANT VARCHAR2 (30)                  := 'DD-MON-YYYY';
   gc_date_format_long           CONSTANT VARCHAR2 (30)                  := 'DD-MM-YYYY HH24:MI:SS';
   gc_empty                      CONSTANT VARCHAR2 (30)                  := '_@@NULL@@_';

   -- notification status
   gc_status_NEW                 CONSTANT VARCHAR2 (50)                  := 'NEW';
   gc_status_BUSY                CONSTANT VARCHAR2 (50)                  := 'BUSY';
   gc_status_RETRY               CONSTANT VARCHAR2 (50)                  := 'RETRY';   
   gc_status_SEND                CONSTANT VARCHAR2 (50)                  := 'SEND';
   gc_status_NOT_SEND            CONSTANT VARCHAR2 (50)                  := 'NOT_SEND';      
   gc_status_ERROR               CONSTANT VARCHAR2 (50)                  := 'ERROR';      
   gc_status_OBSOLETE            CONSTANT VARCHAR2 (50)                  := 'OBSOLETE';   

   -- GLOBALS VARIABLES
   g_org_id                               NUMBER                         := 82;
   g_user_id                              NUMBER                         := -1;
   g_session_id                           NUMBER                         := -1;

   -- FUNCTIONS 
   FUNCTION get_package_body_version      RETURN VARCHAR2;   

   FUNCTION get_package_spec_version      RETURN VARCHAR2;

   FUNCTION get_notification              ( p_notification_id    in      NUMBER ) RETURN XXCT_NOTIFICATIONS%ROWTYPE;

   FUNCTION get_latest_notification       ( p_dossier_id         in      NUMBER 
                                          , p_notification_type  in      VARCHAR2 ) RETURN XXCT_NOTIFICATIONS%ROWTYPE;

   -- PROCEDURES
   PROCEDURE insert_notification          ( p_notification       in             XXCT_NOTIFICATIONS%ROWTYPE );

   PROCEDURE insert_notification          (  p_not_type          in             VARCHAR2 
                                           , p_not_from          in             VARCHAR2    
                                           , p_not_to            in             VARCHAR2 
                                           , p_not_cc            in             VARCHAR2 
                                           , p_not_bcc           in             VARCHAR2 
                                           , p_not_subject       in             VARCHAR2 
                                           , p_not_body          in             CLOB     
                                           , p_not_attachments   in             VARCHAR2 
                                           , p_not_dossier_id    in             NUMBER   
                                           , p_not_status        in             VARCHAR2
                                           );

   PROCEDURE update_notification           ( p_notification      in             XXCT_NOTIFICATIONS%ROWTYPE );

   PROCEDURE obsolete_unsend_notifications ( p_notification      in             XXCT_NOTIFICATIONS%ROWTYPE );

END XXCT_NOTIFICATIONS_PKG;




/

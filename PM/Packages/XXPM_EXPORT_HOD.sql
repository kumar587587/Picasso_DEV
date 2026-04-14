--------------------------------------------------------
--  DDL for Package XXPM_EXPORT_HOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_EXPORT_HOD" AUTHID DEFINER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    PM302 - XXPM_EXPORT_HOD
   *
   * DESCRIPTION
   *    Package for export of all partner data to HomeOfData
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         29-10-2020   Initial Version
   * W.J. Bakker         30-01-2021   Added MSFT send when files are created
   * Wiljo Bakker        16-09-2024   Rebuild for use logging in Cloud   
   **************************************************************/

   -- $Id: XXPM_EXPORT_HOD.pks,v 1.9 2024/09/20 15:44:40 bakke619 Exp $
   -- $Log: XXPM_EXPORT_HOD.pks,v $
   -- Revision 1.9  2024/09/20 15:44:40  bakke619
   -- updated for Cloud and added batch logging
   --

   -- GLOBALS
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXPM_EXPORT_HOD';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXPM_EXPORT_HOD.pks,v 1.9 2024/09/20 15:44:40 bakke619 Exp $';

   g_test                                 BOOLEAN                        := FALSE;
   g_brn_id                               NUMBER;

   g_user_id                              VARCHAR2(255)                  := -1;
   g_session_id                           NUMBER                         := -1;
   g_instance                             VARCHAR2(100)                  := NULL;

   g_source                               VARCHAR2(100)                  := 'ODIS';
   g_version                              VARCHAR2(100)                  := '1.0';

   g_partner_channel                      VARCHAR2(20)                   := NULL;
   g_retry_unsend                         BOOLEAN                        := FALSE;

   -- GLOBAL CONSTANTS
   gc_production_instance        CONSTANT VARCHAR2 (30)                  := 'APXPRD';
   gc_bah_code                   CONSTANT VARCHAR2 (30)                  := 'PM302';

   gc_tab                        CONSTANT VARCHAR2(1)                    := CHR(9);
   gc_eol                        CONSTANT VARCHAR2(1)                    := CHR(10);
   gc_pipe                       CONSTANT VARCHAR2(1)                    := CHR(124);
   gc_quote                      CONSTANT VARCHAR2(1)                    := CHR(39);
   gc_double_quote               CONSTANT VARCHAR2(1)                    := CHR(34);

   gc_date_format                CONSTANT VARCHAR2(40)                   := 'YYYY-MM-DD';
   gc_datetime_format            CONSTANT VARCHAR2(40)                   := 'YYYY-MM-DD HH24:MI:SS';
   gc_date_format_long           CONSTANT VARCHAR2(25)                   := 'MM/DD/YYYY HH24:MI:SS';

   -- Counters in api_counters_batch for program logging
   gc_MAIN_PNR_EXPORTED          CONSTANT VARCHAR2 (10)                  := 'MPNR_EXP';
   gc_SUB_PNR_EXPORTED           CONSTANT VARCHAR2 (10)                  := 'SPNR_EXP';
   gc_ADDRESSES_EXPORTED         CONSTANT VARCHAR2 (10)                  := 'ADDR_EXP';
   gc_CONTACTS_EXPORTED          CONSTANT VARCHAR2 (10)                  := 'CONT_EXP';

   gc_ZIPPED_DONE                CONSTANT VARCHAR2 (10)                  := 'ZIP_DONE';
   gc_PURGED_DONE                CONSTANT VARCHAR2 (10)                  := 'PUR_DONE';

   -- Global types
   TYPE T_FLEX_FIELDS            IS TABLE  OF VARCHAR2(240)              INDEX BY VARCHAR2(240);

   -- PROCEDURES
   PROCEDURE main                ( x_errbuf                           OUT       VARCHAR2
                                 , x_retcode                          OUT       VARCHAR2
                                 , p_full_dump                     IN               VARCHAR2 DEFAULT NULL
                                 , p_date_from                     IN               VARCHAR2 DEFAULT NULL
                                 , p_v_code                        IN               VARCHAR2 DEFAULT NULL
                                 );

   PROCEDURE run;

END XXPM_EXPORT_HOD;

/

--------------------------------------------------------
--  DDL for Package XXPM_IMPORT_SALESFORCE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_IMPORT_SALESFORCE" AUTHID DEFINER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    PM101 - XXPM_IMPORT_SALESFORCE
   *
   * DESCRIPTION
   *    Package for importing partner data from salesforce
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         20/10/2020   Initial Version
   * W.J. Bakker         23/02/2021   Added validations on file
   * W.J. Bakker         01/03/2021   Added scheduling and call to conc request.
   * W.J. Bakker         03/06/2021   Allow sub-partner to change to other main-partner
   * Wiljo Bakker        16-09-2024   Rebuild for use logging in Cloud   
   **************************************************************/

   -- $Id: XXPM_IMPORT_SALESFORCE.pks,v 1.29 2024/09/20 15:44:58 bakke619 Exp $
   -- $Log: XXPM_IMPORT_SALESFORCE.pks,v $
   -- Revision 1.29  2024/09/20 15:44:58  bakke619
   -- updated for Cloud and added batch logging
   --

   e_no_center_code_found   exception;

   -- GLOBAL CONSTANTS
      TYPE G_LINES_TYPE      IS TABLE  OF VARCHAR2(2000)               INDEX BY BINARY_INTEGER;
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXPM_IMPORT_SALESFORCE';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXPM_IMPORT_SALESFORCE.pks,v 1.29 2024/09/20 15:44:58 bakke619 Exp $';
   gc_dda_version                CONSTANT VARCHAR2(200)                  := '1.0';

   gc_bah_code                   CONSTANT VARCHAR2(20)                   := 'PM101';
   gc_bah_code_undo              CONSTANT VARCHAR2(20)                   := 'PM101_UD';
   gc_source                     CONSTANT VARCHAR2(200)                  := 'Salesforce ZM';

   gc_test                       CONSTANT BOOLEAN                        := FALSE;

   -- Translations in ODIS
   gc_EMPTY                      CONSTANT VARCHAR2(10)                   := '-9999';
   gc_E_DATE                     CONSTANT DATE                           := to_date('31-12-9998', 'DD-MM-YYYY');
   gc_NULL                       CONSTANT VARCHAR2(2)                    := NULL;

   gc_JA                         CONSTANT VARCHAR2(2)                    := 'J';
   gc_NEE                        CONSTANT VARCHAR2(2)                    := 'N';

   gc_YES                        CONSTANT VARCHAR2(2)                    := 'Y';
   gc_NO                         CONSTANT VARCHAR2(2)                    := 'N';

   gc_INSERT                     CONSTANT VARCHAR2(2)                    := 'I';
   gc_UPDATE                     CONSTANT VARCHAR2(2)                    := 'U';
   gc_DELETE                     CONSTANT VARCHAR2(2)                    := 'D';

   gc_NEW_PARTNER                CONSTANT VARCHAR2(20)                   := 'NEW_PARTNER';
   gc_NEW_ADDRESS                CONSTANT VARCHAR2(20)                   := 'NEW_ADDRESS';
   gc_NEW_CONTACT                CONSTANT VARCHAR2(20)                   := 'NEW_CONTACT';
   gc_NEW_CHAIN                  CONSTANT VARCHAR2(20)                   := 'NEW_CHAIN';

   gc_production_instance        CONSTANT VARCHAR2 (30)                  := 'APXPRD';
   gc_default_org_id             CONSTANT NUMBER                         := 82;

   gc_tab                        CONSTANT VARCHAR2(1)                    := CHR(9);
   gc_eol                        CONSTANT VARCHAR2(1)                    := CHR(10);
   gc_pipe                       CONSTANT VARCHAR2(1)                    := CHR(124);
   gc_quote                      CONSTANT VARCHAR2(1)                    := CHR(39);
   gc_double_quote               CONSTANT VARCHAR2(1)                    := CHR(34);
   gc_space                      CONSTANT VARCHAR2(1)                    := ' ';

   gc_NOW                        CONSTANT DATE                           := SYSDATE;

   gc_file_date_format           CONSTANT VARCHAR2(40)                   := 'YYYYMMDD_HH24MISS';
   gc_file_suffix                CONSTANT VARCHAR2(40)                   := '.csv';
   gc_file_prefix                CONSTANT VARCHAR2(240)                  := 'Partnerdata_';

   gc_file_pattern               CONSTANT VARCHAR2 (240)                 := gc_file_prefix || '*' ||gc_file_suffix;
   gc_file_size_limit_bytes      CONSTANT NUMBER                         := 10000000;

   gc_working_directory          CONSTANT VARCHAR2 (30)                  := 'XXPM_SALESFORCE_WORKING';
   gc_input_directory            CONSTANT VARCHAR2 (30)                  := 'XXPM_SALESFORCE_IMPORT';
   gc_done_directory             CONSTANT VARCHAR2 (30)                  := 'XXPM_SALESFORCE_DONE';
   gc_archive_directory          CONSTANT VARCHAR2 (30)                  := 'XXPM_SALESFORCE_ARCHIVE';
   gc_error_directory            CONSTANT VARCHAR2 (30)                  := 'XXPM_SALESFORCE_ERROR';

   gc_field_separator            CONSTANT VARCHAR2(10)                   := gc_pipe;

   gc_datetime_format            CONSTANT VARCHAR2(40)                   := 'YYYY-MM-DD HH24:MI:SS';
   gc_date_format_long           CONSTANT VARCHAR2(25)                   := 'MM/DD/YYYY HH24:MI:SS';

   gc_header_record_type         CONSTANT VARCHAR2(20)                   := '10';
   gc_main_partner_record_type   CONSTANT VARCHAR2(20)                   := '20';
   gc_sub_partner_record_type    CONSTANT VARCHAR2(20)                   := '30';
   gc_address_record_type        CONSTANT VARCHAR2(20)                   := '40';
   gc_contact_record_type        CONSTANT VARCHAR2(20)                   := '50';
   gc_chain_record_type          CONSTANT VARCHAR2(20)                   := '89';
   gc_trailer_record_type        CONSTANT VARCHAR2(20)                   := '90';

   gc_main_partner_database_type CONSTANT VARCHAR2(20)                   := 'M';
   gc_sub_partner_database_type  CONSTANT VARCHAR2(20)                   := 'S';

   gc_partner_table              CONSTANT VARCHAR2(50)                   := 'XXPM_PARTNERS';
   gc_address_table              CONSTANT VARCHAR2(50)                   := 'XXPM_ADDRESSES';
   gc_contact_table              CONSTANT VARCHAR2(50)                   := 'XXPM_CONTACTS';
   gc_chain_table                CONSTANT VARCHAR2(50)                   := 'XXPM_CHAINS';
   gc_unknown                    CONSTANT VARCHAR2(50)                   := 'UNKNOWN';

   gc_partner_table_id           CONSTANT VARCHAR2(50)                   := 'PARTNER_ID';
   gc_address_table_id           CONSTANT VARCHAR2(50)                   := 'ADDRESS_ID';
   gc_contact_table_id           CONSTANT VARCHAR2(50)                   := 'CONTACT_ID';
   gc_chain_table_id             CONSTANT VARCHAR2(50)                   := 'CHAIN_ID';

   -- Indicators in ICE_KENGETALLEN_BATCH for main
   gc_READ_MAIN_PARTNER          CONSTANT VARCHAR2 (10)                  := 'READ_MPNR';
   gc_READ_CHAIN                 CONSTANT VARCHAR2 (10)                  := 'READ_CHN';
   gc_READ_SUB_PARTNER           CONSTANT VARCHAR2 (10)                  := 'READ_SPNR';
   gc_READ_ADDRESS               CONSTANT VARCHAR2 (10)                  := 'READ_ADDR';
   gc_READ_CONTACT               CONSTANT VARCHAR2 (10)                  := 'READ_CONT';

   gc_INSERTED_MAIN_PARTNER      CONSTANT VARCHAR2 (10)                  := 'INS_MPNR';
   gc_INSERTED_CHAIN             CONSTANT VARCHAR2 (10)                  := 'INS_CHN';
   gc_INSERTED_SUB_PARTNER       CONSTANT VARCHAR2 (10)                  := 'INS_SPNR';
   gc_INSERTED_ADDRESS           CONSTANT VARCHAR2 (10)                  := 'INS_ADDR';
   gc_INSERTED_CONTACT           CONSTANT VARCHAR2 (10)                  := 'INS_CONT';

   gc_UPDATED_MAIN_PARTNER       CONSTANT VARCHAR2 (10)                  := 'UPD_MPNR';
   gc_UPDATED_CHAIN              CONSTANT VARCHAR2 (10)                  := 'UPD_CHN';
   gc_UPDATED_SUB_PARTNER        CONSTANT VARCHAR2 (10)                  := 'UPD_SPNR';
   gc_UPDATED_ADDRESS            CONSTANT VARCHAR2 (10)                  := 'UPD_ADDR';
   gc_UPDATED_CONTACT            CONSTANT VARCHAR2 (10)                  := 'UPD_CONT';

   gc_UNCHANGED_MAIN_PARTNER     CONSTANT VARCHAR2 (10)                  := 'NOC_MPNR';
   gc_UNCHANGED_CHAIN            CONSTANT VARCHAR2 (10)                  := 'NOC_CHN';
   gc_UNCHANGED_SUB_PARTNER      CONSTANT VARCHAR2 (10)                  := 'NOC_SPNR';
   gc_UNCHANGED_ADDRESS          CONSTANT VARCHAR2 (10)                  := 'NOC_ADDR';
   gc_UNCHANGED_CONTACT          CONSTANT VARCHAR2 (10)                  := 'NOC_CONT';

   gc_ERROR_MAIN_PARTNER         CONSTANT VARCHAR2 (10)                  := 'ERR_MPNR';
   gc_ERROR_CHAIN                CONSTANT VARCHAR2 (10)                  := 'ERR_CHN';
   gc_ERROR_SUB_PARTNER          CONSTANT VARCHAR2 (10)                  := 'ERR_SPNR';
   gc_ERROR_ADDRESS              CONSTANT VARCHAR2 (10)                  := 'ERR_ADDR';
   gc_ERROR_CONTACT              CONSTANT VARCHAR2 (10)                  := 'ERR_CONT';

   gc_PURGED_DONE                CONSTANT VARCHAR2 (10)                  := 'PUR_DONE';
   gc_MOVED_SUBS                 CONSTANT VARCHAR2 (10)                  := 'SUB_MOVE';
   gc_MAIN2SUB                   CONSTANT VARCHAR2 (10)                  := 'MAIN2SUB';
   gc_SUB2MAIN                   CONSTANT VARCHAR2 (10)                  := 'SUB2MAIN';

   -- UNDO INDICATORS
   gc_UNDO_INS_MAIN_PARTNER      CONSTANT VARCHAR2 (10)                  := 'UDI_MPNR';
   gc_UNDO_INS_SUB_PARTNER       CONSTANT VARCHAR2 (10)                  := 'UDI_SPNR';
   gc_UNDO_INS_ADDRESS           CONSTANT VARCHAR2 (10)                  := 'UDI_ADR';
   gc_UNDO_INS_CONTACT           CONSTANT VARCHAR2 (10)                  := 'UDI_CON';
   gc_UNDO_INS_CHAIN             CONSTANT VARCHAR2 (10)                  := 'UDI_CHN';

   gc_UNDO_UPD_MAIN_PARTNER      CONSTANT VARCHAR2 (10)                  := 'UDU_MPNR';
   gc_UNDO_UPD_SUB_PARTNER       CONSTANT VARCHAR2 (10)                  := 'UDU_SPNR';
   gc_UNDO_UPD_ADDRESS           CONSTANT VARCHAR2 (10)                  := 'UDU_ADR';
   gc_UNDO_UPD_CONTACT           CONSTANT VARCHAR2 (10)                  := 'UDU_CON';
   gc_UNDO_UPD_CHAIN             CONSTANT VARCHAR2 (10)                  := 'UDU_CHN';

   -- Error Messages
   gc_MSG_1                      CONSTANT VARCHAR2(50) := 'SQL_ERR';
   gc_MSG_2                      CONSTANT VARCHAR2(50) := 'DUPL_PNR';
   gc_MSG_3                      CONSTANT VARCHAR2(50) := 'DUPL_ADR';
   gc_MSG_4                      CONSTANT VARCHAR2(50) := 'DUPL_CON';
   gc_MSG_5                      CONSTANT VARCHAR2(50) := 'DUPL_CHN';
   gc_MSG_6                      CONSTANT VARCHAR2(50) := 'PNF_ADR';
   gc_MSG_7                      CONSTANT VARCHAR2(50) := 'PNF_CON';
   gc_MSG_8                      CONSTANT VARCHAR2(50) := 'PNF_CHN';
   gc_MSG_9                      CONSTANT VARCHAR2(50) := 'PNF_MPNR';
   gc_MSG_10                     CONSTANT VARCHAR2(50) := 'INV_NUM';
   gc_MSG_11                     CONSTANT VARCHAR2(50) := 'SQL_ERRP';
   gc_MSG_12                     CONSTANT VARCHAR2(50) := 'SQL_ERRA';
   gc_MSG_13                     CONSTANT VARCHAR2(50) := 'SQL_ERRC';
   gc_MSG_14                     CONSTANT VARCHAR2(50) := 'ERR_MAND';
   gc_MSG_15                     CONSTANT VARCHAR2(50) := 'ERR_ORPH';
   gc_MSG_16                     CONSTANT VARCHAR2(50) := 'ERR_SUBS';
   gc_MSG_17                     CONSTANT VARCHAR2(50) := 'ERR_MAIN';

   -- Warnings
   gc_WRG_1                      CONSTANT VARCHAR2(50) := 'WRG_ORPH';
   gc_WRG_2                      CONSTANT VARCHAR2(50) := 'WRG_SUBS';
   gc_WRG_3                      CONSTANT VARCHAR2(50) := 'WRG_MAIN';

   TYPE R_VCODE                  IS RECORD (   PARTNER_ID                     NUMBER
                                           ,   PARTNER_TYPE                   VARCHAR2(20)
                                           );


   TYPE T_CHAINS                 IS TABLE  OF XXPM_CHAINS%ROWTYPE        INDEX BY BINARY_INTEGER;
   TYPE T_PARTNERS               IS TABLE  OF XXPM_PARTNERS%ROWTYPE      INDEX BY BINARY_INTEGER;
   TYPE T_PARTNER_ADDRESSES      IS TABLE  OF XXPM_ADDRESSES%ROWTYPE     INDEX BY BINARY_INTEGER;
   TYPE T_PARTNER_CONTACTS       IS TABLE  OF XXPM_CONTACTS%ROWTYPE      INDEX BY BINARY_INTEGER;
   TYPE T_VCODE_BY_ID            IS TABLE  OF VARCHAR2(50)               INDEX BY VARCHAR2(20);
   TYPE T_VCODE                  IS TABLE  OF NUMBER                     INDEX BY VARCHAR2(10);
   TYPE T_VCODES                 IS TABLE  OF R_VCODE                    INDEX BY VARCHAR2(10);

   TYPE T_CHAIN_NAME             IS TABLE  OF NUMBER                     INDEX BY VARCHAR2(400);
   TYPE T_CHAIN_ID               IS TABLE  OF NUMBER                     INDEX BY VARCHAR2(10);

   TYPE T_AUDIT_DATA             IS TABLE  OF XXPM_AUDIT_DATA%ROWTYPE    INDEX BY BINARY_INTEGER;
   TYPE T_NULL_FIELDS            IS TABLE  OF VARCHAR2(2000);

   TYPE R_META_DATA              IS RECORD (  LINE_NUMBER         NUMBER
                                           ,  RECORD_TYPE         VARCHAR2(20)
                                           ,  V_CODE              VARCHAR2(200)
                                           ,  V_CODE_MAIN         VARCHAR2(200)
                                           ,  LAST_UPDATE_DATE    DATE
                                           ,  AUDIT_DATA          T_AUDIT_DATA
                                           );


   TYPE T_META_DATA              IS TABLE OF R_META_DATA         INDEX BY BINARY_INTEGER;

   TYPE R_FILE_HEADER            IS RECORD (   RECORD_TYPE                     NUMBER
                                           ,   FILE_NAME                       VARCHAR2(200)
                                           ,   FILE_SOURCE                     VARCHAR2(100)
                                           ,   VERSION                         VARCHAR2(10)
                                           ,   FILE_CREATION_DATE              DATE
                                           );
   TYPE R_FILE_TRAILER           IS RECORD (   RECORD_TYPE                     NUMBER
                                           ,   LINE_COUNT                      VARCHAR2(200)
                                           );

   PROCEDURE main                          ( p_errbuf                           OUT       VARCHAR2
                                           , p_retcode                          OUT       VARCHAR2
                                           , p_full_dump                     IN           VARCHAR2 DEFAULT NULL
                                           , p_date_from                     IN           VARCHAR2 DEFAULT NULL
                                           , p_v_code                        IN           VARCHAR2 DEFAULT NULL
                                           );

   /*PROCEDURE undo                         ( p_errbuf                            OUT       VARCHAR2
                                          , p_retcode                           OUT       NUMBER
                                          );*/

   PROCEDURE writeDataStream_v2           ( p_filename                      IN            VARCHAR2  DEFAULT NULL
                                          , p_content_type                  IN            VARCHAR2  DEFAULT NULL
                                          , p_character_set                 IN            VARCHAR2  DEFAULT NULL
                                          , p_content_length                IN            VARCHAR2  DEFAULT NULL
                                          , p_blob                          IN            BLOB      DEFAULT EMPTY_BLOB
                                          , p_hash_value                    IN            VARCHAR2
                                          , p_response                          OUT       VARCHAR2
                                          , p_status_code                       OUT       NUMBER
                                          , p_error_code                        OUT       VARCHAR2
                                          , p_error_message                     OUT       VARCHAR2
                                          , p_error_description                 OUT       VARCHAR2
                                          );

   PROCEDURE writeDataStream_v1           ( p_filename                      IN            VARCHAR2  DEFAULT NULL
                                          , p_content_type                  IN            VARCHAR2  DEFAULT NULL
                                          , p_character_set                 IN            VARCHAR2  DEFAULT NULL
                                          , p_content_length                IN            VARCHAR2  DEFAULT NULL
                                          , p_blob                          IN            BLOB      DEFAULT EMPTY_BLOB
                                          , p_status_code                       OUT       NUMBER
                                          , p_error_code                        OUT       VARCHAR2
                                          , p_error_message                     OUT       VARCHAR2
                                          , p_error_description                 OUT       VARCHAR2
                                          );

   PROCEDURE validateDataStream_v1        ( p_file_id                       IN            NUMBER
                                          , p_validation_code               IN            VARCHAR2
                                          , p_hash_value                    IN            VARCHAR2
                                          , p_response                          OUT       VARCHAR2
                                          , p_status_code                       OUT       NUMBER
                                          , p_error_code                        OUT       VARCHAR2
                                          , p_error_message                     OUT       VARCHAR2
                                          , p_error_description                 OUT       VARCHAR2
                                          );

   PROCEDURE validateDataStream_v2        ( p_file_id                       IN            NUMBER
                                          , p_validation_code               IN            VARCHAR2
                                          , p_hash_value                    IN            VARCHAR2
                                          , p_response                          OUT       VARCHAR2
                                          , p_status_code                       OUT       NUMBER
                                          , p_error_code                        OUT       VARCHAR2
                                          , p_error_message                     OUT       VARCHAR2
                                          , p_error_description                 OUT       VARCHAR2
                                          );

   PROCEDURE run;

   /*PROCEDURE run_undo;*/

   PROCEDURE processNewFiles;

   PROCEDURE start_request;

   PROCEDURE writeFilesToDisk;

   FUNCTION get_version_number RETURN VARCHAR2;

   PROCEDURE run_salesforce_import_job;  
   PROCEDURE writeDataStream_v3           ( p_filename                      IN            VARCHAR2  DEFAULT NULL
                                          , p_content_type                  IN            VARCHAR2  DEFAULT NULL
                                          , p_character_set                 IN            VARCHAR2  DEFAULT NULL
                                          , p_content_length                IN            VARCHAR2  DEFAULT NULL
                                          , p_blob                          IN            BLOB      DEFAULT EMPTY_BLOB
                                          , p_hash_value                    IN            VARCHAR2
                                          , p_response                          OUT       VARCHAR2
                                          , p_status_code                       OUT       NUMBER
                                          , p_error_code                        OUT       VARCHAR2
                                          , p_error_message                     OUT       VARCHAR2
                                          , p_error_description                 OUT       VARCHAR2
                                          , p_message                           OUT       VARCHAR2
                                          )
;   

END XXPM_IMPORT_SALESFORCE;

/

--------------------------------------------------------
--  DDL for Package XXCPC_IMPORT_EXCEL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_IMPORT_EXCEL" 
AS
/****************************************************************
   *
   *
   * PROGRAM NAME
   *   CPC103 - XXICE_CPC_IMPORT_EXCEL
   *
   * DESCRIPTION
   *   Program to import CPC Subscription Quantities from an Excel (XLS/XLSX) file
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        21-11-2017  Initial Version
    **************************************************************/
   -- GLOBAL VARIABLES
   g_package_name                         VARCHAR2(50)                             := 'XXCPC_IMPORT_EXCEL';
   g_brn_id                               NUMBER;
   g_user_id                              NUMBER                               := -1;
   g_session_id                           NUMBER                               := -1;
   g_org_id                               NUMBER                               := 84;
   g_source                               VARCHAR2(50)                         := 'XLS';

   g_current_file                         VARCHAR2(200)                  := NULL;
   g_line_counter                         NUMBER                         := 1;
   g_tab                                  VARCHAR2(3)                    := '   ';
   g_decimal_to                           VARCHAR2(1)                    := '.';
   g_decimal_from                         VARCHAR2(1)                    := ',';
   g_last_loading_period                  DATE                           := SYSDATE;

   -- GLOBAL CONSTANTS
   gc_test                       CONSTANT BOOLEAN                        := FALSE;
   --gc_bah_code                   CONSTANT ICE_BATCHES.bah_code%TYPE      := 'CPC103';
   --gc_bah_code_undo              CONSTANT ICE_BATCHES.bah_code%TYPE      := 'CPC103_UD';
   --gc_brn_id_null                CONSTANT ICE_BATCH_RUNS.BRN_ID%TYPE     := -9999;

   gc_working_directory          CONSTANT VARCHAR2 (30)                  := 'CPC_EXPORT_DIRECTORY';
   gc_input_directory            CONSTANT VARCHAR2 (30)                  := 'CPC_EXPORT_DIRECTORY';
   gc_done_directory             CONSTANT VARCHAR2 (30)                  := 'CPC_EXPORT_DIRECTORY';

   gc_field_separator            CONSTANT VARCHAR2(10)                   := ';';
   gc_error_separator            CONSTANT VARCHAR2(10)                   := ': ';
   gc_prefix                     CONSTANT VARCHAR2(100)                  := '';
   gc_postfix                    CONSTANT VARCHAR2(100)                  := '.xls*';

   gc_file_pattern               CONSTANT VARCHAR2(100)                  := gc_prefix || '*' || gc_postfix;
   gc_date_format                CONSTANT VARCHAR2(25)                   := 'YYYYMMDDHH24MISS';
   gc_period_format              CONSTANT VARCHAR2(25)                   := 'YYYYMM';
   gc_canonical_format           CONSTANT VARCHAR2(30)                   := 'RRRR/MM/DD HH24:MI:SS';

   gc_EOT                        CONSTANT DATE                           := to_date('31129999','DDMMYYYY');
   gc_SOT                        CONSTANT DATE                           := to_date('01011900','DDMMYYYY');

   gc_number_format              CONSTANT VARCHAR2(25)                   := '999G999G999D00';
   gc_default_transaction_type   CONSTANT VARCHAR2(240)                  := 'Normal';
   gc_EMPTY                      CONSTANT VARCHAR2(10)                   := '_NULL_';
   gc_NULL                       CONSTANT VARCHAR2(2)                    := NULL;
   gc_JA                         CONSTANT VARCHAR2(2)                    := 'J';
   gc_NEE                        CONSTANT VARCHAR2(2)                    := 'N';
   gc_YES                        CONSTANT VARCHAR2(2)                    := 'Y';
   gc_NO                         CONSTANT VARCHAR2(2)                    := 'N';

   -- Error Messages
   gc_MSG_1                      CONSTANT VARCHAR2(20) := 'SQL_ERR';
   gc_MSG_2                      CONSTANT VARCHAR2(20) := 'DUPL_SUB';
   gc_MSG_3                      CONSTANT VARCHAR2(20) := 'DUPL_IMP';
   gc_MSG_4                      CONSTANT VARCHAR2(20) := 'DUPL_BAS';
   gc_MSG_5                      CONSTANT VARCHAR2(20) := 'INV_FILE';
   gc_MSG_6                      CONSTANT VARCHAR2(20) := 'ERR_PKNF'; -- pakket not found
   gc_MSG_7                      CONSTANT VARCHAR2(20) := 'ERR_PRNF'; -- partner not found
   gc_MSG_8                      CONSTANT VARCHAR2(20) := 'ERR_PERD'; -- counting per after loading period
   gc_MSG_9                      CONSTANT VARCHAR2(20) := 'ERR_PKNV'; -- pakket not valid for period
   gc_MSG_10                     CONSTANT VARCHAR2(20) := 'ERR_PRNV'; -- partner  not valid for period
   gc_MSG_11                     CONSTANT VARCHAR2(20) := 'ERR_PER2'; --

   -- Warnings
   gc_WRG_1                      CONSTANT VARCHAR2(20) := 'WRG_PNF'; -- pakket not found

   -- Indicators in ICE_KENGETALLEN_BATCH for main
   gc_READ_SUB                   CONSTANT VARCHAR2 (10)                  := 'REC_SUB';
   gc_INSERTED_SUB               CONSTANT VARCHAR2 (10)                  := 'INS_SUB';
   gc_UPDATED_SUB                CONSTANT VARCHAR2 (10)                  := 'UPD_SUB';
   gc_DELETED_SUB                CONSTANT VARCHAR2 (10)                  := 'DEL_SUB';
   gc_ERROR_PACKAGE_NF           CONSTANT VARCHAR2 (10)                  := 'ERR_PKNF';
   gc_ERROR_PACKAGE_NV           CONSTANT VARCHAR2 (10)                  := 'ERR_PKNV';
   gc_ERROR_PROVIDER_NF          CONSTANT VARCHAR2 (10)                  := 'ERR_PRNF';
   gc_ERROR_PROVIDER_NV          CONSTANT VARCHAR2 (10)                  := 'ERR_PRNV';
   gc_ERROR_SOURCE_NF            CONSTANT VARCHAR2 (10)                  := 'ERR_SNF';
   gc_ERROR_OTHER                CONSTANT VARCHAR2 (10)                  := 'ERR_SUB';
   gc_ERROR_DUPLICATE            CONSTANT VARCHAR2 (10)                  := 'ERR_DUPL';
   gc_ERROR_DUPLICATE_IMPORT     CONSTANT VARCHAR2 (10)                  := 'ERR_DUPI';
   gc_ERROR_DUPLICATE_BASE       CONSTANT VARCHAR2 (10)                  := 'ERR_DUPB';
   gc_ERROR_LATEST_BASE_FOUND    CONSTANT VARCHAR2 (10)                  := 'FOUND_BS';
   gc_ERROR_INVALID_PERIOD       CONSTANT VARCHAR2 (10)                  := 'INV_PER';
   gc_ERROR_INVALID_PERIOD2      CONSTANT VARCHAR2 (10)                  := 'INV_PER2';

   -- Indicators in ICE_KENGETALLEN_BATCH for undo
   gc_UNDO_SUB                   CONSTANT VARCHAR2 (10)                  := 'REM_SUB';
   gc_UNDO_DELETED               CONSTANT VARCHAR2 (10)                  := 'UPD_SUB';

   type T_subscription_counts_rec_type IS 
         RECORD ( packagename      varchar2(200)
                , packageid        number
                , periodcounted    varchar2(200)  
                , periodloaded     varchar2(200) 
                , providername     varchar2(200)
                , providerid       number
                , transactiontype  varchar2(200)
                , endquantity      number
                , createdby        integer
                , created          date
                , updatedby        integer
                , updated          date
                , startquantity    number
                );

   --TYPE T_SUBSCRIPTIONS     IS TABLE  OF xxcpc_subscriber%ROWTYPE      INDEX BY BINARY_INTEGER;
   TYPE T_SUBSCRIPTIONS     IS TABLE  OF T_subscription_counts_rec_type      INDEX BY BINARY_INTEGER;

   TYPE T_SOURCE_LINES      IS TABLE  OF VARCHAR2(2000)                             INDEX BY BINARY_INTEGER;
   TYPE T_KEYS              IS TABLE  OF VARCHAR2(6000)                             INDEX BY BINARY_INTEGER;

   --GLOBAL ARRAYS
   g_SUBSCRIPTIONS          T_SUBSCRIPTIONS := T_SUBSCRIPTIONS();
   g_EMPTY_SUBS_TBL         T_SUBSCRIPTIONS := T_SUBSCRIPTIONS();
   g_file_id                NUMBER;

   PROCEDURE main ( p_file_name          in varchar2
                  , p_file_data          in blob 
                  , p_subscriber_data_id in number
                  , p_open_period        in varchar2
                  );
END XXCPC_IMPORT_EXCEL;


/

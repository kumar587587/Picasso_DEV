--------------------------------------------------------
--  DDL for Package XXCT_EXHIBITS_FILE_SEND_TO_TV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_EXHIBITS_FILE_SEND_TO_TV" 
IS
  /****************************************************************
   *
   * PROGRAM NAME
   *  XXCT_EXHIBITS_FILE_SEND_TO_TV
   *
   * DESCRIPTION
   * Package to support REST-APIS
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Rabindra       02-JAN-2026      Initial Version
   **************************************************************/

   gc_tv_url                  CONSTANT    VARCHAR(200) := 'https://g1cb1b3dd717dd7-apx###.adb.eu-frankfurt-1.oraclecloudapps.com/ords/tv/';
   --gc_tv_url                  CONSTANT    VARCHAR(200) := 'https://g1cb1b3dd717dd7-apx###.adb.eu-frankfurt-1.oraclecloudapps.com/ords/tv/credittool/v1/addSharedDocumentNEW';
   gc_package_name            CONSTANT    VARCHAR(50)  := 'XXCT_EXHIBITS_FILE_SEND_TO_TV';
   gc_varicent_date_format    CONSTANT    VARCHAR(50)  := 'YYYY-MM-DD';
   --g_iso_codes                XXCT_iso_country_table;
   g_open_period              VARCHAR2(15);
   g_api_active               BOOLEAN := false;
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------
   FUNCTION inspect_response (p_clob IN CLOB ) RETURN VARCHAR2;
   ---------------------------------------------------------------------------------------------
   -- Procedure to insert a new row in a Varicent table.
   ---------------------------------------------------------------------------------------------
   PROCEDURE insert_row (p_url varchar2,p_new_values IN CLOB,p_out_data OUT VARCHAR2);
   ---------------------------------------------------------------------------------------------
   -- Procedure to delete a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------
   PROCEDURE delete_row (p_pk_value IN VARCHAR2);  
   ---------------------------------------------------------------------------------------------
   -- Procedure to update a row in a Varicent table.  
   ---------------------------------------------------------------------------------------------
   PROCEDURE update_row
       ( p_new_values   IN VARCHAR2
       , p_old_values   IN VARCHAR2
       , p_id           IN VARCHAR2);
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------
   FUNCTION call_request(
        p_url           IN VARCHAR2,
        p_http_method   IN VARCHAR2,
        p_body          IN CLOB
        )
   RETURN CLOB;
   ---------------------------------------------------------------------------------------------
   -- Function to get all columns of a specific varicent table.
   ---------------------------------------------------------------------------------------------
   FUNCTION get_api_value (p_code IN VARCHAR2 ) RETURN CLOB;
   ---------------------------------------------------------------------------------------------
   -- Fuction to
   ---------------------------------------------------------------------------------------------
   FUNCTION get_access_token RETURN VARCHAR2;
   ---------------------------------------------------------------------------------------------
   -- Fuction to
   ---------------------------------------------------------------------------------------------
   FUNCTION FILE_SEND_TO_TV(P_FILE_ID NUMBER) RETURN VARCHAR2;
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------
   PROCEDURE AFTER_CTPAYOUTAPPROVAL_UPDT(P_DOSSIER_ID NUMBER);
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------
   PROCEDURE CT_FILE_PUBLISHED;
   ---------------------------------------------------------------------------------------------
   -- Fuction to
   ---------------------------------------------------------------------------------------------
   FUNCTION GET_PARTNER_ACCESS_TREE(P_PARTNER_ID VARCHAR2) RETURN VARCHAR2;
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------
   PROCEDURE EXHIBITS_FILE_SEND_TO_VARICENT;
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------
   PROCEDURE CREATE_SCHEDULER_FOR_FILE_SEND;

END XXCT_EXHIBITS_FILE_SEND_TO_TV;


/

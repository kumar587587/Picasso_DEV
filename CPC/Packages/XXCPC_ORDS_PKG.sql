--------------------------------------------------------
--  DDL for Package XXCPC_ORDS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_ORDS_PKG" 
AS
   ---------------------------------------------------------------------------------------------   
--   PROCEDURE create_credential
--   ;
   ---------------------------------------------------------------------------------------------   
   PROCEDURE update_credential ( p_application in varchar2, p_client_id in varchar2, p_client_secret in varchar2 ) 
   ;
   ---------------------------------------------------------------------------------------------   
   FUNCTION call_oci_request        ( p_url                 IN          VARCHAR2
                                    , p_http_method         IN          VARCHAR2
                                    , p_body                IN          VARCHAR2
                                    , p_token_url           IN          VARCHAR2
                                    , p_client_id           IN          VARCHAR2
                                    , p_secret              IN          VARCHAR2
                                    , p_scope               IN VARCHAR2 )  RETURN CLOB;
   ---------------------------------------------------------------------------------------------   
   PROCEDURE run_test;
   ---------------------------------------------------------------------------------------------   
   FUNCTION recreate_ord_credentials ( p_owner IN VARCHAR2,  p_target IN VARCHAR2 ) 
   RETURN ords_user_ords_data_type
   ;   
   ---------------------------------------------------------------------------------------------      
   PROCEDURE recreate_ords_credentials ( p_owning_app in varchar2,  p_calling_app in varchar2 )   
   ;
END xxcpc_ords_pkg;

/

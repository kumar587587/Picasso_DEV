--------------------------------------------------------
--  DDL for Package Body XXAPI_DISPATCHER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_DISPATCHER_PKG" 
IS  
  /****************************************************************    
   *    
   * PROGRAM NAME    
   *  xxapi_dispatcher_pkg    
   *    
   * DESCRIPTION    
   * Package to support functionality for the manual partner invoice apex page (page-alias is xxxxxx).
   *    
   * CHANGE HISTORY    
   * Who                 When         What    
   * -------------------------------------------------------------    
   * Geert Engbers       08-12-2022  Initial Version    
   * Wiljo Bakker        08-10-2024  Added Credittool API
   **************************************************************/

   gc_log_debug_info                      BOOLEAN       := TRUE;
   c_transfer_timeout  CONSTANT           INTEGER       := 180;


   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
--   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2 )
--   IS
--   BEGIN
--      XXAPI_GEN_DEBUG_PKG.debug( gc_package_name||'.'||p_routine, rtrim(p_message) );
--      NULL;
--   END debug;   
   --
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      xxapi_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine,p_message, p_message_clob );  
      NULL;   
   END debug;   
--   ---------------------------------------------------------------------------------------------
--   -- Procedure to be used for debugging purposes.
--   ---------------------------------------------------------------------------------------------
--   PROCEDURE debug_cs ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_clob in clob )
--   IS
--   BEGIN
--      XXAPI_GEN_DEBUG_PKG.debug_cs( gc_package_name||'.'||p_routine, rtrim(p_message), p_clob);
--      NULL;
--   END debug_cs;      

   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug_bs ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_blob in blob )
   IS
   BEGIN
      XXAPI_GEN_DEBUG_PKG.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message), p_blob);
      NULL;
   END debug_bs;  

   ---------------------------------------------------------------------------------------------   
   -- Procedure to be inster debug messages into debug table.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE d ( p_routine IN VARCHAR2, p_message IN VARCHAR2,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN  
      case when gc_log_debug_info then xxapi_gen_debug_pkg.debug_cs ( gc_package_name||'.'||p_routine,p_message, p_message_clob ); 
         else null;
      end case;     
   END d;    


   ---------------------------------------------------------------------------------------------   
   -- Procedure to log the start of the routine, used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE s ( p_routine IN VARCHAR2 )    
   IS   
   BEGIN   
      d( p_routine, '(start)' );     
   END s;    

   ---------------------------------------------------------------------------------------------   
   -- Procedure to log the end of the routine, used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE e ( p_routine IN VARCHAR2, p_message IN VARCHAR2 DEFAULT NULL,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      d( p_routine, '(end) '||p_message, p_message_clob );  
   END e;    

   ---------------------------------------------------------------------------------------------   
   -- Procedure to log exception handling errors be used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE er ( p_routine IN VARCHAR2, p_message IN VARCHAR2 DEFAULT NULL,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      d( gc_package_name||'.'||p_routine, '(end) ERROR: '||p_message, p_message_clob );  
   END er;    

   ---------------------------------------------------------------------------------------------
   -- Function to get the client information
   ---------------------------------------------------------------------------------------------   
   FUNCTION get_client_info   ( p_name   in VARCHAR2  )   RETURN  XXAPI_API_USERS%ROWTYPE
   IS
      l_client XXAPI_API_USERS%ROWTYPE; 
   BEGIN
      for r_client in ( select * from xxapi_api_users where application_code_name = p_name ) loop 
         l_client := r_client;
      end loop;
      return l_client;
   END get_client_info;

   ---------------------------------------------------------------------------------------------
   -- Function to upload a file as an API request
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_upload_file_request      ( p_url          IN VARCHAR2
                                          , p_http_method  IN VARCHAR2
                                          , p_body         IN BLOB
                                          , p_token_url    IN VARCHAR2
                                          , p_client_id    IN VARCHAR2
                                          , p_secret       IN VARCHAR2
                                          , p_filename     IN VARCHAR2
                                          , p_content_type IN VARCHAR2 default 'text/csv'
                                          )
   RETURN CLOB 
   IS
      c_routine_name   CONSTANT VARCHAR2(30) := 'call_upload_file_request';          
      l_clob                    CLOB;
      l_index                   INTEGER:= 1;
      l_sqlerrm                 CLOB;      
      l_header_parameters       CLOB;
   BEGIN
      debug( c_routine_name, '(start)' );  
      debug( c_routine_name, 'p_url         = '||p_url );
      debug( c_routine_name, 'p_http_method = '||p_http_method );
      debug( c_routine_name, 'p_token_url   = '||p_token_url );
      debug( c_routine_name, 'p_client_id   = '||p_client_id );
      debug( c_routine_name, 'p_secret      = '||p_secret );

      IF g_api_active then     
         -- 
         apex_web_service.g_request_headers.DELETE(); 
         apex_web_service.oauth_authenticate ( p_token_url     => p_token_url
                                             , p_client_id     => p_client_id
                                             , p_client_secret => p_secret
                                             );

         debug( c_routine_name, 'authentication succeeded.' );
         -- add header value
         apex_web_service.g_request_headers( l_index ).name  := 'Content-Type';
         apex_web_service.g_request_headers( l_index ).value := 'application/json'; --'text/csv';

         -- second header 
         l_index := l_index + 1;

         -- add header value
         apex_web_service.g_request_headers( l_index ).name  := 'Authorization';
         apex_web_service.g_request_headers( l_index ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token; 

         -- construct and send api request
         l_clob := apex_web_service.make_rest_request ( p_url                => p_url   
                                                      , p_http_method        => p_http_method   
                                                      , p_transfer_timeout   => c_transfer_timeout   
                                                      , p_body_blob          => p_body
                                                      );   
      END IF;   

      -- add headers to a single string
      FOR i IN 1.. apex_web_service.g_headers.count LOOP
           l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
      END LOOP;  

      -- register request into table
      INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
      VALUES                                         ( p_url , p_http_method , p_body       , l_clob           , l_header_parameters);

      debug( c_routine_name, '(end) l_clob = ' || substr( l_clob , 1, 200 ));      

      RETURN l_clob;

   EXCEPTION
      WHEN OTHERS THEN
         l_sqlerrm           := sqlerrm;
         l_header_parameters := null;
         FOR i IN 1.. apex_web_service.g_headers.count LOOP
              l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
         END LOOP;        

         INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
         VALUES                                         ( p_url , p_http_method , p_body       , l_sqlerrm        , l_header_parameters);

         debug( c_routine_name, 'ERROR: '||l_sqlerrm);      
         RAISE;
   END call_upload_file_request; 
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to call an API request
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_request   ( p_url          IN VARCHAR2
                           , p_http_method  IN VARCHAR2
                           , p_body         IN VARCHAR2
                           , p_token_url    IN VARCHAR2
                           , p_client_id    IN VARCHAR2
                           , p_secret       IN VARCHAR2
                           )
   RETURN CLOB
   IS
      c_routine_name      CONSTANT VARCHAR2(30) := 'call_request';             
      l_clob              CLOB;
      l_index             INTEGER:= 1;
      l_sqlerrm           CLOB;
      l_header_parameters CLOB;
      l_body_blob         BLOB;
      --l_bearer_token      VARCHAR2(200) := 'TBoqZlqvxZ2sxnbBVCF5Rg';
     --l_url                VARCHAR2(200) := 'https://g1cb1b3dd717dd7-apxdev.adb.eu-frankfurt-1.oraclecloudapps.com/ords/cpc/ordsClients/v1/recreateIds';     
   BEGIN
      debug( c_routine_name, '(start)' );  
      debug( c_routine_name, 'p_url         = '||p_url );
      debug( c_routine_name, 'p_http_method = '||p_http_method );
      debug( c_routine_name, 'p_body        = '||p_body );
      debug( c_routine_name, 'p_token_url   = '||p_token_url );
      debug( c_routine_name, 'p_client_id   = '||p_client_id );
      debug( c_routine_name, 'p_secret      = '||p_secret );

      -- when data is send in the body convert this to a blob
      IF p_body is not null then
         l_body_blob := apex_util.clob_to_blob( p_body , 'WE8ISO8859P1');
      END IF;

      -- only when API is set active run the API
      IF g_api_active then     
         apex_web_service.g_request_headers.DELETE();
         -- get new bearer token or use existing
         apex_web_service.oauth_authenticate ( p_token_url     => p_token_url
                                             , p_client_id     => p_client_id
                                             , p_client_secret => p_secret
                                             );  
         debug( c_routine_name, 'authentication succeeded.' );

         -- when payload in the body add content type to headers
         if p_body is not null then
            apex_web_service.g_request_headers( l_index ).name  := 'Content-Type';
            apex_web_service.g_request_headers( l_index ).value := 'application/json';
            l_index := l_index + 1;
         end if;   

         -- add bearer token to headers
         apex_web_service.g_request_headers( l_index ).name  := 'Authorization';
         apex_web_service.g_request_headers( l_index ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token; 
         -- make the request and catch the return value 
         l_clob := apex_web_service.make_rest_request ( p_url                => p_url   
                                                      , p_http_method        => p_http_method   
                                                      , p_transfer_timeout   => c_transfer_timeout   
                                                      , p_body               => p_body  
                                                      );
      END IF;   

      -- format headers for logging
      FOR i IN 1.. apex_web_service.g_headers.count LOOP
           l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
      END LOOP;  

      -- log the request
      INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
      VALUES                                         ( p_url , p_http_method , l_body_blob  , l_clob           , l_header_parameters);

      debug( c_routine_name, '(end) l_clob = ' , l_clob );      

      RETURN l_clob;

   EXCEPTION
      WHEN OTHERS THEN
         l_sqlerrm           := sqlerrm;
         l_header_parameters := null;
         FOR i IN 1.. apex_web_service.g_headers.count LOOP
              l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
         END LOOP;  
         INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
         VALUES                                         ( p_url , p_http_method , l_body_blob  , l_sqlerrm        , l_header_parameters);
         debug( c_routine_name, 'ERROR: '||l_sqlerrm);      
         RAISE;
   END call_request; 

   ---------------------------------------------------------------------------------------------
   -- Procedure to service the delivery of Statusupdates on Dossiers for Credittool
   ---------------------------------------------------------------------------------------------        
   PROCEDURE updateDossierStatus     ( p_file_content        IN          BLOB      
                                     , p_status_code              OUT    VARCHAR2 )
   IS  
      lc_routine_name   CONSTANT VARCHAR2(30) := 'updateDossierStatus';          
      --
      l_message     VARCHAR2(2000) :=   '200' ; 
      l_client      XXAPI_API_USERS%ROWTYPE; 
      l_parameters  VARCHAR2(2000); 
      l_blob        BLOB;


   BEGIN  
      s( lc_routine_name );  

      debug_bs( lc_routine_name, 'p_file_content (see clob column) ', p_file_content );  

      --convert payload into a blob
--      l_blob := apex_util.clob_to_blob ( p_clob => p_file_content
--                                       , p_charset => 'AL32UTF8'
--                                       );
--      l_blob := p_file_content;

      -- get the credentials
      l_client := get_client_info ('CT');

      -- call the rest API                        
      l_message := call_upload_file_request  ( p_url          => g_base_url || 'ct/dossiers/v1/updateStatus' 
                                             , p_http_method  => 'POST'
                                             , p_body         => p_file_content
                                             , p_token_url    => g_base_url || 'ct' || '/oauth/token'
                                             , p_client_id    => l_client.client_id
                                             , p_secret       => l_client.secret
                                             , p_filename     => null
                                             , p_content_type => 'application/json '
                                             );

      d( lc_routine_name, 'l_message = '||l_message);    

      p_status_code := substr( l_message,1,3);
      l_message := substr( l_message ,4 );

      htp.p( l_message );

      d( lc_routine_name, 'p_status_code = '||p_status_code);    

      e( lc_routine_name );
--   EXCEPTION 
--      WHEN OTHERS THEN  
--         er( lc_routine_name );
--         RAISE;         
   END updateDossierStatus; 

   ---------------------------------------------------------------------------------------------
   -- Procedure to execute an API call from IAM
   ---------------------------------------------------------------------------------------------        
   PROCEDURE dispatch_iam_request   ( p_body                IN          CLOB
                                    , p_application         IN          VARCHAR2
                                    , p_status                   OUT    VARCHAR2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'dispatch_iam_request';          

      l_message     varchar2(2000); 
      l_client_id   varchar2(100);
      l_secret      varchar2(100);
   BEGIN  
      debug( c_routine_name, '(start)' );  

      debug( c_routine_name, 'p_body        = '||p_body );  
      debug( c_routine_name, 'p_application = '||p_application );  
      debug( c_routine_name, 'p_status      = '||p_status );  


      IF instr( p_body ,'keepaliveuser@kpn.com') > 0 THEN
         l_message := 'keep-alive exectuted at '||to_char(sysdate,'DD-MM-YYYY HH24:MI:SS');
      ELSE

         select  client_id ,   secret
         into  l_client_id , l_secret
         from xxapi_api_users
         where application_code_name = p_application
         ;

         debug( c_routine_name, 'l_client_id      = '||l_client_id );  
         debug( c_routine_name, 'l_secret         = '||l_secret );  

         -- call the rest API          
         l_message := call_request ( p_url          => g_base_url || lower(p_application) || '/user/v1/role'
                                   , p_http_method  => 'POST'
                                   , p_body         => p_body
                                   , p_token_url    => g_base_url || lower(p_application)|| '/oauth/token'
                                   , p_client_id    => l_client_id
                                   , p_secret       => l_secret
                                   );
         p_status  := substr( l_message,1,3);
         l_message := substr( l_message,5);

         debug( c_routine_name, 'p_status = '||p_status);    
         debug( c_routine_name, 'l_message = '||l_message);    
      END IF;    
      htp.p( l_message );
      debug( c_routine_name, '(end)');  
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;
   END dispatch_iam_request;        

   ---------------------------------------------------------------------------------------------
   -- Procedure to run manual invoices update from Varicent to CPC
   ---------------------------------------------------------------------------------------------        
   PROCEDURE update_invoice_request ( p_status                   OUT    VARCHAR2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'update_invoice_request';          

      l_message     varchar2(2000); 
      l_client_id   varchar2(100);
      l_secret      varchar2(100);
   BEGIN  
      debug( c_routine_name, '(start)' );  

      select  client_id ,   secret
      into  l_client_id , l_secret
      from xxapi_api_users
      where application_code_name = 'CPC'
      ;

      debug( c_routine_name, 'l_client_id      = '||l_client_id );  
      debug( c_routine_name, 'l_secret         = '||l_secret );  

      -- call the rest API
      l_message := call_request  ( p_url          => g_base_url || 'cpc' || '/mpi/v1/updateInvoiceStatus'
                                 , p_body         => null  
                                 , p_http_method  => 'POST'
                                 , p_token_url    => g_base_url || 'cpc' || '/oauth/token'
                                 , p_client_id    => l_client_id
                                 , p_secret       => l_secret
                                 );
      --
      --p_status := substr( l_message,1,3);
      --l_message := substr( l_message,5);
      --debug( c_routine_name, 'p_status = '||p_status);    
      --debug( c_routine_name, 'l_message = '||l_message);    
      htp.p( l_message );
      p_status := 200;
      debug( c_routine_name, '(end)');
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;          
   END update_invoice_request;    
   --
   ---------------------------------------------------------------------------------------------
   -- Procedure to format a new vcode amd return it to the consumer
   ---------------------------------------------------------------------------------------------        
   PROCEDURE getNewVcode            ( p_status                   OUT    VARCHAR2
                                    , p_message                  OUT    VARCHAR2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'getNewVcode';          

      l_message     varchar2(2000); 
      l_client_id   varchar2(100);
      l_secret      varchar2(100);
   BEGIN  
      debug( c_routine_name, '(start)' );  

      select  client_id ,   secret
      into  l_client_id , l_secret
      from xxapi_api_users
      where application_code_name = 'PM'
      ;

      -- call the rest API
      l_message := call_request  ( p_url          => g_base_url || 'pm/partners/v2/getNewVcode'
                                 , p_body         => null  
                                 , p_http_method  => 'GET'
                                 , p_token_url    => g_base_url || 'pm' || '/oauth/token'
                                 , p_client_id    => l_client_id
                                 , p_secret       => l_secret
                                 );
      --
      --p_status := substr( l_message,1,3);
      --l_message := substr( l_message,5);
      --debug( c_routine_name, 'p_status = '||p_status);    
      --debug( c_routine_name, 'l_message = '||l_message);    
      htp.p( l_message );
      p_message := l_message;
      p_status  := 200;
      debug( c_routine_name, '(end)');    
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;   
   END getNewVcode;     

   ---------------------------------------------------------------------------------------------
   -- Procedure to service the delivery of partnerdata files from Salesforce
   ---------------------------------------------------------------------------------------------        
   PROCEDURE partnersDataStream     ( p_name                IN          VARCHAR2 
                                    , p_character_set       IN          VARCHAR2
                                    , p_hash_value          IN          VARCHAR2
                                    , p_content_length      IN          VARCHAR2
                                    , p_file_content        IN          CLOB   
                                    , p_status                    OUT   VARCHAR2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'partnersDataStream';          
      --
      l_message     varchar2(2000); 
      l_client_id   varchar2(100);
      l_secret      varchar2(100);
      l_parameters  varchar2(2000); 
      l_blob        blob;
   BEGIN  
      debug( c_routine_name, '(start)' );  

      debug( c_routine_name, 'p_name           = '||p_name );  
      debug( c_routine_name, 'p_character_set  = '||p_character_set );  
      debug( c_routine_name, 'p_hash_value     = '||p_hash_value );  
      debug( c_routine_name, 'p_content_length = '||p_content_length );  

      -- convert payload into a blob
      l_blob := apex_util.clob_to_blob ( p_clob => p_file_content
                                       , p_charset => 'AL32UTF8'
                                       );

      --sys.dbms_output.put_line( 'The utf-8 BLOB has ' || sys.dbms_lob.getlength( l_blob ) || ' bytes.' );
      --l_blob := apex_util.clob_to_blob(
      --p_clob => l_clob,
      --p_charset => 'WE8ISO8859P1' );
      --sys.dbms_output.put_line( 'The iso-8859-1 BLOB has ' || sys.dbms_lob.getlength( l_blob ) || ' bytes.' );
      --
      d( c_routine_name, 'p_file_content (see clob column) ', p_file_content );  
      --

      select  client_id ,   secret
      into  l_client_id , l_secret
      from xxapi_api_users
      where application_code_name = 'PM'
      ;

      -- contruct the request paranmeters 
      l_parameters :=   '?name='          ||p_name||
                        '&character_set=' ||p_character_set||
                        '&status='        ||p_status||
                        '&hash_value='    ||p_hash_value||
                        '&content_length='||p_content_length
                        ;

      -- call the rest API                        
      l_message := call_upload_file_request  ( p_url          => g_base_url || 'pm/partners/v3/partnersDataStream' || l_parameters 
                                             , p_http_method  => 'POST'
                                             , p_body         => l_blob
                                             , p_token_url    => g_base_url || 'pm' || '/oauth/token'
                                             , p_client_id    => l_client_id
                                             , p_secret       => l_secret
                                             , p_filename     => p_name
                                             , p_content_type => 'text/csv'
                                             );

      debug( c_routine_name, 'l_message = '||l_message);    

      p_status := substr( l_message,1,3);
      l_message := substr( l_message ,4 );
      htp.p( l_message );
      debug( c_routine_name, 'p_status = '||p_status);    
      debug( c_routine_name, '(end)');    
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;         
   END partnersDataStream; 


   ---------------------------------------------------------------------------------------------
   -- Procedure to validate the contents of an API call 
   ---------------------------------------------------------------------------------------------        
   PROCEDURE validateDataStream     ( p_file_id             IN          VARCHAR2 
                                    , p_validation_code     IN          VARCHAR2
                                    , p_hash_value          IN          VARCHAR2
                                    , p_status                    OUT   VARCHAR2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'validateDataStream';          

      l_message     varchar2(2000); 
      l_client_id   varchar2(100);
      l_secret      varchar2(100);
      l_parameters  varchar2(2000); 
      l_blob        blob;

   BEGIN  
      debug( c_routine_name, '(start)' );  

      debug( c_routine_name, 'p_file_id           = '||p_file_id );  
      debug( c_routine_name, 'p_validation_code   = '||p_validation_code );  
      debug( c_routine_name, 'p_hash_value        = '||p_hash_value );  

      -- get credentials for PM
      select  client_id ,   secret
      into  l_client_id , l_secret
      from xxapi_api_users
      where application_code_name = 'PM'
      ;

      -- contruct the parameters 
      l_parameters := '?File_ID='||p_file_id||'&Validation_Code='||p_validation_code||'&hash_value='||p_hash_value ;

      l_message := call_request 
      ( p_url          => g_base_url || 'pm/partners/v2/validateDataStream'||l_parameters
      , p_body         => null  
      , p_http_method  => 'POST'
      , p_token_url    => g_base_url || 'pm' || '/oauth/token'
      , p_client_id    => l_client_id
      , p_secret       => l_secret
      );      
      debug( c_routine_name, 'l_message = '||l_message);    
      --
      p_status := substr( l_message,1,3);
      l_message := substr( l_message ,4 );
      htp.p( l_message );
      debug( c_routine_name, 'p_status = '||p_status);    
      debug( c_routine_name, '(end)');    
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;         
   END validateDataStream;    
   --  
   ---------------------------------------------------------------------------------------------
   -- Procedure
   ---------------------------------------------------------------------------------------------        
   PROCEDURE dummy_grant   ( p_schema          in varchar2
                           , p_client_id       in varchar2
                           , p_client_secret   in varchar2 )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30) := 'dummy_grant';          
      l_clob           clob;
   BEGIN  
      debug( c_routine_name, '(start) token_url = ' ||g_base_url ||'api/oauth/token' );  
      --
      apex_web_service.g_request_headers.DELETE(); 
      apex_web_service.oauth_authenticate    ( p_token_url     => g_base_url ||'api/oauth/token'
                                             , p_client_id     => p_client_id
                                             , p_client_secret => p_client_secret
                                             );  
      debug( c_routine_name, 'token = ' || apex_web_service.g_oauth_token.token );     
      --          
      apex_web_service.g_request_headers(1).name  := 'Authorization';   
      apex_web_service.g_request_headers(1).value := 'Bearer ' || apex_web_service.g_oauth_token.token;    
      --   
      l_clob := apex_web_service.make_rest_request ( p_url                =>  g_base_url||'api/user/v1/'||p_schema||'Role'  
                                                   , p_http_method        => 'POST'
                                                   , p_transfer_timeout   => 180   
                                                   , p_body               => '{ "username":"WakeUpUser","ruisname":"WakeUpUser","role":"DevOps Engineer", "action":"GRANT"}'
                                                   );   
      --
      d( c_routine_name, '(end) l_clob', l_clob);
   EXCEPTION
      WHEN OTHERS THEN
          debug( c_routine_name, 'ERROR: '||sqlerrm);  
          RAISE;           
   END dummy_grant;        
   --  
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
   PROCEDURE oci_dummy_grant  ( p_schema          in varchar2
                              , p_client_id       in varchar2
                              , p_client_secret   in varchar2
                              )
   IS  
      c_routine_name   CONSTANT VARCHAR2(30)  := 'oci_dummy_grant';          
      l_token_url      CONSTANT VARCHAR2(400) := g_base_url||'env/token';
      l_url            VARCHAR2(400)          :=  g_base_url||'picasso/user/v1/cpcRole';
      --l_token_url      CONSTANT VARCHAR2(400) := 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token';
      --l_url            VARCHAR2(400)          := 'https://omdanvv42ktvbrzt7mnl2r4nfu.apigateway.eu-frankfurt-1.oci.customer-oci.com/picasso/user/v1/'||p_schema||'Role';
      l_clob           clob;
   BEGIN  
      debug( c_routine_name, '(start)');
      debug( c_routine_name, 'p_client_id     = '||p_client_id);
      debug( c_routine_name, 'p_client_secret = '||p_client_secret);
      --
      apex_web_service.g_request_headers.DELETE();   
      apex_web_service.oauth_authenticate ( p_token_url     => l_token_url
                                          , p_client_id     => p_client_id
                                          , p_client_secret => p_client_secret
                                          , p_scope         => 'picasso:apxdev:dpe'
                                          );  
      --          
      apex_web_service.g_request_headers.DELETE();   
      apex_web_service.g_request_headers(1).name  := 'Authorization';   
      apex_web_service.g_request_headers(1).value := 'Bearer ' || apex_web_service.g_oauth_token.token;    
      apex_web_service.g_request_headers(2).name  := 'Scope';   
      apex_web_service.g_request_headers(2).value := 'picasso:apxdev:dpe';    
      --   
      l_clob := apex_web_service.make_rest_request  ( p_url                =>  l_url
                                                    , p_http_method        => 'POST'
                                                    , p_transfer_timeout   => 180   
                                                    , p_body               => '{ "username":"WakeUpUser","ruisname":"WakeUpUser","role":"DevOps Engineer", "action":"GRANT"}'
                                                    );   
      --
      d( c_routine_name, '(end) l_clob', l_clob);    
   END oci_dummy_grant;  
   --    
   ---------------------------------------------------------------------------------------------
   -- Function to 
   ---------------------------------------------------------------------------------------------  
   FUNCTION call_era_oci_request ( p_url          IN VARCHAR2
                                 , p_http_method  IN VARCHAR2
                                 , p_body         IN VARCHAR2
                                 , p_token_url    IN VARCHAR2
                                 , p_client_id    IN VARCHAR2
                                 , p_secret       IN VARCHAR2
                                 , p_scope        IN VARCHAR2
                                 )
   RETURN CLOB
   IS
      c_routine_name   CONSTANT VARCHAR2(30) := 'call_era_oci_request';          
      l_return_value VARCHAR2(400) :='';
      l_clob         CLOB;
      l_index        INTEGER:= 1;
   BEGIN
      debug( c_routine_name, '(start)' );  
      debug( c_routine_name, 'p_url         = '||p_url );
      debug( c_routine_name, 'p_http_method = '||p_http_method );
      debug( c_routine_name, 'p_body        = '||p_body );
      debug( c_routine_name, 'p_token_url   = '||p_token_url );
      debug( c_routine_name, 'p_client_id   = '||p_client_id );
      debug( c_routine_name, 'p_secret      = '||p_secret );
      debug( c_routine_name, 'p_scope       = '||p_scope );
      --
      --IF g_api_active then     
         --
         apex_web_service.g_request_headers.DELETE(); 
         apex_web_service.oauth_authenticate ( p_token_url     => p_token_url
                                             , p_client_id     => p_client_id
                                             , p_client_secret => p_secret
                                             , p_scope         => p_scope
                                             );  
         debug( c_routine_name, 'authentication succeeded.' );
         --if p_body is not null then
            apex_web_service.g_request_headers( l_index ).name  := 'Content-Type';
            apex_web_service.g_request_headers( l_index ).value := 'application/json';
            l_index := l_index + 1;
         --end if;   
         --
         apex_web_service.g_request_headers( l_index ).name  := 'Authorization';
         apex_web_service.g_request_headers( l_index ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token; 
--         l_index := l_index + 1;
--         apex_web_service.g_request_headers( l_index ).name  := 'Content-Length';
--         apex_web_service.g_request_headers( l_index ).value := to_char(length(p_body)); 
--         l_index := l_index + 1;
--         apex_web_service.g_request_headers( l_index ).name  := 'Host';
--         apex_web_service.g_request_headers( l_index ).value := 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com'; 
         --
         l_clob := apex_web_service.make_rest_request  ( p_url                => p_url   
                                                       , p_http_method        => p_http_method   
                                                       , p_transfer_timeout   => 120 --c_transfer_timeout   
                                                       , p_body               => p_body  
                                                       );   
      --end if;   
      debug( c_routine_name, '(end) l_clob = ' || substr( l_clob , 1, 200 ));      
      --
      RETURN l_clob;
      --
   EXCEPTION
   WHEN OTHERS THEN
      debug( c_routine_name, 'ERROR: '||sqlerrm);      
      RAISE;
   END call_era_oci_request; 
   --    
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
--   PROCEDURE call_oic_gateway
--   --( p_body            in  clob
--   --, p_application in  varchar2
--   --, p_status     out  varchar2
--   --, p_wakeUpCall  in boolean default false
--   --)
--   IS  
--      c_routine_name   CONSTANT VARCHAR2(30) := 'call_oic_gateway';          
--      --
--      l_message     varchar2(2000); 
--      l_client_id   varchar2(100);
--      l_secret      varchar2(100);
--   BEGIN  
--      debug( c_routine_name, '(start)' );  
--      --debug( c_routine_name, 'p_body        = '||p_body );  
--      --debug( c_routine_name, 'p_application = '||p_application );  
--      --debug( c_routine_name, 'p_status      = '||p_status );  
--      --
--      --select  client_id ,   secret
--      --into  l_client_id , l_secret
--      --from xxapi_api_users
--      --where application_code_name = p_application
--      --;
--      --debug( c_routine_name, 'l_client_id      = '||l_client_id );  
--      --debug( c_routine_name, 'l_secret         = '||l_secret );  
----      l_message := call_request 
----      ( p_url          => g_base_url || lower(p_application) || '/user/v1/role'
----      , p_http_method  => 'POST'
----      , p_body         => p_body
----      , p_token_url    => g_base_url || lower(p_application)|| '/oauth/token'
----      , p_client_id    => l_client_id
----      , p_secret       => l_secret
----      );
--
----      -- Production
----      l_message := call_era_oci_request 
----      ( p_url          => 'https://era-apigw.oci.kpn.com/picasso/user/v1/tvRole'
----      , p_http_method  => 'POST'
----      , p_body         => '{ "username":"geert.engbers@kpn.com","ruisname":"ENGBE502","role":"TV Partner Maintenance", "action":"GRANT"}'
----      --, p_token_url    => 'https://era-apigw.oci.kpn.com/env/token'
----      , p_token_url    => 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token'
----      , p_client_id    => '93313aa96d9942459dfcc9548f33e1f7'
----      , p_secret       => '049c9e5d-3755-4845-bd41-7c71984f0b6d'
----      , p_scope        => 'picasso:apxprd:dpe'
----      );
--      -- Development
--      l_message := call_era_oci_request 
--      ( p_url          => 'https://era-apigw-dev.oci-np.kpn.com/picasso/'
--      , p_http_method  => 'POST'
--      , p_body         => '{ "username":"geert.engbers@kpn.com","ruisname":"ENGBE502","role":"TV Partner Maintenance", "action":"GRANT"}'
--      --, p_token_url    => 'https://era-apigw.oci.kpn.com/env/token'
--      , p_token_url    => 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token'
--      , p_client_id    => '9e97899b934845e58ad82068bf13d91d'
--      , p_secret       => '189420b4-1b2f-44fc-8300-3910860f9229'
--      , p_scope        => 'picasso:apxdev:dpe'
--      );
--
--
--      --
--      --p_status := substr( l_message,1,3);
--      --l_message := substr( l_message,5);
--      --debug( c_routine_name, 'p_status = '||p_status);    
--      debug( c_routine_name, 'l_message = '||l_message);    
--      --if not p_wakeUpCall then
--      --   htp.p( l_message );
--      --end if;   
--      debug( c_routine_name, '(end)');  
--   exception
--   WHEN others then
--       debug( c_routine_name, 'ERROR: '||sqlerrm);  
--       raise;
--   END call_oic_gateway;        
   --
   ---------------------------------------------------------------------------------------------
   -- Procedure to
   ---------------------------------------------------------------------------------------------        
--   PROCEDURE WakeUpRestApis
--   IS  
--      c_routine_name   CONSTANT VARCHAR2(30) := 'WakeUpRestApis';          
--      l_client_id      VARCHAR2(200); 
--      l_secret         VARCHAR2(200); 
--      l_status         VARCHAR2(2000);
--   BEGIN  
--      debug( c_routine_name, '(start)' );  
--      delete from xxapi_debug;
--      commit;
--      --
--      call_oic_gateway
--      --( p_body           => '{ "username":"WakeUpUser","ruisname":"WakeUpUser","role":"DevOps Engineer", "action":"GRANT"}'
--      --, p_application    => 'CPC'
--      --, p_status         => l_status
--      --, p_wakeUpCall     => true
--      --)
--      ;      
----      dispatch_iam_request
----      ( p_body           => '{ "username":"WakeUpUser","ruisname":"WakeUpUser","role":"DevOps Engineer", "action":"GRANT"}'
----      , p_application    => 'PM'
----      , p_status         => l_status
----      , p_wakeUpCall     => true
----      );      
----      dispatch_iam_request
----      ( p_body           => '{ "username":"WakeUpUser","ruisname":"WakeUpUser","role":"DevOps Engineer", "action":"GRANT"}'
----      , p_application    => 'TV'
----      , p_status         => l_status
----      , p_wakeUpCall     => true
----      );      
--
----      select  client_id ,   secret
----      into  l_client_id , l_secret
----      from xxapi_api_users
----      where application_code_name = 'OCI'
----      ;      
----      oci_dummy_grant
----      ( p_schema        => 'cpc'
----      , p_client_id     => l_client_id
----      , p_client_secret => l_secret
----      );      
----      oci_dummy_grant
----      ( p_schema        => 'tv'
----      , p_client_id     => l_client_id
----      , p_client_secret => l_secret
----      );      
----      oci_dummy_grant
----      ( p_schema        => 'pm'
----      , p_client_id     => l_client_id
----      , p_client_secret => l_secret
----      );      
--
--      --
----      select  client_id ,   secret
----      into  l_client_id , l_secret
----      from xxapi_api_users
----      where application_code_name = 'API'
----      ;      
----      dummy_grant
----      ( p_schema        => 'cpc'
----      , p_client_id     => l_client_id
----      , p_client_secret => l_secret
----      );
----      
----      dummy_grant
----      ( p_schema        => 'tv'
----      , p_client_id     => l_client_id 
----      , p_client_secret => l_secret
----      );
----      --
----      dummy_grant
----      ( p_schema        => 'pm'
----      , p_client_id     => l_client_id
----      , p_client_secret => l_secret
----      );
----      
--
--      debug( c_routine_name, '(end)');    
--   END WakeUpRestApis;       
   --
   ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------    
    FUNCTION test_clientid_and_secret ( p_application IN VARCHAR2, p_scope IN VARCHAR2, p_token_url IN VARCHAR2)
    RETURN NUMBER
    IS
       c_routine_name   CONSTANT VARCHAR2(30) := 'test_clientid_and_secret';
       l_client_id      VARCHAR2(2000); 
       l_client_secret  VARCHAR2(2000);
       l_url            VARCHAR2(2000);
    BEGIN
       debug( c_routine_name, '(start)' );
       SELECT   client_id ,          secret
       INTO   l_client_id , l_client_secret
       FROM xxapi_api_users
       WHERE application_code_name = p_application
       AND   nvl(scope,'NO SCOPE') = nvl( p_scope, 'NO SCOPE')
       ;
       IF p_token_url IS NULL THEN
          l_url := g_base_url||lower(p_application)||'/oauth/token';
       ELSE
          l_url := p_token_url;
       END IF;
       apex_web_service.g_request_headers.DELETE(); 
       apex_web_service.oauth_authenticate ( p_token_url     => l_url
                                           , p_client_id     => l_client_id
                                           , p_client_secret => l_client_secret
                                           , p_scope         => p_scope
                                           );  
       debug( c_routine_name, 'Authentication succeeded for application '||p_application );
       debug( c_routine_name, '(end)' );
       RETURN 1;
    EXCEPTION
    WHEN OTHERS THEN
       debug( c_routine_name, 'ERROR: application = '||p_application||' message ='||sqlerrm );
       RETURN 0;
    END test_clientid_and_secret;  
  ---------------------------------------------------------------------------------------------
   -- Function to
   ---------------------------------------------------------------------------------------------    
    FUNCTION test_user_ords_clients ( p_application IN VARCHAR2, p_client_id in varchar2, p_client_secret in varchar2)
    RETURN NUMBER
    IS
       c_routine_name   CONSTANT VARCHAR2(30) := 'test_user_ords_clients';
       --l_client_id      VARCHAR2(2000); 
       --l_client_secret  VARCHAR2(2000);
    BEGIN
       debug( c_routine_name, '(start)' );
       --SELECT   client_id ,   client_secret
       --INTO   l_client_id , l_client_secret
       --FROM user_ords_clients
       --;
       apex_web_service.g_request_headers.DELETE(); 
       apex_web_service.oauth_authenticate ( p_token_url     => g_base_url||lower(p_application)||'/oauth/token'
                                           , p_client_id     => p_client_id
                                           , p_client_secret => p_client_secret
                                           );  
       debug( c_routine_name, 'authentication succeeded.' );
       debug( c_routine_name, '(end)' );
       RETURN 1;
    EXCEPTION
    WHEN OTHERS THEN
       debug( c_routine_name, 'ERROR: '||sqlerrm );
       RETURN 0;
    END test_user_ords_clients;     
   --
--   --------------------------------------------------------
--   --
--   --------------------------------------------------------
--   FUNCTION get_user_ords_clients  ( p_application in varchar2 ) 
--   RETURN xxapi_user_ords_clients_table_type PIPELINED
--   IS
--      c_routine_name   CONSTANT VARCHAR2(30) := 'get_user_ords_clients';          
--      l_return_value   VARCHAR2(400) :='';
--      l_data           xxapi_user_ords_clients_table_type := xxapi_user_ords_clients_table_type();
--      l_clob           CLOB;
--      l_json_obj       json_array_t;
--      l_result         number;
--      l_url            VARCHAR2(2000);
--      l_client_id      VARCHAR2(2000);
--      l_client_secret  VARCHAR2(2000);
--      --
--      PROCEDURE d ( p_message IN VARCHAR2 )
--      IS
--      BEGIN 
--         NULL;
--         debug( c_routine_name, p_message  );  
--      END;         
--      PROCEDURE d ( p_message IN VARCHAR2, p_clob IN CLOB )
--      IS
--      BEGIN 
--         NULL;
--         debug( c_routine_name, p_message, p_clob  );  
--      END;        
--   BEGIN
--      s ( c_routine_name );     
--      --
--      --l_result := test_user_ords_clients( p_application );
--      select   client_id,          secret
--      into   l_client_id, l_client_secret  
--      from xxapi_api_users
--      where application_code_name = p_application;
--      --     
--      d( 'l_client_id     = '|| l_client_id ); 
--      d( 'l_client_secret = '|| l_client_secret ); 
--      d( 'toke_url        = '|| g_base_url||lower(p_application)||'/oauth/token' ); 
--      apex_web_service.oauth_authenticate ( p_token_url     =>  g_base_url||lower(p_application)||'/oauth/token'
--                                           , p_client_id     => l_client_id
--                                           , p_client_secret => l_client_secret
--                                           );
--      --
--      apex_web_service.g_request_headers.DELETE();   
--      --   
--      l_url :=  g_base_url||lower(p_application)||'/ordsClients/v1/clients';
--      d( 'l_url = '||l_url ); 
--      --
--      apex_web_service.g_request_headers( 1 ).name  := 'Content-Type';
--      apex_web_service.g_request_headers( 1 ).value := 'application/json'; --'text/csv';
--      apex_web_service.g_request_headers( 2 ).name  := 'Authorization';
--      apex_web_service.g_request_headers( 2 ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token;       
--      
--      l_clob := apex_web_service.make_rest_request   
--                   ( p_url                => l_url
--                   , p_http_method        => 'GET'
--                   );       
--      d( 'l_clob', l_clob );     
--      --FOR i IN 1.. apex_web_service.g_headers.count LOOP
--      --    d( 'apex_web_service.g_headers('||to_char(i)||': '||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value );
--          --if  l_total_rows = -1 and apex_web_service.g_headers(i).name  = 'totalRows' then
--          --    l_total_rows := apex_web_service.g_headers(i).value;
--          --    d( 'l_total_rows = '|| l_total_rows );  
--          --end if;
--      --END LOOP;            
--      --
--      FOR r_row IN ( 
--                    WITH json_data AS (
--                                       SELECT l_clob AS json_text
--                                       FROM dual
--                                       ) 
--                    SELECT name, client_id, client_secret
--                    FROM json_data,
--                         JSON_TABLE( json_text, '$.items[*]'
--                           COLUMNS (
--                           name                     VARCHAR2(2000)   PATH '$.name',
--                           client_id                VARCHAR2(2000)   PATH '$.client_id',
--                           client_secret            VARCHAR2(2000)   PATH '$.client_secret'
--                           )
--                         )
--                   ) LOOP
--          l_data.extend;
--          d( 'r_row.name = '||r_row.name ); 
--          d( 'r_row.client_id = '||r_row.client_id ); 
--          d( 'r_row.client_secret = '||r_row.client_secret ); 
--          l_data(l_data.last) := xxapi_user_ords_clients_type
--                                ( r_row.name
--                                , r_row.client_id
--                                , r_row.client_secret               
--                                );
--      END LOOP;                 
--      --
--      e ( c_routine_name );  
--      FOR i IN 1 .. l_data.count LOOP
--          PIPE ROW ( l_data(i) );
--      END LOOP;
--      --
--      RETURN;
--      --
--   EXCEPTION
--   WHEN OTHERS THEN
--      debug( c_routine_name, 'ERROR: '||sqlerrm );
--      RAISE;
--      --
--   END get_user_ords_clients ;     
   --
   --------------------------------------------------------
   --
   --------------------------------------------------------
   FUNCTION get_ords_data  ( p_application in varchar2 ,p_uri in varchar2 )   
   RETURN xxapi_user_ords_data_table_type PIPELINED
   IS
      c_routine_name   CONSTANT VARCHAR2(30) := 'get_ords_data';          
      l_return_value   VARCHAR2(400) :='';
      l_data           xxapi_user_ords_data_table_type := xxapi_user_ords_data_table_type();
      l_clob           CLOB;
      l_json_obj       json_array_t;
      l_result         number;
      l_url            VARCHAR2(2000);
      l_client_id      VARCHAR2(2000);
      l_client_secret  VARCHAR2(2000);
      --
      PROCEDURE d ( p_message IN VARCHAR2 )
      IS
      BEGIN 
         NULL;
         debug( c_routine_name, p_message  );  
      END;         
      PROCEDURE d ( p_message IN VARCHAR2, p_clob IN CLOB )
      IS
      BEGIN 
         NULL;
         debug( c_routine_name, p_message, p_clob  );  
      END;        
   BEGIN
      s ( c_routine_name );     
      --
      --l_result := test_user_ords_clients( p_application );
      select   client_id,          secret
      into   l_client_id, l_client_secret  
      from xxapi_api_users
      where application_code_name = p_application;
      --     
      d( 'l_client_id     = '|| l_client_id ); 
      d( 'l_client_secret = '|| l_client_secret ); 
      d( 'token_url       = '|| g_base_url||lower(p_application)||'/oauth/token' ); 
      apex_web_service.g_request_headers.DELETE(); 
      apex_web_service.oauth_authenticate ( p_token_url     =>  g_base_url||lower(p_application)||'/oauth/token'
                                           , p_client_id     => l_client_id
                                           , p_client_secret => l_client_secret
                                           );
      --
      --apex_web_service.g_request_headers.DELETE();   
      --   
      l_url := g_base_url||lower(p_application)||'/ordsClients'||p_uri;
      d( 'l_url = '||l_url ); 
      --
      apex_web_service.g_request_headers( 1 ).name  := 'Authorization';
      apex_web_service.g_request_headers( 1 ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token;          
      apex_web_service.g_request_headers( 2 ).name  := 'Content-Type';
      apex_web_service.g_request_headers( 2 ).value := 'application/json'; --'text/csv';


      l_clob := apex_web_service.make_rest_request   
                   ( p_url                => l_url
                   , p_http_method        => 'GET'
                   );       
      d( 'l_clob', l_clob );     
      --FOR i IN 1.. apex_web_service.g_headers.count LOOP
      --    d( 'apex_web_service.g_headers('||to_char(i)||': '||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value );
          --if  l_total_rows = -1 and apex_web_service.g_headers(i).name  = 'totalRows' then
          --    l_total_rows := apex_web_service.g_headers(i).value;
          --    d( 'l_total_rows = '|| l_total_rows );  
          --end if;
      --END LOOP;            
      --
      FOR r_row IN ( 
                    WITH json_data AS (
                                       SELECT l_clob AS json_text
                                       FROM dual
                                       ) 
                    SELECT name, client_id, client_secret, updated_on
                    FROM json_data,
                         JSON_TABLE( json_text, '$.items[*]'
                           COLUMNS (
                           name                     VARCHAR2(2000)   PATH '$.field1',
                           client_id                VARCHAR2(2000)   PATH '$.field2',
                           client_secret            VARCHAR2(2000)   PATH '$.field3',
                           updated_on               VARCHAR2(2000)   PATH '$.field4'
                           )
                         )
                   ) LOOP
          l_data.extend;
          d( 'r_row.name          = '||r_row.name ); 
          d( 'r_row.client_id     = '||r_row.client_id ); 
          d( 'r_row.client_secret = '||r_row.client_secret ); 
          d( 'r_row.updated_on    = '||r_row.updated_on ); 
          l_data(l_data.last) := xxapi_user_ords_data_type
                                ( r_row.name
                                , r_row.client_id
                                , r_row.client_secret   
                                , r_row.updated_on
                                );
      END LOOP;                 
      --
      e ( c_routine_name );  
      FOR i IN 1 .. l_data.count LOOP
          PIPE ROW ( l_data(i) );
      END LOOP;
      --
      RETURN;
      --
   EXCEPTION
   WHEN OTHERS THEN
      debug( c_routine_name, 'ERROR: '||sqlerrm );
      RAISE;
      --
   END get_ords_data ;     
   --
--   --------------------------------------------------------
--   --
--   --------------------------------------------------------
--   FUNCTION get_custom_apis  ( p_application in varchar2 ) 
--   RETURN xxapi_user_ords_clients_table_type PIPELINED
--   IS
--      c_routine_name   CONSTANT VARCHAR2(30) := 'get_custom_apis';          
--      l_return_value   VARCHAR2(400) :='';
--      l_data           xxapi_user_ords_clients_table_type := xxapi_user_ords_clients_table_type();
--      l_clob           CLOB;
--      l_json_obj       json_array_t;
--      l_result         number;
--      l_url            VARCHAR2(2000);
--      l_client_id      VARCHAR2(2000);
--      l_client_secret  VARCHAR2(2000);
--      --
--      PROCEDURE d ( p_message IN VARCHAR2 )
--      IS
--      BEGIN 
--         NULL;
--         debug( c_routine_name, p_message  );  
--      END;         
--      PROCEDURE d ( p_message IN VARCHAR2, p_clob IN CLOB )
--      IS
--      BEGIN 
--         NULL;
--         debug( c_routine_name, p_message, p_clob  );  
--      END;        
--   BEGIN
--      s ( c_routine_name );     
--      --
--      --l_result := test_user_ords_clients( p_application );
--      select   client_id,          secret
--      into   l_client_id, l_client_secret  
--      from xxapi_api_users
--      where application_code_name = p_application;
--      --     
--      d( 'l_client_id     = '|| l_client_id ); 
--      d( 'l_client_secret = '|| l_client_secret ); 
--      d( 'toke_url        = '|| g_base_url||lower(p_application)||'/oauth/token' ); 
--      apex_web_service.oauth_authenticate ( p_token_url     =>  g_base_url||lower(p_application)||'/oauth/token'
--                                           , p_client_id     => l_client_id
--                                           , p_client_secret => l_client_secret
--                                           );
--      --
--      apex_web_service.g_request_headers.DELETE();   
--      --   
--      l_url :=  g_base_url||lower(p_application)||'/ordsClients/v1/apis';
--      d( 'l_url = '||l_url ); 
--      --
--      apex_web_service.g_request_headers( 1 ).name  := 'Content-Type';
--      apex_web_service.g_request_headers( 1 ).value := 'application/json'; --'text/csv';
--      apex_web_service.g_request_headers( 2 ).name  := 'Authorization';
--      apex_web_service.g_request_headers( 2 ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token;       
--      
--      l_clob := apex_web_service.make_rest_request   
--                   ( p_url                => l_url
--                   , p_http_method        => 'GET'
--                   );       
--      d( 'l_clob', l_clob );     
--      --FOR i IN 1.. apex_web_service.g_headers.count LOOP
--      --    d( 'apex_web_service.g_headers('||to_char(i)||': '||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value );
--          --if  l_total_rows = -1 and apex_web_service.g_headers(i).name  = 'totalRows' then
--          --    l_total_rows := apex_web_service.g_headers(i).value;
--          --    d( 'l_total_rows = '|| l_total_rows );  
--          --end if;
--      --END LOOP;            
--      --
--      FOR r_row IN ( 
--                    WITH json_data AS (
--                                       SELECT l_clob AS json_text
--                                       FROM dual
--                                       ) 
--                    SELECT name, client_id, client_secret
--                    FROM json_data,
--                         JSON_TABLE( json_text, '$.items[*]'
--                           COLUMNS (
--                           name                     VARCHAR2(2000)   PATH '$.application',
--                           client_id                VARCHAR2(2000)   PATH '$.label',
--                           client_secret            VARCHAR2(2000)   PATH '$.value'
--                           )
--                         )
--                   ) LOOP
--          l_data.extend;
--          d( 'r_row.application = '||r_row.name ); 
--          d( 'r_row.label = '||r_row.client_id ); 
--          d( 'r_row.value = '||r_row.client_secret ); 
--          l_data(l_data.last) := xxapi_user_ords_clients_type
--                                ( r_row.name
--                                , r_row.client_id
--                                , r_row.client_secret               
--                                );
--      END LOOP;                 
--      --
--      e ( c_routine_name );  
--      FOR i IN 1 .. l_data.count LOOP
--          PIPE ROW ( l_data(i) );
--      END LOOP;
--      --
--      RETURN;
--      --
--   EXCEPTION
--   WHEN OTHERS THEN
--      debug( c_routine_name, 'ERROR: '||sqlerrm );
--      RAISE;
--      --
--   END get_custom_apis ;     
   FUNCTION get_base_url RETURN VARCHAR2
   IS
   BEGIN
      return g_base_url;
   END;   
------------------------------ Initialization section----------------------     
BEGIN  

   debug( 'Initialization section', '-----Initialization section----start--' );   
   -- 
   if    instr( sys_context('USERENV'   , 'DB_NAME') ,'APXDEV') > 0 then
      g_base_url  := 'https://g1cb1b3dd717dd7-apxdev.adb.eu-frankfurt-1.oraclecloudapps.com/ords/';
   elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXTST') > 0 then
      g_base_url  := 'https://g1cb1b3dd717dd7-apxtst.adb.eu-frankfurt-1.oraclecloudapps.com/ords/';
   elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXACC') > 0  then
      g_base_url  := 'https://g1cb1b3dd717dd7-apxacc.adb.eu-frankfurt-1.oraclecloudapps.com/ords/';
   elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXPRD') > 0 then
      g_base_url  := 'https://g1cb1b3dd717dd7-apxprd.adb.eu-frankfurt-1.oraclecloudapps.com/ords/';
   end if;   
   --
   debug( 'Initialization section', 'g_base_url = '||g_base_url ); 
   debug( 'Initialization section', '-----Initialization section----end--' ); 
END xxapi_dispatcher_pkg;

/

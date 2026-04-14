--------------------------------------------------------
--  DDL for Package Body XXAPI_ORDS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_ORDS_PKG" 
AS
   gc_package_name     CONSTANT           VARCHAR(50) := 'XXAPI_ORDS_PKG';
   gc_log_debug_info                      BOOLEAN       := TRUE;
   c_transfer_timeout  CONSTANT           INTEGER       := 180;
   g_base_url                             VARCHAR2(300);
   g_api_active                           BOOLEAN     := TRUE;
   --
   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      xxapi_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine,p_message, p_message_clob );  
      NULL;   
   END debug;   
   --  
   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug_bs ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_blob IN BLOB )
   IS
   BEGIN
      xxapi_gen_debug_pkg.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message), p_blob);
      NULL;
   END debug_bs;  
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to be inster debug messages into debug table.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE d ( p_routine IN VARCHAR2, p_message IN VARCHAR2,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN  
      CASE WHEN gc_log_debug_info THEN xxapi_gen_debug_pkg.debug_cs ( gc_package_name||'.'||p_routine,p_message, p_message_clob ); 
         ELSE NULL;
      END CASE;     
   END d;    
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to log the start of the routine, used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE s ( p_routine IN VARCHAR2 )    
   IS   
   BEGIN   
      d( p_routine, '(start)' );     
   END s;    
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to log the end of the routine, used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE e ( p_routine IN VARCHAR2, p_message IN VARCHAR2 DEFAULT NULL,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      d( p_routine, '(end) '||p_message, p_message_clob );  
   END e;    
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to log exception handling errors be used for debugging purposes.   
   ---------------------------------------------------------------------------------------------   
   PROCEDURE er ( p_routine IN VARCHAR2, p_message IN VARCHAR2 DEFAULT NULL,  p_message_clob IN CLOB DEFAULT NULL )    
   IS   
   BEGIN   
      d( gc_package_name||'.'||p_routine, '(end) ERROR: '||p_message, p_message_clob );  
   END er;    
   --
   ---------------------------------------------------------------------------------------------   
   -- 
   ---------------------------------------------------------------------------------------------   
   PROCEDURE update_credential ( p_application in varchar2, p_client_id in varchar2, p_client_secret in varchar2 ) 
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'update_credential';
      l_credential_name   varchar2(200) := 'Credentials for accessing XX'||p_application;
   BEGIN
      debug( c_routine_name, '(start)' ); 
      debug( c_routine_name, 'p_application   = '|| p_application ); 
      --debug( c_routine_name, 'p_client_id     = '|| p_client_id ); 
      --debug( c_routine_name, 'p_client_secret = '|| p_client_secret ); 
      for r_row in (
                   select *
                   from apex_workspace_credentials
                   where name = l_credential_name
                   ) loop
          debug( c_routine_name,'Updating the Client ID and Client Secret for: ''' ||l_credential_name||'''');         
          apex_credential.set_persistent_credentials
           ( p_credential_static_id => r_row.static_id
           , p_client_id            => p_client_id
           , p_client_secret        => p_client_secret 
           );
     end loop;  
     debug( c_routine_name, '(end)' );
   EXCEPTION
   WHEN OTHERS THEN
       -- no credential to update?
       debug( c_routine_name, 'ERROR: '||SQLERRM ); 
   END update_credential;
   -- 
   ---------------------------------------------------------------------------------------------   
   -- 
   ---------------------------------------------------------------------------------------------   
   FUNCTION call_request   ( p_url          IN VARCHAR2
                           , p_http_method  IN VARCHAR2
                           , p_body         IN VARCHAR2
                           , p_token_url    IN VARCHAR2
                           , p_client_id    IN VARCHAR2
                           , p_secret       IN VARCHAR2
                           , p_scope        IN VARCHAR2 
                           )
   RETURN CLOB
   IS
      c_routine_name   CONSTANT VARCHAR2(30) := 'call_request';          
      l_clob              CLOB;
      l_index             INTEGER:= 1;
      l_sqlerrm           CLOB;
      l_header_parameters CLOB;
      l_body_blob         BLOB;
   BEGIN
      debug( c_routine_name, '(start)' );  
      debug( c_routine_name, 'p_url         = '||p_url );
      debug( c_routine_name, 'p_http_method = '||p_http_method );
      debug( c_routine_name, 'p_body        = '||p_body );
      debug( c_routine_name, 'p_token_url   = '||p_token_url );
      debug( c_routine_name, 'p_client_id   = '||p_client_id );
      debug( c_routine_name, 'p_secret      = '||p_secret );

      -- when data is send in the body convert this to a blob
      IF p_body IS NOT NULL THEN
         l_body_blob := apex_util.clob_to_blob( p_body , 'WE8ISO8859P1');
      END IF;

      -- only when API is set active run the API
      IF g_api_active THEN     
         apex_web_service.g_request_headers.DELETE(); 
         -- get new bearer token or use existing
         apex_web_service.oauth_authenticate ( p_token_url     => p_token_url
                                             , p_client_id     => p_client_id
                                             , p_client_secret => p_secret
                                             , p_scope         => p_scope
                                             );  
         debug( c_routine_name, 'authentication succeeded.' );

         -- when payload in the body add content type to headers
         IF p_body IS NOT NULL THEN
            apex_web_service.g_request_headers( l_index ).name  := 'Content-Type';
            apex_web_service.g_request_headers( l_index ).value := 'application/json';
            l_index := l_index + 1;
         END IF;   

         -- add bearer token to headers
         apex_web_service.g_request_headers( l_index ).name  := 'Authorization';
         apex_web_service.g_request_headers( l_index ).value := 'Bearer ' ||apex_web_service.oauth_get_last_token; 

         -- make the request and catch the return value 
         l_clob := apex_web_service.make_rest_request ( p_url                => p_url   
                                                      , p_http_method        => p_http_method   
                                                      , p_transfer_timeout   => c_transfer_timeout   
                                                      , p_body               => p_body  
                                                      );

         debug( c_routine_name, 'l_clob  =' ||l_clob );          
      END IF;   

      -- format headers for logging
      FOR i IN 1.. apex_web_service.g_headers.count LOOP
           l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
      END LOOP;  

      -- log the request
      INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
      VALUES                                         ( p_url , p_http_method , l_body_blob  , l_clob           , l_header_parameters);

      debug( c_routine_name, '(end) l_clob = ' || substr( l_clob , 1, 200 ));      

      RETURN l_clob;

   EXCEPTION
      WHEN OTHERS THEN
         l_sqlerrm           := sqlerrm;
         l_header_parameters := NULL;
         FOR i IN 1.. apex_web_service.g_headers.count LOOP
              l_header_parameters := l_header_parameters||apex_web_service.g_headers(i).name ||' value: '||apex_web_service.g_headers(i).value||chr(13);
         END LOOP;  
         INSERT INTO wksp_xxapi.xxapi_executed_requests ( url   , http_method   , request_body , request_response , header_parameters) 
         VALUES                                         ( p_url , p_http_method , l_body_blob  , l_sqlerrm        , l_header_parameters);
         debug( c_routine_name, 'ERROR: '||l_sqlerrm);      
         RAISE;
   END call_request; 
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------   
   PROCEDURE run_test
   IS 
      l_response   CLOB;
   BEGIN
      l_response := call_request   
                    ( p_url          => 'https://omdanvv42ktvbrzt7mnl2r4nfu.apigateway.eu-frankfurt-1.oci.customer-oci.com/picasso/' || 'partners/v2/getNewVcode'
                    , p_http_method  => 'GET'
                    , p_body         => NULL
                    , p_token_url    => 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token'
                    , p_client_id    => '9af6847be6b24f42ae4949234a73178a'
                    , p_secret       => 'cd1163e6-16ef-4578-906c-c8e8d1228c98'
                    , p_scope        => 'picasso:apxdev:salesforce'
                    );
   END run_test;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------   
   PROCEDURE update_lookup_values ( p_owning_app in varchar2, p_calling_app in varchar2, p_client_id in varchar2, p_client_secret in varchar2 ) 
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'update_lookup_values';
      l_resonse        CLOB;
      l_url            VARCHAR2(2000) :=  xxapi_dispatcher_pkg.g_base_url || lower( p_owning_app ) ||  '/ordsClients/v1/lookups';
      l_parameters     VARCHAR2(2000) := '?client_id='||p_client_id||'&client_secret='||p_client_secret||'&calling_app='|| p_calling_app;
      l_client_id      VARCHAR2(2000);
      l_client_secret  VARCHAR2(2000);
      l_token_url      VARCHAR2(2000) := xxapi_dispatcher_pkg.g_base_url ||lower(  p_owning_app)  || '/oauth/token';
   BEGIN
      s( c_routine_name );   
      debug( c_routine_name , 'p_owning_app    = '|| p_owning_app );
      debug( c_routine_name , 'p_calling_app   = '|| p_calling_app );
      debug( c_routine_name , 'p_client_id     = '|| p_client_id );
      debug( c_routine_name , 'p_client_secret = '|| p_client_secret );
      debug( c_routine_name , 'l_url (POST)    = '|| l_url );
      debug( c_routine_name , 'l_token_url = '|| l_token_url );
      --
      select  client_id,          secret
      into  l_client_id, l_client_secret
      from xxapi_api_users
      where application_code_name = p_owning_app
      ;
      debug( c_routine_name , p_owning_app ||': l_client_id     = '|| l_client_id );
      debug( c_routine_name , p_owning_app ||': l_client_secret = '|| l_client_secret );

      l_resonse := call_request   ( p_url          => l_url || l_parameters 
                                  , p_http_method  => 'POST'
                                  , p_body         => null
                                  , p_token_url    => l_token_url
                                  , p_client_id    => l_client_id
                                  , p_secret       => l_client_secret
                                  , p_scope        => null
                                  );  
      debug( c_routine_name ,  'l_resonse =', l_resonse);                              
      e( c_routine_name, NULL );
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;     
   END update_lookup_values;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------   
   FUNCTION recreate_ord_credentials ( p_owner IN VARCHAR2,  p_target IN VARCHAR2 ) 
   RETURN xxapi_user_ords_data_type
   IS 
      c_routine_name   CONSTANT VARCHAR2(200) := 'recreate_ord_credentials (function)';
      l_grantor        VARCHAR2(100) := p_owner;
      l_grantee        VARCHAR2(100) := p_target;
      l_name           VARCHAR2(100) := 'to allow '||l_grantee||' to access '||l_grantor||' objects';
      l_client_name    VARCHAR2(100) := 'Credentials '||l_name;
      l_owner          VARCHAR2(100) := 'WKSP_XX'||l_grantor;
      l_description    VARCHAR2(100) := 'Allow '||l_grantee||' to access '||l_grantor||' objects';
      l_count          NUMBER;
      l_rec            xxapi_user_ords_data_type := xxapi_user_ords_data_type( NULL, NULL, NULL,NULL);
      PRAGMA           autonomous_transaction;
   BEGIN
      s( c_routine_name );  
      SELECT COUNT(*)
      INTO l_count
      FROM user_ords_clients
      WHERE name = l_client_name
      ;
      IF l_count > 0 THEN
         oauth.delete_client (p_name            => l_client_name);
      END IF
      ;
      oauth.create_client( p_name            => l_client_name
                         , p_grant_type      => 'client_credentials'
                         , p_owner           => l_owner
                         , p_description     => l_description
                         , p_support_email   => 'odis-devops-teams@kpn.com'
                         , p_privilege_names => 'Privilege '||l_name
                         );
      COMMIT;
      --
      SELECT name          , client_id    , client_secret
      INTO   l_rec.field1, l_rec.field2, l_rec.field3
      FROM user_ords_clients
      WHERE name = l_client_name
      ;
      e( c_routine_name, NULL );
      RETURN l_rec;
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;     
   END recreate_ord_credentials;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------   
   FUNCTION call_recreate_ord_credentials ( p_application IN VARCHAR2, p_target in varchar2 ) 
   RETURN xxapi_user_ords_data_type
   IS 
      c_routine_name   CONSTANT VARCHAR2(200) := 'call_recreate_ord_credentials (function)';
      l_count          NUMBER;
      l_rec            xxapi_user_ords_data_type := xxapi_user_ords_data_type( NULL, NULL, NULL,NULL);
      l_client_id      VARCHAR2(200);
      l_secret         VARCHAR2(200);
      l_token_url      VARCHAR2(200);
      l_url            VARCHAR2(2000);
      l_response       clob;
   BEGIN
      s( c_routine_name ); 
      debug( c_routine_name , 'p_application = '|| p_application );
      --
      select client_id,   secret
      into l_client_id, l_secret
      from xxapi_api_users
      where application_code_name = p_application
      ;
      l_url       := xxapi_dispatcher_pkg.get_base_url || lower( p_application)||'/ordsClients/v1/recreateIds?owning_app='||p_application||'&calling_app='||p_target;
      debug( c_routine_name , 'l_url = '|| l_url );
      l_token_url := xxapi_dispatcher_pkg.get_base_url || lower(p_application)|| '/oauth/token'
      ;
      l_response := xxapi_dispatcher_pkg.call_request
                    ( p_url          => l_url
                    , p_http_method  => 'POST'
                    , p_body         => NULL
                    , p_token_url    => l_token_url
                    , p_client_id    => l_client_id
                    , p_secret       => l_secret
                    );
      debug( c_routine_name , 'l_response = (see clob column) ', l_response );  
      for r_row in (
                    SELECT credential_name
                    ,      owning_application
                    ,      jt.name
                    ,      jt.client_id
                    ,      jt.client_secret
                    FROM 
                        JSON_TABLE( l_response,
                                    '$[*]' 
                                    COLUMNS ( credential_name     VARCHAR2(100) PATH '$.credential_name'
                                            , owning_application  VARCHAR2(100) PATH '$.owning_application'
                                            , name                VARCHAR2(100) PATH '$.name'
                                            , client_id           VARCHAR2(200) PATH '$.client_id'
                                            , client_secret       VARCHAR2(200) PATH '$.client_secret'
                                            )
                                   ) jt 
                   ) loop
         debug( c_routine_name , 'r_row.owning_application = ' || r_row.owning_application);            
         debug( c_routine_name , 'r_row.name (calling app) = ' || r_row.name);    
         -- Only credentials like Credentials to allow API to access xxx will be used to update
         -- the xxapi_api_users table.
         l_rec.field1 := r_row.owning_application;
         l_rec.field2 := r_row.client_id;
         l_rec.field3 := r_row.client_secret;
         if r_row.name ='API' then
            update xxapi_api_users
            set client_id    = r_row.client_id
            ,   secret       = r_row.client_secret
            where application_code_name = r_row.owning_application
            ;
            debug( c_routine_name , r_row.credential_name||': number of updates = ' || SQL%ROWCOUNT);  
            -- 
            update_credential ( p_application   => r_row.owning_application
                              , p_client_id     => r_row.client_id
                              , p_client_secret => r_row.client_secret
                              ); 
         else
            -- if name = CT and owning_application = PM then the pm credentials need to be sent to CT
            -- if name = PM and owning_application = TV then the tv credentials need to be sent to PM
            debug( c_routine_name , 'r_row.client_id          = ' || r_row.client_id);    
            debug( c_routine_name , 'r_row.client_secret      = ' || r_row.client_secret);    
            debug( c_routine_name , 'r_row.owning_application = ' || r_row.owning_application);    
            debug( c_routine_name , 'r_row.name               = ' || r_row.name);    
            --update_lookup_values( r_row.owning_application , r_row.name, r_row.client_id, r_row.client_secret );
            update_lookup_values( r_row.name , r_row.owning_application, r_row.client_id, r_row.client_secret );
         end if;
      end loop;                 
      e( c_routine_name, NULL );
      RETURN l_rec;
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;     
   END call_recreate_ord_credentials;   
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------     
   PROCEDURE recreate_api_credentials
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'recreate_api_credentials';
      l_rec            xxapi_user_ords_data_type;
   BEGIN
      s( c_routine_name );
      FOR r_row IN (
                    SELECT xuo.schema
                    ,      replace( replace( xuo.name, 'Credentials to allow ',''), ' to access '||schema||' objects','') target
                    FROM xxapi_all_user_ords_clients_v xuo 
                    WHERE schema ='API'
                   ) LOOP
         l_rec := recreate_ord_credentials ( r_row.schema, r_row.target );
         IF r_row.schema = 'API' THEN
            UPDATE xxapi_api_users 
            SET client_id  = l_rec.field2
            ,   secret     = l_rec.field3
            WHERE application_code_name = 'API';
            debug( c_routine_name , 'number of updates 1 = ' || SQL%ROWCOUNT);  
         END IF;
      END LOOP;      
      COMMIT;
      e( c_routine_name, NULL );
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;         
   END recreate_api_credentials;   
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------     
   PROCEDURE recreate_credentials_needed_for_xxapi
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'recreate_credentials_needed_for_xxapi';
      l_rec            xxapi_user_ords_data_type;
   BEGIN
      s( c_routine_name );
      FOR r_row IN (
                    SELECT xuo.schema
                    ,      replace( replace( xuo.name, 'Credentials to allow ',''), ' to access '||schema||' objects','') target
                    FROM xxapi_all_user_ords_clients_v xuo 
                    WHERE 1=1
                    AND   schema in ('CPC','CT', 'TV','PM')
                    AND   replace( replace( xuo.name, 'Credentials to allow ',''), ' to access '||schema||' objects','') ='API'
                   ) LOOP
         debug( c_routine_name , '------------------------------------' );
         debug( c_routine_name , 'r_row.schema = '|| r_row.schema ||' r_row.target = '|| r_row.target  );          
         l_rec := call_recreate_ord_credentials ( r_row.schema, r_row.target  );
      END LOOP;     
      --
      COMMIT;
      e( c_routine_name, NULL );
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;         
   END recreate_credentials_needed_for_xxapi;  
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------     
   PROCEDURE recreate_inter_app_credentials
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'recreate_inter_app_credentials';
      l_rec            xxapi_user_ords_data_type;
      --l_token_url      VARCHAR2(2000);
      --l_url            VARCHAR2(2000);
      --l_response       clob;
   BEGIN
      s( c_routine_name );
      FOR r_row IN (      
                    SELECT xuo.schema
                    ,      replace( replace( xuo.name, 'Credentials to allow ',''), ' to access '||schema||' objects','') target
                    ,      xuo.name
                    FROM xxapi_all_user_ords_clients_v xuo 
                    WHERE 1=1
                    AND   schema in ('CPC','CT', 'TV','PM')
                    AND   replace( replace( xuo.name, 'Credentials to allow ',''), ' to access '||schema||' objects','') !='API'      
                   ) LOOP                    
         debug( c_routine_name , '------------------------------------' );
         debug( c_routine_name , 'r_row.name = '|| r_row.name ||' r_row.schema = '|| r_row.schema ||' r_row.target = '|| r_row.target  );          
         l_rec := call_recreate_ord_credentials ( r_row.schema , r_row.target );
         debug( c_routine_name , 'l_rec.name          = '|| l_rec.field1  );          
         debug( c_routine_name , 'l_rec.client_id     = '|| l_rec.field2  );          
         debug( c_routine_name , 'l_rec.client_secret = '|| l_rec.field3  );
         --  
         update_lookup_values (   r_row.target, r_row.schema, l_rec.field2, l_rec.field3 ); 
         --
--         l_url       := xxapi_dispatcher_pkg.g_base_url ||lower( l_rec.field1 ) ||'/ordsClients/v1/lookups';
--         l_token_url := xxapi_dispatcher_pkg.g_base_url ||lower(  l_rec.field1 )  || '/oauth/token';
--         l_response := call_request ( p_url            => l_url
--                                    , p_http_method    => 'POST'
--                                    , p_body           => null
--                                    , p_token_url      => l_token_url
--                                    , p_client_id      => l_rec.field2
--                                    , p_secret         => l_rec.field3
--                                    , p_scope          => null
--                                    );
--          debug( c_routine_name , 'l_response (see clob column)' , l_response  );                          
      END LOOP;     
      --
      COMMIT;
      e( c_routine_name, NULL );
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;         
   END recreate_inter_app_credentials;    
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------     
   PROCEDURE recreate_ords_credentials
   IS
      c_routine_name   CONSTANT VARCHAR2(200) := 'recreate_ords_credentials (procedure)';
      l_rec            xxapi_user_ords_data_type;
      --PRAGMA           autonomous_transaction;
   BEGIN
      s( c_routine_name );
      -- For API-schema only. This Credential is used for allowing Oracle Gateway OCI to access this Apex application.
      recreate_api_credentials;
      -- 
      -- This section recreates the client_id's and client_secrets in 'the other' applications. These are the applications that
      -- the API-Dispatcher application needs to interact with.
      -- OCI in the XXAPI_API_USESRS table is added so we can execute api's that go through the Oracle OCI-gateway
      -- The client_id and client_secret of the OCI record in this table should not be changed.
      -- The OCI values only change when an Oracle OCI database administrator changes them.      
      recreate_credentials_needed_for_xxapi;
      -- 
      -- This section recreates the client_id's and client_secrets in 'the other' applications that interact other (not XXAPI) application. 
      -- These are the inter-applications interactions, like TV calling PM or vice versa.
      recreate_inter_app_credentials;
      --
      e( c_routine_name, NULL );
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;         
   END recreate_ords_credentials;
   --
   ---------------------------------------------------------------------------------------------   
   -- Procedure to  
   ---------------------------------------------------------------------------------------------   
   FUNCTION get_web_credentials ( p_application IN VARCHAR2 ) 
   RETURN xxapi_user_ords_data_type
   IS 
      c_routine_name   CONSTANT VARCHAR2(200) := 'get_web_credentials (function)';
      l_count          NUMBER;
      l_rec            xxapi_user_ords_data_type := xxapi_user_ords_data_type( NULL, NULL, NULL,NULL);
      l_client_id      VARCHAR2(200);
      l_secret         VARCHAR2(200);
      l_token_url      VARCHAR2(200);
      l_url            VARCHAR2(2000);
      l_response       clob;
   BEGIN
      s( c_routine_name ); 
      debug( c_routine_name , 'p_application = '|| p_application );
      --
      select client_id,   secret
      into l_client_id, l_secret
      from xxapi_api_users
      where application_code_name = p_application
      ;
      l_url       := xxapi_dispatcher_pkg.get_base_url || lower( p_application)||'/ordsClients/v1/getWebCreds';
      debug( c_routine_name , 'l_url = '|| l_url );
      l_token_url := xxapi_dispatcher_pkg.get_base_url || lower(p_application)|| '/oauth/token'
      ;
      l_response := xxapi_dispatcher_pkg.call_request
                    ( p_url          => l_url
                    , p_http_method  => 'GET'
                    , p_body         => NULL
                    , p_token_url    => l_token_url
                    , p_client_id    => l_client_id
                    , p_secret       => l_secret
                    );
      debug( c_routine_name , 'l_response = ', l_response );  
      for r_row in (
                    SELECT credential_name
                    ,      owning_application
                    ,      jt.name
                    ,      jt.client_id
                    ,      jt.client_secret
                    FROM 
                        JSON_TABLE( l_response,
                                    '$[*]' 
                                    COLUMNS ( credential_name     VARCHAR2(100) PATH '$.credential_name'
                                            , owning_application  VARCHAR2(100) PATH '$.owning_application'
                                            , name                VARCHAR2(100) PATH '$.name'
                                            , client_id           VARCHAR2(200) PATH '$.client_id'
                                            , client_secret       VARCHAR2(200) PATH '$.client_secret'
                                            )
                                   ) jt 
                   ) loop
         debug( c_routine_name , 'r_row.owning_application = ' || r_row.owning_application);            
         update xxapi_api_users
         set client_id    = r_row.client_id
         ,   secret       = r_row.client_secret
         where application_code_name = r_row.owning_application
         ;
         debug( c_routine_name , r_row.credential_name||': number of updates 2 = ' || SQL%ROWCOUNT);  
         -- 
         update_credential ( p_application   => r_row.owning_application
                           , p_client_id     => r_row.client_id
                           , p_client_secret => r_row.client_secret
                           ); 
      end loop;                 
      e( c_routine_name, NULL );
      RETURN l_rec;
   EXCEPTION
      WHEN OTHERS THEN
         er( c_routine_name, 'ERROR: '||sqlerrm);      
         RAISE;     
   END get_web_credentials;   
END xxapi_ords_pkg;

/

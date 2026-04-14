--------------------------------------------------------
--  DDL for Procedure XXAPI_KEEP_ALIVE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXAPI"."XXAPI_KEEP_ALIVE" 
AUTHID definer
IS
   c_routine_name     VARCHAR2(200)  :=  'xxapi_keep_alive';
   l_bearer_token     VARCHAR2(32767);      
   l_url              VARCHAR2(2000) := 'https://omdanvv42ktvbrzt7mnl2r4nfu.apigateway.eu-frankfurt-1.oci.customer-oci.com/picasso/user/v1/tvRole'; 
   l_body             CLOB           := '{ "username":"keepaliveuser@kpn.com","ruisname":"keepalive","role":"Keep Alive", "action":"GRANT"}';
   l_clob             CLOB;
   l_client_id        VARCHAR2(200);  
   l_client_secret    VARCHAR2(200);
   l_scope            VARCHAR2(200);
   l_token_url        VARCHAR2(200);
   l_env              VARCHAR2(200);
   l_time_in_seconds  NUMBER;
   l_start_date       DATE;
   l_otap_env         VARCHAR2(200); 
   l_counter          NUMBER := 0;
   PRAGMA autonomous_transaction;
BEGIN
   xxapi_gen_debug_pkg.debug( c_routine_name, '(start)');
   -- The keep_alive procedure runs frequently. We not want to use more tablespace than necesssary. So we delete all registrations older than 24 hours.
   begin
       delete from xxapi_debug
       where routine = 'xxapi_keep_alive'
       and timestamp < sysdate -1
       and message like '(start)'
       ;
--       delete from xxapi_debug
--       where seq_nr in (select seq_nr 
--                        from xxapi_debug 
--                        where routine = 'xxapi_keep_alive'
--                        and timestamp < sysdate -1
--                        --and message not like '(end)%'
--                        and message not like 'ERROR%'
--                        and duration  < 8 
--                        )
--       --and to_number( substr( message,17,7)) < 8 -- delete only short durarions. Long durations need to be investigated                        
--       ;
       commit;
   exception
   when others then
      xxapi_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||SQLERRM);
   end;
   xxapi_gen_debug_pkg.debug( c_routine_name, 'after delete section');
   IF instr( sys_context('USERENV'   , 'DB_NAME') ,'APXPRD') > 0 THEN
      l_client_id     := '93313aa96d9942459dfcc9548f33e1f7';
      l_client_secret := '049c9e5d-3755-4845-bd41-7c71984f0b6d';
      --l_token_url     := 'https://era-apigw.oci.kpn.com/env/token'; 
      l_token_url     := 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token';
   ELSE
      l_client_id     := '9e97899b934845e58ad82068bf13d91d';
      l_client_secret := '189420b4-1b2f-44fc-8300-3910860f9229';
      l_token_url     := 'https://idcs-e9dd9ef58da944ef9ab853b7506d4452.identity.oraclecloud.com/oauth2/v1/token';
   END IF;     
   xxapi_gen_debug_pkg.debug( c_routine_name, 'l_client_id = '||l_client_id );
   --
   l_otap_env  := sys_context('USERENV'   , 'DB_NAME');
   l_env := substr( l_otap_env, instr( l_otap_env,'_') +1 );
   l_scope         := 'picasso:' ||lower ( l_env )||':dpe';
   xxapi_gen_debug_pkg.debug( c_routine_name, 'l_scope = '||l_scope );
   --
   l_start_date    := sysdate;
   --
   while l_bearer_token is null loop
       l_bearer_token := apex_web_service.oauth_get_last_token;
       xxapi_gen_debug_pkg.debug( c_routine_name, 'l_bearer_token = '||l_bearer_token );
       --
       apex_web_service.oauth_authenticate
             ( p_token_url      => l_token_url
             , p_client_id      => l_client_id
             , p_client_secret  => l_client_secret
             , p_scope          => l_scope
             );     
        exit when l_counter > 3;
        l_counter := l_counter + 1;
   end loop;
   xxapi_gen_debug_pkg.debug( c_routine_name, '1' );
   apex_web_service.g_request_headers.DELETE(); 
   apex_web_service.g_request_headers(1).name  := 'Authorization';   
   apex_web_service.g_request_headers(1).value := 'Bearer ' || l_bearer_token;    
   apex_web_service.g_request_headers(2).name  := 'Content-Type';   
   apex_web_service.g_request_headers(2).value := 'application/json';   
   --
   xxapi_gen_debug_pkg.debug( c_routine_name, '2' );
   l_clob := apex_web_service.make_rest_request   
                   ( p_url                => l_url   
                   , p_http_method        => 'POST'
                   , p_transfer_timeout   => 180   
                   , p_body               => l_body
                   );           
   xxapi_gen_debug_pkg.debug( c_routine_name, '3' );                   
   xxapi_gen_debug_pkg.debug_cs( c_routine_name, 'l_clob ',l_clob);
   l_time_in_seconds :=  round(   ( sysdate - l_start_date) * (60 * 24 *60) ,3 ); 
   xxapi_gen_debug_pkg.debug( c_routine_name, 'l_time_in_seconds = '||l_time_in_seconds );                   
   xxapi_gen_debug_pkg.debug_duration( c_routine_name, '(end) duration = '|| to_char(l_time_in_seconds,'99990.999') ||' seconds '||l_clob, l_time_in_seconds);
   COMMIT;
EXCEPTION
WHEN OTHERS
THEN 
   xxapi_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||sqlerrm); 
   RAISE;
END xxapi_keep_alive;

/

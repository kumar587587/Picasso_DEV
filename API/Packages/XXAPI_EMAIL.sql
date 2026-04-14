--------------------------------------------------------
--  DDL for Package Body XXAPI_EMAIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_EMAIL" 
AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    API004 GENERIC - XXAPI_EMAIL
   *
   * DESCRIPTION
   *    Package to register email status and history
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        05-07-2019  Initial Version 
   * Wiljo Bakker        16-09-2024  Rebuild for use in Cloud   
   **************************************************************/

   -- $Id: XXAPI_EMAIL.pkb,v 1.1 2024/09/20 15:42:38 bakke619 Exp $
   -- $Log: XXAPI_EMAIL.pkb,v $
   -- Revision 1.1  2024/09/20 15:42:38  bakke619
   -- Initial revision
   --
   
   gc_package_body_version       CONSTANT VARCHAR2(200) := '$Id: XXAPI_EMAIL.pkb,v 1.1 2024/09/20 15:42:38 bakke619 Exp $';

   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2 ) IS
      gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN xxapi_gen_debug_pkg.debug( gc_package_name||'.'||p_routine, rtrim(p_message));
             ELSE NULL;
         END CASE;
      ELSE
         xxapi_gen_debug_pkg.debug( gc_package_name||'.'||p_routine, rtrim(p_message));
      END IF;
   END debug;

   ---------------------------------------------------------------------------------------------
   -- Function to get the package body version
   ---------------------------------------------------------------------------------------------
   FUNCTION get_package_body_version
      RETURN VARCHAR2 IS
   BEGIN
      RETURN gc_package_body_version;
   END get_package_body_version;

   ---------------------------------------------------------------------------------------------
   -- Function to get the package spec version
   ---------------------------------------------------------------------------------------------
   FUNCTION get_package_spec_version
      RETURN VARCHAR2 IS
   BEGIN
      RETURN gc_package_spec_version;
   END get_package_spec_version;

   ----------------------------------------------------------------------------
   -- Function to remove redundant characters from an email-string
   ----------------------------------------------------------------------------
   FUNCTION clean_email_string            ( p_value                   in       VARCHAR2  DEFAULT NULL       ) RETURN VARCHAR2
   IS
      lc_routine_name           VARCHAR2(50)      := 'clean_email_string ';
      l_return                  VARCHAR2(32767);
      l_illegal_char            VARCHAR2(100)     := '[`~!#$%^&*()+{}:"|<>?/,\''=]';
   BEGIN

      -- remove redundant semicolons
      l_return := p_value;
      l_return := REGEXP_REPLACE(l_return ,'(;){2,}' ,';');
      l_return := REGEXP_REPLACE(l_return ,l_illegal_char,'');

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         RAISE;
   END clean_email_string ;
   ----------------------------------------------------------------------------
   -- Function to return an email body header line with title
   ----------------------------------------------------------------------------
   FUNCTION add_html_header               ( p_title                   in       VARCHAR   DEFAULT  '&nbsp;'  ) RETURN VARCHAR2
   IS
      lc_routine_name            VARCHAR2(50)      := 'add_html_header';
   BEGIN
      RETURN '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>'||p_title||'</title>
    <style>
      td, th, caption{
        border: 1px solid #999;
        padding: 0.5rem;
        text-align: left;
      }
      caption {
        text-align: center;
      }
      a:link {
          color: blue;
      }
      a:visited {
          color: blue;
      }
      p {
        font-family: Arial, Helvetica, sans-serif;
        color: #000000;
        font-size: 10,5px;
      }
      .bold-text {
        font-family: Arial, Helvetica, sans-serif;
        font-weight: bold;
        color: #000000;
        font-size: 10,5px;
      }
    </style>
  </head>
  <body>
';
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         RETURN '&nbsp;';
   END add_html_header;

   ----------------------------------------------------------------------------
   -- Function to add the formatted signature to the email body
   ----------------------------------------------------------------------------
   FUNCTION add_html_signature            ( p_greetings               in       VARCHAR   DEFAULT  NULL
                                          , p_from_name               in       VARCHAR   DEFAULT  NULL
                                          , p_from_position           in       VARCHAR   DEFAULT  NULL
                                          , p_from_department         in       VARCHAR   DEFAULT  NULL
                                          , p_free_format             in       VARCHAR   DEFAULT  NULL      ) RETURN VARCHAR2
   IS
      lc_routine_name            VARCHAR2(50)      := 'add_html_signature';
      l_return                   VARCHAR2(32767)   := NULL;
   BEGIN
      CASE WHEN length(p_free_format) > 0
           THEN l_return:= p_free_format;
           ELSE l_return := '
<p>'||p_greetings||'</p>
<p>'||p_from_name||'<br />'||p_from_position||'<br /> '||p_from_department||'</p>';
      END CASE;

      RETURN l_return;

   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         RETURN '&nbsp;';
   END add_html_signature;

   ----------------------------------------------------------------------------
   -- Function to return the ending for a standard html page
   ----------------------------------------------------------------------------
   FUNCTION add_html_footer  RETURN VARCHAR2
   IS
      lc_routine_name            VARCHAR2(50)      := 'add_html_footer';
   BEGIN
      RETURN '
</body></html>';
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         RETURN '&nbsp;';
   END add_html_footer;

   ----------------------------------------------------------------------------
   -- Function to format the html body text for the notification
   ----------------------------------------------------------------------------
   FUNCTION format_html_body              ( p_body_text               in       T_BODY_TEXT            
                                          , p_sign_free_format        in       VARCHAR2  DEFAULT NULL ) RETURN CLOB
   IS
      lc_routine_name           VARCHAR2(50)      := 'format_html_body';

      l_email_body              CLOB ;
      l_body_text               T_BODY_TEXT;

      l_sign_greeting           VARCHAR2(32767)    := NULL;
      l_sign_name               VARCHAR2(300)      := NULL;
      l_sign_position           VARCHAR2(300)      := NULL;
      l_sign_department         VARCHAR2(300)      := NULL;
      l_sign_free_format        VARCHAR2(32767)    := p_sign_free_format ;
      l_sign_concatenate        VARCHAR2(32767)    := NULL;

      -- add extra hard-enter (no crlf) after end of line because SMTP protocol only supports lines of max 1000 char.
      -- Adding utl_tcp.crlf (in xxice_send_email prc) after 900 char will result in unwanted spaces, so for now do it like this.
      l_weird                   VARCHAR2(10)       := '
';

      -- local procedure to add a line of text to the CLOB
      PROCEDURE add_line (p_line in varchar2)
      IS
         l_offset          NUMBER := 0;
      BEGIN
         l_offset := dbms_lob.getlength(l_email_body) + 1;
         dbms_lob.write(l_email_body,length(p_line),l_offset,p_line);
      END add_line;

   BEGIN

      -- initialize the clob for the mail-body text
      dbms_lob.createtemporary( l_email_body, false, 10 );

      -- start a html page with mandatory code
      add_line( add_html_header    ( p_title      => 'ODIS Email'));

      -- add the body text from input
      l_body_text := p_body_text;

      -- only when lines are found
      IF l_body_text.COUNT > 0 THEN
         -- get each line from the array
         FOR i in 1..l_body_text.COUNT LOOP
            -- add the line to the email
            add_line(l_body_text(i)|| l_weird) ;
         END LOOP;
      END IF;

      -- add signature to email.
      add_line( add_html_signature   ( p_greetings       => l_sign_greeting
                                     , p_from_name       => l_sign_name
                                     , p_from_position   => l_sign_position
                                     , p_from_department => l_sign_department
                                     , p_free_format     => nvl(l_sign_free_format,l_sign_concatenate)
                                     )
               );

      -- finish the html page with mandatory code
      add_line ( add_html_footer );

      RETURN l_email_body;

   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         RAISE;         RETURN EMPTY_CLOB;
   END format_html_body;


   ----------------------------------------------------------------------------
   -- Function to format a line
   ----------------------------------------------------------------------------
   FUNCTION format_line ( p_value    in      VARCHAR2 ) RETURN VARCHAR2
   IS
      lc_routine_name           VARCHAR2(50)      := 'format_line';
      l_return                  VARCHAR2(4000) ;
   BEGIN

      l_return := substr(p_value,1,4000);

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END format_line;

   ----------------------------------------------------------------------------
   -- Function to reformat the record
   ----------------------------------------------------------------------------
   FUNCTION format_email_record   ( p_email_id                in       NUMBER
                                  , p_email_from              in       VARCHAR2
                                  , p_email_to                in       VARCHAR2
                                  , p_email_cc                in       VARCHAR2
                                  , p_email_bcc               in       VARCHAR2
                                  , p_email_subject           in       VARCHAR2
                                  , p_email_body              in       CLOB
                                  , p_email_message           in       VARCHAR2
                                  , p_email_attachments_name  in       VARCHAR2
                                  , p_email_comment           in       VARCHAR2
                                  , p_email_status            in       VARCHAR2
                                  , p_email_at_testcase_id    in       NUMBER                                  
                                  , p_email_at_status         in       VARCHAR2
                                  , p_email_at_tested_by      in       VARCHAR2 ) RETURN XXAPI_EMAILS%ROWTYPE
   IS
      lc_routine_name           VARCHAR2(50)      := 'format_email_record_1';
      l_return                  XXAPI_EMAILS%ROWTYPE ;
   BEGIN
      debug  (lc_routine_name, ' Start.');
      l_return.email_id                 :=  p_email_id;
      l_return.email_from               :=  format_line(p_email_from);
      l_return.email_to                 :=  format_line(p_email_to);
      l_return.email_cc                 :=  format_line(p_email_cc);
      l_return.email_bcc                :=  format_line(p_email_bcc);
      l_return.email_subject            :=  format_line(p_email_subject);
      l_return.email_body               :=  p_email_body;
      l_return.email_message            :=  format_line(p_email_message);
      l_return.email_attachments_name   :=  format_line(p_email_attachments_name);
      l_return.email_comment            :=  format_line(p_email_comment);
      l_return.email_status             :=  coalesce(p_email_status,'CREATED');
      l_return.email_at_testcase_id     :=  coalesce(p_email_at_testcase_id,-1);      
      l_return.email_at_status          :=  format_line(p_email_at_status);
      l_return.email_at_tested_by       :=  format_line(p_email_at_tested_by);      


      debug  (lc_routine_name, ' End.');
      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END format_email_record;

   ----------------------------------------------------------------------------
   -- Function to reformat the record
   ----------------------------------------------------------------------------
   FUNCTION format_email_record  ( p_value     in XXAPI_EMAILS%ROWTYPE ) RETURN XXAPI_EMAILS%ROWTYPE
   IS
      lc_routine_name           VARCHAR2(50)      := 'format_email_record_2';
      l_return                  XXAPI_EMAILS%ROWTYPE ;
   BEGIN
      debug  (lc_routine_name, ' Start.');
      l_return := format_email_record   ( p_email_id                    =>    p_value.email_id                
                                        , p_email_from                  =>    p_value.email_from              
                                        , p_email_to                    =>    p_value.email_to                
                                        , p_email_cc                    =>    p_value.email_cc                
                                        , p_email_bcc                   =>    p_value.email_bcc               
                                        , p_email_subject               =>    p_value.email_subject           
                                        , p_email_body                  =>    p_value.email_body              
                                        , p_email_message               =>    p_value.email_message           
                                        , p_email_attachments_name      =>    p_value.email_attachments_name  
                                        , p_email_comment               =>    p_value.email_comment           
                                        , p_email_status                =>    p_value.email_status  
                                        , p_email_at_testcase_id        =>    p_value.email_at_testcase_id
                                        , p_email_at_status             =>    p_value.email_at_status         
                                        , p_email_at_tested_by          =>    p_value.email_at_tested_by
                                        );      

      debug  (lc_routine_name, ' End.');
      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END format_email_record;

   ----------------------------------------------------------------------------
   -- Function to check if the email_test_case_id exists in the xxice_email table
   ----------------------------------------------------------------------------
   FUNCTION email_testcase_id_exists ( p_email_testcase_id          in  NUMBER    default  -1  ) RETURN BOOLEAN
   IS 
   
      lc_routine_name           VARCHAR2(50)      := 'email_testcase_id_exists';

      CURSOR c_emails (b_email_testcase_id      IN      NUMBER ) IS
         SELECT 1
         FROM   XXAPI_EMAILS xie
         WHERE  xie.email_at_testcase_id  = b_email_testcase_id  ;
      l_return                  BOOLEAN := FALSE;
      
   BEGIN
      
      IF COALESCE(p_email_testcase_id,-1) > 0 then    
         FOR r_emails in c_emails (p_email_testcase_id)LOOP
            l_return := TRUE;
         END LOOP;
      ELSE
         l_return := TRUE;
      END IF;

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN 
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END email_testcase_id_exists;


   ----------------------------------------------------------------------------
   -- Function to check if the email_test_case_id exists in the xxice_email table and return the status
   ----------------------------------------------------------------------------
   FUNCTION get_email_testcase_status     ( p_email_testcase_id       in       NUMBER    DEFAULT  -1  ) RETURN VARCHAR2
   IS 
   
      lc_routine_name           VARCHAR2(50)      := 'get_email_testcase_status';

      CURSOR c_emails (b_email_testcase_id      IN      NUMBER ) IS
         SELECT xie.email_status status
         FROM   XXAPI_EMAILS xie
         WHERE  xie.email_at_testcase_id  = b_email_testcase_id 
         ORDER BY xie.email_id DESC; 

      l_return                  VARCHAR2(200) := 'NOT_FOUND';
      
   BEGIN
      
      IF COALESCE(p_email_testcase_id,-1) > 0 then  
        
         FOR r_emails in c_emails (p_email_testcase_id)LOOP
            l_return := r_emails.status;
            -- record found so no longer loop
            EXIT;
         END LOOP;
      END IF;

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN 
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END get_email_testcase_status;

   --------------------------------------------------------------------------------------
   -- Function return an email details
   --------------------------------------------------------------------------------------
   FUNCTION get_email     ( p_email_id    IN      NUMBER ) RETURN XXAPI_EMAILS%ROWTYPE
   IS
      lc_routine_name            VARCHAR2(50)      := 'get_email';
      l_email                    XXAPI_EMAILS%ROWTYPE;

      CURSOR c_emails (b_email_id    IN      NUMBER ) IS
         SELECT xie.*
         FROM   XXAPI_EMAILS xie
         WHERE  xie.email_id = b_email_id;

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug  (lc_routine_name, ' Start.');

      FOR r_email in c_emails (p_email_id) LOOP
         l_email := r_email;
      END LOOP;

      RETURN l_email;

      debug  (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END get_email;

   --------------------------------------------------------------------------------------
   -- Procedure to update an email record and return the new values
   --------------------------------------------------------------------------------------
   PROCEDURE update_email          ( p_email     IN    OUT  XXAPI_EMAILS%ROWTYPE )
   IS
      lc_routine_name            VARCHAR2(50)      := 'update_email';
      l_email                    XXAPI_EMAILS%ROWTYPE;

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug  (lc_routine_name, ' Start.');

      -- reformat the record if needed
      l_email := format_email_record(p_email);

      l_email.LAST_UPDATE_DATE     := SYSDATE;
      l_email.LAST_UPDATED_BY      := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      
      -- insert into the db
      UPDATE XXAPI_EMAILS  xie
      SET ROW = l_email
      WHERE  xie.email_id = l_email.email_id ;

      COMMIT;

      --get the db record back and return it
      p_email := get_email(l_email.email_id);
      
      debug  (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END update_email;

   --------------------------------------------------------------------------------------
   -- Procedure to update an email
   --------------------------------------------------------------------------------------
   PROCEDURE insert_email       ( p_email     IN   OUT  XXAPI_EMAILS%ROWTYPE )
   IS
      lc_routine_name            VARCHAR2(50)      := 'insert_email_to_db';
      l_email                    XXAPI_EMAILS%ROWTYPE;
      
      --l_latest_email_testcase    XXAT_EMAIL_TESTCASES%ROWTYPE;
      
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN
      debug  (lc_routine_name, ' Start.');

      -- reformat the record if needed
      l_email := format_email_record(p_email);

      --set the sequence
      l_email.email_id             := XXAPI_EMAILS_S.NEXTVAL;
      l_email.CREATION_DATE        := SYSDATE;
      l_email.CREATED_BY           := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      l_email.LAST_UPDATE_DATE     := SYSDATE;
      l_email.LAST_UPDATED_BY      := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 

--      IF NVL(xxice_utils.get_ice_settings('AT_ACTIVATED'),'N')  = 'Y' THEN
--
--         -- get max value from XXAT_EMAIL_TESTCASES  
--         --l_latest_email_testcase  := xxat_email_testcases_pkg.get_latest_testcase;
--
--         -- check in XXAPI_EMAIL if max not already exists email_at_testcase_id
--         IF NOT email_testcase_id_exists(l_latest_email_testcase.email_testcase_id) THEN
--            -- if not exists then register in current email as email_at_status / email_at_tested. 
--            l_email.email_at_testcase_id  := coalesce(l_latest_email_testcase.email_testcase_id,-1);
--         ELSE 
--            l_email.email_at_testcase_id  := -1; 
--         END IF;   
--         
--      END IF;

      -- insert into the db
      INSERT INTO XXAPI_EMAILS VALUES  l_email;

      COMMIT;

      --get the db record back and return it
      p_email := get_email(l_email.email_id);
      
      debug  (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END insert_email;

   --------------------------------------------------------------------------------------
   -- Procedure to insert values for an email
   --------------------------------------------------------------------------------------
   PROCEDURE insert_email         ( p_email_from              in       VARCHAR2
                                  , p_email_to                in       VARCHAR2
                                  , p_email_cc                in       VARCHAR2
                                  , p_email_bcc               in       VARCHAR2
                                  , p_email_subject           in       VARCHAR2
                                  , p_email_body              in       CLOB
                                  , p_email_message           in       VARCHAR2
                                  , p_email_attachments_name  in       VARCHAR2
                                  , p_email_comment           in       VARCHAR2
                                  , p_email_status            in       VARCHAR2
                                  , p_email_at_testcase_id    in       NUMBER
                                  , p_email_at_status         in       VARCHAR2
                                  , p_email_at_tested_by      in       VARCHAR2
                                  )
   IS
      lc_routine_name            VARCHAR2(50)      := 'insert_email_2';
      l_email                    XXAPI_EMAILS%ROWTYPE;

   BEGIN
      debug  (lc_routine_name, ' Start.');

      l_email := format_email_record   ( p_email_id                      =>         NULL
                                       , p_email_from                    =>         p_email_from                
                                       , p_email_to                      =>         p_email_to                  
                                       , p_email_cc                      =>         p_email_cc                  
                                       , p_email_bcc                     =>         p_email_bcc                 
                                       , p_email_subject                 =>         p_email_subject             
                                       , p_email_body                    =>         p_email_body                
                                       , p_email_message                 =>         p_email_message             
                                       , p_email_attachments_name        =>         p_email_attachments_name    
                                       , p_email_comment                 =>         p_email_comment             
                                       , p_email_status                  =>         p_email_status 
                                       , p_email_at_testcase_id          =>         p_email_at_testcase_id               
                                       , p_email_at_status               =>         p_email_at_status           
                                       , p_email_at_tested_by            =>         p_email_at_tested_by        
                                       ); 
      insert_email ( l_email);

      debug  (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END insert_email;

   --------------------------------------------------------------------------------------
   -- Function to insert values for an email and return all the values 
   --------------------------------------------------------------------------------------
   FUNCTION insert_email          ( p_email_from              in       VARCHAR2
                                  , p_email_to                in       VARCHAR2
                                  , p_email_cc                in       VARCHAR2
                                  , p_email_bcc               in       VARCHAR2
                                  , p_email_subject           in       VARCHAR2
                                  , p_email_body              in       CLOB
                                  , p_email_message           in       VARCHAR2
                                  , p_email_attachments_name  in       VARCHAR2
                                  , p_email_comment           in       VARCHAR2
                                  , p_email_status            in       VARCHAR2
                                  , p_email_at_testcase_id    in       NUMBER                                  
                                  , p_email_at_status         in       VARCHAR2
                                  , p_email_at_tested_by      in       VARCHAR2 )    RETURN XXAPI_EMAILS%ROWTYPE
   IS
      lc_routine_name            VARCHAR2(50)      := 'insert_email_3';
      l_email                    XXAPI_EMAILS%ROWTYPE;

   BEGIN
      debug  (lc_routine_name, ' Start.');

      l_email := format_email_record   ( p_email_id                      =>         NULL
                                       , p_email_from                    =>         p_email_from                
                                       , p_email_to                      =>         p_email_to                  
                                       , p_email_cc                      =>         p_email_cc                  
                                       , p_email_bcc                     =>         p_email_bcc                 
                                       , p_email_subject                 =>         p_email_subject             
                                       , p_email_body                    =>         p_email_body                
                                       , p_email_message                 =>         p_email_message             
                                       , p_email_attachments_name        =>         p_email_attachments_name    
                                       , p_email_comment                 =>         p_email_comment             
                                       , p_email_status                  =>         p_email_status         
                                       , p_email_at_testcase_id          =>         p_email_at_testcase_id                                            
                                       , p_email_at_status               =>         p_email_at_status           
                                       , p_email_at_tested_by            =>         p_email_at_tested_by        
                                       ); 
      insert_email ( l_email);


      RETURN l_email;

      debug  (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END insert_email;

END XXAPI_EMAIL;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_EMAIL" TO "WKSP_XXCT";

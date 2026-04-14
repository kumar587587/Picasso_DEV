--------------------------------------------------------
--  DDL for Procedure XXAPI_SEND_EMAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXAPI"."XXAPI_SEND_EMAIL" (  p_from               IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_to                 IN    VARCHAR2
                                                             ,  p_cc                 IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_bcc                IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_subject            IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_message            IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_body_clob          IN    CLOB                            DEFAULT EMPTY_CLOB
                                                             ,  p_html               IN    VARCHAR2                        DEFAULT 'TEXT'
                                                             ,  p_print_att          IN    BOOLEAN                         DEFAULT FALSE
                                                             ,  p_filename           IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_file_type          IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_directory          IN    VARCHAR2                        DEFAULT NULL
                                                             ,  p_attachments        IN    XXAPI_ATTACHMENTS               DEFAULT NULL         
                                                             ) AUTHID DEFINER
   AS
      /**************************************************************************************************************************************
      *
      *
      * PROGRAM NAME
      *   GENERIC - ICE004- XXAPI_SEND_EMAIL.prc
      *
      * DESCRIPTION
      *   Function to send email messages with attachments
      *
      * PARAMETERS
      *    Name               Nullable      Values                       Meaning
      *    --------------     --------      ----------------------       -------------------------------------------------------------------
      *    p_from             Yes           max 2000  Characters         Valid sending email-address
      *    p_to               No            max 32767 Characters         Recipients  email-address list semicolon seperated
      *    p_cc               Yes           max 32767 Characters         Carbon Copy email-address list semicolon seperated
      *    p_bcc              Yes           max 32767 Characters         Blind Carbon Copy email-address list semicolon seperated
      *    p_subject          Yes           max 2000  Characters         Email subject line
      *    p_message          Yes           max 32767 Characters         Single line Email Message Line. cannot contain crlf
      *    p_body_clob        Yes           CLOB                         clob containing the message body text.
      *    p_html             Yes           TEXT or HTML                 When the clob contains valid html code use HTML here to change the content type for the body part
      *    p_print_att*       Yes           TRUE / FALSE                 Obsolete. Print the attachentname in the email message body?
      *    p_filename*        Yes           200 Characters               Obsolete, use p_attachments type - Full Filename of attachment
      *    p_file_type*       Yes           A or B                       Obsolete. Ascii (A) or Binary (B) file
      *    p_directory*       Yes           Oracle Directory             Obsolete, use p_attachments type --Oracle Directory name of location of file
      *    p_attachments      Yes           XXAPI_ATTACHMENT_TYPE        Table of XXAPI_FILE_LIST object ( FILE_NAME            VARCHAR2(200)
      *                                                                                                  , FILE_TYPE            VARCHAR2(1)
      *                                                                                                  , FILE_MIME_TYPE       VARCHAR2(200)
      *                                                                                                  , FILE_DIRECTORY       VARCHAR2(30)           -- no longer supported use clob /blob values icw file type A(scii) or B(inary)
      *                                                                                                  , FILE_CONTENTS_A      CLOB
      *                                                                                                  , FILE_CONTENTS_B      BLOB 
      *                                                                                                  )
      *
      * USAGE of POCEDURE
      *    When calling this procedure, the p_to parameter is mandatory. All other parameters are optional.
      *    When only the p_to parameter is entered, the other fields are defaulted (from, subject, message).
      *    You can use either 1 message line with p_message, or an clob of lines for the body text using p_body_text.
      *    When the line of the clob containsa HTML code, then sned the p_html flag using HTML or TEXT
      *
      *    Attachments:
      *      When only 1 attachment is needed, use p_filename, p_file_type and p_directory
      *      When multiple attachments are needed use the p_attachments parameter
      *
      *      In calling package define and fill the parameters as example like below
      *      and pass the l_attachments variable as parameter to XXAPI_SEND_MAIL procedure
      *
      *         l_attachments   XXAPI_ATTACHMENTS := xxapi_attachments();   -- define and instantiate
      *         l_file          XXAPI_FILE_LIST  := xxapi_file_list('<file_name>','<A/B>',<valid mime-type/NULL>,<NULL-ORACLE_DIRECTORYnot used>,<CLOB Value of attachment>,<BLOB Value of attachment>);
      *
      *         l_attachments.extend();
      *         l_attachments(l_attachments.count) := l_file;
      *
      *      <or use a loop to fill multiple files>
      *
      * CHANGE HISTORY
      * Who                 When         What
      * -------------------------------------------------------------
      * Wiljo Bakker        09-12-2013  Initial Version
      * Wiljo Bakker        24-10-2014  Fix HP-ALM 413 Updated add_environment function to R12 environment
      * Wiljo Bakker        27-10-2014  Added customization Code ICE004 to this header
      * Geert Engbers       19-09-2018  Attachments with line sizes of more than 1024 can now be proccessed. ODO-71.
      * Wiljo Bakker        03-10-2018  Added option to add body text as a clob. Also when the contents is html code, use the p_html_text indicator
      * Wiljo Bakker        14-12-2018  Changed chunck length for body clob to 900. no longer lines than SMTP maximum permitted
      * Wiljo Bakker        05-07-2019  Added logging into XXAPI_EMAIL table for Automated Testing and for general error handling.
      * Wiljo Bakker        16-09-2024  Rewritten for APEX_MAIL and use in Cloud 
      ****************************************************************************************************************************************/

      -- $Id: XXAPI_SEND_EMAIL.prc,v 1.1 2024/09/20 16:04:08 bakke619 Exp $
      -- $Log: XXAPI_SEND_EMAIL.prc,v $
      -- Revision 1.1  2024/09/20 16:04:08  bakke619
      -- Initial revision
      --

      lc_routine_name            CONSTANT VARCHAR2(50)                   := 'XXAPI_SEND_EMAIL';
      lc_procedure_version       CONSTANT VARCHAR2(200)                  := '$Id: XXAPI_SEND_EMAIL.prc,v 1.1 2024/09/20 16:04:08 bakke619 Exp $';
      lc_package_name            CONSTANT VARCHAR2(50)                   := 'Procedure';            

      l_mime_type_binary                  VARCHAR2(50)  := 'application/octet-stream';
      l_mime_type_ascii                   VARCHAR2(50)  := 'text/plain';

      l_lookup_type_email                 VARCHAR2(30)  := 'BATCH_EMAIL';

      l_from                              XXAPI_LOOKUP_VALUES.MEANING%TYPE;
      l_to                                VARCHAR2(32767);
      l_cc                                VARCHAR2(32767);
      l_bcc                               VARCHAR2(32767);

      l_subject                           VARCHAR2(2000);
      l_message                           CLOB; -- VARCHAR2(32767);

      l_attachments_names                 VARCHAR2(8000);
      l_empty_email_log                   XXAPI_EMAILS%ROWTYPE;
      l_registered_email                  XXAPI_EMAILS%ROWTYPE;

      l_email_id                          NUMBER := 0;

      l_contents_clob                     CLOB;
      l_contents_blob                     BLOB;

      ---------------------------------------------------------------------------------------------
      -- Procedure to be used for debugging purposes.
      ---------------------------------------------------------------------------------------------
      PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2 ) IS
         gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
      BEGIN
         IF p_message in (' Start.', ' End.') THEN
            CASE WHEN gc_show_debug_start_end
                THEN xxapi_gen_debug_pkg.debug( lc_package_name||'.'||p_routine, rtrim(p_message));
                ELSE NULL;
            END CASE;
         ELSE
            xxapi_gen_debug_pkg.debug( lc_package_name||'.'||p_routine, rtrim(p_message));
         END IF;
      END debug;      
      --
      PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_clob in clob ) IS
         gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
      BEGIN
         IF p_message in (' Start.', ' End.') THEN
            CASE WHEN gc_show_debug_start_end
                THEN xxapi_gen_debug_pkg.debug_cs( lc_package_name||'.'||p_routine, rtrim(p_message) ,p_clob );
                ELSE NULL;
            END CASE;
         ELSE
            xxapi_gen_debug_pkg.debug_cs( lc_package_name||'.'||p_routine, rtrim(p_message), p_clob );
         END IF;
      END debug;
      --
      PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_blob in blob ) IS
         gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
      BEGIN
         IF p_message in (' Start.', ' End.') THEN
            CASE WHEN gc_show_debug_start_end
                THEN xxapi_gen_debug_pkg.debug_bs( lc_package_name||'.'||p_routine, rtrim(p_message) ,p_blob );
                ELSE NULL;
            END CASE;
         ELSE
            xxapi_gen_debug_pkg.debug_bs( lc_package_name||'.'||p_routine, rtrim(p_message), p_blob );
         END IF;
      END debug;      
      ----------------------------------------------------------------------------
      -- Functions return a setting from XXAPI_LOOKUP_VALUES
      ----------------------------------------------------------------------------
      FUNCTION get_settings_value  ( p_lookup_type  IN VARCHAR2
                                   , p_lookup_code  IN VARCHAR2 ) RETURN VARCHAR2
      IS
        l_meaning           XXAPI_LOOKUP_VALUES.MEANING%TYPE;
        --
      BEGIN
         select meaning
         into   l_meaning
         from   xxapi_lookup_values
         where  1=1
         and    upper(lookup_type) = upper(p_lookup_type)
         and    upper(lookup_code) = upper(p_lookup_code);
         --
         RETURN l_MEANING;

      END get_settings_value;


      -------------------------------------------------------------------------
      -- Function to register a new email in the database
      -------------------------------------------------------------------------
      FUNCTION register_new_email RETURN XXAPI_EMAILS%ROWTYPE 
      IS 
         lc_sub_routine_name            VARCHAR2(50)      := 'register_new_email';
         l_return                   XXAPI_EMAILS%ROWTYPE;
      BEGIN
         debug  (lc_sub_routine_name, ' Start.');
         IF p_attachments IS NOT NULL THEN

            -- attachments
            FOR i in p_attachments.FIRST..p_attachments.LAST LOOP

               -- make attachments string for the names
               case i when 1 then l_attachments_names := p_attachments(i).file_directory||'\'||p_attachments(i).file_name;
                             else l_attachments_names := l_attachments_names ||' | '||p_attachments(i).file_directory||'\'||p_attachments(i).file_name; 
               end case;

            END LOOP;

         END IF;

         l_return :=  xxapi_email.insert_email  ( p_email_from              =>  l_from
                                                , p_email_to                =>  l_to
                                                , p_email_cc                =>  l_cc
                                                , p_email_bcc               =>  l_bcc
                                                , p_email_subject           =>  l_subject
                                                , p_email_body              =>  p_body_clob
                                                , p_email_message           =>  p_message
                                                , p_email_attachments_name  =>  l_attachments_names
                                                , p_email_comment           =>  'APEX_MAIL ID:' --l_smtp_host ||':'||l_smtp_port
                                                , p_email_status            =>  'NEW'
                                                , p_email_at_testcase_id    =>  NULL
                                                , p_email_at_status         =>  NULL
                                                , p_email_at_tested_by      =>  NULL
                                                );

         debug  (lc_sub_routine_name, ' End.');

         RETURN l_return;
      EXCEPTION
         WHEN OTHERS THEN
            debug  (lc_routine_name||'.'||lc_sub_routine_name ,    'ERROR: ' || SQLERRM);
            RAISE;
      END register_new_email;

      -------------------------------------------------------------------------
      -- Function to updated values for this email in the database and return the new set
      -------------------------------------------------------------------------
      FUNCTION update_email  (p_email in XXAPI_EMAILS%ROWTYPE ) RETURN XXAPI_EMAILS%ROWTYPE 
      IS 
         lc_sub_routine_name            VARCHAR2(50)      := 'update_email';
         l_return                   XXAPI_EMAILS%ROWTYPE;
      BEGIN
         debug  (lc_sub_routine_name, ' Start.');      
         l_return := p_email;
         xxapi_email.update_email  ( p_email  => l_return );
         debug  (lc_sub_routine_name, ' End.');         
         RETURN l_return;
      EXCEPTION
         WHEN OTHERS THEN
            debug  (lc_sub_routine_name,'ERROR: ' || SQLERRM);
            RAISE;
      END update_email;

      -------------------------------------------------------------------------
      -- Function to get a text from a semicolon seperated list of email addresses
      -------------------------------------------------------------------------
      FUNCTION unlist (p_list IN OUT VARCHAR2) RETURN VARCHAR2
      IS
         l_item   VARCHAR2 (256);
         l_int     PLS_INTEGER;

         FUNCTION lookup_unquoted_char (p_str IN VARCHAR2, p_chrs IN VARCHAR2) RETURN PLS_INTEGER
         IS
            l_char           VARCHAR2 (5);
            l_integer        PLS_INTEGER;
            l_len            PLS_INTEGER;
            l_inside_quote   BOOLEAN;
         BEGIN
            l_inside_quote := FALSE;
            l_integer := 1;
            l_len := LENGTH (p_str);

            WHILE (l_integer <= l_len) LOOP
               l_char := SUBSTR (p_str, l_integer, 1);
               IF (l_inside_quote) THEN
                  IF (l_char = '"')  THEN
                     l_inside_quote := FALSE;
                  ELSIF (l_char = '\') THEN
                     l_integer := l_integer + 1;
                  END IF;
               ELSIF (l_char = '"') THEN
                  l_inside_quote := TRUE;
               END IF;
               IF (INSTR (p_chrs, l_char) >= 1) THEN
                  RETURN l_integer;
               END IF;

               l_integer := l_integer + 1;
            END LOOP;
            RETURN 0;
         END lookup_unquoted_char;

      BEGIN
         p_list := LTRIM (p_list);
         l_int  := lookup_unquoted_char (p_list, ',;');

         IF (l_int >= 1) THEN
            l_item := SUBSTR (p_list, 1, l_int - 1);
            p_list := SUBSTR (p_list, l_int + 1);
         ELSE
            l_item := p_list;
            p_list := '';
         END IF;

         l_int := lookup_unquoted_char (l_item, '<');

         IF (l_int >= 1) THEN
            l_item := SUBSTR (l_item, l_int + 1);
            l_int   := INSTR (l_item, '>');
            IF (l_int >= 1)  THEN
               l_item := SUBSTR (l_item, 1, l_int - 1);
            END IF;
         END IF;
         RETURN l_item;
      END unlist;

      -------------------------------------------------------------------------
      -- Function to add the environment name to the subject
      -------------------------------------------------------------------------
      FUNCTION add_environment ( b_subject     IN  VARCHAR2 ) RETURN VARCHAR
      IS
         l_instance             VARCHAR2(100);
         l_local_subject        VARCHAR2(200);
      BEGIN
         CASE when instr( sys_context('USERENV', 'DB_NAME') ,'APXDEV') > 0 THEN l_instance:= '!!!!DEVELOPMENT!!!! : ';
              when instr( sys_context('USERENV', 'DB_NAME') ,'APXACC') > 0 THEN l_instance:= '!!!!ACCEPTANCE!!!! : ';
              when instr( sys_context('USERENV', 'DB_NAME') ,'APXTST') > 0 THEN l_instance:= '!!!!TEST!!!! : ';
              ELSE NULL; 
         END CASE; 

         l_local_subject := SUBSTR (l_instance || b_subject, 0, 200);

         RETURN l_local_subject;

      END add_environment;

      -------------------------------------------------------------------------
      -- Procedure to initialize locals and set default values when null are passed
      -------------------------------------------------------------------------
      PROCEDURE init
      IS
         lc_sub_routine_name            VARCHAR2(50)      := 'init';      
      BEGIN
         debug  (lc_sub_routine_name, ' Start.');                   
         -- clear existing data
         l_registered_email := l_empty_email_log;

         -- put parameters into local values
         l_to         := p_to;
         l_cc         := p_cc;
         l_bcc        := p_bcc;

         -- unlist the mailaddresses
         l_to         := unlist(l_to);
         l_cc         := unlist(l_cc);
         l_bcc        := unlist(l_bcc);

         l_from       := nvl(p_from,get_settings_value(l_lookup_type_email,'SENDER_EMAIL'));
         l_subject    := add_environment(nvl(substr(p_subject,1,2000),get_settings_value(l_lookup_type_email,'EMAIL_SUBJECT')));
         l_message    := nvl(p_message,get_settings_value(l_lookup_type_email,'EMAIL_TEXT'));
         debug  (lc_sub_routine_name, ' End.');             
      END init;

   BEGIN
      debug  (lc_routine_name, ' Start.');

      -- initialize locals
      init;

      -- register the email data into the database for logging
      l_registered_email := register_new_email;

      -- add the email to the queue
      l_email_id :=  apex_mail.send(  p_to        => l_to
                                    , p_from      => l_from 
                                    , p_subj      => l_subject 
                                    , p_body      => l_message
                                    , p_body_html => p_body_clob
                                    , p_cc        => l_cc
                                    , p_bcc       => l_bcc      
                                    );

      IF p_attachments IS NOT NULL THEN
         -- attachments
         FOR i in p_attachments.FIRST..p_attachments.LAST LOOP

            IF p_attachments(i).file_type = 'A' then

               l_contents_blob :=   apex_util.clob_to_blob   ( p_clob              => p_attachments(i).file_contents_a
                                                             , p_charset           => 'AL32UTF8'
                                                             , p_include_bom       => 'N' 
                                                             , p_in_memory         => 'Y'
                                                             , p_free_immediately  => 'Y' 
                                                             );
            ELSE
               l_contents_blob := p_attachments(i).file_contents_b  ;              
            END IF;

            apex_mail.add_attachment   ( p_mail_id    => l_email_id
                                       , p_attachment => l_contents_blob
                                       , p_filename   => p_attachments(i).file_name
                                       , p_mime_type  => l_mime_type_binary
                                       );     

         END LOOP;

      END IF;

      -- the mail is now ready to be send from the queue
      APEX_MAIL.PUSH_QUEUE;

      -- update the email status in the logging
      l_registered_email.email_status  := 'SEND'; 
      l_registered_email.email_comment := 'APEX_MAIL ID:'|| to_Char(l_email_id);
      l_registered_email := update_email (l_registered_email) ;

      debug  (lc_routine_name, ' End.');
   EXCEPTION
      -- when error, register error and raise
      WHEN OTHERS THEN 
         debug  (lc_routine_name,    'ERROR: ' || SQLERRM);
         l_registered_email.email_status  := 'ERROR'; 
         l_registered_email.email_comment := 'APEX_MAIL ID:'|| to_Char(l_email_id);         
         xxapi_email.update_email (l_registered_email) ;       
         RAISE;

   END XXAPI_SEND_EMAIL;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_SEND_EMAIL" TO "WKSP_XXCT";

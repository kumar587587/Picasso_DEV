--------------------------------------------------------
--  DDL for Package Body XXAPI_BATCH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_BATCH" 
AS
   /****************************************************************
   *
   *
   * PROGRAM NAME
   *  GENERIC - API002 -  XXAPI_BATCH
   *
   * DESCRIPTION
   * Package to hold all the batch run related procedures and functions for
   *  all generic API modules
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        03-12-2013  Initial Version
   * Wiljo Bakker        03-01-2014  Added indicator procedures and globals
   * Wiljo Bakker        16-01-2014  Added get_ftp_target_host
   * Wiljo Bakker        10-02-2014  Moved package to XXCUST schema
   * Wiljo Bakker        13-02-2014  Added delete_files (multiple)
   * Wiljo Bakker        26-02-2014  Added new functions for CC and output mail addresses
   * Wiljo Bakker        11-03-2014  Added new pocedure to load a file using external table.
   * Wiljo Bakker        25-03-2014  Moved File handling procedures to XXICE_UTILS_FILE
   * Wiljo Bakker        25-03-2014  insert_batch_run_info prevent duplicates with exception
   * Wiljo Bakker        26-11-2014  passing 0 value to increase_indicator will reset the indicator to 0
   * Wiljo Bakker        23-02-2015  Added procedure for ending batches with warning status.
   * Wiljo Bakker        16-09-2024  Rebuild for use in Cloud   

   **************************************************************/
   --
   -- $Id: XXAPI_BATCH.pkb,v 1.1 2024/09/20 15:42:29 bakke619 Exp $
   -- $Log: XXAPI_BATCH.pkb,v $
   -- Revision 1.1  2024/09/20 15:42:29  bakke619
   -- Initial revision
   --

----------------------------------------------------------------------------
-- DEBUG
----------------------------------------------------------------------------
   gc_package_body_version       CONSTANT VARCHAR2(200) := '$Id: XXAPI_BATCH.pkb,v 1.1 2024/09/20 15:42:29 bakke619 Exp $';

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

   ----------------------------------------------------------------------------
   -- Function to return the body version
   ----------------------------------------------------------------------------
   FUNCTION get_package_body_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN gc_package_body_version;
   END get_package_body_version;

   ----------------------------------------------------------------------------
   -- Function to return the spec version
   ----------------------------------------------------------------------------
   FUNCTION get_package_spec_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN gc_package_spec_version;
   END get_package_spec_version;

   ----------------------------------------------------------------------------
   --    Procedure start_batch_run to register the batch to the batch tables
   ----------------------------------------------------------------------------
   PROCEDURE start_batch_run ( p_bah_code                  VARCHAR2
                             , p_brn_id            IN OUT  NUMBER
                             )
   IS
      lc_routine_name            VARCHAR2(50)      := 'start_batch_run';   
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug (lc_routine_name, ' Start.');
      SELECT xxapi_seq_brn.NEXTVAL
      INTO   p_brn_id
      FROM   DUAL;

      INSERT INTO XXAPI_BATCH_RUNS ( brn_id
                                 , brn_id_main
                                 , brn_bah_code
                                 , brn_startdate
                                 , brn_user_name
                                 )
      VALUES ( p_brn_id
             , NULL
             , p_bah_code
             , SYSDATE
             , USER
             );

      COMMIT;
      debug (lc_routine_name, ' End.');
   END start_batch_run;

   ----------------------------------------------------------------------------
   --    Procedure end_batch_correct to register the batch is finished ok
   ----------------------------------------------------------------------------
   PROCEDURE end_batch_correct            ( p_brn_id           IN       NUMBER)
   IS
      lc_routine_name            VARCHAR2(50)      := 'end_batch_correct';   
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      debug (lc_routine_name, ' Start.');
      UPDATE xxapi_batch_runs
      SET    brn_enddate = SYSDATE
      ,      brn_indicator_ok  = gc_Y
      WHERE  brn_id = p_brn_id;

      COMMIT;

      generate_batch_run_output (p_brn_id);

      COMMIT;
      debug (lc_routine_name, ' End.');
   END end_batch_correct;

   ----------------------------------------------------------------------------
   --    Procedure end_batch_warning to register the batch is finished, but with warnings
   ----------------------------------------------------------------------------
   PROCEDURE end_batch_warning            ( p_brn_id           IN       NUMBER
                                          , p_brn_error        IN       VARCHAR2) 
   IS
      lc_routine_name            VARCHAR2(50)      := 'end_batch_warning';
      PRAGMA AUTONOMOUS_TRANSACTION;

   BEGIN
      debug (lc_routine_name, ' Start.');
      UPDATE XXAPI_BATCH_RUNS
      SET    brn_enddate = SYSDATE
      ,      brn_indicator_ok  = gc_W
      ,      brn_error      = REPLACE(SUBSTR (p_brn_error, 1, 2000), 'ORA-20000: ', '')
      WHERE  brn_id        = p_brn_id;

      COMMIT;

      generate_batch_run_output (p_brn_id);

      COMMIT;
      debug (lc_routine_name, ' End.');
   end end_batch_warning;

   ----------------------------------------------------------------------------
   --    Procedure end_batch_error to register the batch is finished but with errors
   ----------------------------------------------------------------------------
   PROCEDURE end_batch_error              ( p_brn_id           IN       NUMBER
                                          , p_brn_error         IN       VARCHAR2)  
   IS
      lc_routine_name            VARCHAR2(50)      := 'end_batch_error';
      PRAGMA AUTONOMOUS_TRANSACTION;

   BEGIN
      debug (lc_routine_name, ' Start.');
      UPDATE XXAPI_BATCH_RUNS
      SET    brn_enddate = SYSDATE
      ,      brn_indicator_ok  = gc_N
      ,      brn_error      = REPLACE(SUBSTR (p_brn_error, 1, 2000), 'ORA-20000: ', '')
      WHERE  brn_id        = p_brn_id;

      COMMIT;

      generate_batch_run_output (p_brn_id);

      COMMIT;
      debug (lc_routine_name, ' End.');
   end end_batch_error;

   ----------------------------------------------------------------------------
   -- Procedure to register the undo batch information for a run
   ----------------------------------------------------------------------------
   PROCEDURE undo_batch_run    ( p_brn_id_current    IN       NUMBER
                               , p_brn_id_undo       IN       NUMBER )
   IS
   BEGIN

      UPDATE  xxapi_batch_runs
      SET     brn_id_undo               = p_brn_id_current
      ,       brn_date_undo            = SYSDATE
      ,       brn_user_name_undo = USER
      WHERE   brn_id = p_brn_id_undo;

   END undo_batch_run;

   ----------------------------------------------------------------------------
   -- Procedure to register the loaded files into the XXAPI_BATCH_RUN_FILE (file) table
   ----------------------------------------------------------------------------
   PROCEDURE insert_batch_run_file ( p_brn_id             IN      NUMBER
                                   , p_brf_bestand        IN      VARCHAR2
                                   , p_brf_input_output   IN      VARCHAR2 )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      lc_routine_name            VARCHAR2(50)      := 'insert_batch_run_file';
      l_brf_id    XXAPI_BATCH_RUN_FILE.BRF_ID%TYPE;

   BEGIN

      SELECT xxapi_seq_brd.NEXTVAL
      INTO   l_brf_id
      FROM   DUAL;

      INSERT INTO XXAPI_BATCH_RUN_FILE ( brf_id
                                        , brf_brn_id
                                        , brf_file
                                        , brf_input_output
                                        , brf_startdate
                                        )
      VALUES ( l_brf_id
             , p_brn_id
             , p_brf_bestand
             , p_brf_input_output
             , SYSDATE
             ) ;

      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;  
   END insert_batch_run_file;

   ----------------------------------------------------------------------------
   -- Procedure to register errors into the batch run uitval table an place it in a file
   ----------------------------------------------------------------------------
   PROCEDURE insert_batch_run_error_file  ( p_brn_id         IN       NUMBER
                                          , p_brl_bestand    IN       VARCHAR2
                                          , p_brl_regel_nr   IN       NUMBER
                                          , p_brl_regel      IN       VARCHAR2
                                          , p_bah_code       IN       VARCHAR2
                                          , p_bft_code       IN       VARCHAR2
                                          , p_brl_parameter  IN       VARCHAR2   DEFAULT NULL
                                          , p_brl_or_brn_id  IN       NUMBER     DEFAULT NULL )
   IS

      PRAGMA AUTONOMOUS_TRANSACTION;

      l_brl_id    XXAPI_BATCH_RUN_FAILURES.BRL_ID%TYPE;
      lc_routine_name            VARCHAR2(50)      := 'insert_batch_run_error_file';
   BEGIN

      SELECT xxapi_seq_brl.NEXTVAL
      INTO   l_brl_id
      FROM   DUAL;

      INSERT INTO XXAPI_BATCH_RUN_FAILURES (brl_id            
                                       , brl_brn_id        
                                       , brl_line_nr       
                                       , brl_line          
                                       , brl_file          
                                       , brl_bah_code      
                                       , brl_bft_code      
                                       , brl_parameter     
                                       , brl_or_brn_id     
                                       )
      VALUES   ( l_brl_id
               , p_brn_id
               , p_brl_regel_nr
               , SUBSTR(NVL(p_brl_regel, '**EMPTY LINE**'), 1, 4000)
               , p_brl_bestand
               , p_bah_code
               , p_bft_code
               , SUBSTR(p_brl_parameter, 1, 200)
               , NVL(p_brl_or_brn_id, p_brn_id)
               ) ;

      COMMIT;

   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;  

   END insert_batch_run_error_file ;

   ----------------------------------------------------------------------------
   -- Procedure to register errors into the batch run uitval table
   ----------------------------------------------------------------------------
   PROCEDURE insert_batch_run_error ( p_brn_id         IN       NUMBER
                                    , p_brl_regel_nr   IN       NUMBER
                                    , p_brl_regel      IN       VARCHAR2
                                    , p_bah_code       IN       VARCHAR2
                                    , p_bft_code       IN       VARCHAR2
                                    , p_brl_parameter  IN       VARCHAR2   DEFAULT NULL )
   IS

   BEGIN
      insert_batch_run_error_file   ( p_brn_id
                                    , ''
                                    , p_brl_regel_nr
                                    , p_brl_regel
                                    , p_bah_code
                                    , p_bft_code
                                    , p_brl_parameter
                                    , NULL
                                    ) ;
   END insert_batch_run_error;

   ----------------------------------------------------------------------------
   -- Procedure to register information into the batch run information table
   ----------------------------------------------------------------------------
   PROCEDURE insert_batch_run_info ( p_brn_id      IN   NUMBER
                                   , p_bro_description     IN   VARCHAR2
                                   , p_bro_seq     IN   NUMBER   DEFAULT  NULL )
   IS

     PRAGMA AUTONOMOUS_TRANSACTION;

   BEGIN

      INSERT INTO XXAPI_BATCH_RUN_INFO ( bro_brn_id , bro_description, bro_number)
      VALUES ( p_brn_id , SUBSTR(p_bro_description,1,2000), nvl(p_bro_seq,1) ) ;

      COMMIT;
   EXCEPTION
    WHEN OTHERS THEN
       IF instr(SQLERRM,'ORA-00001', 1, 1) > 0  THEN
          -- message already present, so do nothing.
          NULL;
       ELSE
          RAISE;
       END IF;
   END insert_batch_run_info;

   ----------------------------------------------------------------------------
   --    Procedure send email to send the batch run details via email
   ----------------------------------------------------------------------------
   PROCEDURE generate_batch_run_output ( p_brn_id number )
   IS
      l_error   varchar2(32000);
      lc_routine_name            VARCHAR2(50)      := 'generate_batch_run_output';

      PRAGMA AUTONOMOUS_TRANSACTION;

   BEGIN
      debug (lc_routine_name, ' Start.');   
         xxapi_batch_result.main (p_brn_id);
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         l_error := 'error with sending procedure:' || sqlerrm;

         UPDATE XXAPI_BATCH_RUNS
         SET    brn_error = substr (l_error,1,2000 )
         WHERE  brn_id   = p_brn_id;

         RAISE;
   END generate_batch_run_output;

   ----------------------------------------------------------------------------
   --   Procedure to raise a fatal error
   ----------------------------------------------------------------------------
   PROCEDURE raise_fatal_error ( p_error_text VARCHAR2 )
   IS
   BEGIN
      raise_application_error (-20000, p_error_text);
   END;

   ----------------------------------------------------------------------------
   -- Functions return a batch run record for a specific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batchrun_record      ( p_brn_id      IN NUMBER ) RETURN XXAPI_BATCH_RUNS%ROWTYPE
   IS

      CURSOR c_brn IS
         SELECT *
         FROM   XXAPI_BATCH_RUNS
         WHERE  brn_id = p_brn_id;

      l_brn_rec  XXAPI_BATCH_RUNS%ROWTYPE;
   BEGIN

     OPEN  c_brn;
     FETCH c_brn INTO l_brn_rec;
     CLOSE c_brn;

     RETURN l_brn_rec;

   END get_batchrun_record;

   ----------------------------------------------------------------------------
   -- Functions return a batch record for a specific batch
   ----------------------------------------------------------------------------
   FUNCTION get_batch_record    (p_bah_code      IN     VARCHAR2) RETURN XXAPI_BATCHES%ROWTYPE
   IS
     CURSOR c_bah IS
        SELECT *
        FROM   XXAPI_BATCHES
        WHERE  bah_code = p_bah_code;

     l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN

      OPEN  c_bah;
      FETCH c_bah INTO l_bah_rec;
      CLOSE c_bah;

      RETURN l_bah_rec;

   END get_batch_record;

   ----------------------------------------------------------------------------
   -- Get the next file that needs to be loaded from ICE-BATCHES using a batch-code
   ----------------------------------------------------------------------------
   FUNCTION get_next_file (p_bah_code       IN    VARCHAR2
                          ,p_file_number    IN    NUMBER    DEFAULT 1) RETURN VARCHAR2
   IS
      l_batch_rec  XXAPI_BATCHES%ROWTYPE;
      l_next_file  XXAPI_BATCHES.bah_next_FILE1%TYPE;
   BEGIN

      l_batch_rec := get_batch_record (p_bah_code);

      l_next_file := CASE p_file_number
                        WHEN 1 THEN l_batch_rec.bah_next_file1
                        WHEN 2 THEN l_batch_rec.bah_next_file2
                        WHEN 3 THEN l_batch_rec.bah_next_file3
                        WHEN 4 THEN l_batch_rec.bah_next_file4
                        ELSE l_batch_rec.bah_next_file1
                     END;

     RETURN l_next_file;

   END get_next_file;

   ----------------------------------------------------------------------------
   -- Update the next expecte file in ICE-BATCHES (file1, 2, 3, or 4)
   ----------------------------------------------------------------------------
   PROCEDURE update_next_file ( p_bah_code              IN  VARCHAR2
                              , p_file_name             IN  VARCHAR2
                              , p_file_number           IN  NUMBER    DEFAULT 1 )
   IS
      l_file_number number := 1;
   BEGIN
      l_file_number := p_file_number;

      IF l_file_number = 1 THEN

         update xxapi_batches
         set    bah_next_file1 = p_file_name
         where  bah_code           = p_bah_code
         ;

      ELSIF l_file_number = 2 THEN

         update xxapi_batches
         set    bah_next_file2 = p_file_name
         where  bah_code           = p_bah_code
         ;

      ELSIF l_file_number = 3 THEN

         update xxapi_batches
         set    bah_next_file3 = p_file_name
         where  bah_code           = p_bah_code
         ;

      ELSIF l_file_number = 4 THEN

         update xxapi_batches
         set    bah_next_file4 = p_file_name
         where  bah_code           = p_bah_code
         ;

      END IF;

   END update_next_file;

   ----------------------------------------------------------------------------
   --   Function return the type of file that was processed
   ----------------------------------------------------------------------------
   FUNCTION get_file_type  ( p_brn_id    IN  NUMBER  )  RETURN VARCHAR2 IS

      l_aantal_input        NUMBER;
      l_aantal_output       NUMBER;
      l_type_bestanden      VARCHAR2(2);

   BEGIN

      SELECT NVL(SUM(DECODE(brf_input_output, 'I', 1, 0)),0)  aantal_input
      ,      NVL(SUM(DECODE(brf_input_output, 'U', 1, 0)),0)  aantal_output
      INTO   l_aantal_input
      ,      l_aantal_output
      FROM   XXAPI_BATCH_RUN_FILE;

      IF l_aantal_input > 0 AND l_aantal_output > 0 THEN
         l_type_bestanden := 'IO';
      ELSIF l_aantal_input > 0 AND l_aantal_output = 0 THEN
         l_type_bestanden := 'I';
      ELSIF l_aantal_input = 0 AND l_aantal_output > 0 THEN
         l_type_bestanden := 'U';
      ELSE
         NULL;
      END IF;

      RETURN l_type_bestanden;

   end get_file_type;

   ----------------------------------------------------------------------------
   --   Function checks if a file has already been processed
   ----------------------------------------------------------------------------
   FUNCTION file_processed ( p_filename   IN      VARCHAR2
                           , p_bah_code   IN      VARCHAR2
                           , p_brn_id         OUT NUMBER         ) RETURN BOOLEAN
   IS

     CURSOR c_files IS
        SELECT brn_id
        FROM   XXAPI_BATCH_RUN_FILE
        ,      XXAPI_BATCH_RUNS
        WHERE  brf_file      = p_filename
        AND    brf_brn_id    = brn_id
        AND    brn_bah_code  = p_bah_code
        AND    brn_id_undo   IS NULL
        ;

     l_found   BOOLEAN := FALSE;

   BEGIN

     FOR r_files in c_files LOOP
        p_brn_id := r_files.brn_id;
        l_found := TRUE;
     END LOOP;

     RETURN l_found;

   END file_processed;

   ----------------------------------------------------------------------------
   -- Functions return a batch run id for the batch that was undone
   ----------------------------------------------------------------------------
   FUNCTION get_batch_id_undone  ( p_brn_id      IN     NUMBER ) RETURN NUMBER
   IS
      l_brn_id  XXAPI_BATCH_RUNS.BRN_ID%TYPE;

      CURSOR c_brn IS
      SELECT brn_id
      FROM   XXAPI_BATCH_RUNS
      WHERE  brn_id_undo = p_brn_id
      ORDER BY 1
      ;
   BEGIN

      OPEN  c_brn;
      FETCH c_brn INTO l_brn_id;
      CLOSE c_brn;

      RETURN l_brn_id;

   END get_batch_id_undone;

   ----------------------------------------------------------------------------
   -- Function to retrieve the brn_id of the maximum batch run that was
   --          was not already undone.(regardless if it is correct or not)
   ----------------------------------------------------------------------------
   FUNCTION max_undo_batch (p_bah_code IN VARCHAR2) RETURN NUMBER
   IS
     CURSOR c_brn IS
        SELECT   brn_id
        FROM     XXAPI_BATCH_RUNS
        WHERE    brn_bah_code = p_bah_code
        AND      brn_id_undo IS NULL
        ORDER BY brn_startdate desc
        ;

     l_brn_id  XXAPI_BATCH_RUNS.BRN_ID%TYPE := NULL;

   BEGIN
     OPEN  c_brn;
     FETCH c_brn INTO l_brn_id;
     CLOSE c_brn;

     RETURN l_brn_id;

   END max_undo_batch;

   ----------------------------------------------------------------------------
   -- Function to retrieve the brn_id of the maximum batch run that was succesfull
   --          and that was not already undone.
   ----------------------------------------------------------------------------
   FUNCTION max_undo_succes_batch (p_bah_code IN VARCHAR2) RETURN NUMBER
   IS
     CURSOR c_brn IS
        SELECT   brn_id
        FROM     XXAPI_BATCH_RUNS brn
        WHERE    brn_bah_code = p_bah_code
        AND      brn_id_undo IS NULL
        AND      brn.brn_indicator_ok in( gc_Y, gc_W)
        ORDER BY brn_startdate desc
        ;
     l_brn_id  xxapi_batch_runs.brn_id%type := null;

   BEGIN

     OPEN  c_brn;
     FETCH c_brn INTO l_brn_id;
     CLOSE c_brn;

     RETURN l_brn_id;

   END max_undo_succes_batch;

   -----------------------------------------------------------------------------
   -- Funtion return the setting value from XXAPI_SETTINGS
   -----------------------------------------------------------------------------
   FUNCTION get_settings_value  ( p_lookup_code  IN VARCHAR2                   
                                , p_lookup_type  IN VARCHAR2  DEFAULT 'GENERIC'  ) RETURN VARCHAR2
   IS
      CURSOR c_api_settings  ( b_lookup_type  IN VARCHAR2  
                             , b_lookup_code  IN VARCHAR2 ) IS  
         select meaning          setting_value
         from   xxapi_lookup_values
         where  1=1
         and    upper(lookup_type) = upper(b_lookup_type)
         and    upper(lookup_code) = upper(b_lookup_code);

      l_meaning           XXAPI_LOOKUP_VALUES.MEANING%TYPE := 'NOT FOUND';
      lc_routine_name     VARCHAR (30)                     := 'get_settings_value';
     --
   BEGIN
      debug (lc_routine_name, ' Start.');
      FOR r_setting in c_api_settings ( p_lookup_type  , p_lookup_code)  LOOP

         l_meaning := r_setting.setting_value;

      END LOOP;
      debug (lc_routine_name, ' End.');
      --
      RETURN l_meaning;

   END get_settings_value;

   ----------------------------------------------------------------------------
   -- Function to get the last date this batch has run
   ----------------------------------------------------------------------------
   FUNCTION get_batch_last_run_date  (p_bah_code    in VARCHAR2 ) RETURN DATE
   IS
      lc_routine_name           VARCHAR2(50)      := 'get_batch_last_run_date';
      l_return                  DATE              := to_date('01-JAN-2024','DD-MON-YYYY');

      CURSOR c_batches IS
         SELECT   brn_startdate      datum
         FROM     XXAPI_BATCH_RUNS   brn
         WHERE    1=1
         AND      brn.brn_bah_code  = p_bah_code
         AND      brn.brn_indicator_ok in ('W','J')
         AND      brn.brn_id_undo  IS NULL
         AND      rownum = 1
         ORDER BY brn_startdate desc
         ;
   BEGIN
      debug (lc_routine_name, ' Start.');

      FOR r_batch in c_batches LOOP
         l_return := r_batch.datum;
      END LOOP;

      debug (lc_routine_name, ' End.');

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END get_batch_last_run_date;

   ----------------------------------------------------------------------------
   -- Functions return a batch code for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_code (p_brn_id    IN  NUMBER) RETURN VARCHAR2
   IS
      l_brn_rec  XXAPI_BATCH_RUNS%ROWTYPE;
   BEGIN
      l_brn_rec := get_batchrun_record (p_brn_id);
      RETURN l_brn_rec.brn_bah_code;
   END get_batch_code;

   ----------------------------------------------------------------------------
   -- Functions return the main batch id for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_id_main (p_brn_id       IN     NUMBER) RETURN NUMBER
   IS
      l_brn_rec  XXAPI_BATCH_RUNS%ROWTYPE;
   BEGIN
      l_brn_rec := get_batchrun_record(p_brn_id);
      RETURN l_brn_rec.brn_id_main;
   END get_batch_id_main;

   ----------------------------------------------------------------------------
   -- Functions return the indicator for a sepecific batch if it is has a main batch
   ----------------------------------------------------------------------------
   FUNCTION get_indicator_main_batch (p_bah_code      IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.bah_indicator_main;
   END get_indicator_main_batch;

  ----------------------------------------------------------------------------
   -- Functions return the indicator for a sepecific batch if it needs inline logging in the email response
   ----------------------------------------------------------------------------
   FUNCTION get_indicator_log_inline (p_bah_code      IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.BAH_INDICATOR_MAIN;
   END get_indicator_log_inline;

   ----------------------------------------------------------------------------
   -- Functions return the batch description for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_description (p_bah_code      IN     VARCHAR2) RETURN VARCHAR2
   IS

      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.bah_description;
   END get_batch_description;


   ----------------------------------------------------------------------------
   -- Functions returns the email address for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_mailadres (p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  xxapi_batches%rowtype;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.bah_email_address;
   END get_batch_mailadres;

   ----------------------------------------------------------------------------
   -- Functions returns the cc email address for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_mailadres_cc (p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.bah_email_address_cc;
   END get_batch_mailadres_cc;

   ----------------------------------------------------------------------------
   -- Functions returns the email address for the output for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_batch_mailadres_output (p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
      l_bah_rec := get_batch_record(p_bah_code);
      RETURN l_bah_rec.bah_email_address_output;
   END get_batch_mailadres_output;

   ----------------------------------------------------------------------------
   -- Functions returns the FTP hostto send the the output to for a sepecific batch run id
   ----------------------------------------------------------------------------
   FUNCTION get_ftp_target_host     ( p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
     l_bah_rec :=  get_batch_record(p_bah_code);
     RETURN l_bah_rec.bah_ftp_target_machine;
   END get_ftp_target_host;


   ----------------------------------------------------------------------------
   -- Functions returns to handle the interface file (ENCRYPT / DECRYPT / NULL )
   ----------------------------------------------------------------------------
   FUNCTION get_encrypt_indicator     ( p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
     l_bah_rec :=  get_batch_record(p_bah_code);
     RETURN l_bah_rec.BAH_ENCRYPT_INDICATOR;
   END get_encrypt_indicator;

   ----------------------------------------------------------------------------
   -- Functions returns the encryption file extention
   ----------------------------------------------------------------------------
   FUNCTION get_encrypted_file_extention     ( p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
     l_bah_rec :=  get_batch_record(p_bah_code);
     RETURN l_bah_rec.BAH_ENCRYPT_EXTENTION;
   END get_encrypted_file_extention;

   ----------------------------------------------------------------------------
   -- Functions returns the group id
   ----------------------------------------------------------------------------
   FUNCTION get_encrypt_sender_group_id     ( p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
     l_bah_rec :=  get_batch_record(p_bah_code);
     RETURN l_bah_rec.bah_encrypt_sender_group_id;
   END get_encrypt_sender_group_id;

   ----------------------------------------------------------------------------
   -- Functions returns the group id
   ----------------------------------------------------------------------------
   FUNCTION get_encrypt_receiver_group_id     ( p_bah_code       IN      VARCHAR2) RETURN VARCHAR2
   IS
      l_bah_rec  XXAPI_BATCHES%ROWTYPE;
   BEGIN
     l_bah_rec :=  get_batch_record(p_bah_code);
     RETURN l_bah_rec.bah_encrypt_receiver_group_id;
   END get_encrypt_receiver_group_id;

   ----------------------------------------------------------------------------
   -- Returns a TRUE boolean if a round count exists for this batch
   ----------------------------------------------------------------------------
   FUNCTION round_count_exists  ( p_bah_code   IN   VARCHAR2    ) RETURN BOOLEAN
   IS
      CURSOR c_brg IS
         SELECT 1
         FROM   XXAPI_BATCH_ROUNDCOUNTS
         WHERE  brt_bah_code = p_bah_code;

      l_exists BOOLEAN := FALSE;

   BEGIN

      FOR r_brg in c_brg LOOP
         l_exists := TRUE;
      END LOOP;

      RETURN l_exists;

   END round_count_exists;

   -------------------------------------------------------------
   -- Procedure initialize the indicators
   -------------------------------------------------------------
   PROCEDURE init_indicators
   IS
      l_empty_indicators       T_INDICATORS;
      l_empty_indicator_count  T_INDICATOR_COUNT;
      lc_routine_name          VARCHAR2(50)      := 'init_indicators';      
   BEGIN
      debug (lc_routine_name, ' Start.');   
      -- clear the indicator arrays of any left-over data
      g_indicators       := l_empty_indicators;
      g_indicator_count  := l_empty_indicator_count;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;            
   END init_indicators;


   -------------------------------------------------------------
   -- Procedure current value from the indicator
   -------------------------------------------------------------
   FUNCTION get_current_indicator_value ( p_indicator IN       VARCHAR2) RETURN NUMBER
   IS
      l_indicator            VARCHAR2(100) := NULL;
      l_return               NUMBER        := 0;
      lc_routine_name        VARCHAR2(50)      := 'get_current_indicator_value';
   BEGIN
      debug (lc_routine_name, ' Start.');   
      IF p_indicator IS NOT NULL THEN
         l_indicator := p_indicator;
      END IF;

      -- If there are incators pre-defined, increase the p_number
      IF  g_INDICATORS.COUNT > 0 THEN

         FOR i in g_INDICATORS.FIRST..g_INDICATORS.LAST LOOP

            IF  g_INDICATORS(i) = l_indicator THEN
               l_return := g_INDICATOR_COUNT(g_INDICATORS(i));
            END IF;

         END LOOP;

      END IF;
      debug (lc_routine_name, ' End.');
      RETURN l_return;
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;            
   END get_current_indicator_value;

   -------------------------------------------------------------
   -- Procedure increase an indicator value
   -------------------------------------------------------------
   PROCEDURE increase_indicator      ( p_indicator             IN       VARCHAR2
                                     , p_number                IN       NUMBER   DEFAULT 1
                                     , p_brn_id                IN       NUMBER   )
   IS
      l_found                BOOLEAN           := FALSE;
      l_indicator            VARCHAR2(100)     := NULL;
      l_indicator_counter    NUMBER            := 0;
      lc_routine_name        VARCHAR2(50)      := 'increase_indicator';
      cursor c_indicators (b_bah_code in xxapi_batch_counters.bcs_bah_code%type ) is
         select ind.bcs_code   bcs_code
         from   xxapi_batch_counters ind
         where  1=1
         and    IND.BCS_BAH_CODE = b_bah_code
         ;
   BEGIN
      debug (lc_routine_name, ' Start.');
      l_indicator_counter := g_INDICATORS.COUNT;

      IF p_indicator IS NOT NULL THEN
         l_indicator := p_indicator;
      END IF;

      -- try to fill in the indicators array if no records are available
      IF l_indicator_counter < 1 THEN

         FOR r_indicators IN c_indicators(xxapi_batch.get_batch_code(p_brn_id)) LOOP

            l_indicator_counter := l_indicator_counter + 1;

            g_INDICATORS(l_indicator_counter)        := r_indicators.bcs_code;
            g_INDICATOR_COUNT(r_indicators.bcs_code) := 0;

         END LOOP;
      --
      END IF;

      -- If there are indicators pre-defined, increase the p_number
      IF  g_INDICATORS.COUNT > 0 THEN

         FOR i in g_INDICATORS.FIRST..g_INDICATORS.LAST LOOP

            IF  g_INDICATORS(i) = l_indicator THEN

               IF p_number = 0 THEN
                  g_INDICATOR_COUNT(g_INDICATORS(i))     := 0;
               ELSE
                  g_INDICATOR_COUNT(g_INDICATORS(i))     := g_INDICATOR_COUNT(g_INDICATORS(i)) + p_number;
               END IF;
               l_found := TRUE;
            END IF;

         END LOOP;

         -- the indicator was not found so add it,and initialize with p_number
         IF NOT l_found THEN
            g_INDICATORS(g_INDICATORS.COUNT+1) := l_indicator;
            g_INDICATOR_COUNT(l_indicator) := p_number;
         END IF;
      -- If there are NO incators pre-defined, create it and start with p_number.
      ELSE
         g_INDICATORS(1)                := l_indicator;
         g_INDICATOR_COUNT(l_indicator) := p_number;
      END IF;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;            
   END increase_indicator;

   -------------------------------------------------------------
   -- Procedure to write all counters as indicators into the database
   -------------------------------------------------------------
   PROCEDURE write_indicators        ( p_brn_id                IN       NUMBER   )
   IS
      lc_routine_name        VARCHAR2(50)      := 'write_indicators';   
   BEGIN
      debug (lc_routine_name, ' Start.');
      IF g_INDICATORS.COUNT > 0 THEN
         FOR i in g_INDICATORS.FIRST..g_INDICATORS.LAST LOOP
            xxapi_batch.insert_indicator (p_brn_id,g_INDICATORS(i),g_INDICATOR_COUNT(g_INDICATORS(i)));
         END LOOP;
      END IF;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM); 
         RAISE;            
   END write_indicators;

   ----------------------------------------------------------------------------
   -- Add indicators for this batch run (kengetallen) to the table
   ----------------------------------------------------------------------------
   PROCEDURE insert_indicator        ( p_brn_id    in     NUMBER
                                     , p_code      in     VARCHAR2
                                     , p_value     in     NUMBER
                                     )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      E_ONTBREKEND_KENGETAL   exception;
      PRAGMA EXCEPTION_INIT (e_ontbrekend_kengetal, -2291);

      l_bah_code              XXAPI_BATCHES.BAH_CODE%TYPE;
      lc_routine_name         VARCHAR2(50)      := 'insert_indicator';
   BEGIN
      debug (lc_routine_name, ' Start.');
      l_bah_code := get_batch_code(p_brn_id);

      INSERT INTO xxapi_batch_run_counters  ( brc_brn_id
                                             , brc_bah_code
                                             , brc_bcs_code
                                             , brc_value
                                             )
      VALUES  ( p_brn_id
              , l_bah_code
              , p_code
              , nvl(p_value, 0)
              ) ;
      COMMIT;
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         debug (lc_routine_name, 'ERROR: ' ||SQLERRM);
      WHEN E_ONTBREKEND_KENGETAL THEN
          --RAISE_APPLICATION_ERROR (-20000, 'Technical error ! Indicator / Kengetal '||p_code||' missing');
          debug (lc_routine_name, 'ERROR: Technical error ! Indicator / Kengetal '||p_code||' missing');          
   END insert_indicator;

END XXAPI_BATCH;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_BATCH" TO "WKSP_XXPM";
  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_BATCH" TO "WKSP_XXCT";

--------------------------------------------------------
--  DDL for Package Body XXAPI_BATCH_RESULT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_BATCH_RESULT" 
AS
   /****************************************************************
   *
   *
   * PROGRAM NAME
   *  GENERIC - API003 - xxapi_BATCH_RESULT
   *
   * DESCRIPTION
   * Program to send the batch results for
   *  all generic API modules
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        02-12-2013  Initial Version
   * Wiljo Bakker        26-02-2014  Updated result folder in global
   * Wiljo Bakker        26-02-2014  Added cc and output email address (read from xxapi_batches)
   * Wiljo Bakker        27-02-2014  Updated textual
   * Wiljo Bakker        11-03-2014  Added procedures to print to screen and fnd_log
   * Wiljo Bakker        24-03-2014  Removed handling for main and sub-batches. All batch runs are main batches.
   * Wiljo Bakker        24-03-2014  General re-design for R12 implementation.
   * Wiljo Bakker        27-11-2014  Removed unwanted error message on roundcounts
   * Wiljo Bakker        23-02-2015  Updated header to also have warnings
   * Wiljo Bakker        25-02-2015  Fixed bug in printing the header
   * Wiljo Bakker        26-08-2021  Added option to add logging inline in email
   * Wiljo Bakker        16-09-2024  Rebuild for use in Cloud   
   **************************************************************/
   --
   -- $Id: XXAPI_BATCH_RESULT.pkb,v 1.1 2024/09/20 15:42:17 bakke619 Exp $
   -- $Log: XXAPI_BATCH_RESULT.pkb,v $
   -- Revision 1.1  2024/09/20 15:42:17  bakke619
   -- Initial revision
   --

   g_lines                  T_LINES;
   g_output_lines           T_LINES;   
   g_error_lines            T_LINES;   
   g_lines_empty            T_LINES;

   -- GLOBAL CONSTANTS
   gc_package_body_version         CONSTANT VARCHAR2(200) := '$Id: XXAPI_BATCH_RESULT.pkb,v 1.1 2024/09/20 15:42:17 bakke619 Exp $';
               
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
   --
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_clob in clob ) IS
      gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN xxapi_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine, rtrim(p_message) ,p_clob );
             ELSE NULL;
         END CASE;
      ELSE
         xxapi_gen_debug_pkg.debug_cs( gc_package_name||'.'||p_routine, rtrim(p_message), p_clob );
      END IF;
   END debug;
   --
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2, p_blob in blob ) IS
      gc_show_debug_start_end       CONSTANT BOOLEAN       := false;
   BEGIN
      IF p_message in (' Start.', ' End.') THEN
         CASE WHEN gc_show_debug_start_end
             THEN xxapi_gen_debug_pkg.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message) ,p_blob );
             ELSE NULL;
         END CASE;
      ELSE
         xxapi_gen_debug_pkg.debug_bs( gc_package_name||'.'||p_routine, rtrim(p_message), p_blob );
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
   -- Function to format the html body text for an email
   ----------------------------------------------------------------------------
   FUNCTION format_body  RETURN CLOB
   IS
      lc_routine_name           VARCHAR2(50)      := 'format_body';
      l_error_message           VARCHAR2(2000);
      l_email_body              CLOB ;
      l_style                   VARCHAR2(2000)    := '<DIV style="margin-left: 20px; font-family: Courier New, Courier, Lucida Console, Monospace; font-size: 14px">';
      l_end_Style               VARCHAR2(20)      := '</DIV>';

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
      add_line( xxapi_email.add_html_header    ( p_title      => xxapi_batch.get_settings_value('EMAIL_SUBJECT',gc_lookup_type_email)||' - '||g_bah_oms||' '||g_brn_id  ));

      ---------------------------------------
      -- Here custom code
      ---------------------------------------

      add_line('<p>Dear User,</p>');
      add_line('<p>'|| xxapi_batch.get_settings_value('EMAIL_TEXT',gc_lookup_type_email)||' "'|| g_bah_oms ||'".</p>');

      IF g_lines.COUNT > 0 THEN
         add_line('<p>'||l_style); 
         FOR i in g_lines.FIRST..g_lines.LAST LOOP
            add_line(g_lines(i) ||'<br>'|| UTL_TCP.CRLF);         
         END LOOP;
         add_line(l_end_style||'</p>'|| UTL_TCP.CRLF);         
      END IF;

      ---------------------------------------
      -- End custom code
      ---------------------------------------

      -- add an email signature
      add_line( xxapi_EMAIL.add_html_signature   ( p_free_format => '<p><span>'||gc_mnt_greeting||'</span></p>
<p><span style="color: #333399;">'||gc_mnt_name||'</span><br />
   <span style="color: #333399;"><strong>Email: </strong>
   <a style="color: #333399;" href="'||gc_mnt_email_address||'"><strong>'||gc_mnt_email_address||'</strong></a></span>
</p>'|| UTL_TCP.CRLF
)
               );

      -- finish the html page with mandatory code
      add_line ( xxapi_EMAIL.add_html_footer );

      RETURN l_email_body;

   EXCEPTION
      WHEN OTHERS THEN
         l_error_message := gc_package_name||'.'||lc_routine_name||' -SQL error: '||SQLERRM;
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RETURN EMPTY_CLOB;
   END format_body;

   ----------------------------------------------------------------------------
   -- Procedure to print a line into DBMS_OUPUT.PUT_LINE
   ----------------------------------------------------------------------------
   PROCEDURE put_line_dbms_output (p_line  in   VARCHAR2  )
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE(p_line);
   END put_line_dbms_output;

   ----------------------------------------------------------------------------
   -- PROCEDURE to put a line to an array of tekst
   ----------------------------------------------------------------------------
   PROCEDURE put_line   ( p_str       IN   VARCHAR2)
   IS
      l_crlf   VARCHAR2(2)  := chr(13) || chr(10);
      
   BEGIN
      -- add line to array 
      g_output_lines(g_output_lines.count+1) := p_str||l_crlf; 

      IF g_log_dbms_output THEN
         put_line_dbms_output (p_str);
      END IF;

      IF g_inline_email THEN 
         g_lines(g_lines.count+1) := substr(replace(p_str,gc_SPACE,gc_HTML_SPACE),0,32000);
      END IF; 

   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('Error writing to file: '||SQLERRM);

   END put_line;

   ----------------------------------------------------------------------------
   -- Funtion RETURN  time differnce between 2 dates WITHin 1 day
   ----------------------------------------------------------------------------
   FUNCTION get_time_diff   ( starttijd    IN DATE
                            , eindtijd     IN DATE)   RETURN VARCHAR2
   IS
      l_value VARCHAR2(10);
      l_tijd  NUMBER := round ( 86400 * ( eindtijd - starttijd ) );
   BEGIN
      SELECT replace ( trim ( to_char ( to_NUMBER ( trunc ( ( ( l_tijd ) / 60 ) / 60 ) - 24 * ( trunc ( ( ( ( l_tijd ) / 60 ) / 60 ) / 24 ) ) ), '00' ) ||
             to_char ( to_NUMBER ( trunc ( ( l_tijd ) / 60 ) - 60 * ( trunc ( ( ( l_tijd ) / 60 ) / 60 ) ) ), '00' ) ||
             to_char ( to_NUMBER ( trunc ( l_tijd ) - 60 * ( trunc ( ( l_tijd ) / 60 ) ) ), '00' ) ), ' ', ':' )
      INTO   l_value
      FROM   dual;

      RETURN l_value;

   END get_time_diff;

   ----------------------------------------------------------------------------
   -- Returns the percentage of value1 against value2
   ----------------------------------------------------------------------------
   FUNCTION get_percentage   ( p_value   IN   NUMBER
                             , p_value2  IN   NUMBER   ) RETURN NUMBER
   IS
     l_perc  NUMBER;
   BEGIN

      IF p_value2 > 0 THEN
        l_perc  := round(  (  ( p_value - p_value2
                             )
                          / p_value2
                          ) * 100
                       ) ;
      END if;

      RETURN (l_perc);
   END get_percentage;

   ----------------------------------------------------------------------------
   -- Procedure return the historical indicators with its percentage
   ----------------------------------------------------------------------------
   PROCEDURE get_historical_indicators       ( p_bcs_code           VARCHAR2
                                             , p_value              NUMBER
                                             , p_bah_code           VARCHAR2
                                             , p_value1      IN OUT NUMBER
                                             , p_perc1          OUT NUMBER
                                             , p_value2      IN OUT NUMBER
                                             , p_perc2          OUT NUMBER
                                             , p_value10     IN OUT NUMBER
                                             , p_perc10         OUT NUMBER    )
   IS
      CURSOR c_indicators IS
         SELECT brc_value    value
         FROM   xxapi_batch_run_counters ind
         ,      xxapi_batch_runs            brn
         WHERE  brn.brn_id       = ind.brc_brn_id
         AND    brn.brn_bah_code = p_bah_code
         AND    ind.brc_bcs_code = p_bcs_code
         AND    ind.brc_brn_id   < g_brn_id
         AND    brn.brn_id_undo  IS  NULL
         ORDER BY ind.brc_brn_id desc;

      l_row_count   NUMBER := 0;
      l_value       xxapi_batch_run_counters.brc_value%TYPE := 0;
      l_value1      NUMBER := 0;
      l_value2      NUMBER := 0;
      l_value10     NUMBER := 0;

   BEGIN
      p_value1  := 0;
      p_value2  := 0;
      p_value10 := 0;

      --LOOP through the past 10 batch runs of the same type AND extract the required data..
      FOR r_indicators IN c_indicators LOOP

         l_row_count := l_row_count + 1;
         l_value     := l_value + r_indicators.value;

         IF l_row_count  > 10 THEN   EXIT;                END IF;
         IF l_row_count  = 1  THEN   l_value1 := l_value; END IF;
         IF l_row_count <= 2  THEN   l_value2 := l_value; END IF;

         l_value10 :=  l_value;

      END LOOP;

      -- calculate the averages
      p_value1 := l_value1;

      IF l_row_count > 0 THEN
         p_value2  := round(l_value2/least(l_row_count, 2));
         p_value10 := round(l_value10/l_row_count);
      END IF;

      -- Calculate percentages
      p_perc1   := get_percentage ( p_value, p_value1);
      p_perc2   := get_percentage ( p_value, p_value2);
      p_perc10  := get_percentage ( p_value, p_value10);

   END get_historical_indicators;

   ----------------------------------------------------------------------------
   --Procedure to print the batch run header
   ----------------------------------------------------------------------------
   PROCEDURE print_header
   IS
      r_brn           XXAPI_BATCH_RUNS%ROWTYPE;
      l_brn_id_undone XXAPI_BATCH_RUNS.BRN_ID%TYPE;
   BEGIN
      r_brn           := xxapi_batch.get_batchrun_record(g_brn_id);
      l_brn_id_undone := xxapi_batch.get_batch_id_undone(g_brn_id);

      put_line( 'Batch Name        : ' || g_bah_oms);
      put_line( 'Batch Run Number  : ' || g_brn_id);

      IF l_brn_id_undone IS NULL THEN
         NULL;
      ELSE
         put_line( 'Undo of Batch Run: ' || l_brn_id_undone);
      END if;

      put_line( 'User name         : ' || r_brn.brn_user_name);
      put_line( 'Batch start time  : ' || to_char( r_brn.brn_startdate, 'DD-MM-YYYY HH24:MI:SS' ));
      put_line( 'Batch end time    : ' || to_char( r_brn.brn_enddate, 'DD-MM-YYYY HH24:MI:SS' ));
      put_line( 'Processing time   : ' || get_time_diff( r_brn.brn_startdate, r_brn.brn_enddate ));
      put_line( 'Batch run OK?     : ' || case r_brn.brn_indicator_ok
                                             WHEN gc_Y       THEN gc_YES
                                             WHEN gc_N       THEN gc_NO
                                             WHEN gc_W       THEN gc_WARNING
                                             ELSE r_brn.brn_indicator_ok
                                           end);
      put_line( 'Error message     : ' || coalesce( trim( r_brn.brn_error ), 'No errors' ));

   END print_header;

   ----------------------------------------------------------------------------
   -- Procedure to print the batch run information values in the batch report
   ----------------------------------------------------------------------------
   PROCEDURE print_information_lines
   IS
      CURSOR c_lines IS
         SELECT bro_description
         FROM   XXAPI_BATCH_RUN_INFO
         WHERE  bro_brn_id = g_brn_id
         ORDER BY bro_number ASC, bro_description;

      l_first_line BOOLEAN := TRUE;

   BEGIN

      FOR r_lines IN c_lines LOOP

         IF l_first_line THEN

            put_line ('');
            put_line ('Batch Information Lines' );
            put_line ('=======================' ) ;

            l_first_line := FALSE;

         END if;

         put_line (r_lines.bro_description);

      END LOOP;

   END print_information_lines;

   ----------------------------------------------------------------------------
   -- Procedure to print batch run errors (which are not in a round count)
   ----------------------------------------------------------------------------
   PROCEDURE print_error_lines  ( p_error_indicator  IN VARCHAR2
                                , p_round_count_code IN VARCHAR2  DEFAULT NULL)
   IS
      CURSOR c_errors IS
         WITH with_brl AS (   SELECT line.brl_line_nr    line_number
                              ,      line.brl_line       line
                              ,      line.brl_file     file_name
                              ,      replace(err.bft_description, '#1', line.brl_parameter) ||CASE WHEN nvl(line.brl_or_brn_id, line.brl_brn_id) = line.brl_brn_id THEN ''
                                                                                  ELSE 'Old Batch Run Number:'||line.brl_or_brn_id
                                                                             END  error_text
                              ,      row_number() over ( partition by line.brl_bft_code ORDER BY line.brl_line_nr)  row_numbers
                              ,      line.brl_bft_code    error_code
                              FROM   XXAPI_BATCH_RUN_FAILURES   line
                              ,      XXAPI_BATCH_ERRORS       err
                              WHERE  line.brl_brn_id     = g_brn_id
                              AND    line.brl_bah_code   = err.bft_bah_code
                              AND    line.brl_bft_code   = err.bft_code
                              AND    NVL(err.bft_brc_code,'NULL') = NVL(p_round_count_code,'NULL')
                              AND    err.bft_error_info_flag      = p_error_indicator
                              )
         SELECT   line_number
         ,        line
         ,        file_name
         ,        error_text
         ,        error_code
         FROM     with_brl
         WHERE    row_numbers <= 10
         ORDER BY error_code, line_number;

      l_exists       BOOLEAN := FALSE;
      l_print_header BOOLEAN := TRUE;

   BEGIN

      FOR r_errors IN c_errors LOOP

         IF l_print_header THEN

            l_print_header := FALSE;

            put_line('');

            IF p_error_indicator = 'E' THEN
               put_line('Errors (10 records for each error are shown)' );
               put_line('===========================================');
            ELSE
               put_line('Information Lines (10 records for each information type are shown)' );
               put_line('==================================================================');
            END IF;

         END IF;

         l_exists := TRUE;

         put_line('File               : '|| r_errors.file_name);
         put_line('Line Number        : '|| r_errors.line_number);
         put_line('Line Data          : '|| r_errors.line);
         put_line('Error Message      : '|| r_errors.error_text);

      END LOOP;

      IF p_round_count_code IS NULL THEN

         IF (NOT l_exists) AND p_error_indicator = 'E' THEN

           IF xxapi_batch.round_count_exists(g_bah_code) THEN
              put_line('');
              put_line('==========================================');
              put_line('There are no general errors');
              put_line('==========================================');
           ELSE
              put_line('');
              put_line('===============================');
              put_line('There are no unprocessed lines');
              put_line('===============================');
           END IF;

         END IF;

      ELSE

         IF (NOT l_exists) AND p_error_indicator = 'E' THEN
            put_line('==================================================');
            put_line('There are no error records within this round count');
            put_line('==================================================');
         END IF;

      END IF;

   END print_error_lines;

   ----------------------------------------------------------------------------
   -- Procedure to print the batch run errors
   ----------------------------------------------------------------------------
   PROCEDURE print_errors_per_type  (p_error_indicator  IN VARCHAR2
                                   , p_round_count_code IN VARCHAR2  DEFAULT NULL)
   IS
      CURSOR c_errors IS
         SELECT line.brl_bft_code         error_code
         ,      err.bft_description               error_description
         ,      COUNT(*)                  error_count
         FROM   XXAPI_BATCH_RUN_FAILURES line
         ,      XXAPI_BATCH_ERRORS     err
         WHERE  line.brl_brn_id              = g_brn_id
         AND    line.brl_bah_code            = err.bft_bah_code
         AND    line.brl_bft_code            = err.bft_code
         AND    err.bft_error_info_flag      = p_error_indicator
         AND    NVL(err.bft_brc_code,'NULL') = NVL(p_round_count_code,'NULL')
         GROUP BY line.brl_bft_code
         ,        err.bft_description
         ORDER BY err.bft_description;

      l_print_header BOOLEAN := TRUE;

   BEGIN

      FOR r_errors IN c_errors LOOP

         IF l_print_header THEN

            put_line('');
            put_line('');

            IF p_error_indicator = 'E' THEN
               put_line('Errors (Accumulated per Error)' );
               put_line('=============================');
            ELSE
               put_line('Information Lines (Accumulated per type of Information line)' );
               put_line('===========================================================');
            END IF;

            l_print_header := FALSE;

         END IF;

         put_line(rpad(substr(r_errors.error_description, 1, 70), 70)
                      ||lpad (r_errors.error_count, 10)
                 );
      END LOOP;

   END print_errors_per_type;

   ----------------------------------------------------------------------------
   -- Procedure to print the files that were processed during the batch run
   ----------------------------------------------------------------------------
   PROCEDURE print_files_processed
   IS

      CURSOR c_files IS
         SELECT files.brf_file file_name
         ,      min (files.brf_input_output) OVER (PARTITION BY files.brf_brn_id ORDER BY files.brf_input_output) min_brf_input_output
         ,      max (files.brf_input_output) OVER (PARTITION BY files.brf_brn_id ORDER BY files.brf_input_output) max_brf_input_output
         FROM  xxapi_batch_run_file files
         WHERE files.brf_brn_id = g_brn_id;

      c_max_print_in_test CONSTANT NUMBER  := 10;

      l_count_files                NUMBER  := 0;
      l_print_files                BOOLEAN := TRUE;
      l_print_header               BOOLEAN := TRUE;

      l_text_part                 VARCHAR2(60);

   BEGIN

      FOR r_files IN c_files LOOP

         IF l_print_header THEN

            put_line ('');

            IF       r_files.min_brf_input_output = 'I'
                 AND r_files.max_brf_input_output = 'I' THEN
               put_line ('Processed Files' );
               put_line ('===================' ) ;
            ELSIF    r_files.min_brf_input_output = 'I'
                 AND r_files.max_brf_input_output = 'O' THEN
               put_line ('Processed and Created Files' );
               put_line ('==================================' ) ;
            ELSE
               put_line ('Created Files' );
               put_line ('=====================' ) ;
            END if;

            l_print_header := FALSE;

         END IF;

         l_count_files := l_count_files + 1;

         IF g_test THEN

            -- only the first 10 files are shown
            IF l_count_files > c_max_print_in_test THEN
               l_print_files := FALSE;
            END if;

         END if;

         IF l_print_files THEN
            put_line (r_files.file_name);
         END if;

      END LOOP;

      IF    g_test
        AND l_count_files > c_max_print_in_test THEN

         CASE xxapi_batch.get_file_type(g_brn_id)
            WHEN 'I'  THEN l_text_part := 'loaded';
            WHEN 'U'  THEN l_text_part := 'created';
            WHEN 'IU' THEN l_text_part := 'loaded and created';
            ELSE l_text_part := 'unknown action';
         END CASE;

         put_line ('There are '||l_count_files||' files '||l_text_part||'. The first '||c_max_print_in_test||' files are shown');

      END IF;

   END print_files_processed;


   ----------------------------------------------------------------------------
   -- Procedure to print a single round count for this batchrun
   ----------------------------------------------------------------------------
   PROCEDURE print_single_round_count    ( p_brt_code  IN   VARCHAR2
                                         , p_brt_description   IN   VARCHAR2 )
   IS
      CURSOR c_indicators_read IS
         SELECT ind.bcs_description                ind_description
         ,      ind_cnt.brc_value         ind_value
         ,      ind.bcs_code               ind_code
         ,      brn.brn_bah_code           batch_code
         FROM   xxapi_batch_run_counters  ind_cnt
         ,      xxapi_batch_counters      ind
         ,      XXAPI_BATCH_RUNS             brn
         WHERE  ind_cnt.brc_bcs_code      = ind.bcs_code
         AND    ind_cnt.brc_bah_code      = ind.bcs_bah_code
         AND    ind_cnt.brc_brn_id        = brn.brn_id
         AND    ind_cnt.brc_brn_id        = g_brn_id
         AND    ind.bcs_bah_code          = brn.brn_bah_code
         AND    ind.bcs_brt_code_read   = p_brt_code
         ORDER BY bcs_printing_order, bcs_description;

      CURSOR c_indicators_processed IS
         SELECT ind.bcs_description                ind_description
         ,      ind_cnt.brc_value         ind_value
         ,      ind.bcs_code               ind_code
         ,      brn.brn_bah_code           batch_code
         FROM   xxapi_batch_run_counters  ind_cnt
         ,      xxapi_batch_counters      ind
         ,      XXAPI_BATCH_RUNS             brn
         WHERE  ind_cnt.brc_bcs_code      = ind.bcs_code
         AND    ind_cnt.brc_bah_code      = ind.bcs_bah_code
         AND    ind_cnt.brc_brn_id        = brn.brn_id
         AND    ind_cnt.brc_brn_id        = g_brn_id
         AND    ind.bcs_bah_code          = brn.brn_bah_code
         AND    ind.bcs_brt_code_processed = p_brt_code
         ORDER BY bcs_printing_order, bcs_description;

      l_total_read               NUMBER := 0;
      l_total_processed          NUMBER := 0;
      l_difference               NUMBER;
      l_count                    NUMBER;

      l_value1                   NUMBER;
      l_perc1                    NUMBER;
      l_value2                   NUMBER;
      l_perc2                    NUMBER;
      l_value10                  NUMBER;
      l_perc10                   NUMBER;

      E_ROUND_COUNT_0            EXCEPTION;

   BEGIN

      -- Count the number of records to decide if the header needs to be printed
      SELECT nvl(sum(ind_cnt.brc_value), 0)
      INTO   l_count
      FROM   xxapi_batch_run_counters  ind_cnt
      ,      xxapi_batch_counters      ind
      ,      XXAPI_BATCH_RUNS             brn
      WHERE  ind_cnt.brc_bcs_code      = ind.bcs_code
      AND    ind_cnt.brc_bah_code      = ind.bcs_bah_code
      AND    ind_cnt.brc_brn_id        = brn.brn_id
      AND    ind_cnt.brc_brn_id        = g_brn_id
      AND    ind.bcs_bah_code          = brn.brn_bah_code
      AND    ind.bcs_brt_code_read   = p_brt_code;

     -- Print header line for this round count
      IF l_count = 0 THEN

         IF  NOT g_test THEN
            RAISE E_ROUND_COUNT_0;
         END IF;

      ELSE
         put_line ('');
         put_line ('');
         put_line ('Round counts '||p_brt_description);
         put_line ('============='||rpad('=', length(p_brt_description), '='));
         put_line ('');
      END if;

      -- Print the header lines for Read Indicators
      put_line(rpad('Read indicators'    , gc_length_column1, ' ')
              || rpad('This'             , gc_length_column2, ' ')
              || rpad('Deviation against', gc_length_column3, ' ')
              || rpad('Deviation against', gc_length_column4, ' ')
              || rpad('Deviation against', gc_length_column5, ' ')
              ) ;

      put_line ( rpad('. '              , gc_length_column1, ' ')
              || rpad('Batch Run'       , gc_length_column2, ' ')
              || rpad('Previous Run '   , gc_length_column3, ' ')
              || rpad('Previous 2 Runs' , gc_length_column4, ' ')
              || rpad('Previous 10 Runs', gc_length_column5, ' ')
              ) ;

      -- Print all read indicators for this round count and the historical values
      FOR r_read IN c_indicators_read LOOP

         get_historical_indicators     ( r_read.ind_code
                                       , r_read.ind_value
                                       , r_read.batch_code
                                       , l_value1
                                       , l_perc1
                                       , l_value2
                                       , l_perc2
                                       , l_value10
                                       , l_perc10
                                       );

         put_line(   rpad(r_read.ind_description, gc_length_column1, ' ' )
                  || rpad(r_read.ind_value      , gc_length_column2, ' ')
                  || rpad(l_value1              , gc_length_column3, ' ')
                  || rpad(l_value2              , gc_length_column4, ' ')
                  || rpad(l_value10             , gc_length_column5, ' ')
                  );

         put_line(   rpad('. '             , gc_length_column1, ' ' )
                  || rpad('.'              , gc_length_column2, ' ')
                  || rpad('   % '||l_perc1 , gc_length_column3, ' ')
                  || rpad('   % '||l_perc2 , gc_length_column4, ' ')
                  || rpad('   % '||l_perc10, gc_length_column5, ' ')
                  );

         l_total_read := l_total_read + r_read.ind_value;

      END LOOP;

      put_line ('');
      put_line ('**Total Read: '||l_total_read);
      put_line ('');
      put_line ('');

      -- Print the header lines for Processed Indicators
      put_line(rpad('Processed Indicators', gc_length_column1, ' ')
             || rpad('This'               , gc_length_column2, ' ')
             || rpad('Deviation against'  , gc_length_column3, ' ')
             || rpad('Deviation against'  , gc_length_column4, ' ')
             || rpad('Deviation against'  , gc_length_column5, ' ')
             ) ;

      put_line (   rpad('. '               , gc_length_column1, ' ')
                || rpad('Batch Run'        , gc_length_column2, ' ')
                || rpad('Previous Run '    , gc_length_column3, ' ')
                || rpad('Previous 2 Runs ' , gc_length_column4, ' ')
                || rpad('Previous 10 Runs ', gc_length_column5, ' ')
             ) ;

      -- Print all processed indicators for this round count and the historical values
      FOR r_processed IN c_indicators_processed LOOP
         get_historical_indicators     ( r_processed.ind_code
                                       , r_processed.ind_value
                                       , r_processed.batch_code
                                       , l_value1
                                       , l_perc1
                                       , l_value2
                                       , l_perc2
                                       , l_value10
                                       , l_perc10
                                       );

         put_line(   rpad(r_processed.ind_description, gc_length_column1, ' ' )
                  || rpad(r_processed.ind_value      , gc_length_column2, ' ')
                  || rpad(' '||l_value1              , gc_length_column3, ' ')
                  || rpad(' '||l_value2              , gc_length_column4, ' ')
                  || rpad(' '||l_value10             , gc_length_column5, ' ')
                  );

         put_line(   rpad('. '             , gc_length_column1, ' ' )
                  || rpad('.'              , gc_length_column2, ' ')
                  || rpad('   % '||l_perc1 , gc_length_column3, ' ')
                  || rpad('   % '||l_perc2 , gc_length_column4, ' ')
                  || rpad('   % '||l_perc10, gc_length_column5, ' ')
                  );

         l_total_processed := l_total_processed + r_processed.ind_value;

      END LOOP;

      put_line ('');
      put_line ('**Total processed: '||l_total_processed);
      put_line ('');

      l_difference := l_total_read - l_total_processed;

      put_line ('');
      put_line ('**Total read - Total processed: '||l_difference);
      put_line ('');

      print_errors_per_type   ('E', p_brt_code);         -- Print counts for Errors of this round count (if any exist)
      print_error_lines       ('E', p_brt_code);         -- Print first 10 Errors for this round count (if any exist)
      print_errors_per_type   ('I', p_brt_code);         -- Print counts for Info lines of this round count (if any exist)
      print_error_lines       ('I', p_brt_code);         -- Print first 10 Info Lines for this round count (if any exist)

   EXCEPTION
      WHEN E_ROUND_COUNT_0 THEN
--         technical message, not relevant to users. Do not print this.
--         IF NOT g_test THEN
--            put_line ('No indicators have been counted or all are 0');
--         END IF;
          NULL;
   END print_single_round_count;

   ----------------------------------------------------------------------------
   -- Procedure to print all round counts for a batch run
   ----------------------------------------------------------------------------
   PROCEDURE print_round_counts
   IS
      CURSOR c_round_counts IS
         SELECT brt_code    code
         ,      brt_description     description
         FROM   XXAPI_BATCH_ROUNDCOUNTS rc
         WHERE  rc.brt_bah_code = g_bah_code
         ORDER BY rc.brt_sequence;

   BEGIN

      -- First check if a round count exists. If so, print it.
      IF xxapi_batch.round_count_exists(g_bah_code)  THEN

         FOR r_round_counts IN c_round_counts LOOP

            print_single_round_count  ( r_round_counts.code
                                      , r_round_counts.description
                                      ) ;
         END LOOP;

      END IF;

   END print_round_counts;

   ----------------------------------------------------------------------------
   -- Procedure to print the historical indicators for this batch run
   ----------------------------------------------------------------------------
   PROCEDURE print_indicators
   IS
      CURSOR c_indicators IS
         SELECT ind.bcs_description        ind_description
         ,      cnt.brc_value     ind_value
         ,      ind.bcs_code       ind_code
         ,      brn.brn_bah_code   batch_code
         FROM   xxapi_batch_run_counters    cnt
         ,      xxapi_batch_counters        ind
         ,      xxapi_batch_runs               brn
         WHERE  cnt.brc_bcs_code                    = ind.bcs_code
         AND    cnt.brc_bah_code                    = ind.bcs_bah_code
         AND    brn.brn_id                          = cnt.brc_brn_id
         AND    cnt.brc_brn_id                      = g_brn_id
         AND    ind.bcs_brt_code_read             IS  NULL
         AND    ind.bcs_brt_code_processed           IS  NULL
         ORDER BY ind.bcs_printing_order, ind.bcs_description;

      l_value1          NUMBER;
      l_perc1           NUMBER;
      l_value2          NUMBER;
      l_perc2           NUMBER;
      l_value10         NUMBER;
      l_perc10          NUMBER;
      l_print_header    BOOLEAN := TRUE;

   BEGIN

     --Get the Indicator values.
      FOR r_indicators IN c_indicators LOOP

         IF l_print_header THEN
            put_line ('');
            put_line ('');
            put_line ('Remaining Indicators');
            put_line ('========================');
            put_line ('');

            --Build title string for indicator results.
            put_line(rpad('Description'        , gc_length_column1, ' ')
                    || rpad('This'             , gc_length_column2, ' ')
                    || rpad('Deviation against', gc_length_column3, ' ')
                    || rpad('Deviation against', gc_length_column4, ' ')
                    || rpad('Deviation against', gc_length_column5, ' ')
                    ) ;
            --
            put_line ( rpad('. '              , gc_length_column1, ' ')
                    || rpad('Batch Run'       , gc_length_column2, ' ')
                    || rpad('Previous Run '   , gc_length_column3, ' ')
                    || rpad('Previous 2 Runs' , gc_length_column4, ' ')
                    || rpad('Previous 10 Runs', gc_length_column5, ' ')
                    ) ;

            l_print_header := FALSE;

         END IF;

         get_historical_indicators     ( r_indicators.ind_code
                                       , r_indicators.ind_value
                                       , r_indicators.batch_code
                                       , l_value1
                                       , l_perc1
                                       , l_value2
                                       , l_perc2
                                       , l_value10
                                       , l_perc10
                                       );

         put_line (  rpad(r_indicators.ind_description, gc_length_column1, ' ' )
                  || rpad(r_indicators.ind_value      , gc_length_column2, ' ')
                  || rpad(l_value1                    , gc_length_column3, ' ')
                  || rpad(l_value2                    , gc_length_column4, ' ')
                  || rpad(l_value10                   , gc_length_column5, ' ')
                  );
         put_line (  rpad('. '             , gc_length_column1, ' ' )
                  || rpad('.'              , gc_length_column2, ' ')
                  || rpad('   % '||l_perc1 , gc_length_column3, ' ')
                  || rpad('   % '||l_perc2 , gc_length_column4, ' ')
                  || rpad('   % '||l_perc10, gc_length_column5, ' ')
                  );
      END LOOP;

   END print_indicators;

   ----------------------------------------------------------------------------
   -- Procedure to create the batch run report
   ----------------------------------------------------------------------------
   PROCEDURE create_batch_run_report
   IS
      lc_routine_name            VARCHAR2(50)      := 'create_batch_run_report';
   BEGIN
      debug (lc_routine_name, ' Start.');

      print_header;
      print_information_lines;
      print_files_processed;
      print_round_counts;
      print_indicators;
      print_errors_per_type('E', null);
      print_error_lines    ('E', null);
      print_errors_per_type('I', null);
      print_error_lines    ('I', null);
      
      -- Add the report to the file names array
      g_file_names(g_file_names.COUNT + 1) := g_batch_report_name;
      
      debug (lc_routine_name, ' End.');
     
   EXCEPTION
      WHEN OTHERS THEN
         debug(lc_routine_name,'Error writing to file: '||SQLERRM);
         raise;
   END create_batch_run_report;


   ----------------------------------------------------------------------------
   -- Procedure to create the batch run report
   ----------------------------------------------------------------------------
   PROCEDURE create_error_report
   IS
      l_header                   VARCHAR2(2000)   := 'BRL_ID|BRL_BRN_ID|BRL_REGEL_NR|BRL_REGEL|BRL_BESTAND|BRL_BAH_CODE|BRL_BFT_CODE|BRL_PARAMETER|BRL_OR_BRN_ID';
      lc_routine_name            VARCHAR2(50)     := 'create_error_report';
      l_crlf                     VARCHAR2(2)      := chr(13) || chr(10);
            
      CURSOR c_errors IS
         SELECT err.brl_id          ||'|'||
                err.brl_brn_id      ||'|'||
                err.brl_line_nr     ||'|'||
                err.brl_line        ||'|'||
                err.brl_file        ||'|'||
                err.brl_bah_code    ||'|'||
                err.brl_bft_code    ||'|'||
                err.brl_parameter   ||'|'||
                err.brl_or_brn_id    data
         FROM   xxapi_batch_run_failures err
         WHERE  err.brl_brn_id = g_brn_id
         ORDER  BY err.brl_id;

      -- local function to check if there are error lines to print
      FUNCTION brl_exist RETURN BOOLEAN
      IS
         CURSOR c_brl  IS
            SELECT     'x'
            FROM       xxapi_batch_run_failures
            WHERE      brl_brn_id =g_brn_id;

         l_exists boolean := FALSE;

      BEGIN
         FOR r_brl in c_brl LOOP
            l_exists := TRUE;
         END LOOP;

         return l_exists;
      END;
      -- end local functions.
      
   BEGIN

      -- check if there are error lines for this batchrun
      IF brl_exist THEN


         -- print the header line
         g_error_lines(g_error_lines.count+1) := l_header||l_crlf; 

         -- flush the errors into the array
         FOR r_errors IN c_errors  LOOP
            g_error_lines(g_error_lines.count+1) := r_errors.data||l_crlf;
         END LOOP;

         -- add the filename to the array of file names.
         g_file_names(g_file_names.COUNT + 1) := g_error_report_name;

      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         debug(lc_routine_name,'Error writing to file: '||SQLERRM);
         RAISE;
   END create_error_report;

   --------------------------------------------------------------------------------------
   -- procedure to flush a file to object store
   --------------------------------------------------------------------------------------
   PROCEDURE save_to_object_store ( p_file   in  XXAPI_FILE_LIST ) IS
      l_response       CLOB;
      l_contents_blob  BLOB;
      l_request_url    VARCHAR2(32000);      
      lc_routine_name  VARCHAR2(50)      := 'save_to_object_store';      
   BEGIN
      debug (lc_routine_name, ' Start.');
      
      -- contruct the location based on the lookups
      l_request_url :=  xxapi_batch.get_settings_value('BASE_URL',gc_lookup_type_object_store)   || 
                        xxapi_batch.get_settings_value('OUTPUT_DIR',gc_lookup_type_object_store) ||
                        apex_util.url_encode( p_file.file_name);
                           
      -- put the file contents into a blob type  
      IF p_file.FILE_TYPE = 'A' then 
         l_contents_blob :=  apex_util.clob_to_blob ( p_clob              => p_file.file_contents_a
                                                    , p_charset           => 'AL32UTF8'
                                                    , p_include_bom       => 'N' 
                                                    , p_in_memory         => 'Y'
                                                    , p_free_immediately  => 'Y' 
                                                    );
      ELSE
         l_contents_blob := p_file.file_contents_b;
      END IF;

      --push the file into the object store
      l_response := apex_web_service.make_rest_request(  p_url                   => l_request_url
                                                      ,  p_http_method           => 'PUT'
                                                      ,  p_body_blob             => l_contents_blob
                                                      ,  p_credential_static_id  =>  xxapi_batch.get_settings_value('CREDENTIAL_STATIC_ID',gc_lookup_type_object_store) 
                                                      );
      debug (lc_routine_name, ' End.');

   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END save_to_object_store;

   --------------------------------------------------------------------------------------
   -- procedure to send an email with attachments
   --------------------------------------------------------------------------------------
   PROCEDURE send_email_results IS
      lc_routine_name             VARCHAR2(50)      := 'send_email_results';
      
      l_bah_email_address         XXAPI_BATCHES.bah_email_address%TYPE;
      l_bah_email_address_cc      XXAPI_BATCHES.bah_email_address%TYPE;
      l_bah_email_address_output  XXAPI_BATCHES.bah_email_address%TYPE;

      l_attachments               XXAPI_ATTACHMENTS := xxapi_attachments();
      l_file                      XXAPI_FILE_LIST;

      l_clob                      CLOB;

      -- local procedure to add a line of text to the CLOB
      PROCEDURE add_line (p_line in varchar2)
      IS
         l_offset          NUMBER := 0;
      BEGIN
         l_offset := dbms_lob.getlength(l_clob) + 1;
         dbms_lob.write(l_clob,length(p_line),l_offset,p_line);
      END add_line;
            
   BEGIN
      IF g_send_email THEN

         l_bah_email_address           := xxapi_email.clean_email_string(xxapi_batch.get_batch_mailadres(g_bah_code));
         l_bah_email_address_cc        := xxapi_email.clean_email_string(xxapi_batch.get_batch_mailadres_cc(g_bah_code));
         l_bah_email_address_output    := xxapi_email.clean_email_string(xxapi_batch.get_batch_mailadres_output(g_bah_code));

         -- loop over the filename's to add it to the l_attachments type.
         IF g_file_names.COUNT > 0 THEN

            FOR i in g_file_names.FIRST..g_file_names.LAST LOOP

               -- initialize the clob for the mail-body text
               dbms_lob.createtemporary( l_clob, false, 10 );            

               CASE g_file_names(i)
                  WHEN  g_batch_report_name THEN 
                     IF g_output_lines.COUNT > 0 THEN
                        FOR j in g_output_lines.FIRST..g_output_lines.LAST LOOP
                           add_line(g_output_lines(j));                              
                        END LOOP;
                     END IF;
                  WHEN  g_error_report_name THEN                     
                     IF g_error_lines.COUNT > 0 THEN
                        FOR j in g_error_lines.FIRST..g_error_lines.LAST LOOP
                           add_line(g_error_lines(j));                              
                        END LOOP;
                     END IF;
                  ELSE NULL;
               END CASE;
               
               l_file := xxapi_file_list  ( FILE_NAME       => g_file_names(i)
                                          , FILE_TYPE       => 'A'
                                          , FILE_MIME_TYPE  => gc_mime_type_ascii
                                          , FILE_DIRECTORY  => NULL
                                          , FILE_CONTENTS_A => l_clob
                                          , FILE_CONTENTS_B => EMPTY_BLOB
                                          );         

               l_attachments.extend();
               l_attachments(l_attachments.count) := l_file;

               DBMS_LOB.freetemporary (l_clob);

            END LOOP;

         END IF;

         -- send a new mail containing the attachments
         xxapi_send_email(  p_from        => xxapi_batch.get_settings_value('SENDER_EMAIL',gc_lookup_type_email)
                         ,  p_to          => l_bah_email_address
                         ,  p_cc          => l_bah_email_address_cc
                         ,  p_bcc         => NULL
                         ,  p_subject     => xxapi_batch.get_settings_value('EMAIL_SUBJECT',gc_lookup_type_email)||' - '||g_bah_oms||' '||g_brn_id --'Batch Result Information '||l_bah_oms||' '||p_brn_id
                         ,  p_body_clob   => case when g_inline_email then format_body else EMPTY_CLOB end
                         ,  p_html        => case when g_inline_email then 'HTML' else NULL end                          
                         ,  p_message     => case when g_inline_email then NULL   else xxapi_batch.get_settings_value('EMAIL_TEXT',gc_lookup_type_email)||' "'|| g_bah_oms ||'".' end
                         ,  p_print_att   => case when g_inline_email then FALSE  else TRUE end
                         ,  p_attachments => l_attachments
                         );
      debug (lc_routine_name, ' End.');
      END IF;

   END send_email_results;

   --------------------------------------------------------------------------------------
   -- main procedure to create the batch result attachment and send the email
   --------------------------------------------------------------------------------------
   PROCEDURE main (p_brn_id IN NUMBER)
   IS
      lc_routine_name            VARCHAR2(50)      := 'main';
   BEGIN
      debug (lc_routine_name, ' Start.');
      -- Make it global so it can be used in all proc/func.
      g_brn_id                  := p_brn_id;

      -- Get batch run information
      g_bah_code                := xxapi_batch.get_batch_code (g_brn_id);
      g_bah_oms                 := xxapi_batch.get_batch_description (g_bah_code);
      g_inline_email            := case xxapi_batch.get_indicator_log_inline(g_bah_code) when 'N' then FALSE else TRUE end;
      
      g_batch_report_name       := 'xxapi_'||lower(g_bah_code)||'_'||ltrim(to_char(g_brn_id))||'.txt';
      g_error_report_name       := 'xxapi_'||lower(g_bah_code)||'_error_'||ltrim(to_char(g_brn_id))||'.csv';
      g_lines                   := g_lines_empty;
      g_output_lines            := g_lines_empty;
      g_file_names              := g_empty_file_names;   
         
      create_batch_run_report;
      create_error_report;
      
      send_email_results;
 
           
--      --flush files to object store      
--      IF g_attachments.count > 0 THEN 
--         FOR i IN 1..g_attachments.count   LOOP
--               debug (lc_routine_name, '8');
--            save_to_object_store ( p_file  => g_attachments(i));
--         END LOOP;
--      END IF;
      debug (lc_routine_name, ' End.');
   END main;

END XXAPI_BATCH_RESULT;

/

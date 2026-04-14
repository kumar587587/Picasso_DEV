--------------------------------------------------------
--  DDL for Package Body XXAPI_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_UTILS" AS
   /****************************************************************
   *
   *
   * PROGRAM NAME
   *  GENERIC - XXAPI_UTILS
   *
   * DESCRIPTION
   * Program that holds general util functions and procedures for
   *   API Modules
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        03-12-2013  Initial Version
   * Wiljo Bakker        07-01-2014  Added Truncate table
   * Wiljo Bakker        18-03-2014  Fixed Bug on gather Statistics schema-name
   * Wiljo Bakker        25-04-2014  Addded procedure to remove lookup values
   * Wiljo Bakker        27-06-2019  Addded new functions for environments
   * Wiljo Bakker        16-06-2020  Remove directories from javaPolicytable (ODO1095) in tranches of 30
   * Wiljo Bakker        26-01-2021  Overloaded ice_split_record_fnc with version for escaping characters
   * Wiljo Bakker        16-09-2024  Rebuild for use in Cloud      
   **************************************************************/
   --
   -- $Id: XXAPI_UTILS.pkb,v 1.1 2024/09/20 15:43:20 bakke619 Exp $
   -- $Log: XXAPI_UTILS.pkb,v $
   -- Revision 1.1  2024/09/20 15:43:20  bakke619
   -- Initial revision
   --

   gc_package_body_version       CONSTANT VARCHAR2(200) := '$Id: XXAPI_UTILS.pkb,v 1.1 2024/09/20 15:43:20 bakke619 Exp $';

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

   -----------------------------------------------------------------------------
   -- Funtion return the setting value from XXAPI_SETTINGS
   -----------------------------------------------------------------------------
   FUNCTION get_api_settings  ( p_lookup_code  IN VARCHAR2   
                              , p_lookup_type  IN VARCHAR2  DEFAULT 'GENERIC'                  ) RETURN VARCHAR2
   IS
      CURSOR c_api_settings  ( b_lookup_type  IN VARCHAR2  
                             , b_lookup_code  IN VARCHAR2 ) IS  
         select meaning          setting_value
         from   xxapi_lookup_values
         where  1=1
         and    upper(lookup_type) = upper(b_lookup_type)
         and    upper(lookup_code) = upper(b_lookup_code);

      l_meaning           XXAPI_LOOKUP_VALUES.MEANING%TYPE := 'NOT FOUND';
      lc_routine_name     VARCHAR (30)                     := 'get_api_settings';
     --
   BEGIN
      debug (lc_routine_name, ' Start.');
      FOR r_setting in c_api_settings ( p_lookup_type  , p_lookup_code)  LOOP

         l_meaning := r_setting.setting_value;

      END LOOP;
      debug (lc_routine_name, p_lookup_code||' SETTING >> ' ||l_meaning);
      debug (lc_routine_name, ' End.');
      --
      RETURN l_meaning;

   END get_api_settings;

   -----------------------------------------------------------------------------
   -- Function overlaoded for backwards compatible 
   -----------------------------------------------------------------------------
   FUNCTION get_api_settings ( p_setting_code  IN  VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN get_api_settings ( p_lookup_code => p_setting_code );
   END get_api_settings;

   -----------------------------------------------------------------------------
   -- Funtion to open a file handle for an attachment
   -----------------------------------------------------------------------------
   FUNCTION open_bijlage   ( p_filenaam    VARCHAR2
                           , p_directory   VARCHAR2 )   RETURN utl_file.file_type
   IS
      lc_routine_name     VARCHAR (30) := 'open_bijlage';
      l_file_handle       utl_file.file_type;

   BEGIN
      debug (lc_routine_name, ' Start.');
      --Create file to write batch result data in.
      l_file_handle := utl_file.fopen( p_directory, p_filenaam, 'w' );
      debug (lc_routine_name, ' End.');
    RETURN l_file_handle;
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
         RAISE;      
   END open_bijlage;

   -----------------------------------------------------------------------------
   -- Procedure to close a file handle for an attachment
   -----------------------------------------------------------------------------
   PROCEDURE close_bijlage    ( p_file_handle   IN OUT  utl_file.file_type )
   IS
      lc_routine_name     VARCHAR (30) := 'close_bijlage';
   BEGIN
      debug (lc_routine_name, ' Start.');
      utl_file.fclose( p_file_handle );
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
         RAISE;      
   END close_bijlage;

   -----------------------------------------------------------------------------
   -- Procedure to write a line in a file
   -----------------------------------------------------------------------------
   PROCEDURE put_line( p_str         VARCHAR2
                     , p_file_handle utl_file.file_type)
   IS
   BEGIN
      utl_file.put_line(p_file_handle, p_str);
   END;

   ------------------------------------------------------------------------------------------
   -- Gather schema statistics for p_tablename using the analyze table command
   ------------------------------------------------------------------------------------------
   PROCEDURE analyze_table(p_tablename     IN   VARCHAR2)
   IS
      lc_routine_name     VARCHAR (30) := '';
      l_statement   VARCHAR2 (2000) := 'ANALYZE TABLE XXCUST.'||p_tablename||' ESTIMATE STATISTICS SAMPLE 33 PERCENT';
   BEGIN
      debug (lc_routine_name, ' Start.');
      EXECUTE IMMEDIATE l_statement;
      debug (lc_routine_name, ' End.');
   END analyze_table;

   --------------------------------------------------------------------------------------
   -- Procedure to gather the schema statistics on a Schema
   --------------------------------------------------------------------------------------
   PROCEDURE gather_schema_stats      ( p_all_auto_stale     IN         VARCHAR2                 DEFAULT NULL
                                      , p_filter_list        IN         SYS.dbms_stats.objecttab DEFAULT NULL
                                      , p_objects_list            OUT   SYS.dbms_stats.objecttab
                                      )
   IS
      lc_routine_name            VARCHAR2(50)      := 'gather_schema_stats';
   BEGIN

      debug (lc_routine_name, ' Start.');

      SYS.DBMS_STATS.gather_schema_stats    ( ownname            => 'CN'             -- VARCHAR2,
                                            , estimate_percent   => 30               -- NUMBER        DEFAULT      DEFAULT_ESTIMATE_PERCENT,
--                                            , block_sample       =>                -- BOOLEAN       DEFAULT      FALSE,
--                                            , method_opt         =>                -- VARCHAR2      DEFAULT      DEFAULT_METHOD_OPT,
                                            , degree             => 10               -- NUMBER        DEFAULT      DEFAULT_DEGREE_VALUE,
--                                            , granularity        =>                -- VARCHAR2      DEFAULT      DEFAULT_GRANULARITY,
                                            , cascade            => TRUE             -- BOOLEAN       DEFAULT      DEFAULT_CASCADE,
--                                            , stattab            =>                -- VARCHAR2      DEFAULT      null, statid varchar2 default null,
                                            , options            => p_all_auto_stale -- VARCHAR2      DEFAULT      'GATHER',
                                            , objlist            => p_objects_list
--                                            , statown            =>                -- VARCHAR2      DEFAULT      null,
--                                            , no_invalidate      =>                -- BOOLEAN       DEFAULT      to_no_invalidate_type(get_param('NO_INVALIDATE')),
--                                            , gather_temp        =>                -- BOOLEAN       DEFAULT      FALSE,
--                                            , gather_fixed       =>                -- BOOLEAN       DEFAULT      FALSE,
--                                            , stattype           =>                -- VARCHAR2      DEFAULT      'DATA',
--                                            , force              =>                -- BOOLEAN       DEFAULT      FALSE,
                                            , obj_filter_list    => p_filter_list    -- ObjectTab     default      null
                                            );
      debug (lc_routine_name, ' End.');
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END gather_schema_stats;

   ------------------------------------------------------------------------------------------
   -- Gather schema statistics for p_tablename and it's indexes using the DBMS_STAT package
   ------------------------------------------------------------------------------------------
   PROCEDURE gather_table_stats (p_tablename     IN   VARCHAR2
                                ,p_cascade       IN   BOOLEAN   DEFAULT TRUE)
   IS
      lc_routine_name     VARCHAR (30)  := 'gather_table_stats';
      l_owner             VARCHAR2(10)  := 'XXCUST';
      l_tablename         VARCHAR (200) := upper(p_tablename);
   BEGIN
      debug (lc_routine_name, ' Start.');
      SYS.DBMS_STATS.GATHER_TABLE_STATS   ( OWNNAME            => l_owner
                                          , TABNAME            => l_tablename
                                          , ESTIMATE_PERCENT   => 30
                                          , METHOD_OPT         => 'FOR ALL COLUMNS SIZE 1'
                                          , DEGREE             => 4
                                          , CASCADE            => p_cascade
                                          , NO_INVALIDATE      => FALSE);
      debug (lc_routine_name, ' End.');
   END gather_table_stats;

  ------------------------------------------------------------------------------------------
  -- Truncate a table in database and return a boolean for succes or failure
  ------------------------------------------------------------------------------------------
   FUNCTION truncate_table (p_filename   VARCHAR2)    RETURN BOOLEAN
   IS
      lc_routine_name     VARCHAR (30)   := 'truncate_table';
      lv_truncate         VARCHAR2(2000) := 'TRUNCATE TABLE ';
      lv_statement        VARCHAR2(2000);
      lv_error            BOOLEAN        := FALSE;
      lv_success          BOOLEAN        := TRUE;

   BEGIN
      debug (lc_routine_name, ' Start.');
      lv_statement := lv_truncate||p_filename;

      EXECUTE IMMEDIATE lv_statement;
      debug (lc_routine_name, ' End.');
      RETURN lv_success;
   EXCEPTION WHEN OTHERS  THEN
      debug (lc_routine_name,    'ERROR: ' || SQLERRM);
      RETURN lv_error;
   END truncate_table;

   -----------------------------------------------------------------------------
   -- Procedure to write a line in ice info table
   -----------------------------------------------------------------------------
  PROCEDURE api_insert_message_prc (p_error_message IN VARCHAR2,
                                    p_brn_id        IN NUMBER)
   IS
   BEGIN
      xxapi_batch.insert_batch_run_info (p_brn_id               => p_brn_id,
                                         p_bro_description      => SUBSTR(p_error_message,1,2000)
                                        );
  END api_insert_message_prc;


   -----------------------------------------------------------------------------
   -- Procedure to split a line with seperated values
   -----------------------------------------------------------------------------
   FUNCTION ice_split_record_fnc ( p_text              IN VARCHAR2
                                 , p_column_number     IN NUMBER
                                 , p_field_separator   IN VARCHAR2
                                 , p_escape_character  IN VARCHAR2
                                 , p_brn_id            IN NUMBER
                                 ) RETURN VARCHAR2
   IS
      lc_routine_name    CONSTANT       VARCHAR (30)      := 'ice_split_record_fnc';

      l_text                            VARCHAR2(32000);
      l_column_text                     VARCHAR2 (32000)  := NULL;
      l_replace_character               VARCHAR2(10)      := '^/.' ;
      l_escape_character                VARCHAR2(10)      := coalesce(p_escape_character,'\');

      l_count                           NUMBER;
      l_start                           NUMBER            := p_column_number - 1;
      l_end                             NUMBER            := p_column_number;

   BEGIN

      -- replace the escaped characters by unique string
      l_text := REPLACE(p_text,l_escape_character||p_field_separator,l_replace_character );

      -- get the number of columns from the full string
      l_count := LENGTH(l_text) - LENGTH(REPLACE(l_text,p_field_separator,NULL)) + 1;

      -- only get result when the requested column is not beyond the last column
      IF p_column_number <= l_count THEN

         -- get the position of the requested column
         l_count := INSTR (l_text, p_field_separator, 1, p_column_number);

         -- handle first and last column different then middle columns
         CASE
            WHEN l_count = 0 THEN
               -- means it is last field
               l_column_text := SUBSTR (l_text, INSTR (l_text, p_field_separator, -1, 1) + 1);
            WHEN p_column_number = 1 THEN
               -- means it is first field
               l_column_text := SUBSTR (l_text, 1, INSTR (l_text, p_field_separator, 1, 1) - 1);
            ELSE
               -- means other than 1st and last filed
               l_column_text := SUBSTR (l_text, INSTR (l_text, p_field_separator, 1, l_start) + 1,
                                                     (  (INSTR (l_text, p_field_separator, 1, l_end)) -
                                                        (INSTR (l_text, p_field_separator, 1, l_start) + 1  )
                                                     )
                                       );
         END CASE;

         -- put back the escaped character (without the escape)
         l_column_text := REPLACE(l_column_text,l_replace_character,p_field_separator );

         -- remove LF / CR / spaces
         l_column_text := REPLACE(l_column_text,CHR(13),'');
         l_column_text := REPLACE(l_column_text,CHR(10),'');
         l_column_text := LTRIM(l_column_text,' ');
         l_column_text := RTRIM(l_column_text,' ');

      END IF;

      RETURN l_column_text;

   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
         xxapi_utils.api_insert_message_prc (p_error_message      =>    'Exception in '
                                           || gc_package_name
                                           ||'.'
                                           || lc_routine_name
                                           || '--'
                                           || SQLERRM
                                           ,p_brn_id             => p_brn_id);
         RETURN NULL;
   END ice_split_record_fnc;

   FUNCTION ice_split_record_fnc (p_text            IN VARCHAR2
                                 ,p_column_number   IN NUMBER
                                 ,p_field_separator IN VARCHAR2
                                 ,p_brn_id          IN NUMBER)
      RETURN VARCHAR2
   IS
      lc_routine_name     VARCHAR (30)   := 'ice_split_record_fnc';
      lv_column_text      VARCHAR2 (500);
      ln_start            NUMBER         := p_column_number - 1;
      ln_end              NUMBER         := p_column_number;
      ln_count            NUMBER;
   BEGIN
      --
      -- count the number of fields in the string
      --
      ln_count := LENGTH(p_text) - LENGTH(REPLACE(p_text,p_field_separator,NULL)) + 1;

      IF p_column_number <= ln_count THEN

         ln_count := INSTR (p_text, p_field_separator, 1, p_column_number);

         IF ln_count = 0 THEN
            -- means it is last field
            lv_column_text := SUBSTR (p_text, INSTR (p_text, p_field_separator, -1, 1) + 1);

         ELSIF p_column_number = 1 THEN
            -- means it is first field
            lv_column_text := SUBSTR (p_text, 1, INSTR (p_text, p_field_separator, 1, 1) - 1);
         ELSE
            -- means other than 1st and last filed
            lv_column_text :=
               SUBSTR (p_text,
                    INSTR (p_text, p_field_separator, 1, ln_start) + 1,
                    (  (INSTR (p_text, p_field_separator, 1, ln_end))
                     - (INSTR (p_text, p_field_separator, 1, ln_start) + 1)
                    )
                   );
         END IF;

         -- verwijder de eventuele LF en of CR
         lv_column_text := REPLACE(lv_column_text,CHR(13),'');
         lv_column_text := REPLACE(lv_column_text,CHR(10),'');
         lv_column_text := LTRIM(lv_column_text,' ');
         lv_column_text := RTRIM(lv_column_text,' ');

      ELSE
         lv_column_text := NULL;
      END IF;

      RETURN lv_column_text;

   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
         lv_column_text := NULL;
         xxapi_utils.api_insert_message_prc (p_error_message      =>    'Exception in '
                                           || gc_package_name
                                           ||'.'
                                           || lc_routine_name
                                           || '--'
                                           || SQLERRM
                                           ,p_brn_id             => p_brn_id);
         RETURN lv_column_text;
   END ice_split_record_fnc;

   -----------------------------------------------------------------------------
   -- Procedure to delete FND Lookup values in OIC
   -----------------------------------------------------------------------------
   PROCEDURE delete_fnd_lookup_value ( p_lookup_type           IN       VARCHAR2
                                     , p_security_group_id     IN       NUMBER   DEFAULT NULL
                                     , p_view_application_id   IN       NUMBER   DEFAULT NULL
                                     , p_lookup_code           IN       VARCHAR2
                                     , p_error_count               OUT  NUMBER
                                     , p_error_message             OUT  VARCHAR2
                                     )
   IS
      lc_routine_name   VARCHAR (30) := 'delete_fnd_lookup_value';
   BEGIN
      debug (lc_routine_name, ' Start.');

--      apps.fnd_lookup_values_pkg.delete_row ( x_lookup_type         => p_lookup_type
--                                            , x_security_group_id   => p_security_group_id
--                                            , x_view_application_id => p_view_application_id
--                                            , x_lookup_code         => p_lookup_code
--                                            );

      p_error_count := 0;
      p_error_message := NULL;

      debug (lc_routine_name, ' End.');

   EXCEPTION
      WHEN OTHERS THEN
         p_error_count    := 1;
         p_error_message := SQLERRM;
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
   END delete_fnd_lookup_value;

   -----------------------------------------------------------------------------
   -- Procedure to insert FND Lookup values in OIC
   -----------------------------------------------------------------------------
   PROCEDURE insert_fnd_lookup_value ( x_rowid                 IN OUT   ROWID,
                                       p_lookup_type           IN       VARCHAR2,
                                       p_security_group_id     IN       NUMBER   DEFAULT NULL,
                                       p_view_application_id   IN       NUMBER   DEFAULT NULL,
                                       p_lookup_code           IN       VARCHAR2,
                                       p_tag                   IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute_category    IN       VARCHAR2,
                                       p_attribute1            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute2            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute3            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute4            IN       VARCHAR2 DEFAULT NULL,
                                       p_enabled_flag          IN       VARCHAR2 DEFAULT NULL,
                                       p_start_date_active     IN       DATE     DEFAULT NULL,
                                       p_end_date_active       IN       DATE     DEFAULT NULL,
                                       p_territory_code        IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute5            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute6            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute7            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute8            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute9            IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute10           IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute11           IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute12           IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute13           IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute14           IN       VARCHAR2 DEFAULT NULL,
                                       p_attribute15           IN       VARCHAR2 DEFAULT NULL,
                                       p_meaning               IN       VARCHAR2 DEFAULT NULL,
                                       p_description           IN       VARCHAR2 DEFAULT NULL,
                                       p_user_id               IN       NUMBER,
                                       p_error_count           OUT      NUMBER,
                                       p_error_message         OUT      VARCHAR2
                                    )
   IS
      lc_routine_name   VARCHAR (30) := 'insert_fnd_lookup_value';
   BEGIN
      debug (lc_routine_name, ' Start.');

--      apps.fnd_lookup_values_pkg.insert_row  (  x_rowid,
--                                                p_lookup_type,
--                                                p_security_group_id,
--                                                p_view_application_id,
--                                                p_lookup_code,
--                                                p_tag,
--                                                p_attribute_category,
--                                                p_attribute1,
--                                                p_attribute2,
--                                                p_attribute3,
--                                                p_attribute4,
--                                                p_enabled_flag,
--                                                p_start_date_active,
--                                                p_end_date_active,
--                                                p_territory_code,
--                                                p_attribute5,
--                                                p_attribute6,
--                                                p_attribute7,
--                                                p_attribute8,
--                                                p_attribute9,
--                                                p_attribute10,
--                                                p_attribute11,
--                                                p_attribute12,
--                                                p_attribute13,
--                                                p_attribute14,
--                                                p_attribute15,
--                                                p_meaning,
--                                                p_description,
--                                                SYSDATE,
--                                                p_user_id,
--                                                SYSDATE,
--                                                p_user_id,
--                                                0
--                                               );
      p_error_count := 0;
      p_error_message := NULL;

      debug (lc_routine_name, ' End.');

   EXCEPTION
      WHEN OTHERS THEN
         p_error_count := 1;
         p_error_message := SQLERRM;
         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
   END insert_fnd_lookup_value;

   -----------------------------------------------------------------------------
   -- Procedure to update FND Lookup values in OIC
   -----------------------------------------------------------------------------
--   PROCEDURE update_fnd_lookup_value ( p_lookup_type           IN       VARCHAR2,
--                                       p_security_group_id     IN       NUMBER   DEFAULT NULL,
--                                       p_view_application_id   IN       NUMBER   DEFAULT NULL,
--                                       p_lookup_code           IN       VARCHAR2,
--                                       p_tag                   IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute_category    IN       VARCHAR2,
--                                       p_attribute1            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute2            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute3            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute4            IN       VARCHAR2 DEFAULT NULL,
--                                       p_enabled_flag          IN       VARCHAR2 DEFAULT NULL,
--                                       p_start_date_active     IN       DATE     DEFAULT NULL,
--                                       p_end_date_active       IN       DATE     DEFAULT NULL,
--                                       p_territory_code        IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute5            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute6            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute7            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute8            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute9            IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute10           IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute11           IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute12           IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute13           IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute14           IN       VARCHAR2 DEFAULT NULL,
--                                       p_attribute15           IN       VARCHAR2 DEFAULT NULL,
--                                       p_meaning               IN       VARCHAR2 DEFAULT NULL,
--                                       p_description           IN       VARCHAR2 DEFAULT NULL,
--                                       p_user_id               IN       NUMBER,
--                                       p_error_count           OUT      NUMBER,
--                                       p_error_message         OUT      VARCHAR2
--                                      )
--   IS
--      lc_routine_name   VARCHAR (30) := 'update_fnd_lookup_value';
--   BEGIN
--      debug (lc_routine_name, ' Start.');
--
--      apps.fnd_lookup_values_pkg.update_row (p_lookup_type,
--                                             p_security_group_id,
--                                             p_view_application_id,
--                                             p_lookup_code,
--                                             p_tag,
--                                             p_attribute_category,
--                                             p_attribute1,
--                                             p_attribute2,
--                                             p_attribute3,
--                                             p_attribute4,
--                                             p_enabled_flag,
--                                             p_start_date_active,
--                                             p_end_date_active,
--                                             p_territory_code,
--                                             p_attribute5,
--                                             p_attribute6,
--                                             p_attribute7,
--                                             p_attribute8,
--                                             p_attribute9,
--                                             p_attribute10,
--                                             p_attribute11,
--                                             p_attribute12,
--                                             p_attribute13,
--                                             p_attribute14,
--                                             p_attribute15,
--                                             p_meaning,
--                                             p_description,
--                                             SYSDATE,
--                                             p_user_id,
--                                             0
--                                            );
--      p_error_count := 0;
--      p_error_message := NULL;
--
--      debug (lc_routine_name, ' End.');
--
--   EXCEPTION
--      WHEN OTHERS THEN
--         p_error_count := 1;
--         p_error_message := SQLERRM;
--         debug (lc_routine_name,    'ERROR: ' || SQLERRM);
--   END update_fnd_lookup_value;
--
   -----------------------------------------------------------------------------
   -- Procedure Wrapper for populating the temporary table XXICE_DIRECTORY_LISTING
   -- Holding the directory information
   -----------------------------------------------------------------------------
   PROCEDURE populate_dir_list(p_directory in varchar2) is
      language java name 'Bestand.popList( java.lang.String )';

   -----------------------------------------------------------------------------
   -- Procedure to check if a given year (number) is a leap year
   -----------------------------------------------------------------------------
   FUNCTION is_leap_year  ( p_year  IN  NUMBER ) RETURN BOOLEAN
   IS
      lc_routine_name     VARCHAR (30) := 'is_leap_year1';
      l_is_leap_year      VARCHAR2(1)  := 'N';
      l_return            BOOLEAN      := FALSE;
   BEGIN
      debug (lc_routine_name, ' Start.');

      SELECT decode( mod(p_year, 4), 0,
                decode( mod(p_year, 400), 0, 'Y',
                   decode( mod(p_year, 100), 0, 'N', 'Y')
                ), 'N'
             )
      INTO   l_is_leap_year
      FROM   DUAL;

      IF l_is_leap_year = 'Y' THEN l_return := TRUE; END IF;

      debug (lc_routine_name, ' End.');

      RETURN l_return;

   END is_leap_year;

   -----------------------------------------------------------------------------
   -- Procedure to check if a given date is in a leap year
   -----------------------------------------------------------------------------
   FUNCTION is_leap_year  ( p_date  IN  DATE ) RETURN BOOLEAN
   IS
      lc_routine_name     VARCHAR (30) := 'is_leap_year2';
      l_is_leap_year      VARCHAR2(1)  := 'N';
      l_return            BOOLEAN      := FALSE;
      l_year              NUMBER       := 0;
   BEGIN
      debug (lc_routine_name, ' Start.');

      l_year := to_number(to_char(p_date,'YYYY'));

      SELECT decode( mod(l_year, 4), 0,
                decode( mod(l_year, 400), 0, 'Y',
                   decode( mod(l_year, 100), 0, 'N', 'Y')
                ), 'N'
             )
      INTO   l_is_leap_year
      FROM   DUAL;

      IF l_is_leap_year = 'Y' THEN l_return := TRUE; END IF;

      debug (lc_routine_name, ' End.');

      RETURN l_return;

   END is_leap_year;


   ----------------------------------------------------------------------------
   -- Funtion returns the time difference between 2 dates within 1 day
   ----------------------------------------------------------------------------
   FUNCTION get_time_diff   ( p_starttime    IN DATE
                            , p_endtime      IN DATE  DEFAULT NULL )   RETURN VARCHAR2
   IS
      lc_routine_name           VARCHAR2(50)      := 'get_time_diff';
      l_value                   VARCHAR2(10)      := '< 1 sec';
      l_time                    NUMBER            := round ( 86400 * ( coalesce(p_endtime,sysdate) - p_starttime ) );
   BEGIN
      debug (lc_routine_name, ' Start.');
      IF l_time > 0 THEN
         SELECT replace ( trim ( to_char ( to_NUMBER ( trunc ( ( ( l_time ) / 60 ) / 60 ) - 24 * ( trunc ( ( ( ( l_time ) / 60 ) / 60 ) / 24 ) ) ), '00' ) ||
                to_char ( to_NUMBER ( trunc ( ( l_time ) / 60 ) - 60 * ( trunc ( ( ( l_time ) / 60 ) / 60 ) ) ), '00' ) ||
                to_char ( to_NUMBER ( trunc ( l_time ) - 60 * ( trunc ( ( l_time ) / 60 ) ) ), '00' ) ), ' ', ':' )
         INTO   l_value
         FROM   dual;

      END IF;

      debug (lc_routine_name, ' End.');
      RETURN l_value;
   EXCEPTION
      WHEN OTHERS THEN
         debug (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;

   END get_time_diff;

   -----------------------------------------------------------------------------
   -- Function to return the database name of the current database
   -----------------------------------------------------------------------------
   FUNCTION get_database_name RETURN VARCHAR2
   IS
      lc_routine_name     VARCHAR (30) := 'get_database_name';
      l_db_name           VARCHAR2(240);
   BEGIN
      debug (lc_routine_name, ' Start.');

      if    instr( sys_context('USERENV'   , 'DB_NAME') ,'APXDEV') > 0 then
         l_db_name := 'APXDEV';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXTST') > 0 then
         l_db_name := 'APXTST';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXACC') > 0  then
         l_db_name := 'APXACC';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXPRD') > 0 then
         l_db_name := 'APXPRD';
      end if;        

      debug (lc_routine_name, ' End.');

      RETURN l_db_name;

   END get_database_name;

   -----------------------------------------------------------------------------
   -- Function to return the database name of the current database
   -----------------------------------------------------------------------------
   FUNCTION get_environment_name RETURN VARCHAR2
   IS
      lc_routine_name     VARCHAR (30)   := 'get_environment_name';
      l_instance          VARCHAR2(240);
      l_db_name           VARCHAR2(240);
      l_postfix           VARCHAR2(30)   := ' Environment';
      l_prefix            VARCHAR2(30)   := ' - KPN Picasso ';
   BEGIN
      debug (lc_routine_name, ' Start.');
      if    instr( sys_context('USERENV'   , 'DB_NAME') ,'APXDEV') > 0 then
         l_instance := 'Picasso Development';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXTST') > 0 then
         l_instance := 'Picasso Testing';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXACC') > 0  then
         l_instance := 'Picasso Acceptance';
      elsif instr( sys_context('USERENV', 'DB_NAME') ,'APXPRD') > 0 then
         l_instance := 'Picasso Production';
      end if;  
      debug (lc_routine_name, ' End.');

      RETURN l_instance;

   END get_environment_name;

   -----------------------------------------------------------------------------
   -- Function to return the database name of the current database
   -----------------------------------------------------------------------------
   FUNCTION is_database_prod RETURN BOOLEAN
   IS
      lc_routine_name     VARCHAR (30) := 'is_database_prod';
      l_return            BOOLEAN      := FALSE;
   BEGIN
      debug (lc_routine_name, ' Start.');

      if instr( sys_context('USERENV', 'DB_NAME') ,'APXPRD') > 0 then
      --IF get_database_name = 'D2597P' THEN
         l_return := TRUE;
      END IF;

      debug (lc_routine_name, ' End.');

      RETURN l_return;

   END is_database_prod;

   ----------------------------------------------------------------------------
   -- Procedure to zip a file into the archive folder
   ----------------------------------------------------------------------------
   PROCEDURE write_from_utl_file_to_object_storage      ( p_directory     IN      VARCHAR2
                                                        , p_file_name     IN      VARCHAR2
                                                        )
   IS
     lc_sub_routine_name            VARCHAR2(50)      := 'write_to_object_storage';
     l_blob                         BLOB;
     l_bf                           bfile := bfilename( p_directory , p_file_name);
   BEGIN
      debug (lc_sub_routine_name, ' Start.');
      --
      l_blob := EMPTY_BLOB;
      debug (lc_sub_routine_name, 'Blob initialized as empty blob');
      --
      DBMS_LOB.CREATETEMPORARY (l_blob ,true ,dbms_lob.call);
      debug (lc_sub_routine_name, 'temporary Blob created --dead code below');
      --
      -- add the file to a new zip and save it to archive
--      XXAPI_UTILS_ZIP.add1file   ( l_blob
--                                 , p_file_name
--                                 , XXAPI_UTILS_ZIP.file2blob  ( p_directory
--                                                             , p_file_name )
--                                 );
      dbms_lob.createtemporary ( l_blob ,true);
      dbms_lob.fileopen        ( l_bf   , dbms_lob.file_readonly);
      dbms_lob.loadfromfile    ( l_blob , l_bf   ,dbms_lob.getlength(l_bf));
      dbms_lob.fileclose(l_bf);
      
      debug (lc_sub_routine_name, 'temporary Blob Closed ');        
      --
      save_blob_to_object_store ( p_filename      => p_file_name  
                                , p_file_contents => l_blob
                                );

      DBMS_LOB.freetemporary (l_blob);
      debug (lc_sub_routine_name, 'temporary Blob memory freed  --dead code below');        
      
      --
      --remove the original file after zip
      --xxpm_utils_file.delete_file ( p_file_name       => p_file_name
      --                             , p_directory       => p_directory);
      --UTL_FILE.FREMOVE('DATA_PUMP_DIR',p_file_name);
      
     debug (lc_sub_routine_name, ' End.');
   EXCEPTION
     WHEN OTHERS THEN
        debug (lc_sub_routine_name,    'ERROR: ' || SQLERRM);
        RAISE;
   END write_from_utl_file_to_object_storage;   

   --------------------------------------------------------------------------------------
   -- procedure to flush a file to object store
   --------------------------------------------------------------------------------------
   PROCEDURE save_blob_to_object_store ( p_filename      in VARCHAR2  
                                       , p_file_contents in BLOB
                                       ) IS

      l_response       CLOB;
      l_request_url    VARCHAR2(32000);      
      lc_routine_name  VARCHAR2(50)      := 'save_blob_to_object_store';
      

   BEGIN
      debug (lc_routine_name, ' Start.');

      debug (lc_routine_name, 'filename in' || p_filename);
      debug (lc_routine_name, 'blob in', p_file_contents );      
      
      -- contruct the location based on the lookups
      l_request_url :=  xxapi_batch.get_settings_value('BASE_URL',gc_lookup_type_object_store)   || 
                        xxapi_batch.get_settings_value('OUTPUT_DIR',gc_lookup_type_object_store) ||
                        apex_util.url_encode( p_filename);

      debug (lc_routine_name, 'contructed URL :'  || l_request_url);
      debug (lc_routine_name, 'credentials :'  || xxapi_batch.get_settings_value('CREDENTIAL_STATIC_ID',gc_lookup_type_object_store) );

      --push the file into the object store
      l_response := apex_web_service.make_rest_request(  p_url                   => l_request_url
                                                      ,  p_http_method           => 'PUT'
                                                      ,  p_body_blob             => p_file_contents
                                                      ,  p_credential_static_id  => xxapi_batch.get_settings_value('CREDENTIAL_STATIC_ID',gc_lookup_type_object_store) 
                                                      );

      debug (lc_routine_name, 'response :', l_response );                                                       
      debug (lc_routine_name, ' End.');

   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END save_blob_to_object_store;

  --------------------------------------------------------------------------------------
   -- procedure to flush a file to object store
   --------------------------------------------------------------------------------------
   PROCEDURE save_clob_to_object_store ( p_filename      in VARCHAR2  
                                       , p_file_contents in CLOB
                                       ) IS
      l_contents_blob  BLOB;
      lc_routine_name  VARCHAR2(50)      := 'save_clob_to_object_store ';      
   BEGIN
      debug (lc_routine_name, ' Start.');
      
      -- put the file contents into a blob type  
      l_contents_blob :=  apex_util.clob_to_blob ( p_clob              => p_file_contents
                                                 --, p_charset           => 'AL32UTF8'
                                                 , p_include_bom       => 'N' 
                                                 , p_in_memory         => 'Y'
                                                 , p_free_immediately  => 'Y' 
                                                 );

      save_blob_to_object_store  ( p_filename      =>  p_filename
                                 , p_file_contents =>  l_contents_blob      
                                 ) ;
                           
      debug (lc_routine_name, ' End.');

   EXCEPTION
      WHEN OTHERS THEN
         debug  (lc_routine_name ,    'ERROR: ' || SQLERRM);
         RAISE;
   END save_clob_to_object_store;

END XXAPI_UTILS;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_UTILS" TO "WKSP_XXPM";

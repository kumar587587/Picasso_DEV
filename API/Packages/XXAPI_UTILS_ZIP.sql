--------------------------------------------------------
--  DDL for Package Body XXAPI_UTILS_ZIP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_UTILS_ZIP" 
AS
  /****************************************************************
   *
   *
   * PROGRAM NAME
   *    API010 - XXAPI_UTILS_ZIP
   *
   * DESCRIPTION
   *    Program to zip files on the filesystem based on as_zip
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        28-03-2019  Initial Version
   * Wiljo Bakker        16-09-2024  Rebuild for use in Cloud   
   **************************************************************/

   -- $Id: XXAPI_UTILS_ZIP.pkb,v 1.1 2024/09/20 15:41:52 bakke619 Exp $
   -- $Log: XXAPI_UTILS_ZIP.pkb,v $
   -- Revision 1.1  2024/09/20 15:41:52  bakke619
   -- Initial revision
   --

   c_package_body_version         CONSTANT VARCHAR2(200) := '$Id: XXAPI_UTILS_ZIP.pkb,v 1.1 2024/09/20 15:41:52 bakke619 Exp $';
   gc_package_name                CONSTANT VARCHAR2(200) := 'XXAPI_UTILS_ZIP';

   c_local_file_header            CONSTANT RAW (4)       := HEXTORAW ('504B0304');                                                        -- Local file header signature
   c_end_of_central_directory     CONSTANT RAW (4)       := HEXTORAW ('504B0506');                                                 -- End of central directory signature

   ----------------------------------------------------------------------------
   -- Function to return the body version
   ----------------------------------------------------------------------------
   FUNCTION get_package_body_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN c_package_body_version;
   END get_package_body_version;

   ----------------------------------------------------------------------------
   -- Function to return the spec version
   ----------------------------------------------------------------------------
   FUNCTION get_package_spec_version RETURN VARCHAR2
   IS
   BEGIN
      RETURN c_package_spec_version;
   END get_package_spec_version;
   --
   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug ( p_routine IN VARCHAR2, p_message IN VARCHAR2 ) 
   IS
   BEGIN
      XXAPI_gen_debug_pkg.debug( gc_package_name||'.'||p_routine, rtrim(p_message));
      NULL;
   END debug;       

   ----------------------------------------------------------------------------
   -- Function to cast a blob part into a integer value
   ----------------------------------------------------------------------------
   FUNCTION blob2num    ( p_blob               BLOB
                        , p_len                INTEGER
                        , p_pos                INTEGER ) RETURN NUMBER
   IS
      l_return     NUMBER;
   BEGIN
      l_return      := UTL_RAW.cast_to_binary_integer ( DBMS_LOB.SUBSTR ( p_blob
                                                                        , p_len
                                                                        , p_pos
                                                                        )
                                                      , UTL_RAW.little_endian);

      IF l_return < 0 THEN
         l_return   := l_return + 4294967296;
      END IF;

      RETURN l_return;
   END blob2num;

   ----------------------------------------------------------------------------
   -- Function to cast a raw into a varchar2
   ----------------------------------------------------------------------------
   FUNCTION raw2varchar2 ( p_raw                RAW
                         , p_encoding           VARCHAR2)
      RETURN VARCHAR2 IS
   BEGIN
      RETURN COALESCE ( UTL_I18N.raw_to_char ( p_raw
                                             , p_encoding)
                      , UTL_I18N.raw_to_char ( p_raw
                                             , UTL_I18N.map_charset  ( p_encoding
                                                                     , UTL_I18N.GENERIC_CONTEXT
                                                                     , UTL_I18N.IANA_TO_ORACLE)));
   END raw2varchar2;

   ----------------------------------------------------------------------------
   -- Function to get the little endian (most significant bytes) part.
   ----------------------------------------------------------------------------
   FUNCTION little_endian ( p_big                NUMBER
                          , p_bytes              PLS_INTEGER := 4) RETURN RAW
   IS
      l_big   NUMBER := p_big;
   BEGIN

      IF l_big > 2147483647 THEN
         l_big   := l_big - 4294967296;
      END IF;

      RETURN UTL_RAW.SUBSTR ( UTL_RAW.cast_from_binary_integer ( l_big
                                                               , UTL_RAW.little_endian)
                            , 1
                            , p_bytes);
   END little_endian;

   ----------------------------------------------------------------------------
   -- Function to return a file from filesystem as a BLOB
   ----------------------------------------------------------------------------
   FUNCTION file2blob ( p_directory          VARCHAR2
                      , p_file_name          VARCHAR2 ) RETURN BLOB
   IS
      file_lob    BFILE;
      file_blob   BLOB;
   BEGIN
      file_lob      := BFILENAME ( p_directory
                                 , p_file_name);

      DBMS_LOB.open ( file_lob
                    , DBMS_LOB.file_readonly);

      DBMS_LOB.createtemporary ( file_blob
                               , TRUE);

      DBMS_LOB.loadfromfile ( file_blob
                            , file_lob
                            , DBMS_LOB.lobmaxsize);
      DBMS_LOB.close (file_lob);

      RETURN file_blob;

   EXCEPTION
      WHEN OTHERS THEN
         IF DBMS_LOB.ISOPEN (file_lob) = 1 THEN
            DBMS_LOB.close (file_lob);
         END IF;

         IF DBMS_LOB.istemporary (file_blob) = 1 THEN
            DBMS_LOB.freetemporary (file_blob);
         END IF;

         RAISE;
   END file2blob ;

   ----------------------------------------------------------------------------
   -- Function to return a file listing from a zipped BLOB as an array of CLOB values
   ----------------------------------------------------------------------------
   FUNCTION get_file_list ( p_zipped_blob        BLOB
                          , p_encoding           VARCHAR2 := NULL) RETURN file_list
   IS
      t_ind        INTEGER;
      t_hd_ind     INTEGER;
      t_l_return   FILE_LIST;
      t_encoding   VARCHAR2 (32767);
   BEGIN

      t_ind   := NVL (DBMS_LOB.getlength (p_zipped_blob), 0) - 21;

      LOOP
         EXIT WHEN t_ind < 1
                OR DBMS_LOB.SUBSTR ( p_zipped_blob
                                   , 4
                                   , t_ind) = c_end_of_central_directory;
         t_ind   := t_ind - 1;
      END LOOP;

      IF t_ind <= 0 THEN
         RETURN NULL;
      END IF;

      t_hd_ind      := blob2num  ( p_zipped_blob
                                 , 4
                                 , t_ind + 16)
                       + 1;
      t_l_return    := file_list ();
      t_l_return.EXTEND (blob2num   ( p_zipped_blob
                                    , 2
                                    , t_ind + 10
                                    )
                        );

      FOR i IN 1 .. blob2num( p_zipped_blob, 2, t_ind + 8 ) LOOP

         IF p_encoding IS NULL THEN
            IF UTL_RAW.bit_and( DBMS_LOB.SUBSTR( p_zipped_blob, 1, t_hd_ind + 9 ), HEXTORAW( '08' ) ) = HEXTORAW( '08' ) THEN
               t_encoding := 'AL32UTF8'; -- utf8
            ELSE
               t_encoding := 'US8PC437'; -- IBM codepage 437
            END IF;
         ELSE
            t_encoding := p_encoding;
         END IF;

         t_l_return( i ) := raw2varchar2
                        ( DBMS_LOB.SUBSTR( p_zipped_blob
                                         , blob2num( p_zipped_blob, 2, t_hd_ind + 28 )
                                         , t_hd_ind + 46
                                         )
                        , t_encoding
                        );

         t_hd_ind := t_hd_ind + 46
                   + blob2num( p_zipped_blob, 2, t_hd_ind + 28 )  -- File name length
                   + blob2num( p_zipped_blob, 2, t_hd_ind + 30 )  -- Extra field length
                   + blob2num( p_zipped_blob, 2, t_hd_ind + 32 ); -- File comment length

      END LOOP;

      RETURN t_l_return;
   END get_file_list;

   ----------------------------------------------------------------------------
   -- Function to a file listing from a directory/file  as an array of CLOB values
   ----------------------------------------------------------------------------
   FUNCTION get_file_list  ( p_directory         VARCHAR2
                           , p_zip_file           VARCHAR2
                           , p_encoding           VARCHAR2 := NULL) RETURN file_list
   IS
   BEGIN
      RETURN get_file_list ( file2blob ( p_directory
                                       , p_zip_file)
                           , p_encoding );
   END get_file_list;

   ----------------------------------------------------------------------------
   -- Function to get a file from a BLOB zipfile and return as BLOB
   ----------------------------------------------------------------------------
   FUNCTION get_file ( p_zipped_blob        BLOB
                     , p_file_name          VARCHAR2
                     , p_encoding           VARCHAR2 := NULL) RETURN BLOB
   IS
      t_tmp        BLOB;
      t_ind        INTEGER;
      t_hd_ind     INTEGER;
      t_fl_ind     INTEGER;
      t_encoding   VARCHAR2 (32767);
      l_length        INTEGER;
   BEGIN
      t_ind   := NVL (DBMS_LOB.getlength (p_zipped_blob), 0) - 21;

      LOOP
         EXIT WHEN t_ind < 1
                   OR DBMS_LOB.SUBSTR ( p_zipped_blob
                                      , 4
                                      , t_ind) = c_end_of_central_directory;
         t_ind   := t_ind - 1;
      END LOOP;

      IF t_ind <= 0 THEN
         RETURN NULL;
      END IF;

      t_hd_ind      := blob2num  ( p_zipped_blob
                                 , 4
                                 , t_ind + 16)
                       + 1;

      FOR i IN 1 .. blob2num( p_zipped_blob, 2, t_ind + 8 ) LOOP

         IF p_encoding IS NULL THEN
            IF UTL_RAW.bit_and( DBMS_LOB.SUBSTR( p_zipped_blob, 1, t_hd_ind + 9 ), HEXTORAW( '08' ) ) = HEXTORAW( '08' ) THEN
               t_encoding := 'AL32UTF8'; -- utf8
            ELSE
               t_encoding := 'US8PC437'; -- IBM codepage 437
            END IF;
         ELSE
           t_encoding := p_encoding;
         END IF;

         IF p_file_name = raw2varchar2 ( DBMS_LOB.SUBSTR( p_zipped_blob
                                                         , blob2num( p_zipped_blob, 2, t_hd_ind + 28 )
                                                         , t_hd_ind + 46
                                                         )
                                       , t_encoding
                                       ) THEN
            l_length := blob2num( p_zipped_blob, 4, t_hd_ind + 24 ); -- uncompressed length

            IF l_length = 0 THEN
               IF SUBSTR( p_file_name, -1 ) IN ( '/', '\' ) THEN  -- directory/folder
                  RETURN NULL;
               ELSE -- empty file
                  RETURN EMPTY_BLOB();
               END IF;
            END IF;

            IF DBMS_LOB.SUBSTR( p_zipped_blob, 2, t_hd_ind + 10 ) IN ( HEXTORAW( '0800' )  -- deflate
                                                                    , HEXTORAW( '0900' ) -- deflate64
                                                                    ) THEN
               t_fl_ind := blob2num( p_zipped_blob, 4, t_hd_ind + 42 );
               t_tmp := HEXTORAW( '1F8B0800000000000003' ); -- gzip header

               DBMS_LOB.COPY ( t_tmp
                             , p_zipped_blob
                             , blob2num( p_zipped_blob, 4, t_hd_ind + 20 )
                             , 11
                             , t_fl_ind + 31
                                        + blob2num( p_zipped_blob, 2, t_fl_ind + 27 ) -- File name length
                                        + blob2num( p_zipped_blob, 2, t_fl_ind + 29 ) -- Extra field length
                             );
               DBMS_LOB.append( t_tmp, UTL_RAW.CONCAT( DBMS_LOB.SUBSTR( p_zipped_blob, 4, t_hd_ind + 16 ) -- CRC32
                                                   , little_endian( l_length ) -- uncompressed length
                                                   )
                              );
               RETURN UTL_COMPRESS.lz_uncompress( t_tmp );
            END IF;

            IF DBMS_LOB.SUBSTR( p_zipped_blob, 2, t_hd_ind + 10 ) = HEXTORAW( '0000' ) -- The file is stored (no compression)
            THEN
               t_fl_ind := blob2num( p_zipped_blob, 4, t_hd_ind + 42 );
               DBMS_LOB.createtemporary( t_tmp, TRUE );
               DBMS_LOB.COPY ( t_tmp
                             , p_zipped_blob
                             , l_length
                             , 1
                             , t_fl_ind + 31
                                        + blob2num( p_zipped_blob, 2, t_fl_ind + 27 ) -- File name length
                                        + blob2num( p_zipped_blob, 2, t_fl_ind + 29 ) -- Extra field length
                             );
               RETURN t_tmp;
            END IF;
         END IF;

         t_hd_ind := t_hd_ind
                      + 46
                      + blob2num( p_zipped_blob, 2, t_hd_ind + 28 )  -- File name length
                      + blob2num( p_zipped_blob, 2, t_hd_ind + 30 )  -- Extra field length
                      + blob2num( p_zipped_blob, 2, t_hd_ind + 32 ); -- File comment length
      END LOOP;

      RETURN NULL;

   END get_file;

   ----------------------------------------------------------------------------
   -- Function to get a file from a driectory/zip-file return as a BLOB
   ----------------------------------------------------------------------------
   FUNCTION get_file  ( p_directory          VARCHAR2
                      , p_zip_file           VARCHAR2
                      , p_file_name          VARCHAR2
                      , p_encoding           VARCHAR2 := NULL) RETURN BLOB
   IS
   BEGIN
      RETURN get_file ( file2blob ( p_directory
                                  , p_zip_file)
                      , p_file_name
                      , p_encoding);
   END get_file;

   ----------------------------------------------------------------------------
   -- Procedure to add a single file (as blob) to an existing zip (as blob)
   -- p_name can hold directory structure (fi. dir-name/file-name.txt)
   -- id p_content = null, empty file or folder is added.
   ----------------------------------------------------------------------------
   PROCEDURE add1file ( p_zipped_blob       IN OUT BLOB
                      , p_name                     VARCHAR2
                      , p_content                  BLOB)
   IS
      l_now          DATE;
      l_blob         BLOB;
      l_length       INTEGER;
      l_clen         INTEGER;
      l_crc32        RAW (4) := HEXTORAW ('00000000');
      l_compressed   BOOLEAN := FALSE;
      l_name         RAW (32767);
   BEGIN
      l_now      := SYSDATE;
      l_length   := NVL (DBMS_LOB.getlength (p_content), 0);

      IF l_length > 0 THEN
         l_blob         := UTL_COMPRESS.lz_compress (p_content);
         l_clen         := DBMS_LOB.getlength (l_blob) - 18;
         l_compressed   := l_clen < l_length;
         l_crc32        := DBMS_LOB.SUBSTR   ( l_blob
                                             , 4
                                             , l_clen + 11);
      END IF;

      IF NOT l_compressed THEN
         l_clen   := l_length;
         l_blob   := p_content;
      END IF;

      IF p_zipped_blob IS NULL THEN
         DBMS_LOB.createtemporary ( p_zipped_blob
                                  , TRUE);
      END IF;

      l_name      := UTL_I18N.string_to_raw (p_name, 'AL32UTF8');
      DBMS_LOB.append ( p_zipped_blob
                      , UTL_RAW.CONCAT ( c_local_file_header                                                                        -- Local file header signature
                                       , HEXTORAW ('1400')                                                                                          -- version 2.0
                                       , CASE
                                          WHEN l_name = UTL_I18N.string_to_raw (p_name, 'US8PC437') THEN
                                             HEXTORAW ('0000')                                                                          -- no General purpose bits
                                          ELSE
                                             HEXTORAW ('0008')                                                                 -- set Language encoding flag (EFS)
                                          END
                                       , CASE
                                             WHEN l_compressed THEN
                                                HEXTORAW ('0800')                                                                                       -- deflate
                                             ELSE
                                                HEXTORAW ('0000')                                                                                        -- stored
                                         END
                                       , little_endian (    TO_NUMBER (TO_CHAR ( l_now
                                                                               , 'ss'))
                                                        / 2
                                                      +   TO_NUMBER (TO_CHAR ( l_now
                                                                             , 'mi'))
                                                        * 32
                                                      +   TO_NUMBER (TO_CHAR ( l_now
                                                                             , 'hh24'))
                                                        * 2048
                                                      , 2)                                                                          -- File last modification time
                                       , little_endian (  TO_NUMBER (TO_CHAR (l_now
                                                                             ,'dd'))
                                                      +   TO_NUMBER (TO_CHAR (l_now
                                                                             ,'mm'))
                                                        * 32
                                                      +   (  TO_NUMBER (TO_CHAR (l_now
                                                                                ,'yyyy'))
                                                           - 1980)
                                                        * 512
                                                      , 2)                                                                          -- File last modification date
                                       , l_crc32                                                                                                         -- CRC-32
                                       , little_endian (l_clen)                                                                                 -- compressed size
                                       , little_endian (l_length)                                                                             -- uncompressed size
                                       , little_endian ( UTL_RAW.LENGTH (l_name)
                                                       , 2)                                                                                    -- File name length
                                       , HEXTORAW ('0000')                                                                                   -- Extra field length
                                       , l_name                                                                                                       -- File name
                      ));

      IF l_compressed THEN
         DBMS_LOB.COPY ( p_zipped_blob
                       , l_blob
                       , l_clen
                       , DBMS_LOB.getlength (p_zipped_blob) + 1
                       , 11);                                                                                                                -- compressed content
      ELSIF l_clen > 0 THEN
         DBMS_LOB.COPY ( p_zipped_blob
                       , l_blob
                       , l_clen
                       , DBMS_LOB.getlength (p_zipped_blob) + 1
                       , 1);                                                                                                                          --  content
      END IF;

      IF DBMS_LOB.istemporary (l_blob) = 1 THEN
         DBMS_LOB.freetemporary (l_blob);
      END IF;
   END add1file;

   ----------------------------------------------------------------------------
   -- Procedure to finish the blob as a correct zipped format
   ----------------------------------------------------------------------------
   PROCEDURE finish_zip (p_zipped_blob IN OUT BLOB)
   IS
      l_count               PLS_INTEGER := 0;
      l_offset              INTEGER;
      l_offset_dir_header   INTEGER;
      l_offset_end_header   INTEGER;
      l_comment             RAW (32767) := UTL_RAW.cast_to_raw ('KPN ODIS');
   BEGIN
      l_offset_dir_header   := DBMS_LOB.getlength (p_zipped_blob);
      l_offset              := 1;

      WHILE DBMS_LOB.SUBSTR ( p_zipped_blob
                            , UTL_RAW.LENGTH (c_local_file_header)
                            , l_offset) = c_local_file_header LOOP
         l_count   := l_count + 1;
         DBMS_LOB.append ( p_zipped_blob
                         , UTL_RAW.CONCAT ( HEXTORAW ('504B0102')                                                       -- Central directory file header signature
                                          , HEXTORAW ('1400')                                                                                       -- version 2.0
                                          , DBMS_LOB.SUBSTR ( p_zipped_blob
                                                            , 26
                                                            , l_offset + 4)
                                          , HEXTORAW ('0000')                                                                               -- File comment length
                                          , HEXTORAW ('0000')                                                                     -- Disk number where file starts
                                          , HEXTORAW ('0000')                                                                       -- Internal file attributes =>
                                                                                                                                         --     0000 binary file
                                                                                                                                         --     0100 (ascii)text file
                                          ,  CASE
                                             WHEN DBMS_LOB.SUBSTR (  p_zipped_blob
                                                                  , 1
                                                                  , l_offset
                                                                   + 30
                                                                   + blob2num ( p_zipped_blob
                                                                              , 2
                                                                              , l_offset + 26)
                                                                   - 1) IN ( HEXTORAW ('2F')                                                                 -- /
                                                                           , HEXTORAW ('5C')                                                                 -- \
                                                                                           ) THEN
                                                HEXTORAW ('10000000')                                                                      -- a directory/folder
                                             ELSE
                                                HEXTORAW ('2000B681')                                                                                  -- a file
                                             END                                                                                        -- External file attributes
                                          , little_endian (l_offset - 1)                                                    -- Relative offset of local file header
                                          , DBMS_LOB.SUBSTR ( p_zipped_blob
                                                            , blob2num ( p_zipped_blob
                                                                       , 2
                                                                       , l_offset + 26)
                                                            , l_offset + 30)                                                                          -- File name
                                                                       ));
         l_offset      := l_offset
           + 30
           + blob2num ( p_zipped_blob
                      , 4
                      , l_offset + 18)                                                                                                          -- compressed size
           + blob2num ( p_zipped_blob
                      , 2
                      , l_offset + 26)                                                                                                         -- File name length
           + blob2num ( p_zipped_blob
                      , 2
                      , l_offset + 28);                                                                                                      -- Extra field length
      END LOOP;

      l_offset_end_header   := DBMS_LOB.getlength (p_zipped_blob);
      DBMS_LOB.append ( p_zipped_blob
                      , UTL_RAW.CONCAT ( c_end_of_central_directory                                                           -- End of central directory signature
                                       , HEXTORAW ('0000')                                                                                   -- Number of this disk
                                       , HEXTORAW ('0000')                                                                   -- Disk where central directory starts
                                       , little_endian (l_count
                                                        ,2)                                                     -- Number of central directory records on this disk
                                       , little_endian (l_count
                                                       ,2)                                                             -- Total number of central directory records
                                       , little_endian (l_offset_end_header - l_offset_dir_header)                                     -- Size of central directory
                                       , little_endian (l_offset_dir_header)                  -- Offset of start of central directory, relative to start of archive
                                       , little_endian (NVL (UTL_RAW.LENGTH (l_comment), 0)
                                                       ,2)                                                                               -- ZIP file comment length
                                       , l_comment));
   END finish_zip;

   ----------------------------------------------------------------------------
   -- Procedure to save a blob that is finished to the filesystem
   -- do not forget to run dbms_lob.freetemporary of p_zipped_blob in the calling procedure.
   ----------------------------------------------------------------------------
   PROCEDURE save_zip     ( p_zipped_blob              BLOB
                          , p_directory                VARCHAR2 := 'TEMP'
                          , p_filename                 VARCHAR2 := 'file.zip')
   IS
      lc_routine_name   VARCHAR2(200) := 'save_zip'; 
      l_file_handle    UTL_FILE.file_type;
      l_length         PLS_INTEGER := 32767;
   BEGIN
      debug (lc_routine_name, 'start' );
      debug (lc_routine_name, 'p_directory  = '||p_directory );
      debug (lc_routine_name, 'p_filename   = '||p_filename );
      l_file_handle      :=   UTL_FILE.fopen ( p_directory
                                             , p_filename
                                             , 'wb');

      FOR i IN 0 .. TRUNC ( ( DBMS_LOB.getlength (p_zipped_blob) - 1) / l_length) LOOP
         UTL_FILE.put_raw (l_file_handle
                          ,DBMS_LOB.SUBSTR ( p_zipped_blob
                                           , l_length
                                           , i * l_length + 1));
      END LOOP;

      UTL_FILE.fclose (l_file_handle);
      debug (lc_routine_name, 'end' );
   END save_zip;

   /* to use this package, view some examples below. Package is based on as_zip by A.Scheffer
   declare
     g_zipped_blob blob;
   begin
      as_zip.add1file( g_zipped_blob, 'test4.txt', null ); -- a empty file
      xxice_utils_zip.add1file( g_zipped_blob, 'dir1/test1.txt', utl_raw.cast_to_raw( q'<A file with some more text, stored in a subfolder which isn't added>' ) );
      xxice_utils_zip.add1file( g_zipped_blob, 'test1234.txt', utl_raw.cast_to_raw( 'A small file' ) );
      xxice_utils_zip.add1file( g_zipped_blob, 'dir2/', null ); -- a folder
      xxice_utils_zip.add1file( g_zipped_blob, 'dir3/', null ); -- a folder
      xxice_utils_zip.add1file( g_zipped_blob, 'dir3/test2.txt', utl_raw.cast_to_raw( 'A small filein a previous created folder' ) );
      xxice_utils_zip.finish_zip( g_zipped_blob );
      xxice_utils_zip.save_zip( g_zipped_blob, 'MY_DIR', 'my.zip' );
      dbms_lob.freetemporary( g_zipped_blob );
   end;
   --
   declare
      zip_files xxice_utils_zip.file_list;
   begin
      zip_files  := xxice_utils_zip.get_file_list( 'MY_DIR', 'my.zip' );
      for i in zip_files.first() .. zip_files.last loop
         dbms_output.put_line( zip_files( i ) );
         dbms_output.put_line( utl_raw.cast_to_varchar2( xxice_utils_zip.get_file( 'MY_DIR', 'my.zip', zip_files( i ) ) ) );
      end loop;
   end;
   */

END XXAPI_UTILS_ZIP;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_UTILS_ZIP" TO "WKSP_XXPM";

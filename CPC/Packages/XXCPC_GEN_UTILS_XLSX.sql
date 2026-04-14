--------------------------------------------------------
--  DDL for Package XXCPC_GEN_UTILS_XLSX
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_GEN_UTILS_XLSX" AUTHID CURRENT_USER IS
   /****************************************************************
   *
   * PROGRAM NAME
   *  GENERIC - ICE008 - XXICE_UTILS_XLSX
   *
   * DESCRIPTION
   *   Package to support basic ICE Excel file handling (XLSX Only )
   *   reading and writing based on as_xlsx from Anton Scheffer
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        08-11-2017  Fixed for ODIS use
   * Wiljo Bakker        24-08-2018  Added the functions to create XLSX
   * Wiljo Bakker        12-04-2019  Added number of cols/rows to query2sheet
   * Wiljo Bakker        08-06-2020  Added named ranges / definedNames
   **************************************************************/

   -- $Id: XXICE_UTILS_XLSX.pks,v 1.11 2020/06/29 09:27:10 bakke619 Exp $
   -- $Log: XXICE_UTILS_XLSX.pks,v $
   -- Revision 1.11  2020/06/29 09:27:10  bakke619
   -- ODO-1136 - added set define off command for script
   --
   -- Revision 1.10  2020/06/23 15:30:41  bakke619
   -- ODO-1028 - Added a p_max_rows_read to stop reading the files before end of worksheet is reached
   --
   -- Revision 1.9  2020/06/23 13:45:24  bakke619
   -- ODO-962
   --
   -- Revision 1.4  2019/12/23 11:52:56  bakke619
   -- ODO-861
   --
   -- Revision 1.3  2019/04/12 15:41:36  bakke619
   -- Added number of cols/rows to query2sheet
   --
   -- Revision 1.2  2018/08/24 15:31:53  bakke619
   -- Added options for generating XLSX files
   --
   -- Revision 1.1  2017/11/17 09:51:47  bakke619
   -- Initial revision
   --

   gc_package_name               CONSTANT VARCHAR2(200)                  := 'XXICE_UTILS_XLSX';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXICE_UTILS_XLSX.pks,v 1.11 2020/06/29 09:27:10 bakke619 Exp $';

   gc_date_format                CONSTANT VARCHAR2(25)                   := 'DD-MM-YYYY HH24:MI:SS';

   TYPE T_SINGLE_CELL      IS RECORD   ( sheet_number       NUMBER(10)
                                       , sheet_name         VARCHAR(4000)
                                       , row_number         NUMBER(10)
                                       , column_number      NUMBER(10)
                                       , cell               VARCHAR2(100)
                                       , cell_type          VARCHAR2(100)
                                       , string_value       VARCHAR2(32767)
                                       , number_value       NUMBER
                                       , date_value         DATE
                                       , formula            VARCHAR2(32767)
                                       );

   TYPE T_NAMED_RANGE      IS RECORD   ( range_name         VARCHAR2 ( 1000 )
                                       , range_reference    VARCHAR2 ( 4200 )
                                       , sheet_name         VARCHAR2 ( 4000 )
                                       , named_range        VARCHAR2 ( 200 )
                                       , topLeft            VARCHAR2 ( 200 )
                                       , bottomRight        VARCHAR2 ( 200 )
                                       , topLeftCol         VARCHAR2 ( 200 )
                                       , topLeftRow         VARCHAR2 ( 200 )
                                       , bottomRightCol     VARCHAR2 ( 200 )
                                       , bottomRightRow     VARCHAR2 ( 200 )
                                       );

   TYPE T_NAMED_RANGES     IS TABLE OF T_NAMED_RANGE INDEX BY BINARY_INTEGER;

   TYPE T_SHEET_BOUNDARIES IS RECORD   ( sheet_id           VARCHAR2 ( 32767 )
                                       , sheet_name         VARCHAR2 ( 32767 )
                                       , max_row_number     NUMBER(10)
                                       , max_column_number  NUMBER(10)
                                       );

   TYPE T_WORKSHEET        IS RECORD   ( sheet_id           VARCHAR2 ( 32767 )
                                       , sheet_name         VARCHAR2 ( 32767 )
                                       , max_row_number     NUMBER(20)
                                       , max_column_number  NUMBER(20)
                                       , sheet_contents     XXCPC_VARCHAR_TABLE_TYPE
                                       , named_ranges       T_NAMED_RANGES
                                       );



   TYPE T_ALL_SHEETS    IS TABLE OF T_SHEET_BOUNDARIES INDEX BY BINARY_INTEGER;
   TYPE T_ALL_CELLS     IS TABLE OF T_SINGLE_CELL;
   TYPE T_WORKBOOK      IS TABLE OF T_WORKSHEET        INDEX BY BINARY_INTEGER;

   TYPE tp_alignment       IS RECORD   ( vertical           VARCHAR2 (11)
                                       , horizontal         VARCHAR2 (16)
                                       , wrapText           BOOLEAN
                                       );

   FUNCTION read               ( p_excel_document      BLOB
                               , p_sheets              VARCHAR2 := NULL
                               , p_cell                VARCHAR2 := NULL
                               , p_max_rows_read       NUMBER   := NULL )  RETURN T_WORKBOOK  ;


   FUNCTION file2blob         ( p_dir                    VARCHAR2
                              , p_file_name              VARCHAR2 ) RETURN BLOB ;

   PROCEDURE clear_workbook;


   PROCEDURE new_sheet         ( p_sheetname    VARCHAR2 := NULL
                               , p_tabcolor     VARCHAR2 := NULL -- this is a hex ALPHA Red Green Blue value);
                               );

   FUNCTION OraFmt2Excel       ( p_format       VARCHAR2 := NULL) RETURN VARCHAR2;


   FUNCTION get_numFmt         ( p_format       VARCHAR2 := NULL) RETURN PLS_INTEGER;


   FUNCTION get_font           ( p_name         VARCHAR2
                               , p_family       PLS_INTEGER := 2
                               , p_fontsize     NUMBER      := 11
                               , p_theme        PLS_INTEGER := 1
                               , p_underline    BOOLEAN     := FALSE
                               , p_italic       BOOLEAN     := FALSE
                               , p_bold         BOOLEAN     := FALSE
                               , p_rgb          VARCHAR2    := NULL  )  RETURN PLS_INTEGER;
                                                               -- this p_rgb is a hex ALPHA Red Green Blue value

   FUNCTION get_fill           ( p_patternType  VARCHAR2
                               , p_fgRGB        VARCHAR2 := NULL ) RETURN PLS_INTEGER;
                                                           -- this p_fgRGB is a hex ALPHA Red Green Blue value

   FUNCTION get_border         ( p_top          VARCHAR2   := 'thin'
                               , p_bottom       VARCHAR2   := 'thin'
                               , p_left         VARCHAR2   := 'thin'
                               , p_right        VARCHAR2   := 'thin' ) RETURN PLS_INTEGER;
                                  /* border options:
                                       none
                                       thin
                                       medium
                                       dashed
                                       dotted
                                       thick
                                       double
                                       hair
                                       mediumDashed
                                       dashDot
                                       mediumDashDot
                                       dashDotDot
                                       mediumDashDotDot
                                       slantDashDot
                                  */


   FUNCTION get_alignment      ( p_vertical     VARCHAR2 := NULL
                               , p_horizontal   VARCHAR2 := NULL
                               , p_wrapText     BOOLEAN  := NULL
                               ) RETURN tp_alignment;
                                        /* horizontal options
                                             center
                                             centerContinuous
                                             distributed
                                             fill
                                             general
                                             justify
                                             left
                                             right
                                       */
                                       /* vertical options
                                             bottom
                                             center
                                             distributed
                                             justify
                                             top
                                       */



   PROCEDURE cell              ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_value        NUMBER
                               , p_numFmtId     PLS_INTEGER  := NULL
                               , p_fontId       PLS_INTEGER  := NULL
                               , p_fillId       PLS_INTEGER  := NULL
                               , p_borderId     PLS_INTEGER  := NULL
                               , p_alignment    tp_alignment := NULL
                               , p_sheet        PLS_INTEGER  := NULL);

   PROCEDURE cell              ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_value        VARCHAR2
                               , p_numFmtId     PLS_INTEGER  := NULL
                               , p_fontId       PLS_INTEGER  := NULL
                               , p_fillId       PLS_INTEGER  := NULL
                               , p_borderId     PLS_INTEGER  := NULL
                               , p_alignment    tp_alignment := NULL
                               , p_sheet        PLS_INTEGER  := NULL);

   PROCEDURE cell              ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_value        DATE
                               , p_numFmtId     PLS_INTEGER  := NULL
                               , p_fontId       PLS_INTEGER  := NULL
                               , p_fillId       PLS_INTEGER  := NULL
                               , p_borderId     PLS_INTEGER  := NULL
                               , p_alignment    tp_alignment := NULL
                               , p_sheet        PLS_INTEGER  := NULL);

   PROCEDURE hyperlink         ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_url          VARCHAR2
                               , p_value        VARCHAR2     := NULL
                               , p_sheet        PLS_INTEGER  := NULL);


   PROCEDURE comment           ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_text         VARCHAR2
                               , p_author       VARCHAR2    := NULL
                               , p_width        PLS_INTEGER := 150 -- pixels
                               , p_height       PLS_INTEGER := 100 -- pixels
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE mergecells        ( p_tl_col       PLS_INTEGER -- top left
                               , p_tl_row       PLS_INTEGER
                               , p_br_col       PLS_INTEGER -- bottom right
                               , p_br_row       PLS_INTEGER
                               , p_sheet        PLS_INTEGER := NULL);

   PROCEDURE list_validation   ( p_sqref_col    PLS_INTEGER
                               , p_sqref_row    PLS_INTEGER
                               , p_tl_col       PLS_INTEGER -- top left
                               , p_tl_row       PLS_INTEGER
                               , p_br_col       PLS_INTEGER -- bottom right
                               , p_br_row       PLS_INTEGER
                               , p_style        VARCHAR2    := 'stop' -- stop, warning, information
                               , p_title        VARCHAR2    := NULL
                               , p_prompt       VARCHAR     := NULL
                               , p_show_error   BOOLEAN     := FALSE
                               , p_error_title  VARCHAR2    := NULL
                               , p_error_txt    VARCHAR2    := NULL
                               , p_sheet        PLS_INTEGER := NULL);

   PROCEDURE list_validation   ( p_sqref_col    PLS_INTEGER
                               , p_sqref_row    PLS_INTEGER
                               , p_defined_name VARCHAR2
                               , p_style        VARCHAR2    := 'stop' -- stop, warning, information
                               , p_title        VARCHAR2    := NULL, p_prompt VARCHAR := NULL
                               , p_show_error   BOOLEAN     := FALSE
                               , p_error_title  VARCHAR2    := NULL
                               , p_error_txt    VARCHAR2    := NULL
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE defined_name      ( p_tl_col       PLS_INTEGER -- top left
                               , p_tl_row       PLS_INTEGER
                               , p_br_col       PLS_INTEGER -- bottom right
                               , p_br_row       PLS_INTEGER
                               , p_name         VARCHAR2
                               , p_sheet        PLS_INTEGER := NULL
                               , p_localsheet   PLS_INTEGER := NULL);


   PROCEDURE set_column_width  ( p_col          PLS_INTEGER
                               , p_width        NUMBER
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE set_column        ( p_col          PLS_INTEGER
                               , p_numFmtId     PLS_INTEGER  := NULL
                               , p_fontId       PLS_INTEGER  := NULL
                               , p_fillId       PLS_INTEGER  := NULL
                               , p_borderId     PLS_INTEGER  := NULL
                               , p_alignment    tp_alignment := NULL
                               , p_sheet        PLS_INTEGER  := NULL);

   PROCEDURE set_row           ( p_row          PLS_INTEGER
                               , p_numFmtId     PLS_INTEGER  := NULL
                               , p_fontId       PLS_INTEGER  := NULL
                               , p_fillId       PLS_INTEGER  := NULL
                               , p_borderId     PLS_INTEGER  := NULL
                               , p_alignment    tp_alignment := NULL
                               , p_sheet        PLS_INTEGER  := NULL
                               , p_height       NUMBER       := NULL);


   PROCEDURE freeze_rows       ( p_nr_rows      PLS_INTEGER := 1
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE freeze_cols       ( p_nr_cols      PLS_INTEGER := 1
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE freeze_pane       ( p_col          PLS_INTEGER
                               , p_row          PLS_INTEGER
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE set_autofilter    ( p_column_start PLS_INTEGER := NULL
                               , p_column_end   PLS_INTEGER := NULL
                               , p_row_start    PLS_INTEGER := NULL
                               , p_row_end      PLS_INTEGER := NULL
                               , p_sheet        PLS_INTEGER := NULL);


   PROCEDURE set_tabcolor      ( p_tabcolor     VARCHAR2 -- this is a hex ALPHA Red Green Blue value
                               , p_sheet        PLS_INTEGER := NULL
                               );

   FUNCTION finish RETURN BLOB;


   PROCEDURE save              ( p_directory     VARCHAR2
                               , p_filename      VARCHAR2);


   PROCEDURE query2sheet       ( p_sql              in           VARCHAR2
                               , p_column_headers   in           BOOLEAN     := TRUE
                               , p_directory        in           VARCHAR2    := NULL
                               , p_filename         in           VARCHAR2    := NULL
                               , p_sheet            in           PLS_INTEGER := NULL
                               , p_UseXf            in           BOOLEAN     := FALSE
                               , p_record_count           out    NUMBER
                               , p_column_count           out    NUMBER
                               );

   PROCEDURE setUseXf          ( p_val            BOOLEAN     := TRUE );

--
/* Example how to use the write to excel function
begin
  xxice_utils_xlsx.clear_workbook;
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 5, 1, 5 );
  xxice_utils_xlsx.cell( 3, 1, 3 );
  xxice_utils_xlsx.cell( 2, 2, 45 );
  xxice_utils_xlsx.cell( 3, 2, 'Your Name ', p_alignment => xxice_utils_xlsx.get_alignment( p_wraptext => true ) );
  xxice_utils_xlsx.cell( 1, 4, sysdate, p_fontId => xxice_utils_xlsx.get_font( 'Calibri', p_rgb => 'FFFF0000' ) );
  xxice_utils_xlsx.cell( 2, 4, sysdate, p_numFmtId => xxice_utils_xlsx.get_numFmt( 'dd/mm/yyyy h:mm' ) );
  xxice_utils_xlsx.cell( 3, 4, sysdate, p_numFmtId => xxice_utils_xlsx.get_numFmt( xxice_utils_xlsx.orafmt2excel( 'dd/mon/yyyy' ) ) );
  xxice_utils_xlsx.cell( 5, 5, 75, p_borderId => xxice_utils_xlsx.get_border( 'double', 'double', 'double', 'double' ) );
  xxice_utils_xlsx.cell( 2, 3, 33 );
  xxice_utils_xlsx.hyperlink( 1, 6, 'http://www.kpn.com', 'KPN' );
  xxice_utils_xlsx.cell( 1, 7, 'Some merged cells', p_alignment => xxice_utils_xlsx.get_alignment( p_horizontal => 'center' ) );
  xxice_utils_xlsx.mergecells( 1, 7, 3, 7 );
  for i in 1 .. 5
  loop
    xxice_utils_xlsx.comment( 3, i + 3, 'Row ' || (i+3), 'Name' );
  end loop;
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.set_row( 1, p_fillId => xxice_utils_xlsx.get_fill( 'solid', 'FFFF0000' ) ) ;
  for i in 1 .. 5
  loop
    xxice_utils_xlsx.cell( 1, i, i );
    xxice_utils_xlsx.cell( 2, i, i * 3 );
    xxice_utils_xlsx.cell( 3, i, 'x ' || i * 3 );
  end loop;
  xxice_utils_xlsx.query2sheet( 'select rownum, x.*
, case when mod( rownum, 2 ) = 0 then rownum * 3 end demo
, case when mod( rownum, 2 ) = 1 then ''demo '' || rownum end demo2 from dual x connect by rownum <= 5' );
  xxice_utils_xlsx.save( 'MY_DIR', 'my.xlsx' );
end;
--
begin
  xxice_utils_xlsx.clear_workbook;
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 1, 6, 5 );
  xxice_utils_xlsx.cell( 1, 7, 3 );
  xxice_utils_xlsx.cell( 1, 8, 7 );
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 2, 6, 15, p_sheet => 2 );
  xxice_utils_xlsx.cell( 2, 7, 13, p_sheet => 2 );
  xxice_utils_xlsx.cell( 2, 8, 17, p_sheet => 2 );
  xxice_utils_xlsx.list_validation( 6, 3, 1, 6, 1, 8, p_show_error => true, p_sheet => 1 );
  xxice_utils_xlsx.defined_name( 2, 6, 2, 8, 'Name', 2 );
  xxice_utils_xlsx.list_validation
    ( 6, 1, 'Name'
    , p_style => 'information'
    , p_title => 'valid values are'
    , p_prompt => '13, 15 and 17'
    , p_show_error => true
    , p_error_title => 'Are you sure?'
    , p_error_txt => 'Valid values are: 13, 15 and 17'
    , p_sheet => 1 );
  xxice_utils_xlsx.save( 'MY_DIR', 'my.xlsx' );
end;
--
begin
  xxice_utils_xlsx.clear_workbook;
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 1, 6, 5 );
  xxice_utils_xlsx.cell( 1, 7, 3 );
  xxice_utils_xlsx.cell( 1, 8, 7 );
  xxice_utils_xlsx.set_autofilter( 1,1, p_row_start => 5, p_row_end => 8 );
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 2, 6, 5 );
  xxice_utils_xlsx.cell( 2, 7, 3 );
  xxice_utils_xlsx.cell( 2, 8, 7 );
  xxice_utils_xlsx.set_autofilter( 2,2, p_row_start => 5, p_row_end => 8 );
  xxice_utils_xlsx.save( 'MY_DIR', 'my.xlsx' );
end;
--
begin
  xxice_utils_xlsx.clear_workbook;
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.setUseXf( false );
  for c in 1 .. 10
  loop
    xxice_utils_xlsx.cell( c, 1, 'COL' || c );
    xxice_utils_xlsx.cell( c, 2, 'val' || c );
    xxice_utils_xlsx.cell( c, 3, c );
  end loop;
  xxice_utils_xlsx.freeze_rows( 1 );
  xxice_utils_xlsx.new_sheet;
  for r in 1 .. 10
  loop
    xxice_utils_xlsx.cell( 1, r, 'ROW' || r );
    xxice_utils_xlsx.cell( 2, r, 'val' || r );
    xxice_utils_xlsx.cell( 3, r, r );
  end loop;
  xxice_utils_xlsx.freeze_cols( 3 );
  xxice_utils_xlsx.new_sheet;
  xxice_utils_xlsx.cell( 3, 3, 'Start freeze' );
  xxice_utils_xlsx.freeze_pane( 3,3 );
  xxice_utils_xlsx.save( 'MY_DIR', 'my.xlsx' );
end;
*/

END XXCPC_GEN_UTILS_XLSX;

/

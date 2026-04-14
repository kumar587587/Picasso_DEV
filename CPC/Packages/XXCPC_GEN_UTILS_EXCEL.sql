--------------------------------------------------------
--  DDL for Package XXCPC_GEN_UTILS_EXCEL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCPC"."XXCPC_GEN_UTILS_EXCEL" AUTHID DEFINER
AS

   /****************************************************************
   *
   * PROGRAM NAME
   *  GENERIC - ICE007 - XXICE_UTILS_EXCEL
   *
   * DESCRIPTION
   *   Package to support basic ICE Excel file handling (XLS, Excel 2007 Only)
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Wiljo Bakker        20-04-2016  Initial Version
   **************************************************************/
   --
   -- GLOBAL VARIABLES
   g_user_id                         NUMBER          := -1;
   g_excel_sheet                     XXCPC_VARCHAR_TABLE_TYPE;

   -- GLOBAL VARIABLES
   gc_package_name               CONSTANT VARCHAR2(200)                  := 'XXCPC_GEN_UTILS_EXCEL';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXICE_UTILS_EXCEL.pks,v 1.6 2020/06/23 14:20:41 bakke619 Exp $';
   TYPE G_LINES_TYPE      IS TABLE  OF VARCHAR2(2000)               INDEX BY BINARY_INTEGER;

   PROCEDURE get_xls_size             ( p_directory          IN        VARCHAR2
                                      , p_filename           IN        VARCHAR2
                                      , p_rows                   OUT   NUMBER
                                      , p_columns                OUT   NUMBER   );

   FUNCTION get_xls_data              ( p_directory          IN        VARCHAR2
                                      , p_filename           IN        VARCHAR2 ) RETURN XXCPC_VARCHAR_TABLE_TYPE;

   FUNCTION get_xls_as_csv            ( p_directory          IN        VARCHAR2
                                      , p_filename           IN        VARCHAR2
                                      , p_seperator          IN        VARCHAR2 ) RETURN G_LINES_TYPE;

   FUNCTION get_xlsx_sheet_as_csv     ( p_sheet              IN        XXCPC_VARCHAR_TABLE_TYPE
                                      --, p_filename           IN        VARCHAR2
                                      , p_sheetname          IN        VARCHAR2
                                      , p_seperator          IN        VARCHAR2
                                      , p_max_lines          IN        NUMBER    DEFAULT NULL) RETURN G_LINES_TYPE;

   FUNCTION get_xlsx_as_csv          ( p_directory          IN         VARCHAR2
                                     , p_filename           IN         VARCHAR2
                                     , p_seperator          IN         VARCHAR2
                                     , p_max_lines          IN         NUMBER    DEFAULT NULL ) RETURN G_LINES_TYPE;

   FUNCTION get_xlsx_as_csv          ( p_workbook           IN         XXCPC_GEN_UTILS_XLSX.T_WORKBOOK
                                     , p_filename           IN         VARCHAR2
                                     , p_seperator          IN         VARCHAR2
                                     , p_max_lines          IN         NUMBER    DEFAULT NULL) RETURN G_LINES_TYPE;

   FUNCTION get_xlsx_single_cell     ( p_excel_blob         IN         BLOB      DEFAULT NULL
                                     , p_sheet              IN         VARCHAR2
                                     , p_cell               IN         VARCHAR2 ) RETURN VARCHAR2 ;

END XXCPC_GEN_UTILS_EXCEL;

/

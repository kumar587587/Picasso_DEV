--------------------------------------------------------
--  DDL for View XXCT_REPORT_BUTTONS_1600_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT_BUTTONS_1600_V" ("REPORT1_BUTTON", "REPORT2_BUTTON", "REPORT3_BUTTON", "REPORT4_BUTTON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT /* Used for calling page 111 from page 110*/
  q'~<input id="P110_REPORT1" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Product regels"/>~'                                                             REPORT1_BUTTON,  
  q'~<input id="P110_REPORT2" onclick="apex.navigation.redirect('/ords/r/ct/xxct/111?~'||/* Used for calling page 111 from page 110*/'p111_called_from_page='||'PAGE_110\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Open dossiers"/>~'     REPORT2_BUTTON,  
  q'~<input id="P110_REPORT3" onclick="apex.navigation.redirect('/ords/r/ct/xxct/113?~'||/* Used for calling page 113 from page 110*/'p113_called_from_page='||'PAGE_110\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON,  
  q'~<input id="P110_REPORT4" onclick="apex.navigation.redirect('/ords/r/ct/xxct/114?~'||/* Used for calling page 114 from page 110*/'p113_called_from_page='||'PAGE_110\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Transpost totaal"/>~'  REPORT4_BUTTON
  from dual
  where 1=1
  and nv('APP_PAGE_ID') = '110'
union
--/* Section for page 111 */
  SELECT /*used when page 110 is called from page 111 */
  q'~<input id="P111_REPORT1" onclick="apex.navigation.redirect('/ords/r/ct/xxct/110?~'||/* Used for calling page 110 from page 111*/'p110_called_from_page='||'PAGE_111\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Product regels"/>~'    REPORT1_BUTTON,
  q'~<input id="P111_REPORT2" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Open dossiers"/>~'                                                           REPORT2_BUTTON,
  q'~<input id="P111_REPORT3" onclick="apex.navigation.redirect('/ords/r/ct/xxct/113?~'||/* Used for calling page 113 from page 111*/'p113_called_from_page='||'PAGE_111\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON,
  q'~<input id="P114_REPORT4" onclick="apex.navigation.redirect('/ords/r/ct/xxct/114?~'||/* Used for calling page 114 from page 111*/'p114_called_from_page='||'PAGE_111\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Transpost totaal"/>~'  REPORT4_BUTTON
  from dual
  where 1=1
  and nv('APP_PAGE_ID') = '111'
  union
/* Section for page 113 */
  select /*used when page 110 is called from page 113 */
  q'~<input id="P113_REPORT1" onclick="apex.navigation.redirect('/ords/r/ct/xxct/110?~'||/* Used for calling page 110 from page 113*/'p110_called_from_page='||'PAGE_113\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Product regels"/>~'   REPORT1_BUTTON,
  q'~<input id="P113_REPORT2" onclick="apex.navigation.redirect('/ords/r/ct/xxct/111?~'||/* Used for calling page 111 from page 113*/'p111_called_from_page='||'PAGE_113\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Open dossiers"/>~'    REPORT2_BUTTON,
  q'~<input id="P113_REPORT3" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Gesloten dossiers"/>~'                                                     REPORT3_BUTTON,
  q'~<input id="P113_REPORT4" onclick="apex.navigation.redirect('/ords/r/ct/xxct/114?~'||/* Used for calling page 114 from page 113*/'p114_called_from_page='||'PAGE_113\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Transpost totaal"/>~' REPORT4_BUTTON
  from dual
  where 1=1
  and nv('APP_PAGE_ID') = '113'
------
union
  /* Section for page 114 */
  SELECT
  q'~<input id="P114_REPORT1" onclick="apex.navigation.redirect('/ords/r/ct/xxct/110?~'||/* Used for calling page 110 from page 114*/'p110_called_from_page='||'PAGE_114\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Product regels"/>~'    REPORT1_BUTTON,
  q'~<input id="P114_REPORT2" onclick="apex.navigation.redirect('/ords/r/ct/xxct/111?~'||/* Used for calling page 111 from page 114*/'p111_called_from_page='||'PAGE_114\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Open dossiers"/>~'     REPORT2_BUTTON,
  q'~<input id="P113_REPORT3" onclick="apex.navigation.redirect('/ords/r/ct/xxct/113?~'||/* Used for calling page 113 from page 114*/'p111_called_from_page='||'PAGE_114\u0026session='||v('APP_SESSION')||q'~');" type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON,
  q'~<input id="P114_REPORT4"  style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Transpost totaal"/>~'                                                      REPORT4_BUTTON
from dual
where 1=1
and nv('APP_PAGE_ID') = '114'
;

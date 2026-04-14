--------------------------------------------------------
--  DDL for View XXCT_REPORT_BUTTONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REPORT_BUTTONS_V" ("REPORT1_BUTTON", "REPORT2_BUTTON", "REPORT3_BUTTON", "REPORT4_BUTTON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  q'~<input id="P110_REPORT1" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Product regels"/>~' REPORT1_BUTTON
,       q'~<input id="P110_REPORT2"    onclick="apex.navigation.redirect('f?p=100:111:0::NO:RP,111:~'||
           -- Parameter section
           'P111_CALLED_FROM_PAGE'||
           ',P111_FUND'||
           ',P111_PAYMENT'||
           ',P111_CREDIT'||
           ',P111_CATEGORY_ID'||
           ',P111_CRS'||
           ',P111_RESOURCE_ID'||
           ',P111_YEAR'||
           ',P111_AMOUNT_FROM'||
           ',P111_AMOUNT_TO'||
           -- Value section
           ':PAGE_110'||
           ','||v('P110_FUND')||
           ','||v('P110_PAYMENT')||
           ','||v('P110_CREDIT')||
           ','||v('P110_CATEGORY_ID')||
           ','||v('P110_CRS')||
           ','||v('P110_RESOURCE_ID')||
           ','||v('P110_YEAR')||
           ','||v('P110_AMOUNT_FROM')||
           ','||v('P110_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Open dossiers"/>~' REPORT2_BUTTON
,       q'~<input id="P110_REPORT3"    onclick="apex.navigation.redirect('f?p=100:113:0::NO:RP,113:~'||
           -- Parameter section
           'P113_CALLED_FROM_PAGE'||
           ',P113_CATEGORY_ID'||
           ',P113_CRS'||
           ',P113_RESOURCE_ID'||
           ',P113_YEAR'||
           ',P113_START_DATE'||
           ',P113_AMOUNT_FROM'||
           ',P113_END_DATE'||
           ',P113_AMOUNT_TO'||
           -- Value section
           ':PAGE_110'||
           ','||v('P110_CATEGORY_ID')||
           ','||v('P110_CRS')||
           ','||v('P110_RESOURCE_ID')||
           ','||v('P110_YEAR')||
           ','||v('P110_START_DATE')||
           ','||v('P110_AMOUNT_FROM')||
           ','||v('P110_END_DATE')||
           ','||v('P110_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON
,       q'~<input id="P110_REPORT4"    onclick="apex.navigation.redirect('f?p=100:114:0::NO:RP,114:~'||
           -- Parameter section
           -- Value section
           ':PAGE_110'||
           ','||
           q'~');"   type="button" value="Transpost totaal"/>~' REPORT4_BUTTON
from dual
where 1=1
and nv('APP_PAGE_ID') = '110'
--and '1' = apps.xxice_debug_pkg.debug('XXCT_REPORT_BUTTONS_V','For page 110')
union
--/* Section for page 111 */
select    q'~<input id="P111_REPORT1"    onclick="apex.navigation.redirect('f?p=100:110:0::NO:RP,110:~'||
           -- Parameter section
           'P110_CALLED_FROM_PAGE'||
           ',P110_CATEGORY_ID'||
           ',P110_CRS'||
           ',P110_RESOURCE_ID'||
           ',P110_YEAR'||
           ',P110_AMOUNT_FROM'||
           ',P110_AMOUNT_TO'||
           -- Value section
           ':PAGE_111'||
           ','||v('P111_CATEGORY_ID')||
           ','||v('P111_CRS')||
           ','||v('P111_RESOURCE_ID')||
           ','||v('P111_YEAR')||
           ','||v('P111_AMOUNT_FROM')||
           ','||v('P111_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Product regels"/>~' REPORT1_BUTTON
,       q'~<input id="P111_REPORT2"  style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Open dossiers"/>~' REPORT2_BUTTON
,       q'~<input id="P113_REPORT2"    onclick="apex.navigation.redirect('f?p=100:113:0::NO:RP,113:~'||
           -- Parameter section
           'P113_CALLED_FROM_PAGE'||
           ',P113_CATEGORY_ID'||
           ',P113_CRS'||
           ',P113_RESOURCE_ID'||
           ',P113_YEAR'||
           ',P113_START_DATE'||
           ',P113_AMOUNT_FROM'||
           ',P113_END_DATE'||
           ',P113_AMOUNT_TO'||
           -- Value section
           ':PAGE_111'||
           ','||v('P111_CATEGORY_ID')||
           ','||v('P111_CRS')||
           ','||v('P111_RESOURCE_ID')||
           ','||v('P111_YEAR')||
           ','||v('P111_START_DATE')||
           ','||v('P111_AMOUNT_FROM')||
           ','||v('P111_END_DATE')||
           ','||v('P111_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON
,       q'~<input id="P114_REPORT4"    onclick="apex.navigation.redirect('f?p=100:114:0::NO:RP,114:~'||
           -- Parameter section
           'P114_CALLED_FROM_PAGE'||
           ':PAGE_111'||
           q'~');"   type="button" value="Transpost totaal"/>~' REPORT4_BUTTON
from dual
where 1=1
and nv('APP_PAGE_ID') = '111'
union
/* Section for page 113 */
select  --q'~<input id="P110_REPORT1" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Product regels"/>~' REPORT1_BUTTON
       q'~<input id="P113_REPORT1"    onclick="apex.navigation.redirect('f?p=100:110:0::NO:RP,110:~'||
           -- Parameter section
           'P110_CALLED_FROM_PAGE'||
           ',P110_FUND'||
           ',P110_PAYMENT'||
           ',P110_CREDIT'||
           ',P110_CATEGORY_ID'||
           ',P110_CRS'||
           ',P110_RESOURCE_ID'||
           ',P110_YEAR'||
           ',P110_START_DATE'||
           ',P110_AMOUNT_FROM'||
           ',P110_END_DATE'||
           ',P110_AMOUNT_TO'||
           -- Value section
           ':PAGE_113'||
           ','||v('P113_FUND')||
           ','||v('P113_PAYMENT')||
           ','||v('P113_CREDIT')||
           ','||v('P113_CATEGORY_ID')||
           ','||v('P113_CRS')||
           ','||v('P113_RESOURCE_ID')||
           ','||v('P113_YEAR')||
           ','||v('P113_START_DATE')||
           ','||v('P113_AMOUNT_FROM')||
           ','||v('P113_END_DATE')||
           ','||v('P113_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Product regels"/>~' REPORT1_BUTTON
,       q'~<input id="P113_REPORT2"    onclick="apex.navigation.redirect('f?p=100:111:0::NO:RP,111:~'||
           -- Parameter section
           'P111_CALLED_FROM_PAGE'||
           ',P111_FUND'||
           ',P111_PAYMENT'||
           ',P111_CREDIT'||
           ',P111_CATEGORY_ID'||
           ',P111_CRS'||
           ',P111_RESOURCE_ID'||
           ',P111_YEAR'||
           ',P111_AMOUNT_FROM'||
           ',P111_AMOUNT_TO'||
           -- Value section
           ':PAGE_113'||
           ','||v('P113_FUND')||
           ','||v('P113_PAYMENT')||
           ','||v('P113_CREDIT')||
           ','||v('P113_CATEGORY_ID')||
           ','||v('P113_CRS')||
           ','||v('P113_RESOURCE_ID')||
           ','||v('P113_YEAR')||
           ','||v('P113_AMOUNT_FROM')||
           ','||v('P113_AMOUNT_TO')||
           ','||
           q'~');"   type="button" value="Open dossiers"/>~' REPORT2_BUTTON
,       q'~<input id="P113_REPORT3"  style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON
,       q'~<input id="P113_REPORT4"    onclick="apex.navigation.redirect('f?p=100:114:0::NO:RP,114:~'||
           -- Parameter section
           'P114_CALLED_FROM_PAGE'||
           -- Value section
           ':PAGE_113'||
           ','||
           q'~');"   type="button" value="Transpost totaal"/>~' REPORT4_BUTTON
from dual
where 1=1
and nv('APP_PAGE_ID') = '113'
------
union
/* Section for page 114 */
select  --q'~<input id="P110_REPORT1" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Product regels"/>~' REPORT1_BUTTON
       q'~<input id="P114_REPORT1"    onclick="apex.navigation.redirect('f?p=100:110:0::NO:RP,110:~'||
           -- Parameter section
           'P110_CALLED_FROM_PAGE'||
           -- Value section
           ':PAGE_114'||
           ','||
           q'~');"   type="button" value="Product regels"/>~' REPORT1_BUTTON
,       q'~<input id="P111_REPORT2"    onclick="apex.navigation.redirect('f?p=100:111:0::NO:RP,111:~'||
           -- Parameter section
           'P111_CALLED_FROM_PAGE'||
           -- Value section
           ':PAGE_114'||
           ','||
           q'~');"   type="button" value="Open dossiers"/>~' REPORT2_BUTTON
,       q'~<input id="P113_REPORT3"    onclick="apex.navigation.redirect('f?p=100:113:0::NO:RP,113:~'||
           -- Parameter section
           'P113_CALLED_FROM_PAGE'||
           -- Value section
           ':PAGE_114'||
           ','||
           q'~');"   type="button" value="Gesloten dossiers"/>~' REPORT3_BUTTON
,       q'~<input id="P114_REPORT4"  style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5"  onclick="void(0);"   type="button" value="Transpost totaal"/>~' REPORT4_BUTTON
from dual
where 1=1
and nv('APP_PAGE_ID') = '114';

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REPORT_BUTTONS_V"  IS '$Id: vw_XXCT_REPORT_BUTTONS_V.sql,v 1.6 2019/02/12 09:29:12 rikke493 Exp $'
;

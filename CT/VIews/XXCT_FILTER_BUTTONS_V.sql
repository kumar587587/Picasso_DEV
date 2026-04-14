--------------------------------------------------------
--  DDL for View XXCT_FILTER_BUTTONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_FILTER_BUTTONS_V" ("ALL_BUTTON", "OPEN_BUTTON", "CONTROLE_BUTTON", "PROCURATIE_BUTTON", "INVOICING_BUTTON", "INVOICING_BUTTON_FD", "CLOSED_BUTTON", "CLOSED_BUTTON_FD", "REJECTED_BUTTON", "REOPENED_BUTTON", "ALL_ACTIVE_BUTTON", "OPEN_ACTIVE_BUTTON", "CONTROLE_ACTIVE_BUTTON", "PROCURATIE_ACTIVE_BUTTON", "INVOICING_ACTIVE_BUTTON", "INVOICING_ACTIVE_FD_BUTTON", "CLOSED_ACTIVE_BUTTON", "CLOSED_ACTIVE_FD_BUTTON", "REJECTED_ACTIVE_BUTTON", "REOPENED_ACTIVE_BUTTON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  q'~<input id="P101_ALL"          onclick="void(0);"   type="button" value="Alle (~'||nvl(v('P101_ALL_COUNT'),0)||')"/>' ALL_BUTTON
,       q'~<input id="P101_OPEN"         onclick="void(0);"   type="button" value="Open (~'||nvl(v('P101_OPEN_COUNT'),0)||')"/>' OPEN_BUTTON
,       q'~<input id="P101_CONTROLE"     onclick="void(0);"   type="button" value="Controle (~'||nvl(v('P101_CONTROLE_COUNT'),0)||')"/>' CONTROLE_BUTTON
,       q'~<input id="P101_PROCURATION"  onclick="void(0);"   type="button" value="Procuratie (~'||nvl(v('P101_PROCURATION_COUNT'),0)||')"/>' PROCURATIE_BUTTON
,       q'~<input id="P101_INVOICING"    onclick="void(0);"   type="button" value="Facturatie (~'||nvl(v('P101_INVOICING_COUNT'),0)||')"/>' INVOICING_BUTTON
,       q'~<input id="P101_INVOICING_FD" onclick="void(0);"   type="button" value="Facturatie (~'||nvl(v('P101_INVOICING_COUNT'),0)||')"/>' INVOICING_BUTTON_FD
,       q'~<input id="P101_CLOSED"       onclick="void(0);"   type="button" value="Afgesloten (~'||nvl(v('P101_CLOSED_COUNT'),0)||')"/>' CLOSED_BUTTON
,       q'~<input id="P101_CLOSED_FD"    onclick="void(0);"   type="button" value="Afgesloten (~'||nvl(v('P101_CLOSED_COUNT'),0)||')"/>' CLOSED_BUTTON_FD
,       q'~<input id="P101_REJECTED"     onclick="void(0);"   type="button" value="Afgekeurd (~'||nvl(v('P101_REJECTED_COUNT'),0)||')"/>' REJECTED_BUTTON
,       q'~<input id="P101_REOPENED"     onclick="void(0);"   type="button" value="Heropend (~'||nvl(v('P101_REOPEND_COUNT'),0)||')"/>' REOPENED_BUTTON
--
,       q'~<input id="P101_ALL_ACTIVE"          style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Alle (~'||nvl(v('P101_ALL_COUNT'),0)||')"/>' ALL_ACTIVE_BUTTON
,       q'~<input id="P101_OPEN_ACTIVE"         style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Open (~'||nvl(v('P101_OPEN_COUNT'),0)||')"/>' OPEN_ACTIVE_BUTTON
,       q'~<input id="P101_CONTROLE_ACTIVE"     style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Controle (~'||nvl(v('P101_CONTROLE_COUNT'),0)||')"/>' CONTROLE_ACTIVE_BUTTON
,       q'~<input id="P101_PROCURATION_ACTIVE"  style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Procuratie (~'||nvl(v('P101_PROCURATION_COUNT'),0)||')"/>' PROCURATIE_ACTIVE_BUTTON
,       q'~<input id="P101_INVOICING_ACTIVE"    style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Facturatie (~'||nvl(v('P101_INVOICING_COUNT'),0)||')"/>' INVOICING_ACTIVE_BUTTON
,       q'~<input id="P101_INVOICING_ACTIVE_FD" style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Facturatie (~'||nvl(v('P101_INVOICING_COUNT'),0)||')"/>' INVOICING_ACTIVE_FD_BUTTON
,       q'~<input id="P101_CLOSED_ACTIVE"       style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Afgesloten (~'||nvl(v('P101_CLOSED_COUNT'),0)||')"/>' CLOSED_ACTIVE_BUTTON
,       q'~<input id="P101_CLOSED_ACTIVE_FD"    style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Afgesloten (~'||nvl(v('P101_CLOSED_COUNT'),0)||')"/>' CLOSED_ACTIVE_FD_BUTTON
,       q'~<input id="P101_REJECTED_ACTIVE"     style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Afgekeurd (~'||nvl(v('P101_REJECTED_COUNT'),0)||')"/>' REJECTED_ACTIVE_BUTTON
,       q'~<input id="P101_REOPENED_ACTIVE"     style="FONT-WEIGHT: bold; DISPLAY: table-cell; BACKGROUND-COLOR: #b0cce5" onclick="void(0);" type="button" value="Heropend (~'||nvl(v('P101_REOPEND_COUNT'),0)||')"/>' REOPENED_ACTIVE_BUTTON
from dual;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_FILTER_BUTTONS_V"  IS '$Id: vw_XXCT_FILTER_BUTTONS_V.sql,v 1.3 2019/03/20 11:56:07 rikke493 Exp $'
;

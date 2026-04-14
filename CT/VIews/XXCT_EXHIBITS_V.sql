--------------------------------------------------------
--  DDL for View XXCT_EXHIBITS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_EXHIBITS_V" ("FILE_ID", "DOSSIER_ID", "EXHIBIT", "EXHIBIT_DATE", "REMARKS", "COPY_PARTNER", "LINK1", "FILE_DATA", "FILE_CONTENT_TYPE", "LAST_UPDATE_DATE", "ORACLE_CHARSET") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select file_id
,      dossier_id
,      file_name exhibit
,      creation_date exhibit_date
,      remarks
,      decode(copy_partner,'Y','Ja','Nee') copy_partner
,      '<img src="https://odis-dev.kpnnl.local/apex_images/menu/pencil16x16.gif" id="FILE_IMAGE_ID_'||trim(to_char(file_id))||'"width="12" height="12" onclick="{gotoUploadPage('||trim(to_char(file_id))||');}" />' link1
,      file_data
,      file_content_type
,      last_update_date
,      oracle_charset
from  xxct_exhibits;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_EXHIBITS_V"  IS '$Id: vw_XXCT_EXHIBITS_V.sql,v 1.1 2018/12/05 15:18:12 rikke493 Exp $'
;

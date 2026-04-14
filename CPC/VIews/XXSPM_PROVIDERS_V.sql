--------------------------------------------------------
--  DDL for View XXSPM_PROVIDERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PROVIDERS_V" ("PROVIDERNAME", "DETAILSONSPEC", "HIDEFLAG", "STARTDATE", "ENDDATE", "SEQUENCENO", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT providername               providername
,      detailsonspec              detailsonspec
,      hideflag                   hideflag
,      startdate                  startdate
,      enddate                    enddate
,      ltrim(to_char(sequencenr)) sequenceno    
,      greatest(updated, created) last_update_or_creation_date
FROM xxcpc_providers
;

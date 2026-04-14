--------------------------------------------------------
--  DDL for View XXSPM_CHANNELINFORMATION_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CHANNELINFORMATION_V" ("NAME", "DESCRIPTION", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT channelname       name
,      channelname       description
,      greatest(updated, created) last_update_or_creation_date
FROM xxcpc_channels 
ORDER BY 1
;

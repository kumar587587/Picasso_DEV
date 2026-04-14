--------------------------------------------------------
--  DDL for View XXSPM_CHANNELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CHANNELS_V" ("CHANNELNAME", "HIDEFLAG", "STARTDATE", "ENDDATE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT channelname                   channelname  
,      hideflag                      hideflag
,      startdate                     startdate
,      enddate                       enddate  
,      greatest(updated, created)    last_update_or_creation_date
FROM xxcpc_channels
;

--------------------------------------------------------
--  DDL for View XXHSH_CHANNELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_CHANNELS_V" ("CHANNELNAME", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(channelname)
,      startdate
,     '['||concat('"'||upper(channelname)||'",'
,          concat('"'||hideflag||'",'
,              concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
,                 decode(enddate             ,NULL,'null','"'||to_char(enddate,'YYYY-MM-DD')            ||'T00:00:00"')
                     )
                 )
                ) ||']'
concatenated_values  
  ,      '['||concat('"'||channelname||'",' 
  ,      decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"'))||']' concatenated_pk
FROM xxspm_channels_v	
--ORDER BY nlssort(UPPER(channelname),'NLS_SORT=GENERIC_M')
--ORDER BY nlssort(UPPER(channelname),'NLS_SORT=GERMAN')
--ORDER BY nlssort(UPPER(channelname),'NLS_SORT=FRENCH')
--ORDER BY nlssort(UPPER(channelname),'NLS_SORT=WEST_EUROPEAN')
--ORDER BY nlssort(UPPER(replace( channelname, '-','Z')),'NLS_SORT=DUTCH')
ORDER BY upper(channelname)
,      startdate
;

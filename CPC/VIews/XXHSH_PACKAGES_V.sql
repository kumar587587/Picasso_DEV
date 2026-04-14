--------------------------------------------------------
--  DDL for View XXHSH_PACKAGES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_PACKAGES_V" ("PACKAGENAME", "STARTDATE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT packagename
  , startdate
  , '['||concat('"'||packagename||'",'
  , concat(decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  , concat(decode(enddate             ,NULL,'null','"'||to_char(enddate  ,'YYYY-MM-DD')          ||'T00:00:00"')||','
  , concat('"'||hideflag||'",'
  , '"'||sequenceno||'"')))) ||']' concatenated_values  
  , '['||concat('"'||packagename||'",'
  , decode(startdate           ,NULL,'null','"'||to_char(startdate,'YYYY-MM-DD')          ||'T00:00:00"'))||']'
FROM xxspm_packages_v
ORDER BY packagename,startdate
;

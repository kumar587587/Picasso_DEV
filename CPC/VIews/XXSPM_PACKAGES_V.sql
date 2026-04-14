--------------------------------------------------------
--  DDL for View XXSPM_PACKAGES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PACKAGES_V" ("PACKAGENAME", "STARTDATE", "ENDDATE", "HIDEFLAG", "SEQUENCENO", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT DISTINCT upper(packagename)   packagename
,      startdate                     startdate 
,      enddate                       enddate              
,      hideflag                      hideflag 
,      to_char(sequencenr)           sequenceno
,      greatest(updated, created)    last_update_or_creation_date
FROM  xxcpc_packages    
--WHERE id > 0 /* but we also need special packages.......???? withou this the synchronisation procedure will delete specialpackages in varicent because they cannot be found in this view*/
ORDER BY 1
;

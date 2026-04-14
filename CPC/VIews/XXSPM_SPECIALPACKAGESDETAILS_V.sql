--------------------------------------------------------
--  DDL for View XXSPM_SPECIALPACKAGESDETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_SPECIALPACKAGESDETAILS_V" ("SPECIALPACKAGENAME", "PACKAGENAME", "OPERATION", "STARTDATE", "ENDDATE", "REMARKS", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT sp.specialpackagename             specialpackagename
,      p.packagename                     packagename
,      spd.operation                     operation
,      spd.startdate                     startdate
,      spd.enddate                       enddate
,      NULL                              remarks
,      greatest(spd.updated, spd.created) last_update_or_creation_date
FROM xxcpc_specialpackagesdetails   spd  
,    xxcpc_specialpackages          sp  
,    xxcpc_packages                 p  
WHERE sp.id = spd.specialpackageid  
AND   p.id  = spd.packageid
;

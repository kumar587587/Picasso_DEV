--------------------------------------------------------
--  DDL for View XXSPM_PACKAGE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_PACKAGE_V" ("PACKAGEID", "DESCRIPTION", "SPECIALPACKAGEFLAG", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(packagename)    packageid
,      packagename                      description 
,      'N'                              specialpackageflag 
,      max(greatest(updated,created))   last_update_or_creation_date
FROM  xxcpc_packages   
WHERE id > 0
group by packagename
,      packagename                 
UNION  
SELECT upper(specialpackagename) specialpackageid
,      specialpackagename                 description 
,      'Y'                                specialpackageflag  
,      max(last_update_or_creation_date)       last_update_or_creation_date
FROM  xxspm_specialpackagesdetails_v   
group by specialpackagename
,      specialpackagename                 
ORDER BY 1
;

--------------------------------------------------------
--  DDL for View XXSPM_CONTRACTPACKAGEDETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CONTRACTPACKAGEDETAILS_V" ("CONTRACTID", "PACKAGENAME", "STARTPERIOD", "ENDPERIOD", "COMMENTS", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contractnr                        contractid 
,      p.packagename                       packagename
,      cpd.startdate                       startperiod
,      cpd.enddate                         endperiod    
,      NULL                                comments 
,      greatest(cpd.updated, cpd.created)  last_update_or_creation_date
FROM  xxcpc_contractpackagedetails cpd    
,     xxcpc_contracts c    
,     xxcpc_packages  p    
WHERE c.id = cpd.contractid    
AND   p.id = cpd.packageid
;

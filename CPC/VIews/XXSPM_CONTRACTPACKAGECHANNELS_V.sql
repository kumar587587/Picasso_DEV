--------------------------------------------------------
--  DDL for View XXSPM_CONTRACTPACKAGECHANNELS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CONTRACTPACKAGECHANNELS_V" ("CONTRACTID", "PACKAGENAME", "CHANNELNAME", "STARTDATE", "ENDDATE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contractnr                        contractid   
,      p.packagename                       packagename
,      ch.channelname                      channelname                      
,      cpc.startdate                       startdate   
,      cpc.enddate                         enddate
,      greatest(cpd.updated, cpd.created)  last_update_or_creation_date
FROM xxcpc_contractpackagechannels cpc  
,    xxcpc_contractpackagedetails  cpd   
,    xxcpc_packages                p   
,    xxcpc_channels                ch   
,    xxcpc_contracts               c
WHERE cpd.id = cpc.contractpackageid   
AND   p.id   = cpd.packageid  
AND   ch.id  = cpc.channelid  
AND   c.id   = cpd.contractid
;

--------------------------------------------------------
--  DDL for View XXSPM_TIEREDCOMMISSIONRATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_TIEREDCOMMISSIONRATES_V" ("CONTRACTID", "STARTDATE", "ENDDATE", "TIERID", "MIN", "MAX", "RATEAMOUNT", "REMARKS", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contractnr                         contractid  
,      tp.startdate                         startdate   
,      tp.enddate                           enddate
,      tcr.tierid                           tierid
,      tcr.min_value                        min   
,      tcr.max_value                        max   
,      tcr.rateamount                       rateamount   
,      NULL                                 remarks
,      greatest(c.updated, c.created)       last_update_or_creation_date
FROM  xxcpc_tieredcommissionrates tcr   
,     xxcpc_tierperiods           tp  
,     xxcpc_contracts             c  
WHERE tp.id  = tcr.tierperiodid  
AND   c.id   = tp.contractid
;

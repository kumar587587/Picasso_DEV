--------------------------------------------------------
--  DDL for View XXSPM_SP_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_SP_CONTRACTS_V" ("CONTRACTID", "CONTRACTNAME", "CONTENTPARTNERNUMBER", "STARTDATE", "ENDDATE", "ENDREMINDERBY", "INFLATIONREMINDERBY", "HOLDPAYMENT", "REMARKS", "CONTRACTTYPE", "PAYWITHCOMARCH", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT c.contractnr                                   contractid
,      c.contractname                                 contractname 
,      cp.partnernumber                               contentpartnernumber       
,      c.startdate                                    startdate
,      c.enddate                                      enddate     
,      c.endreminderby                                endreminderby     
,      c.inflationreminderby                          inflationreminderby         
,      c.holdpayment                                  holdpayment        
,      NULL                                           remarks
,     'CPC_'||replace(upper(typ.description),' ','_') contracttype
,     c.paywithcomarch                                paywithcomarch             
,      greatest(c.updated, c.created)                 last_update_or_creation_date
FROM  xxcpc_contracts        c       
,     xxcpc_contentpartners  cp
,     xxcpc_lookups          typ       
WHERE cp.id   = c.contentpartnerid       
AND   typ.id  = c.contracttypeid
;

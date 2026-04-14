--------------------------------------------------------
--  DDL for View XXSPM_CORRECTIONAMOUNTS_V_TST
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CORRECTIONAMOUNTS_V_TST" ("ID", "PARTNERNUMBER", "PARTNERNAME", "INVOICENO", "INVOICEPERIOD", "DUEDATEOVERRIDE", "PAYMENTAMOUNT", "PAYMENTDESCRIPTION", "DISPLAYONSPECIFICATION", "REFERENCEONSPEC", "TRANSACTIONTYPE", "SOURCE", "IMPORTDATE", "ENDDATECOMPPERIOD", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT ca.id                                   id    
,      p.partnernumber                         partnernumber
--,      p.partnername                           partnername
--, (select a.partnername from XXCPC_CONTENTPARTNERS_A a where a.partnernumber=p.partnernumber and ca.updated between a.created and a.updated and ca.updated between nvl(a.updated_old,a.created) and a.updated) partnername
--, (select a.partnername from XXCPC_CONTENTPARTNERS_A a where ( a.partnernumber=p.partnernumber and ( ca.updated between a.created and a.updated and ca.updated between nvl(a.updated_old,a.created) and a.updated ) or ( ca.updated > a.updated and a.iud<>'I') )  ) partnername
, (
   select distinct partnername from (
   SELECT DISTINCT iud,partnername,id,trunc(updated) updated, nvl(trunc(updated_old),TO_DATE('01-01-1900','DD-MM-YYYY')) updated_old
   FROM xxcpc_contentpartners_a a
   WHERE 1=1
   and a.id  = p.id
   UNION
   SELECT a.iud, a.partnername, a.id, updated+1000000
   , updated updated_old
   FROM xxcpc_contentpartners_a a
   WHERE 1=1
   and a.id  = p.id
   AND a.audit_id = (SELECT MAX(a2.audit_id) 
   FROM xxcpc_contentpartners_a a2 WHERE a2.id =a.id )
) where ca.updated between updated_old and updated  )
partnername
,      NULL                                    invoiceno
,      ca.invoicedate                          invoiceperiod
,      duedateoverride                         duedateoverride
,      paymentamount                           paymentamount   
,      NULL                                    paymentdescription
,      displayonspecification                  displayonspecification
,      referenceonspecification                referenceonspec
,      'NORMAL'                                transactiontype
,      NULL                                    source
,      ca.created                              importdate
,      ca.ENDDATECOMPPERIOD                    ENDDATECOMPPERIOD         
,      greatest( ca.updated, ca.created)       last_update_or_creation_date
--select p.*
FROM  xxcpc_correctionamounts ca
,     xxcpc_contentpartners   p
WHERE p.id= ca.partnerid
--and p.id =44
--and ca.id = 1000
;

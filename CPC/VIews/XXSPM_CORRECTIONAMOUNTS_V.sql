--------------------------------------------------------
--  DDL for View XXSPM_CORRECTIONAMOUNTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CORRECTIONAMOUNTS_V" ("ID", "PARTNERNUMBER", "PARTNERNAME", "INVOICENO", "INVOICEPERIOD", "DUEDATEOVERRIDE", "PAYMENTAMOUNT", "PAYMENTDESCRIPTION", "DISPLAYONSPECIFICATION", "REFERENCEONSPEC", "TRANSACTIONTYPE", "SOURCE", "IMPORTDATE", "ENDDATECOMPPERIOD", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT ca.id                                   id    
,      p.partnernumber                         partnernumber
,      (
       SELECT DISTINCT sub.partnername 
       FROM xxcpc_partnername_changes_v sub
         --WHERE trunc(greatest(ca.enddatecompperiod,ca.created,ca.updated)) BETWEEN sub.updated_old AND sub.updated and sub.id = p.id
         WHERE (greatest(ca.enddatecompperiod,ca.created,ca.updated)) BETWEEN sub.updated_old AND sub.updated and sub.id = p.id   --17-09-2024
       )                                       partnername
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
,      ca.enddatecompperiod                    enddatecompperiod         
,      greatest( ca.updated, ca.created)       last_update_or_creation_date
FROM  xxcpc_correctionamounts ca
,     xxcpc_contentpartners   p
WHERE p.id= ca.partnerid
;

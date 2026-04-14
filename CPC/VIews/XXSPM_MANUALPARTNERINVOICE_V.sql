--------------------------------------------------------
--  DDL for View XXSPM_MANUALPARTNERINVOICE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_MANUALPARTNERINVOICE_V" ("PARTNERINVOICEID", "PARTNERNUMBER", "INVOICEDATE", "DUEDATE", "PARTNERINVOICENUMBER", "INVOICEAMOUNT", "INVOICESTATUS", "PAYMENTTERM", "HOLDPAYMENT", "BILLINGINVOICENUMBER", "BILLINGINVOICEDATE", "EXTRACTTOBILLINGDATE", "VATCODE", "MEMOLINE", "INVOICEDESCRIPTION", "PAYWITHCOMARCH", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT mpi.id                              partnerinvoiceid
,      p.partnernumber                       partnernumber      
,      mpi.invoicedate                       invoicedate 
,      mpi.duedate                           duedate
,      mpi.partnerinvoicenumber              partnerinvoicenumber           
,      mpi.invoiceamount                     invoiceamount      
,      l.description                         invoicestatus  
,      mpi.paymentterm                       paymentterm 
,      mpi.holdpayment                       holdpayment   
,      mpi.billinginvoicenumber              billinginvoicenumber           
,      mpi.billinginvoicedate                billinginvoicedate         
,      mpi.extracttobillingdate              extracttobillingdate                   
,      NULL                                  vatcode
,      NULL                                  memoline
,      mpi.invoicedescription                invoicedescription            
,      mpi.paywithcomarch                    paywithcomarch            
,      greatest( mpi.updated, mpi.created)   last_update_or_creation_date
FROM  xxcpc_manualpartnerinvoice  mpi
,     xxcpc_contentpartners       p
,     xxcpc_lookups               l   
WHERE 1     = 1
AND   p.id  = mpi.partnerid
AND   l.id  = mpi.invoicestatusid
;

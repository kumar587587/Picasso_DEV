--------------------------------------------------------
--  DDL for View XXHSH_MANUALPARTNERINVOICE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_MANUALPARTNERINVOICE_V" ("PARTNERINVOICEID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(partnerinvoiceid)
  ,'['||concat('"'||upper(partnerinvoiceid)||'",'
  ,concat('"'||partnernumber||'",'
  ,concat(decode(invoicedate       ,NULL,'null','"'||to_char(invoicedate,'YYYY-MM-DD')     ||'T00:00:00"')||','
  ,concat(decode(duedate           ,NULL,'null','"'||to_char(duedate,'YYYY-MM-DD')         ||'T00:00:00"')||','
  --,concat('"'||TRIM(replace(partnerinvoicenumber,'\','\\'))||'",' 
  --,concat('"'||TRIM(replace(partnerinvoicenumber,'\','\\'))||'",'   /* Only For ACC2??? */
  --,concat('"'||TRIM(replace(partnerinvoicenumber,'\','\'))||'",'   /* Only For ACC2??? Needed to chabge this on ACC2 also */
  ,concat('"'||TRIM(replace(partnerinvoicenumber,'\\','\'))||'",'   /* Only For ACC???? Needed to chabge this on ACC also */
  --,concat('"'||TRIM(replace(partnerinvoicenumber,'\','\\'))||'",'    /* Only For ACC2??? */
  ,concat(''||     
                replace(   
                replace(   
                replace(   
                replace(   
                replace(   
                replace(   
                replace(   
                replace(   
                replace(   
                   replace(  trim(to_char( invoiceamount,  '99999990.99')) , '.00','')  
                   ,'.10','.1')
                      ,'.20','.2')
                         ,'.30','.3')
                            ,'.40','.4')
                               ,'.50','.5')
                                  ,'.60','.6')
                                     ,'.70','.7')
                                        ,'.80','.8')
                                           ,'.90','.9')

  ||','
  ,concat('"'||invoicestatus||'",'
  ,concat('"'||paymentterm||'",'
  ,concat('"'||holdpayment||'",'
  ,concat('"'||billinginvoicenumber||'",'
  --,concat('"'||billinginvoicedate||'",'
  ,concat(decode(billinginvoicedate             ,NULL,'null','"'||to_char(billinginvoicedate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,concat(decode(extracttobillingdate           ,NULL,'null','"'||to_char(extracttobillingdate,'YYYY-MM-DD')          ||'T00:00:00"')||','
  ,concat('"'||vatcode||'",'
  ,concat('"'||memoline||'",'
  ,concat('"'||TRIM(replace(replace(invoicedescription,'&','&'),chr(13)||chr(10),'\r\n'))||'",'  -- Not sure when this clause must be used. Or is is database dependant. This is DEV...
  --,'"'||paywithcomarch||'"')))))))))))))))|| 
  ,'"'||nvl(paywithcomarch,'')||'"')))))))))))))))|| 
  ']' concatenated_values  
  ,'['||'"'||upper(partnerinvoiceid)||'"]' concatenated_id
  FROM xxspm_manualpartnerinvoice_v 
  ORDER BY upper(partnerinvoiceid)
;

--------------------------------------------------------
--  DDL for Procedure UPD_CORR_AMOUNTS_DATES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCPC"."UPD_CORR_AMOUNTS_DATES" 
( --p_partnernumber            in number
--, p_referenceonspecification in varchar2
--, p_paymentamount            in number

p_invoiceid                in number
, p_invoicedate              in varchar2
)
is
   x number;
   l_partnerid number;
begin
   --select partnerid
   --into l_partnerid
   --from xxcpc_contentpartners
   --where partnernumber = p_partnernumber
   --;

   select count(*)
   into x
   from xxcpc_correctionamounts
   where 1=1
   --and  partnerid = l_partnerid
   --and  referenceonspecification = p_referenceonspecification
   --and paymentamount= p_paymentamount
   and id = p_invoiceid
   ;
   if x <> 1 then
      xxcpc_gen_debug_pkg.debug('TEST','p_invoiceid = '||to_char(p_invoiceid)|| '  x = '||x);
      x:= 1/0;
   end if;

   update xxcpc_correctionamounts
   set invoicedate = to_date(p_invoicedate,'DD-MM-YYYY')
   where 1=1
   --and  partnerid = l_partnerid
   --and  referenceonspecification = p_referenceonspecification
   --and paymentamount= p_paymentamount
   and id = p_invoiceid
   and invoicedate <> to_date(p_invoicedate,'DD-MM-YYYY')
   ;
   commit;
end;

/

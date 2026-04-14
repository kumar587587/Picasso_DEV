--------------------------------------------------------
--  DDL for Procedure INSERT_CORR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCPC"."INSERT_CORR" 
(  p_resource_nr     in    varchar2
,  p_invoice_date   in       varchar2
,  p_import_date   in       varchar2
,  p_payment_amount in       varchar2
,  p_displayonspeci in       varchar2
,  p_duedateoverride in       varchar2
,  p_referenceonspe in       varchar2
)
is
l_partner_id   number;
begin
   --xxcpc_gen_debug_pkg.debug( 'insert_corr' ,'p_resource_nr = '||p_resource_nr||', p_payment_amount = '||p_payment_amount);
   xxcpc_gen_debug_pkg.debug( 'insert_corr' ,'p_import_date = '||p_import_date);
   select id
   into l_partner_id
   from xxcpc_contentpartners
   --where partnername = p_partner_name
   where 1=1
   and odis_resource_nr = p_resource_nr
   --instr(partnername,'['||p_partner_number||']') > 0
   ;
   insert into XXCPC_CORRECTIONAMOUNTS
   ( partnerid
   , invoicedate
   , paymentamount
   , displayonspecification
   , duedateoverride
   , referenceonspecification
   , created
   , open_period_i
   )
   values
   ( l_partner_id
   , to_date ( p_invoice_date, 'DD-MM-YYYY')
   , to_number( p_payment_amount) /100
   , p_displayonspeci
   , p_duedateoverride
   , p_referenceonspe
   , to_date ( p_import_date, 'DD-MM-YYYY')
   , xxcpc_gen_rest_apis.get_open_period
   );
end;

/

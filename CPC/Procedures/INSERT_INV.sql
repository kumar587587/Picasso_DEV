--------------------------------------------------------
--  DDL for Procedure INSERT_INV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCPC"."INSERT_INV" 
( p_resource_nr  in varchar2
, p_invocie_date  in varchar2
, p_due_date  in varchar2
, p_partner_invoice_number  in varchar2
, p_invoice_description  in varchar2
, p_invoice_amount  in varchar2
, p_payment_term  in varchar2
, p_hold_payments  in varchar2
, p_billing_invoice_number  in varchar2
, p_billing_invoice_date  in varchar2
, p_extract_to_billing_date  in varchar2
, p_invoice_status  in varchar2
, p_pay_comarch     in varchar2
)
is
  l_status_id    number;
  l_partner_id   number;
begin
   --xxcpc_gen_debug_pkg.debug( 'insert_inv' ,'p_partner_name = '||p_partner_name||', p_partner_invoice_number = '||p_partner_invoice_number);
   select id 
   into l_status_id
   from xxcpc_lookups 
   where type = 'INVOICE_STATUS'
   and code = p_invoice_status;
   --
   --xxcpc_gen_debug_pkg.debug( 'insert_inv' ,'1');
   select id
   into l_partner_id
   from xxcpc_contentpartners
   where odis_resource_nr = p_resource_nr
   ;
   --xxcpc_gen_debug_pkg.debug( 'insert_inv' ,'2');
   insert into xxcpc_manualpartnerinvoice
   ( PARTNERID
   , INVOICEDATE
   , DUEDATE
   , PARTNERINVOICENUMBER
   , INVOICEDESCRIPTION
   , INVOICEAMOUNT
   , PAYMENTTERM
   , HOLDPAYMENT
   , BILLINGINVOICENUMBER
   , BILLINGINVOICEDATE
   , EXTRACTTOBILLINGDATE
   , INVOICESTATUSID
   , paywithcomarch
   , open_period_i
   )
   values
   ( l_partner_id
   , to_date(p_invocie_date,'DD-MM-YYYY')
   , to_date(p_due_date,'DD-MM-YYYY')
   , p_partner_invoice_number
   , p_invoice_description
   , to_number(p_invoice_amount)/100
   , p_payment_term
   , nvl(p_hold_payments,'N')
   , p_billing_invoice_number
   , to_date(p_billing_invoice_date,'DD-MM-YYYY')
   , to_date(p_extract_to_billing_date,'DD-MM-YYYY')
   , l_status_id
   , p_pay_comarch
   , xxcpc_gen_rest_apis.get_open_period
   ); 
exception
when others then
xxcpc_gen_debug_pkg.debug( 'insert_inv' ,'ERROR: '||SQLERRM);
raise;
end;

/

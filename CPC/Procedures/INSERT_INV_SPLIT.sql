--------------------------------------------------------
--  DDL for Procedure INSERT_INV_SPLIT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCPC"."INSERT_INV_SPLIT" 
( p_partner_invoice_id  in varchar2
, p_description         in varchar2
, p_memo                in varchar2
, p_vat                 in varchar2
, p_split_amount        in varchar2
)
is
  l_invoice_id      number;
  l_partner_id      number;
  l_vat_id          number;
  l_memo_id         number;
  l_bill_Id          number;
begin
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 0:  p_partner_invoice_id = '||p_partner_invoice_id);
   select id , partnerid
   into l_invoice_id, l_partner_Id
   from  xxcpc_manualpartnerinvoice
   where instr( INVOICEDESCRIPTION,'#'||p_partner_invoice_id||'#') > 0
   ;
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 1:  l_invoice_id = '||l_invoice_id);
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 1:  l_partner_Id = '||l_partner_Id);
   select id
   into l_vat_id
   from xxcpc_lookups
   where type = 'VATCODE'
   and   code = upper(p_vat)
   ;
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 2:  l_vat_id = '||l_vat_id);
   --dbms_output.put_line(' 2:  l_vat_id = '||l_vat_id);
   --dbms_output.put_line(' 3:  p_vat = '||p_vat);
   select id
   into l_memo_id
   from xxcpc_lookups
   where type = 'MEMOLINE'
   and   code = upper(p_memo)
   ;
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 3:  l_memo_id = '||l_memo_id);
   --dbms_output.put_line(' 3:  l_memo_id = '||l_memo_id);
   --
   select id
   into l_bill_id
   from XXCPC_CONTENTPARTNERBILLINGINF
   where memolineid    = l_memo_Id
   and vatcodeid       = l_vat_id
   and partnernumberid = l_partner_Id
   ;
   xxcpc_gen_debug_pkg.debug('INSERT_INV_SPLIT',' 4:  l_bill_id = '||l_bill_id);
   --dbms_output.put_line(' 4:  l_bill_id = '||l_bill_id);
   insert into xxcpc_manualpartnerinvoicespli
   ( MANUALPARTNERINVOICEID
   , SPLITDESCRIPTION
   , SPLITAMOUNT
   , CONTENTPARTNERBILLINGINFID
   , OPEN_PERIOD_I
   )
   values
   ( l_invoice_id
   , p_description
   , to_number(p_split_amount)/100
   , l_bill_id
   , xxcpc_gen_rest_apis.get_open_period
   ); 

end;

/

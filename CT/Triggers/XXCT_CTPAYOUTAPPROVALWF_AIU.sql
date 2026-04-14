--------------------------------------------------------
--  DDL for Trigger XXCT_CTPAYOUTAPPROVALWF_AIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_AIU" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF"
  REFERENCING FOR EACH ROW
  declare
   c_trigger_name         CONSTANT VARCHAR2(50)  := 'XXCT_CTPAYOUTAPPROVALWF_AIU';
   l_sp_table_name                 VARCHAR2(200) := 'CTPayoutApprovalWF';
   l_new_values_string             VARCHAR2(32000);
   l_old_values_string             VARCHAR2(32000);
   l_dossier_type                  VARCHAR2(20);
   l_document_url                  VARCHAR2(32000);
   l_count                         NUMBER;
begin
   xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='||'(start) :new.dossierid = ' ||:new.dossierid );   
   --xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new."Comment" = ' ||:new."Comment" );   
   --xxct_gen_rest_apis.delete_deleted_rows;   
   if inserting then
      --if  :new.dossiertype =  xxct_page_102_pkg.C_RESERVATION then
      --   l_dossier_type := xxct_page_102_pkg.C_RESERVATION;
      --elsif  l_dossier_type := xxct_page_102_pkg.C_PAYMENT;
      --   l_dossier_type := xxct_page_102_pkg.C_RESERVATION;
      --else   
      --   l_dossier_type := xxct_page_102_pkg.C_CREDITING;
      --end if;
      if :new."Comment" = 'For automatic testing purposes.' then
         l_document_url := 'https://www.google.com';
         xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| 'l_document_url 1 " = ' || l_document_url );   
      else   
          select count(*)
          into l_count
          from xxct_exhibits
          where dossier_id = to_number( :new.dossierid)
          ;      
          if l_count > 0 then 
            l_document_url := :new.dossierunderpinneddocumentsurl;
         end if;   
         xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| 'l_document_url 2 " = ' || l_document_url );   
      end if;
      xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| 'v(P102_REMARKS)  = ' ||v('P102_REMARKS') );   
      l_new_values_string :=  '"'||:new.dossierid||'",'||
                              '' ||:new.linenr||','||  
                              '"'||:new.dossiertype||'",'||  
                              '"'||:new.actiontype||'",'||  
                              '"'||:new.dossiernumber||'",'||  
                              '"'||:new.partnervcode||'",'||  
                              '"'||:new.partnername||'",'||  
                              '"'||:new.bonuspartnertype||'",'||  
                              '"'||:new.productgroupname||'",'||  
                              '"'||substr(:new.productgroupcomment,1,100)||'",'||  
                              '"'||:new.paymenttype||'",'||  
                              '"'||:new.vatcode||'",'||  
                              '' ||to_char( :new.lineamount, '99999999D99', 'NLS_NUMERIC_CHARACTERS = ''.,'''  )||','||  
                              '' ||to_char( :new.totalamount, '9999999D99', 'NLS_NUMERIC_CHARACTERS = ''.,'''  )||','||  
                              '"'||l_document_url||'",'||  
                              --'"'||:new."Comment"||'",'||  
                              '"'||v('P102_REMARKS')||'",'||  
                              '"'||null||'",'||    -- FormIDApproval
                              '"'||null||'",'||    -- Approved
                              '"'||null||'",'||    -- FormIDPay
                              '"'||null||'",'||    -- Paid
                              '"'||null||'",'||    -- PayDate
                              '"'||null||'",'||    -- InvoiceNumber
                              '"'||null||'",'||    -- Delete
                              '"'||null||'",'||    -- ApprovedAndSynched
                              '"'||null||'",'||    -- PaidAndSynched
                              '"'||null||'",'||    -- PaymentPostpone
                              '"'||:new.SharePartnerFlag||'",'||
                              '"'||:new.CommentFlag||'",'||
                              '"'||null||'",'||   -- PaymentInclude
                              '"'||null||'"';     -- DossierKey
   end if;
   IF UPDATING THEN
      NULL;
   END IF;

   IF inserting then
       --delete from XXCT_CTPAYOUTAPPROVALWF where dossierid = trim( to_number( :new.dossierid ) );
       xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| 'l_new_values_string== '||l_new_values_string);
       xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='||'p_key_values = '|| :new.partnervcode||','||:new.linenr||','||:new.dossiertype||','||:new.actiontype);
       xxct_gen_rest_apis.insert_row
       ( p_table_name      => l_sp_table_name
       , p_key_values      => :new.partnervcode||','||:new.linenr||','||:new.dossiertype||','||:new.actiontype
       , p_new_values      => l_new_values_string
       , p_effective_date  => null
       , p_overwrite       => null
       );    
       xxct_gen_log_pkg.log( c_trigger_name,'inserting row into '||l_sp_table_name ||' '||:new.partnervcode||','||:new.linenr||','||:new.dossiertype||','||:new.actiontype);
       update xxct_dossiers
       set action_type = :new.actiontype
       where dossier_id = to_number(:new.dossierid);
       xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIERID||'=='||'updated row in xxct_dossiers = '||SQL%ROWCOUNT);
       xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIERID||'=='||'action_type set to '||:new.actiontype||' for dossier '||:new.dossierid);
   END IF;
   -------------MWT-813 Start----------------------
   IF DELETING THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name,'Under Delete');

      l_old_values_string := '"'||:OLD.DOSSIERID||'",'||
                             '"'||:OLD.LINENR||'",'||
                             '"'||:OLD.DOSSIERTYPE||'",'||
                             '"'||:OLD.ACTIONTYPE||'",'||
                             '"'||:OLD.DOSSIERNUMBER||'",'||
                             '"'||:OLD.PARTNERVCODE||'",'||
                             '"'||:OLD.PARTNERNAME||'",'||
                             '"'||:OLD.BONUSPARTNERTYPE||'",'||
                             '"'||:OLD.PRODUCTGROUPNAME||'",'||
                             '"'||:OLD.PRODUCTGROUPCOMMENT||'",'||
                             '"'||:OLD.PAYMENTTYPE||'",'||
                             '"'||:OLD.VATCODE||'",'||
                             '"'||:OLD.LINEAMOUNT||'",'||
                             '"'||:OLD.TOTALAMOUNT||'",'||
                             '"'||:OLD.DOSSIERUNDERPINNEDDOCUMENTSURL||'",'||
                             '"'||:OLD."Comment"||'",'||
                             '"'||:OLD.FORMIDAPPROVAL||'",'||--NEED TO FormIDApproval Column
                             '"'||:OLD.APPROVED||'",'||
                             '"'||:OLD.FORMIDPAY||'",'||
                             '"'||:OLD.PAID||'",'||
                             '"'||:OLD.PAYDATE||'",'||
                             '"'||:OLD.INVOICENUMBER||'",'||
                             '"'||:OLD.DELETE||'",'||
                             '"'||:OLD.APPROVEDANDSYNCHED||'",'||
                             '"'||:OLD.PAIDANDSYNCHED||'",'||
                             '"",'||--PaymentPostpone
                             '"'||:OLD.SHAREPARTNERFLAG||'",'||
                             '"'||:OLD.COMMENTFLAG||'",'||
                             '"'||:OLD.PAYMENTINCLUDE||'",'||
                             '"'||:OLD.DOSSIERID||'-'||null ||'"'; --MANDATE_CYCLE

        xxct_gen_debug_pkg.debug_t( c_trigger_name,'l_old_values_string = '||l_old_values_string);

        xxct_gen_rest_apis.delete_row(p_table_name    => l_sp_table_name 
                                    , p_key_values    => l_old_values_string
                                    , p_old_values    => l_old_values_string 
                                    );
       xxct_gen_debug_pkg.debug_t( c_trigger_name,'Delete process end = ');
   END IF;
   --------------MWT-813 End-----------------------
   xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| '(end)' );
exception
when others then 
   xxct_gen_debug_pkg.debug_t( c_trigger_name,:NEW.DOSSIERID||'=='|| 'ERROR: '||SQLERRM ||' :new.dossierid ='||:new.dossierid);         
   raise;
end XXCT_CTPAYOUTAPPROVALWF_AIU;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_AIU" ENABLE;

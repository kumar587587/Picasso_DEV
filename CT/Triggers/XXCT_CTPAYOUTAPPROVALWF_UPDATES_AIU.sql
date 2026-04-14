--------------------------------------------------------
--  DDL for Trigger XXCT_CTPAYOUTAPPROVALWF_UPDATES_AIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_UPDATES_AIU" 
AFTER INSERT OR UPDATE ON "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_UPDATES"
REFERENCING FOR EACH ROW
declare 
   c_trigger_name         CONSTANT VARCHAR2(50)  := 'XXCT_CTPAYOUTAPPROVALWF_UPDATES_AIU';  
   l_mandate_cycle_prdg        NUMBER; 
   l_mandate_cycle_dpssier     NUMBER;
   PRAGMA AUTONOMOUS_TRANSACTION;
begin 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new.approved    = '||:new.approved );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new.dossiertype = '||:new.dossiertype );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new.dossierid   = '||:new.dossierid );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new.actiontype  = '||:new.actiontype );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, ':new.deleteflag  = '||:new.deleteflag );

   if inserting or updating then

      if :new.approved ='Y' and :new.dossiertype = xxct_page_102_pkg.c_reservation and ( :new.actiontype ='NORMAL' or :new.actiontype ='DECREASE' or :new.actiontype ='INCREASE' ) then
         xxct_gen_debug_pkg.debug_t( c_trigger_name, '1' );   
         update xxct_dossiers
         set status = 'AFGESLOTEN'
         where dossier_id = to_number( :new.dossierid );

         update xxct_mandates_hist
         set approval_status = 'Akkoord'
         where dossier_id = to_number( :new.dossierid );
         xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );

      elsif :new.approved ='Y' and :new.dossiertype = xxct_page_102_pkg.c_reservation and :new.actiontype ='PAYMENT' then
         xxct_gen_debug_pkg.debug_t( c_trigger_name, '2' );   
         xxct_gen_log_pkg.log( c_trigger_name,'setting status = FACTURATIE');
         update xxct_dossiers
         set status = 'FACTURATIE'
         where dossier_id = to_number( :new.dossierid );

         xxct_gen_log_pkg.log( c_trigger_name,'setting mandate_hist: approval_status = Akkoord');
         update xxct_mandates_hist
         set approval_status = 'Akkoord'
         where dossier_id = to_number( :new.dossierid ); 
         xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );

      elsif :new.approved ='Y' and :new.dossiertype = xxct_page_102_pkg.c_crediting and :new.actiontype ='PAYMENT' then
         xxct_gen_debug_pkg.debug_t( c_trigger_name, '3' );
         xxct_gen_log_pkg.log( c_trigger_name,'setting status = FACTURATIE');
         update xxct_dossiers
         set status = 'FACTURATIE'
         where dossier_id = to_number( :new.dossierid );

         xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );

       elsif :new.approved ='N' and :old.approved is null then
         xxct_gen_debug_pkg.debug_t( c_trigger_name, '4' );   
         -- This will be run for every product-line for this dossier. So if a dossiers has 3 product group lines
         -- this code will be run 3 times (two of which are unneccessary... but so what.....
         -- When no changes have been made to a product group the mandate_cycles will be lower than those on the dossier..
         select max(mandate_cycle)+1 
         into l_mandate_cycle_prdg
         from xxct_dossier_product_groups
         where dossier_id = to_number( :new.dossierid );

         select max(mandate_cycle)+1 
         into l_mandate_cycle_dpssier
         from xxct_dossiers
         where dossier_id = to_number( :new.dossierid );

         xxct_gen_log_pkg.log( c_trigger_name,'setting status = OPEN and MANDATE_CYCLE = '|| greatest( l_mandate_cycle_prdg, l_mandate_cycle_dpssier));
         update xxct_dossiers
         set status = 'OPEN'
         ,   mandate_cycle = greatest( l_mandate_cycle_prdg, l_mandate_cycle_dpssier) 
         where dossier_id = to_number( :new.dossierid );

         xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );   
       end if;

       if :new.paid ='Y' and :old.paid is null then
          xxct_gen_debug_pkg.debug_t( c_trigger_name, '5' );   
          xxct_gen_log_pkg.log( c_trigger_name,'setting status = AFGESLOTEN');
          update xxct_dossiers
          set status ='AFGESLOTEN'
          where dossier_id = to_number( :new.dossierid );
          xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );   
       end if;

       if :new.invoicenumber is not null and :old.invoicenumber is null then
          xxct_gen_debug_pkg.debug_t( c_trigger_name, '6' );   
          xxct_gen_log_pkg.log( c_trigger_name,'setting status = AFGESLOTEN and INVOICE_NUMBER');
          update xxct_dossiers
          set status ='AFGESLOTEN'
          ,   invoice_number = :new.invoicenumber
          where dossier_id = to_number( :new.dossierid );
          xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated  = '||SQL%ROWCOUNT );

          ------Below Update Query added by TechM team for MWT-731-------
          update XXCT_CTPAYOUTAPPROVALWF
             set FORMIDAPPROVAL = :new.FORMIDAPPROVAL,
                 FORMIDPAY      = :new.FORMIDPAY,
                 PAID           = :new.PAID,
                 PAYDATE        = TO_DATE(TO_DATE(:new.PAYDATE,'MM-DD-YYYY'),'DD-MM-YYYY'),
                 INVOICENUMBER  = :new.INVOICENUMBER
           where dossierid = to_number ( :new.dossierid );
           xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated in XXCT_CTPAYOUTAPPROVALWF =1 = '||SQL%ROWCOUNT );
        ------end---------------------
       end if;

       if nvl(:new.Deleteflag,'N') ='Y' then
          xxct_gen_debug_pkg.debug_t( c_trigger_name, 'calling: delete_deleted_rows');
          xxct_gen_log_pkg.log( c_trigger_name,'calling: delete_deleted_rows');
          xxct_gen_rest_apis.delete_deleted_rows;
       end if;

       if :new.invoicenumber is not null then
          update xxct_dossiers
          set invoice_number = :new.invoicenumber
          where dossier_id = to_number ( :new.dossierid );

          ------Below Update Query added by TechM team for MWT-731-------
          update XXCT_CTPAYOUTAPPROVALWF
             set FORMIDAPPROVAL = :new.FORMIDAPPROVAL,
                 FORMIDPAY      = :new.FORMIDPAY,
                 PAID           = :new.PAID,
                 PAYDATE        = TO_DATE(TO_DATE(:new.PAYDATE,'MM-DD-YYYY'),'DD-MM-YYYY'),
                 INVOICENUMBER  = :new.INVOICENUMBER
           where dossierid      = to_number ( :new.dossierid );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'number of records updated in XXCT_CTPAYOUTAPPROVALWF =2 = '||SQL%ROWCOUNT );
        ------end---------------------
            --START MWT-540
            IF :NEW.ACTIONTYPE = 'PAYMENT' THEN
                BEGIN
                    --XXCT_EXHIBITS_FILE_SEND_TO_TV.AFTER_CTPAYOUTAPPROVAL_UPDT(:NEW.DOSSIERID);
                    UPDATE XXCT_EXHIBITS SET PUBLISHED_FLAG = 'R' WHERE DOSSIER_ID = :NEW.DOSSIERID AND COPY_PARTNER = 'Y' AND PUBLISHED_FLAG IS NULL;
                    XXCT_EXHIBITS_FILE_SEND_TO_TV.CREATE_SCHEDULER_FOR_FILE_SEND;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;
            END IF;
            --END MWT-540
       end if;   

   end if;
   --IF UPDATING OR DELETING THEN
   --   null;
   --END IF;
   COMMIT;
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );         
exception
when others then 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||SQLERRM );         
   raise;

end XXCT_CTPAYOUTAPPROVALWF_UPDATES_AIU;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_UPDATES_AIU" ENABLE;

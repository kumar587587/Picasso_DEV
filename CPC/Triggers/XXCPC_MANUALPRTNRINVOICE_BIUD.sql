--------------------------------------------------------
--  DDL for Trigger XXCPC_MANUALPRTNRINVOICE_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTNRINVOICE_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_MANUALPARTNERINVOICE"
  REFERENCING FOR EACH ROW
  DECLARE            
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_MANUALPRTNRINVOICE_BIUD';  
    l_iud                  varchar2(1);
    l_open_period_i        varchar2(15);
    l_open_period_u        varchar2(15);
    l_open_period_d        varchar2(15);
BEGIN      
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN     
       l_iud := 'I';
       IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
          :new.id := XXCPC_MANUALPARTNER_INV_SEQ.nextval;
          :new.created := sysdate;      
          :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
	       :new.updated := sysdate;       
          :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
          --verplaatst op 1-3-2023 omdat deze ook werd uitgevoerd bij een update... dan werd (soms) de error geraised.
          IF xxcpc_page_manparinv.count_invoicenumbers(:new.partnerid,:new.partnerinvoicenumber, :new.id ) > 0 THEN      
          -- These fields are necessary to prevent additional error messages about not null fields      
          --:new.partner_invoice_id := -1;      
          --:new.created_by       := apps.fnd_global.user_id;      
          --:new.creation_date    := sysdate;      
          --:new.last_update_date := sysdate;      
          --:new.last_updated_by  := apps.fnd_global.user_id;      
             --raise_application_error (-20000, 'Billing Invoice Number has already been used for this partner.');     
             raise_application_error (-20000, 'Partner Invoice Number has already been used for this partner.');      
          END IF;    
       END IF;   
       l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;      
    --  
    --  
    IF updating THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
       l_iud := 'U';
       IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
          :new.updated := sysdate;       
          :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
      END IF;    
      l_open_period_i := :old.open_period_i;
      l_open_period_u := coalesce( :old.open_period_u,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;  
    --      
    IF deleting THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
       l_iud := 'D';
       l_open_period_i := :old.open_period_i;
       l_open_period_u := :old.open_period_u;
       l_open_period_d := coalesce( xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;  
    --  
    insert into XXCPC_MANUALPARTNERINVOICE_A( IUD,ID,PARTNERID,INVOICEDATE,DUEDATE,PARTNERINVOICENUMBER,INVOICEDESCRIPTION,INVOICEAMOUNT,PAYMENTTERM,HOLDPAYMENT,BILLINGINVOICENUMBER,BILLINGINVOICEDATE,EXTRACTTOBILLINGDATE,CREATED,CREATED_BY,UPDATED,UPDATED_BY,INVOICESTATUSID,PAYWITHCOMARCH,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,PARTNERID_OLD,INVOICEDATE_OLD,DUEDATE_OLD,PARTNERINVOICENUMBER_OLD,INVOICEDESCRIPTION_OLD,INVOICEAMOUNT_OLD,PAYMENTTERM_OLD,HOLDPAYMENT_OLD,BILLINGINVOICENUMBER_OLD,BILLINGINVOICEDATE_OLD,EXTRACTTOBILLINGDATE_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,INVOICESTATUSID_OLD,PAYWITHCOMARCH_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD,delete_period)   
    values ( l_iud, :new.ID, :new.PARTNERID, :new.INVOICEDATE, :new.DUEDATE, :new.PARTNERINVOICENUMBER, :new.INVOICEDESCRIPTION, :new.INVOICEAMOUNT, :new.PAYMENTTERM, :new.HOLDPAYMENT, :new.BILLINGINVOICENUMBER, :new.BILLINGINVOICEDATE, :new.EXTRACTTOBILLINGDATE, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, :new.INVOICESTATUSID, :new.PAYWITHCOMARCH, l_open_period_i, l_open_period_u , :old.ID, :old.PARTNERID, :old.INVOICEDATE, :old.DUEDATE, :old.PARTNERINVOICENUMBER, :old.INVOICEDESCRIPTION, :old.INVOICEAMOUNT, :old.PAYMENTTERM, :old.HOLDPAYMENT, :old.BILLINGINVOICENUMBER, :old.BILLINGINVOICEDATE, :old.EXTRACTTOBILLINGDATE, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.INVOICESTATUSID, :old.PAYWITHCOMARCH, :old.OPEN_PERIOD_I, l_open_period_u, l_open_period_d);
    --
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_manualprtnrinvoice_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTNRINVOICE_BIUD" ENABLE;

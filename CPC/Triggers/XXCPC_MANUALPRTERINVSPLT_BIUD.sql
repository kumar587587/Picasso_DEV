--------------------------------------------------------
--  DDL for Trigger XXCPC_MANUALPRTERINVSPLT_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTERINVSPLT_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_MANUALPARTNERINVOICESPLI"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_MANUALPRTERINVSPLT_BIUD';  
    l_iud                  varchar2(1);
    l_open_period_i        varchar2(15);
    l_open_period_u        varchar2(15);
    l_open_period_d        varchar2(15);    
BEGIN      
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting THEN      
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );
      l_iud := 'I';
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         :new.id := XXCPC_MANPARTNER_INV_SPLIT_SEQ.nextval; 
         :new.created := sysdate;      
         :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      END IF;   
      l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;      
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
   insert into XXCPC_MANUALPARTNERINVOICESPLI_A( IUD,ID,MANUALPARTNERINVOICEID,SPLITDESCRIPTION,SPLITAMOUNT,CREATED,CREATED_BY,UPDATED,UPDATED_BY,CONTENTPARTNERBILLINGINFID,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,MANUALPARTNERINVOICEID_OLD,SPLITDESCRIPTION_OLD,SPLITAMOUNT_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,CONTENTPARTNERBILLINGINFID_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD,delete_period)   
   values ( l_iud, :new.ID, :new.MANUALPARTNERINVOICEID, :new.SPLITDESCRIPTION, :new.SPLITAMOUNT, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, :new.CONTENTPARTNERBILLINGINFID, l_open_period_i, l_open_period_u , :old.ID, :old.MANUALPARTNERINVOICEID, :old.SPLITDESCRIPTION, :old.SPLITAMOUNT, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.CONTENTPARTNERBILLINGINFID, :old.OPEN_PERIOD_I, l_open_period_u, l_open_period_d);
   --
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_manualprterinvsplt_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTERINVSPLT_BIUD" ENABLE;

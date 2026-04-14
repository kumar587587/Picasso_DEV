--------------------------------------------------------
--  DDL for Trigger XXCPC_CORRECTIONAMOUNTS_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CORRECTIONAMOUNTS_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_CORRECTIONAMOUNTS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CORRECTIONAMOUNTS_BIUD';  
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
         :new.id := XXCPC_CORRECTIONAMOUNTS_SEQ.nextval;
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, ':new.created = '||:new.created );   
         if :new.created is null then
            :new.created := sysdate;      
         end if;
         :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
         :new.updated := sysdate;       
         :new.updated_by  := coalesce(sys_context('APEX$SESSION','APP_USER'),user);    
         :new.invoicedate := to_date(to_char(:new.invoicedate,'YYYYMM')||'15','YYYYMMDD');
         :new.EndDateCompPeriod := xxcpc_gen_rest_apis.get_end_date_comp_period;
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
      --l_open_period_u := :new.open_period_u;
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
   insert into XXCPC_CORRECTIONAMOUNTS_A( IUD,ID,PARTNERID,INVOICEDATE,PAYMENTAMOUNT,DISPLAYONSPECIFICATION,REFERENCEONSPECIFICATION,CREATED,CREATED_BY,UPDATED,UPDATED_BY,DUEDATEOVERRIDE,ENDDATECOMPPERIOD,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,PARTNERID_OLD,INVOICEDATE_OLD,PAYMENTAMOUNT_OLD,DISPLAYONSPECIFICATION_OLD,REFERENCEONSPECIFICATION_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,DUEDATEOVERRIDE_OLD,ENDDATECOMPPERIOD_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD)   
   values ( l_iud, :new.ID, :new.PARTNERID, :new.INVOICEDATE, :new.PAYMENTAMOUNT, :new.DISPLAYONSPECIFICATION, :new.REFERENCEONSPECIFICATION, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, :new.DUEDATEOVERRIDE, :new.ENDDATECOMPPERIOD, l_open_period_i, l_open_period_u , :old.ID, :old.PARTNERID, :old.INVOICEDATE, :old.PAYMENTAMOUNT, :old.DISPLAYONSPECIFICATION, :old.REFERENCEONSPECIFICATION, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.DUEDATEOVERRIDE, :old.ENDDATECOMPPERIOD, :old.OPEN_PERIOD_I, l_open_period_u);
   --
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_correctionamounts_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CORRECTIONAMOUNTS_BIUD" ENABLE;

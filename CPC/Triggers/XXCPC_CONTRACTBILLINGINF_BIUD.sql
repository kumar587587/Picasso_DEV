--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTRACTBILLINGINF_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTBILLINGINF_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_CONTRACTBILLINGINF"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTRACTBILLINGINF_BIUD';  
    l_open_period_i        varchar2(15);
    l_open_period_u        varchar2(15);
    l_open_period_d        varchar2(15);
BEGIN
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
    IF inserting THEN
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then
         --:new.contractnr := XXCPC_CONTRACTS_SEQ.nextval;
         :new.created := sysdate;
         :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
         :new.updated := sysdate;
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
         :new.updatedflag :='Y';
         :new.enddate := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY'));
      END IF;   
     --l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;       
   IF updating THEN
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then
         :new.updated := sysdate;
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
         :new.updatedflag :='Y';
         :new.enddate := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY'));
      END IF;
     -- l_open_period_i := :old.open_period_i;
      --l_open_period_u := coalesce( :old.open_period_u,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;  
   IF deleting THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
      --xxcpc_gen_rest_apis.set_contractnr(:old.contractnr);  
     -- l_open_period_i := :old.open_period_i;
     -- l_open_period_u := :old.open_period_u;
     -- l_open_period_d := coalesce( xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;

   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END XXCPC_CONTRACTBILLINGINF_BIUD;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTBILLINGINF_BIUD" ENABLE;

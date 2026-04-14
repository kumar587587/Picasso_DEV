--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTENTPARTNERBILLIN_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERBILLIN_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_CONTENTPARTNERBILLINGINF"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTENTPARTNERBILLIN_BIUD';  
    l_error_message        VARCHAR2(5000);
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
         :new.created := sysdate;       
         :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag :='Y';     
      END IF;   
      l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;       
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      l_iud := 'U';
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag :='Y';  
      END IF;   
      l_open_period_i := :old.open_period_i;
      l_open_period_u := coalesce( :old.open_period_u,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;  
   --  
   IF deleting THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting :old.id = '||:old.id );   
      l_iud := 'D';
      l_error_message := xxcpc_page_bilinf.checkusedinmanualprtnrinvoice ( :old.id );
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_error_message = '||l_error_message );   
      IF l_error_message IS NOT NULL THEN
         raise_application_error(-20000 , l_error_message);
      END IF;
      l_open_period_i := :old.open_period_i;
      l_open_period_u := :old.open_period_u;
      l_open_period_d := coalesce( xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;  
   --
   insert into XXCPC_CONTENTPARTNERBILLINGINF_A( IUD,ID,PARTNERNUMBERID,MEMOLINEID,VATCODEID,DEFAULTINDICATOR,UPDATEDFLAG,CREATED,CREATED_BY,UPDATED,UPDATED_BY,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,PARTNERNUMBERID_OLD,MEMOLINEID_OLD,VATCODEID_OLD,DEFAULTINDICATOR_OLD,UPDATEDFLAG_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD,delete_period)   
   values ( l_iud, :new.ID, :new.PARTNERNUMBERID, :new.MEMOLINEID, :new.VATCODEID, :new.DEFAULTINDICATOR, :new.UPDATEDFLAG, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, l_open_period_i, l_open_period_u , :old.ID, :old.PARTNERNUMBERID, :old.MEMOLINEID, :old.VATCODEID, :old.DEFAULTINDICATOR, :old.UPDATEDFLAG, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.OPEN_PERIOD_I, l_open_period_u, l_open_period_d);
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
EXCEPTION   
WHEN OTHERS THEN  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end) ERROR: '||sqlerrm );   
   RAISE;     
END xxcpc_contentpartnerbillin_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERBILLIN_BIUD" ENABLE;

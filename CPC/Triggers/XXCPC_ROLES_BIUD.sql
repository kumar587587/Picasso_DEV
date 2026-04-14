--------------------------------------------------------
--  DDL for Trigger XXCPC_ROLES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_ROLES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_ROLES_BIUD';  
BEGIN       
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;       
    IF updating THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;  
    --  
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END xxcpc_roles_biud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_ROLES_BIUD" ENABLE;

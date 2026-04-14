--------------------------------------------------------
--  DDL for Trigger XXCT_ROLES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_ROLES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCT_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_ROLES_BIUD';  
BEGIN       
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;       
    IF updating THEN  
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;  
    --  
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END xxct_roles_biud;




/
ALTER TRIGGER "WKSP_XXCT"."XXCT_ROLES_BIUD" ENABLE;

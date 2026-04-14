--------------------------------------------------------
--  DDL for Trigger XXCPC_USER_ROLES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_USER_ROLES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_USER_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_USER_ROLES_BIUD';  
--    l_composed             VARCHAR2(1);
BEGIN       
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        /*select composed into  l_composed from xxcpc_roles where id = :new.role_id ;--*/
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

        IF :new.end_date is null THEN
            :new.end_date := to_date( '31-12-9998','DD-MM-YYYY');
        END IF;    
        IF :new.active_flag is null THEN
            :new.active_flag := 'A';
        END IF;
    END IF;

    IF updating THEN  
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

        IF :new.end_date is null THEN
            :new.end_date := to_date( '31-12-9998','DD-MM-YYYY');
        END IF;    
        IF :new.active_flag is null THEN
            :new.active_flag := 'A';
        END IF;
    END IF;  

    IF deleting THEN
        NULL;
    END IF;
    --  
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END xxcpc_user_roles_biud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_USER_ROLES_BIUD" ENABLE;

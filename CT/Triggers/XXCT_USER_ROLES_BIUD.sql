--------------------------------------------------------
--  DDL for Trigger XXCT_USER_ROLES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_USER_ROLES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_USER_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_USER_ROLES_BIUD';  
    l_composed             VARCHAR2(1);
BEGIN       
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        SELECT composed
        INTO  l_composed
        FROM xxct_roles
        WHERE id = :new.role_id
        ;
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
        IF :new.active_flag IS NULL THEN
           :new.active_flag := 'Y';
        END IF;
        IF :new.end_date IS NULL THEN
           :new.end_date := TO_DATE( '31-12-9998','DD-MM-YYYY');
        END IF;
    END IF;       
    IF updating THEN  
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
      IF :new.end_date IS NULL THEN
         :new.end_date := TO_DATE( '31-12-9998','DD-MM-YYYY');
      END IF;
    END IF;  
    IF updating or inserting then
        if :new.start_date > :new.end_date then
           raise_application_error(-20001,'Start-date must be before or equal to end-date.',TRUE ); 
        end if;  
    END IF;
    IF deleting THEN
        NULL;
    END IF;
    --  
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END xxct_user_roles_biud;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_USER_ROLES_BIUD" ENABLE;

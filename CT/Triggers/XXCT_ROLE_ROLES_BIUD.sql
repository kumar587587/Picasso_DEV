--------------------------------------------------------
--  DDL for Trigger XXCT_ROLE_ROLES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_ROLE_ROLES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCT_ROLE_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_ROLE_ROLES_BIUD';  
BEGIN       
    XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
        for r_row in (select distinct user_id from XXCT_user_roles where composed_role_id = :new.composed_role_id ) loop
            insert into XXCT_user_roles (      role_id ,       user_id , start_date ,      composed_role_id )
            values                       ( :new.role_id , r_row.user_id , sysdate    , :new.composed_role_id )   
            ;
        end loop;
    END IF;       
    IF updating THEN  
       XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;  
    --  
    XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END XXCT_ROLE_ROLES_biud;




/
ALTER TRIGGER "WKSP_XXCT"."XXCT_ROLE_ROLES_BIUD" ENABLE;

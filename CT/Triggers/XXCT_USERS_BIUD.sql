--------------------------------------------------------
--  DDL for Trigger XXCT_USERS_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_USERS_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_USERS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_USERS_BIUD';  
BEGIN       
    XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
        XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        :new.created := sysdate;       
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);   
        :new.updated := sysdate;       
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
        if :new.display_name is null then
           :new.display_name := initcap( replace( substr( :new.user_name,1, instr( :new.user_name,'@') -1 ) ,'.',' '));
        end if;
    END IF;       
    IF updating THEN  
       XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
    END IF;  
    IF updating or inserting then
        if :new.start_date > :new.end_date then
           raise_application_error(-20001,'Start-date must be before or equal to end-date.',TRUE ); 
        end if;  
   END IF;     
    --  
    XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
    --  
END XXCT_USERS_biud;

/
ALTER TRIGGER "WKSP_XXCT"."XXCT_USERS_BIUD" ENABLE;

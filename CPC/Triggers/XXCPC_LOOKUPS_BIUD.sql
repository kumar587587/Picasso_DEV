--------------------------------------------------------
--  DDL for Trigger XXCPC_LOOKUPS_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_LOOKUPS_BIUD" 
    BEFORE INSERT OR UPDATE OR DELETE      
    ON xxcpc_lookups      
    FOR EACH ROW      
DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_LOOKUPS_BIUD'; 
    l_error_message        VARCHAR2(500);
BEGIN      
   --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting THEN      
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      :new.created := sysdate;      
      :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
      :new.updated := sysdate;       
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
   END IF;      
   IF updating THEN  
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      :new.updated := sysdate;      
      :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
      :new.code   := upper(:new.code);      
   END IF;  
   --  
   IF deleting THEN  
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
      IF :old.type = 'MEMOLINE' THEN
         l_error_message :=  xxcpc_page_lookup.can_delete_memoline( :old.id );
         IF l_error_message IS NOT NULL THEN
            raise_application_error(-20000, l_error_message);
         END IF;
      END IF;   
      IF :old.type = 'VATCODE' THEN
         l_error_message :=  xxcpc_page_lookup.can_delete_vatcode( :old.id );
         IF l_error_message IS NOT NULL THEN
            raise_application_error(-20000, l_error_message);
         END IF;
      END IF;   

   END IF;  
   --  
   --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_lookups_biud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_LOOKUPS_BIUD" ENABLE;

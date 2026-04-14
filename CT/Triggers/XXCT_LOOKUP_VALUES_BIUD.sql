--------------------------------------------------------
--  DDL for Trigger XXCT_LOOKUP_VALUES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_LOOKUP_VALUES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_LOOKUP_VALUES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_LOOKUP_VALUES_BIUD';  
    l_nr_rows              NUMBER;
    e_custom_error_code    integer := -20001;
BEGIN       
   XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   --  
   IF deleting THEN  
      -- first check if the value that is to be deleted isn't used in any planelements
--      IF :old.lookup_type = 'PLANELEMENT_TYPE' THEN
--        SELECT COUNT(*) INTO l_nr_rows FROM XXCT_planelements WHERE planelementtype = :old.code;
--      ELSIF :old.lookup_type = 'COMMISSION_TYPE' THEN
--        SELECT COUNT(*) INTO l_nr_rows FROM XXCT_planelements WHERE commissiontype = :old.code;
--      END IF; 
      --
      IF l_nr_rows > 0 THEN
         raise_application_error(e_custom_error_code, 'Can not remove this value, because it is being used in one or more of the entries in XXCT_PLANELEMENTS');
      --ELSE
      --   XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(test_else_sttmnt)' );
      --   
      END IF;
   END IF;  
   --  
    if inserting then 
        :new.creation_date := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.last_update_date := sysdate; 
    :new.last_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);    


   XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END XXCT_lookup_values_biud;

/
ALTER TRIGGER "WKSP_XXCT"."XXCT_LOOKUP_VALUES_BIUD" ENABLE;

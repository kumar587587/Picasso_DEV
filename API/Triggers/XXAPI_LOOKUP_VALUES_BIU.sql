--------------------------------------------------------
--  DDL for Trigger XXAPI_LOOKUP_VALUES_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXAPI"."XXAPI_LOOKUP_VALUES_BIU" 
      BEFORE INSERT OR UPDATE ON XXAPI_LOOKUP_VALUES  FOR EACH ROW 
   BEGIN 
      if inserting then 
         :new.creation_date := sysdate; 
         :new.created_by    := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      end if; 
      :new.last_update_date := sysdate; 
      :new.last_updated_by  := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
   END XXAPI_LOOKUP_VALUES_BIU;
/
ALTER TRIGGER "WKSP_XXAPI"."XXAPI_LOOKUP_VALUES_BIU" ENABLE;

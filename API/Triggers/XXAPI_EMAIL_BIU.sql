--------------------------------------------------------
--  DDL for Trigger XXAPI_EMAIL_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXAPI"."XXAPI_EMAIL_BIU" 
      BEFORE INSERT OR UPDATE ON WKSP_XXAPI.XXAPI_EMAILS  FOR EACH ROW 
   BEGIN 
      IF updating then  
        :new.created_by := :old.created_by; 
        :new.creation_date := :old.creation_date;
      END IF;
      :new.last_update_date := sysdate; 
      :new.last_updated_by  := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
   END XXAPI_EMAIL_BIU;
/
ALTER TRIGGER "WKSP_XXAPI"."XXAPI_EMAIL_BIU" ENABLE;

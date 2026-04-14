--------------------------------------------------------
--  DDL for Trigger XXAPI_API_USERS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXAPI"."XXAPI_API_USERS_BIU" 
      BEFORE INSERT OR UPDATE ON xxapi_api_users  FOR EACH ROW 
   BEGIN 
      if inserting then 
         :new.creation_date := sysdate; 
         :new.created_by    := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      end if; 
      :new.last_update_date := sysdate; 
      :new.last_updated_by  := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
   end xxapi_api_users_BIU;



/
ALTER TRIGGER "WKSP_XXAPI"."XXAPI_API_USERS_BIU" ENABLE;

--------------------------------------------------------
--  DDL for Trigger XXCT_LOOKUPS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_LOOKUPS_BIU" 
  BEFORE INSERT OR UPDATE ON "WKSP_XXCT"."XXCT_LOOKUPS"
  REFERENCING FOR EACH ROW
  BEGIN 
    IF inserting THEN 
        :new.creation_date := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    END IF; 
    :new.last_update_date := sysdate; 
    :new.last_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
END XXCT_lookups_biu;

/
ALTER TRIGGER "WKSP_XXCT"."XXCT_LOOKUPS_BIU" ENABLE;

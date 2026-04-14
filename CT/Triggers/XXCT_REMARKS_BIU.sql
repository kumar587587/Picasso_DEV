--------------------------------------------------------
--  DDL for Trigger XXCT_REMARKS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_REMARKS_BIU" 
  BEFORE INSERT OR UPDATE ON "WKSP_XXCT"."XXCT_REMARKS"
  REFERENCING FOR EACH ROW
  DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'XXCT_REMARKS_BIU';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_REMARKS_BIU.sql,v 1.2 2018/12/19 20:11:21 rikke493 Exp $';
   --
BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,'(start)');
   --
   IF INSERTING THEN
      :NEW.creation_date := SYSDATE;
      --IF NOT xxct_general_pkg.g_circumvent_insert_actns THEN /* functionality for adding scenarios, not needed in production */
         :NEW.created_by :=  NVL(wwv_flow.g_user,USER);
         :NEW.last_updated_by  := NVL(wwv_flow.g_user,USER);
         SELECT person_id
         INTO   :NEW.PERSON_ID
         FROM   xxct_persons_v
         where user_name = upper ( v('APP_USER') )
         ;
      --END IF;
      :NEW.last_update_date := SYSDATE;
      :NEW.REMARK_ID := XXCT_REMARKS_SEQ.nextval;
      --
   END IF;
   --
   IF INSERTING OR UPDATING THEN
      :NEW.last_update_date := SYSDATE;
      :NEW.last_updated_by  := NVL(wwv_flow.g_user,USER);
   END IF;
   xxct_gen_debug_pkg.debug( c_trigger_name,'(end)');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);

   --
   raise_application_error( -20001, Sqlerrm );
END;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_REMARKS_BIU" ENABLE;

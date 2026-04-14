--------------------------------------------------------
--  DDL for Trigger XXCT_NOTIFICATIONS_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_NOTIFICATIONS_BRT" 
      BEFORE INSERT OR UPDATE OR DELETE ON XXCT_NOTIFICATIONS
      FOR EACH ROW
   DECLARE
         c_trigger_name            CONSTANT varchar2(30)  := 'XXCT_NOTIFICATIONS_BRT';
         c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_NOTIFICATIONS_BRT.sql,v 1.2 2019/01/03 22:58:39 bakke619 Exp $';
      BEGIN
         --apps.xxice_debug_pkg.debug_trigger( c_trigger_name,'Start');
         --
         IF INSERTING THEN
            :NEW.NOTIFICATION_ID       := XXCT_NOTIFICATIONS_S.NEXTVAL;
            :NEW.CREATION_DATE         := SYSDATE;
            :NEW.CREATED_BY            := -1;
            :NEW.LAST_UPDATE_DATE      := SYSDATE;
            :NEW.LAST_UPDATED_BY       := -1;

         ELSIF UPDATING THEN
            :NEW.CREATION_DATE         := :OLD.CREATION_DATE;
            :NEW.CREATED_BY            := :OLD.CREATED_BY;
            :NEW.LAST_UPDATE_DATE      := SYSDATE;
            :NEW.LAST_UPDATED_BY       := -1;

         ELSIF DELETING THEN
             NULL;
         END IF;

         --apps.xxice_debug_pkg.debug_trigger( c_trigger_name,'End.');
      EXCEPTION
      WHEN OTHERS THEN
         NULL;
         --apps.xxice_debug_pkg.debug_trigger( c_trigger_name,'ERROR: '||sqlerrm);
     END;


/
ALTER TRIGGER "WKSP_XXCT"."XXCT_NOTIFICATIONS_BRT" ENABLE;

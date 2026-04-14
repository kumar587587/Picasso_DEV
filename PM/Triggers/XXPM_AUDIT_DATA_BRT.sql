--------------------------------------------------------
--  DDL for Trigger XXPM_AUDIT_DATA_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_AUDIT_DATA_BRT" 
   BEFORE INSERT OR UPDATE OR DELETE
   ON XXPM_AUDIT_DATA
   FOR EACH ROW
DECLARE
   c_trigger_name      CONSTANT VARCHAR2 (30) := 'XXPM_AUDIT_DATA_BRT';
   c_trigger_version   CONSTANT VARCHAR2 (200)
      := '$Id: trg_XXPM_AUDIT_DATA_BRT.sql,v 1.1 2020/12/30 15:12:51 bakke619 Exp $' ;
BEGIN
   --apps.xxice_debug_pkg.debug( c_trigger_name,' Start');
   IF INSERTING
   THEN
      IF :NEW.AUDIT_ID IS NULL
      THEN
         :NEW.AUDIT_ID := XXPM_AUDIT_DATA_S.NEXTVAL;
      END IF;

      IF :NEW.CREATION_DATE IS NULL
      THEN
         :NEW.CREATION_DATE := SYSDATE;
         :NEW.LAST_UPDATE_DATE := SYSDATE;
      END IF;

      IF :NEW.CREATED_BY IS NULL
      THEN
         :NEW.CREATED_BY := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
         :NEW.LAST_UPDATED_BY := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
      END IF;
   ELSIF UPDATING
   THEN
      :NEW.CREATION_DATE := :OLD.CREATION_DATE;
      :NEW.CREATED_BY := :OLD.CREATED_BY;
      :NEW.LAST_UPDATE_DATE := SYSDATE;
      :NEW.LAST_UPDATED_BY := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
   END IF;
--apps.xxice_debug_pkg.debug( c_trigger_name,' End.');
EXCEPTION
   WHEN OTHERS
   THEN
      xxpm_gen_debug_pkg.debug (c_trigger_name, 'ERROR: ' || SQLERRM);
END;




/
ALTER TRIGGER "WKSP_XXPM"."XXPM_AUDIT_DATA_BRT" ENABLE;

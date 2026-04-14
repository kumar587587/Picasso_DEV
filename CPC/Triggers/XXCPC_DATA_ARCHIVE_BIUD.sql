--------------------------------------------------------
--  DDL for Trigger XXCPC_DATA_ARCHIVE_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_DATA_ARCHIVE_BIUD" 
  BEFORE INSERT ON "XXCPC_DATA_ARCHIVE"
  REFERENCING FOR EACH ROW
  DECLARE   
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_DATA_ARCHIVE_BIUD';
BEGIN     
    xxcpc_gen_debug_pkg.debug( c_trigger_name, '(start)' ); 
    IF inserting THEN     
        xxcpc_gen_debug_pkg.debug( c_trigger_name, 'inserting' ); 
        :new.created := sysdate;     
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
       :new.updated := sysdate;     
       :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);     
    END IF;     
    --
    xxcpc_gen_debug_pkg.debug( c_trigger_name, '(end)' ); 
    --
END XXCPC_DATA_ARCHIVE_BIUD;




/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_DATA_ARCHIVE_BIUD" ENABLE;

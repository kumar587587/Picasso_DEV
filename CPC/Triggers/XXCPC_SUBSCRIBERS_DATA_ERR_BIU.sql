--------------------------------------------------------
--  DDL for Trigger XXCPC_SUBSCRIBERS_DATA_ERR_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_ERR_BIU" 
    BEFORE INSERT OR UPDATE 
    ON xxcpc_subscribers_data_error
    FOR EACH ROW
BEGIN
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_ERR_BIU','(start');   
    IF inserting THEN
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    END IF;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    --
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_ERR_BIU','(end)');   
END XXCPC_SUBSCRIBERS_DATA_ERR_BIU;



/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_ERR_BIU" ENABLE;

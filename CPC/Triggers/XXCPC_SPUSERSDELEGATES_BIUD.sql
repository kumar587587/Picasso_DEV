--------------------------------------------------------
--  DDL for Trigger XXCPC_SPUSERSDELEGATES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SPUSERSDELEGATES_BIUD" 
BEFORE INSERT OR UPDATE OR DELETE ON XXCPC_SPUSERSDELEGATES
REFERENCING FOR EACH ROW
begin
    /*ROLEID = ROLE_KEY
      ROLE_ID = ROLE_ID*/
      
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
        :new.updated := sysdate;
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
        if :new.ROLEID is null then
            select role_key into :new.ROLEID from xxcpc_roles where id = :new.ROLE_ID;
        end if;
        if :new.ROLE_ID is null then
            select id into :new.ROLE_ID from xxcpc_roles where role_key = :new.ROLEID;
        end if;
    end if;
    if updating then
        :new.updated := sysdate;
        :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
        if :new.ROLEID is null then
            select role_key into :new.ROLEID from xxcpc_roles where id = :new.ROLE_ID;
        end if;
        if :new.ROLE_ID is null then
            select id into :new.ROLE_ID from xxcpc_roles where role_key = :new.ROLEID;
        end if;
    end if;
    if deleting then
        null;
    end if;
    if :new.startdate > :new.enddate then
       raise_application_error(-20001,'Start-date must be before or equal to end-date.',TRUE );
    end if;
    
end XXCPC_SPUSERSDELEGATES_BIUD;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SPUSERSDELEGATES_BIUD" ENABLE;

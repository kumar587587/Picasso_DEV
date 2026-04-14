--------------------------------------------------------
--  DDL for Trigger XXPM_ADDRESSES_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_ADDRESSES_BIU" 
    before insert or update  
    on xxpm_addresses 
    for each row 
begin 
    if inserting then
        :new.creation_date                  := sysdate;
        :new.created_by                     := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
        :NEW.ADDRESS_STREET                 := RTRIM(:NEW.ADDRESS_STREET,' ');
        :NEW.ADDRESS_HOUSE_NUMBER           := RTRIM(:NEW.ADDRESS_HOUSE_NUMBER,' ');
        :NEW.ADDRESS_HOUSE_NUMBER_SUFFIX    := RTRIM(:NEW.ADDRESS_HOUSE_NUMBER_SUFFIX,' ');
        :NEW.ADDRESS_ZIP_CODE               := RTRIM(:NEW.ADDRESS_ZIP_CODE,' ');
        :NEW.ADDRESS_RESIDENCE              := RTRIM(:NEW.ADDRESS_RESIDENCE,' ');
        :NEW.ADDRESS_COUNTRY                := RTRIM(:NEW.ADDRESS_COUNTRY,' ');
        :NEW.POSTBUS                        := RTRIM(:NEW.POSTBUS,' ');
    end if;
    :new.last_update_date := sysdate;
    :new.last_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    
END XXPM_ADDRESSES_BIU;
/
ALTER TRIGGER "WKSP_XXPM"."XXPM_ADDRESSES_BIU" ENABLE;

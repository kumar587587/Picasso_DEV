--------------------------------------------------------
--  DDL for Trigger XXCT_SPUSERSDELEGATES_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_SPUSERSDELEGATES_BIU" 
    before insert or update 
    on xxct_spusersdelegates 
    for each row 
begin 
    if inserting then 
        :new.created := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.updated := sysdate; 
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    if :new.startdate > :new.enddate then
       raise_application_error(-20001,'Start-date must be before or equal to end-date.',TRUE ); 
    end if;   
end xxct_spusersdelegates_biu;

/
ALTER TRIGGER "WKSP_XXCT"."XXCT_SPUSERSDELEGATES_BIU" ENABLE;

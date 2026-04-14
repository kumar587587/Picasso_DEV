--------------------------------------------------------
--  DDL for Trigger XXPM_CHAINS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_CHAINS_BIU" 
    before insert or update  
    on xxpm_chains 
    for each row 
begin 
    if inserting then 
        :new.creation_date := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.last_update_date := sysdate; 
    :new.last_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
end xxpm_chains_biu; 








/
ALTER TRIGGER "WKSP_XXPM"."XXPM_CHAINS_BIU" ENABLE;

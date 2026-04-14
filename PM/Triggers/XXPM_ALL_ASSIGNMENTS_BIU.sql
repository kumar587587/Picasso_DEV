--------------------------------------------------------
--  DDL for Trigger XXPM_ALL_ASSIGNMENTS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_ALL_ASSIGNMENTS_BIU" 
    before insert or update  
    on xxpm_all_assignments 
    for each row 
begin 
    if inserting then 
        :new.creation_date := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.last_update_date := sysdate; 
    :new.last_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
end xxpm_all_assignments_biu; 








/
ALTER TRIGGER "WKSP_XXPM"."XXPM_ALL_ASSIGNMENTS_BIU" ENABLE;

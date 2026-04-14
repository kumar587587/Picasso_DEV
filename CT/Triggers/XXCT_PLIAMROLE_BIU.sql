--------------------------------------------------------
--  DDL for Trigger XXCT_PLIAMROLE_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_PLIAMROLE_BIU" 
    before insert or update 
    on xxct_pliamrole 
    for each row 
begin 
    if inserting then 
        :new.created := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.updated := sysdate; 
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
end xxct_pliamrole_biu; 


/
ALTER TRIGGER "WKSP_XXCT"."XXCT_PLIAMROLE_BIU" ENABLE;

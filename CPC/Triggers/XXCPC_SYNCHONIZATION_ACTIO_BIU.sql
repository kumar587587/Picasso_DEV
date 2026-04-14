--------------------------------------------------------
--  DDL for Trigger XXCPC_SYNCHONIZATION_ACTIO_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SYNCHONIZATION_ACTIO_BIU" 
    before insert or update  
    on xxcpc_synchonization_actions 
    for each row 
begin 
    if inserting then 
        :new.created := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.updated := sysdate; 
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
end xxcpc_synchonization_actio_biu; 






/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SYNCHONIZATION_ACTIO_BIU" ENABLE;

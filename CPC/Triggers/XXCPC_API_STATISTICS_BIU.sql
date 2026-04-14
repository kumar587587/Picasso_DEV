--------------------------------------------------------
--  DDL for Trigger XXCPC_API_STATISTICS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_API_STATISTICS_BIU" 
    before insert or update  
    on xxcpc_api_statistics 
    for each row 
begin 
    if inserting then 
        :new.created := sysdate; 
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
    end if; 
    :new.updated := sysdate; 
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user); 
end xxcpc_api_statistics_biu; 




/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_API_STATISTICS_BIU" ENABLE;

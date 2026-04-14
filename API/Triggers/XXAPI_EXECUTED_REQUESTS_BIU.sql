--------------------------------------------------------
--  DDL for Trigger XXAPI_EXECUTED_REQUESTS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXAPI"."XXAPI_EXECUTED_REQUESTS_BIU" 
    before insert or update 
    on XXAPI_EXECUTED_REQUESTS 
    for each row 
begin 
    :new.request_timestamp := sysdate;
end XXAPI_EXECUTED_REQUESTS_BIU; 
/
ALTER TRIGGER "WKSP_XXAPI"."XXAPI_EXECUTED_REQUESTS_BIU" ENABLE;

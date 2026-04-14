--------------------------------------------------------
--  DDL for Trigger XXAPI_DEBUG_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXAPI"."XXAPI_DEBUG_TRG" 
  BEFORE INSERT ON "WKSP_XXAPI"."XXAPI_DEBUG"
  REFERENCING FOR EACH ROW
  BEGIN 
      SELECT XXAPI_DEBUG_SEQ.NEXTVAL INTO :NEW.seq_nr FROM DUAL; 
   END;
/
ALTER TRIGGER "WKSP_XXAPI"."XXAPI_DEBUG_TRG" ENABLE;

--------------------------------------------------------
--  DDL for Trigger XXCT_CAT_PAY_TYPES_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_CAT_PAY_TYPES_BRT" 
   BEFORE INSERT OR UPDATE OR DELETE ON XXCT_CAT_PAY_TYPES
   FOR EACH ROW
   DECLARE
      c_trigger_name            CONSTANT varchar2(30)  := 'Xxct_Cat_Pay_Types_Brt';
      c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_CAT_PAY_TYPES_BRT.sql,v 1.2 2018/11/27 12:24:28 rikke493 Exp $';
      --
  BEGIN
     --apps.xxice_cpc_apis_pkg.debug_trigger( c_trigger_name,'Start');
     --
     IF INSERTING THEN
        :NEW.CAT_PAY_TYPE_ID := XXCT_CAT_PAY_TYPES_SEQ.NEXTVAL;
        :NEW.CREATION_DATE    := SYSDATE;
        :NEW.CREATED_BY       := -1;
        :NEW.LAST_UPDATE_DATE := SYSDATE;
        :NEW.LAST_UPDATED_BY  := -1;
     ELSIF UPDATING THEN
        :NEW.LAST_UPDATE_DATE := SYSDATE;
        :NEW.LAST_UPDATED_BY  := -1;
     END IF;
     --apps.xxice_cpc_apis_pkg.debug_trigger( c_trigger_name,'End.');
   EXCEPTION
   WHEN OTHERS THEN
      null;
      --apps.xxice_cpc_apis_pkg.debug_trigger( c_trigger_name,'ERROR: '||sqlerrm);
      --
  END;



/
ALTER TRIGGER "WKSP_XXCT"."XXCT_CAT_PAY_TYPES_BRT" ENABLE;

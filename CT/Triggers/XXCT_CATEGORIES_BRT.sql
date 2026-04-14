--------------------------------------------------------
--  DDL for Trigger XXCT_CATEGORIES_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_CATEGORIES_BRT" 
   BEFORE INSERT OR UPDATE OR DELETE ON XXCT_CATEGORIES
   FOR EACH ROW
   DECLARE
      c_trigger_name            CONSTANT varchar2(30)  := 'Xxct_Categories_Brt';
      c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_CATEGORIES_BRT.sql,v 1.2 2018/11/27 12:23:04 rikke493 Exp $';
      --
  BEGIN
     --apps.xxice_cpc_apis_pkg.debug_trigger( c_trigger_name,'Start');
     --
     IF INSERTING THEN
        :NEW.CREATION_DATE    := SYSDATE;
        :NEW.CREATED_BY       := -1;
        :NEW.LAST_UPDATE_DATE := SYSDATE;
        :NEW.LAST_UPDATED_BY  := -1;
        if v('APP_ID') is not null then
           owa_util.redirect_url('f?p='||v('APP_ID')||':811:0::NO:811:P811_CATEGORY_ID:'||:NEW.CATEGORY_ID);
        end if;
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
ALTER TRIGGER "WKSP_XXCT"."XXCT_CATEGORIES_BRT" ENABLE;

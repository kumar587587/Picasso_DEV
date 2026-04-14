--------------------------------------------------------
--  DDL for Trigger XXCT_DSSR_PRUCT_GRPS_HST_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_DSSR_PRUCT_GRPS_HST_BRT" 
BEFORE INSERT OR UPDATE OR DELETE ON XXCT_DSSR_PRDCT_GRPS_HST
FOR EACH ROW
DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'Xxct_Dssr_Pruct_Grps_Hst_Brt';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_DSSR_PRUCT_GRPS_HST_BRT.sql,v 1.1 2018/12/05 15:13:04 rikke493 Exp $';
BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,'Start.');
   --
   IF inserting THEN
      :NEW.DSSR_PRDCT_GRP_HST_ID := XXCT_DSSR_PRDCT_GRPS_HST_SEQ.NEXTVAL;
   END IF;
   --
   xxct_gen_debug_pkg.debug( c_trigger_name,'End.');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   --
   raise_application_error( -20001, Sqlerrm );
END;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_DSSR_PRUCT_GRPS_HST_BRT" ENABLE;

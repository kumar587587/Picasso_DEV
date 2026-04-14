--------------------------------------------------------
--  DDL for Trigger XXCT_PRODUCT_GROUPS_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_PRODUCT_GROUPS_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCT_PRODUCT_GROUPS"
  REFERENCING FOR EACH ROW
  DECLARE
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_PRODUCT_GROUPS_BIUD';
    L_CODE          VARCHAR2(5);
BEGIN
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
    IF inserting THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );
 		SELECT LPAD((MAX(SUBSTR(CODE,3))+1),3,0) INTO L_CODE FROM XXCT_PRODUCT_GROUPS;
 		:NEW.CODE := 'PG'||L_CODE;
     END IF;
     IF updating THEN
		NULL;
    END IF;
 	IF deleting THEN
		NULL;
    END IF;
     xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );
END XXCT_PRODUCT_GROUPS_BIUD;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_PRODUCT_GROUPS_BIUD" ENABLE;

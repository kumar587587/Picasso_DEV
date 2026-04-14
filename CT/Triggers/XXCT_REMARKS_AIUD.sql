--------------------------------------------------------
--  DDL for Trigger XXCT_REMARKS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_REMARKS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_REMARKS"
  REFERENCING FOR EACH ROW
  DECLARE
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCT_REMARKS_AIUD';
    l_new_values_string      VARCHAR2(32000);
    l_old_values_string      VARCHAR2(32000);
    l_sp_table_name          VARCHAR2(50) := 'spDossierRemarks';
    l_sp_pk_field            VARCHAR2(50) := 'REMARK_ID';
    L_PERSON_NAME            VARCHAR2(200);
    L_ACTION_TYPE            VARCHAR2(20);
BEGIN
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );
      BEGIN
        SELECT FULL_NAME INTO L_PERSON_NAME FROM xxct_persons_v WHERE PERSON_ID = :NEW.PERSON_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_PERSON_NAME := NULL;
      END;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting L_PERSON_NAME=='||L_PERSON_NAME );

      /*BEGIN
        SELECT DECODE(ACTION_TYPE,'INCREASE','INCREASE','DECREASE','DECREASE') INTO L_ACTION_TYPE FROM XXCT_DOSSIERS WHERE DOSSIER_ID = :NEW.DOSSIER_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_ACTION_TYPE := NULL;
      END;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting L_ACTION_TYPE=='||L_ACTION_TYPE );--*/

      l_new_values_string :=  '"'||:NEW.REMARK_ID                          ||'",'||
                              '"'||:NEW.DOSSIER_ID                         ||'",'||
                              '"'||:NEW.REMARK                             ||'",'||
                              '"'||TO_CHAR(:NEW.CREATION_DATE,'YYYY-MM-DD')||'T00:00:00",'||
                              '"'||L_PERSON_NAME                           ||'"';
   END IF;

   IF updating OR deleting THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );
      BEGIN
        SELECT FULL_NAME INTO L_PERSON_NAME FROM xxct_persons_v WHERE PERSON_ID = :OLD.PERSON_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_PERSON_NAME := NULL;
      END;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating L_PERSON_NAME=='||L_PERSON_NAME );

      /*BEGIN
        SELECT ACTION_TYPE INTO L_ACTION_TYPE FROM XXCT_DOSSIERS WHERE DOSSIER_ID = :OLD.DOSSIER_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_ACTION_TYPE := NULL;
      END;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating L_ACTION_TYPE=='||L_ACTION_TYPE);--*/

      l_old_values_string :=  '"'||:OLD.REMARK_ID                          ||'",'||
                              '"'||:OLD.DOSSIER_ID                         ||'",'||
                              '"'||:OLD.REMARK                             ||'",'||
                              '"'||TO_CHAR(:OLD.CREATION_DATE,'YYYY-MM-DD')||'T00:00:00",'||
                              '"'||L_PERSON_NAME                           ||'"';
    END IF;

    IF inserting THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_sp_table_name=='||l_sp_table_name );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_new_values_string=='||l_new_values_string );

        xxct_gen_rest_apis.insert_row
        ( p_table_name      => l_sp_table_name
        , p_key_values      => l_new_values_string
        , p_new_values      => l_new_values_string
        , p_effective_date  => NULL
        , p_overwrite       => NULL
        );

    END IF;

    IF updating THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_sp_table_name=='||l_sp_table_name );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );

        xxct_gen_rest_apis.update_row
        ( p_table_name     => l_sp_table_name
        , p_key_values     => l_new_values_string
        , p_apex_id        => :new.REMARK_ID
        , p_new_values     => l_new_values_string
        , p_old_values     => l_old_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => NULL
        , p_overwrite      => FALSE
        );

    END IF;

    IF deleting THEN
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting l_sp_table_name=='||l_sp_table_name );
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting l_old_values_string ='||l_old_values_string );

       xxct_gen_rest_apis.delete_row
       ( p_table_name    => l_sp_table_name
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string
       );
    END IF;

    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );
   apex_error.add_error (p_message            => sqlerrm,
                         p_display_location   => apex_error.c_inline_in_notification);
   RAISE;
END XXCT_REMARKS_AIUD;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_REMARKS_AIUD" ENABLE;

--------------------------------------------------------
--  DDL for Trigger XXCT_SPUSERDELEGATES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_SPUSERDELEGATES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON xxct_spusersdelegates
  REFERENCING FOR EACH ROW
  DECLARE
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCT_SPUSERDELEGATES_AIUD';
    l_new_values_string      VARCHAR2(32000);
    l_old_values_string      VARCHAR2(32000);
    l_api_return_value       VARCHAR2(32000);
    l_sp_table_name          VARCHAR2(50) := 'spUserDelegates';
    l_sp_pk_field            VARCHAR2(50) := 'PayeeID,RoleID,StartDate';
    l_role_key               xxct_spusersdelegates.roleID%TYPE;
    l_active_inactive        VARCHAR2(1);
    l_end_date               DATE;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );

      l_new_values_string :=  '"'||:new.PAYEEID                                          ||'",'||  --PayeeID
                              '"'||:new.ROLEID                                           ||'",'||  --Role
                              '"'||to_char(:new.startdate,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --StartDate
                              '"'||to_char(:new.enddate  ,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --EndDate
                              '""';
     xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string = '||l_new_values_string );
   END IF;
   IF updating OR deleting THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );

      l_old_values_string :=  '"'||:old.PAYEEID                                          ||'",'||  --PayeeID
                              '"'||:old.ROLEID                                           ||'",'||  --Role
                              '"'||to_char(:old.startdate,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --StartDate
                              '"'||to_char(:old.enddate  ,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --EndDate
                              '""';
    END IF;

    IF inserting THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_sp_table_name ='||l_sp_table_name );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_new_values_string ='||l_new_values_string );
        
        xxct_gen_rest_apis.insert_row
        ( p_table_name      => l_sp_table_name
        , p_key_values      => l_new_values_string
        , p_new_values      => l_new_values_string
        , p_effective_date  => NULL
        , p_overwrite       => NULL
        );
    END IF;
    
    IF updating THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );
        
        xxct_gen_rest_apis.update_row
        ( p_table_name     => l_sp_table_name
        , p_key_values     => l_new_values_string
        , p_apex_id        => :new.id
        , p_new_values     => l_new_values_string
        , p_old_values     => l_old_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => NULL
        , p_overwrite      => FALSE
        );
    
    END IF;

    IF deleting THEN
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
       xxct_gen_rest_apis.delete_row
       ( p_table_name    => l_sp_table_name
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string 
       );
    END IF;
    -----------Adding Below code for MWT-751-----------------
    IF inserting or updating or deleting THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'Call XXCT_CALL_ACTV_USER_WF_SCHD' );
        BEGIN
            XXCT_CALL_ACTV_USR_WF_SCLD_PKG.CALL_ACTV_USER_WF_SCHD;
        END;
     END IF;
     COMMIT;
     ------------End--------------
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );
   apex_error.add_error (p_message            => sqlerrm,
                         p_display_location   => apex_error.c_inline_in_notification);
   RAISE;
END XXCT_SPUSERDELEGATES_AIUD;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_SPUSERDELEGATES_AIUD" ENABLE;

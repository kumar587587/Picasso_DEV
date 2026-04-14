--------------------------------------------------------
--  DDL for Trigger XXCPC_SPUSERSDELEGATES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SPUSERSDELEGATES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON XXCPC_SPUSERSDELEGATES
  REFERENCING FOR EACH ROW
  DECLARE
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCPC_SPUSERSDELEGATES_AIUD';
    l_new_values_string      VARCHAR2(32000);
    l_old_values_string      VARCHAR2(32000);
    l_api_return_value       VARCHAR2(32000);
    l_sp_table_name          VARCHAR2(50) := 'spUserDelegates';
    l_sp_pk_field            VARCHAR2(50) := 'PayeeID,RoleID,StartDate';
    l_role_key               xxcpc_spusersdelegates.roleID%TYPE;
    l_active_inactive        VARCHAR2(1);
    l_end_date               DATE;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    xxcpc_gen_debug_pkg.debug_t(c_trigger_name,'(start)');

    IF inserting OR updating THEN
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );

        l_new_values_string :=  '"'||:new.PAYEEID                                          ||'",'||  --PayeeID
                                '"'||:new.ROLEID                                           ||'",'||  --Role
                                '"'||to_char(:new.startdate,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --StartDate
                                '"'||to_char(:new.enddate  ,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --EndDate   ;
                                '"'||:NEW.PAYEEID_REGULAR_USER                             ||'"' ;

        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string = '||l_new_values_string );
   END IF;

    IF updating OR deleting THEN
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );

        l_old_values_string :=  '"'||:old.PAYEEID                                          ||'",'||  --PayeeID
                                '"'||:old.ROLEID                                           ||'",'||  --Role
                                '"'||to_char(:old.startdate,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --StartDate
                                '"'||to_char(:old.enddate  ,'YYYY-MM-DD')||'T00:00:00'     ||'",'||  --EndDate   ;
                                '"'||:old.PAYEEID_REGULAR_USER                             ||'"' ;
    END IF;

    IF inserting THEN
        xxcpc_gen_rest_apis.insert_row 
            (p_table_name      => l_sp_table_name
            ,p_key_values      => l_new_values_string
            ,p_new_values      => l_new_values_string
            ,p_effective_date  => NULL
            ,p_overwrite       => NULL
            );
    END IF;

    IF updating THEN  
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );

        xxcpc_gen_rest_apis.update_row
            (p_table_name     => l_sp_table_name
            ,p_key_values     => l_new_values_string
            ,p_apex_id        => :new.id
            ,p_new_values     => l_new_values_string
            ,p_old_values     => l_old_values_string
            ,p_old_rowid      => :old.rowid
            ,p_effective_date => NULL
            ,p_overwrite      => FALSE
            );
    END IF;

    IF deleting THEN
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
        xxcpc_gen_rest_apis.delete_row
            (p_table_name    => l_sp_table_name
            ,p_key_values    => l_old_values_string
            ,p_old_values    => l_old_values_string
            );
    END IF;
    -----------Adding Below code for MWT-749-----------------
    IF inserting or updating or deleting THEN
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Call XXCPC_CALL_ACTV_USR_WF_SCLD_PKG' );
        BEGIN
            XXCPC_CALL_ACTV_USR_WF_SCLD_PKG.CALL_ACTV_USER_WF_SCHD;
        END;
     END IF;
     COMMIT;
     ------------End--------------
    xxcpc_gen_debug_pkg.debug_t(c_trigger_name,'(end)');

EXCEPTION
    WHEN OTHERS THEN 
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );   
        apex_error.add_error (p_message            => sqlerrm,
                              p_display_location   => apex_error.c_inline_in_notification);
    RAISE;

END XXCPC_SPUSERSDELEGATES_AIUD;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SPUSERSDELEGATES_AIUD" ENABLE;

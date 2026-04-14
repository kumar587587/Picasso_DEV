--------------------------------------------------------
--  DDL for Trigger XXCPC_USER_ROLES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_USER_ROLES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_USER_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCPC_USER_ROLES_AIUD';  
    l_new_values_string      VARCHAR2(32000);  
    l_old_values_string      VARCHAR2(32000);  
    l_api_return_value       VARCHAR2(32000);      
    l_sp_table_name          VARCHAR2(50) := 'spUserRole';  
    l_sp_pk_field            VARCHAR2(50) := 'PayeeID,Role,StartDate';  
    l_ruis_name              xxcpc_users.ruis_name%type;
    l_role_key               XXCPC_ROLES.role_key%type;
    l_active_inactive        VARCHAR2(1) := 'A';
    l_end_date               VARCHAR2(50);
    l_GrantedByRole          VARCHAR2(200) := '""';
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting OR updating THEN
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );   
      select  ruis_name
      into  l_ruis_name
      from  xxcpc_users
      where id = :new.user_id
      ;
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_ruis_name = '||l_ruis_name );   
      select  role_key
      into  l_role_key
      from  xxcpc_roles
      where id = :new.role_id
      ;
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_key = '||l_role_key );   
      IF :new.composed_role_id is not null then
          SELECT  '"'||role_key||'"'
          INTO  l_GrantedByRole
          FROM  xxcpc_roles
          WHERE id = :new.composed_role_id
          ;
      END IF;  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_key = '||l_role_key );         
      --
      l_end_date  := '"'||to_char(:new.end_date ,'YYYY-MM-DD')||'T00:00:00"';
      l_new_values_string :=  '"'|| l_ruis_name                                       ||'",'||  --PayeeID
                              '"'|| l_role_key                                        ||'",'||  --Role
                              '"'|| :new.active_flag                                  ||'",'||  --Active
                              '"'|| to_char(:new.start_date,'YYYY-MM-DD')||'T00:00:00'||'",'||  --StartDate  
                              '' || l_end_date                                        ||','||  --EndDate  
                              '' || l_GrantedByRole                                  ;      --GrantedByRole     
   END IF;
   IF updating OR deleting THEN
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );   
      --
      IF :old.end_date IS NULL THEN
          l_end_date  := null;
      ELSE    
          l_end_date  := '"'||to_char( :old.end_date     ,'YYYY-MM-DD')||'T00:00:00"';
      END IF;    
      --      
      l_GrantedByRole:= '""';  
      IF :old.composed_role_id is not null then
          SELECT  '"'||role_key||'"'
          INTO  l_GrantedByRole
          FROM  xxcpc_roles
          WHERE id = :old.composed_role_id
          ;
      END IF;    
      l_old_values_string :=  '"'|| l_ruis_name                                       ||'",'||  --PayeeID
                              '"'|| l_role_key                                        ||'",'||  --Role
                              '"'|| :old.active_flag                                  ||'",'||  --Active
                              '"'|| to_char(:old.start_date,'YYYY-MM-DD')||'T00:00:00'||'",'||  --StartDate  
                              '' || l_end_date                                        ||','||  --EndDate  
                              '' || l_GrantedByRole                                         --GrantedByRole    
                               ;  
    END IF;
    --
    IF inserting THEN       
        xxcpc_gen_rest_apis.insert_row
        ( p_table_name      => l_sp_table_name
        , p_key_values      => l_new_values_string
        , p_new_values      => l_new_values_string
        , p_effective_date  => NULL
        , p_overwrite       => NULL
        );            
    END IF;
    --
    IF updating THEN  
        --
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );                                                        
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );                                                        
        xxcpc_gen_rest_apis.update_row 
        ( p_table_name     => l_sp_table_name 
        , p_key_values     => l_new_values_string
        , p_apex_id        => :new.id  
        , p_new_values     => l_new_values_string
        , p_old_values     => l_old_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => null
        , p_overwrite      => false
        );  
        --  
    END IF;  
    --  
    IF deleting THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
       xxcpc_gen_rest_apis.delete_row
       ( p_table_name    => l_sp_table_name 
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string 
       );  
    END IF;
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Before (end)' );
    -----------Adding Below code for MWT-749-----------------
    IF inserting or updating or deleting THEN
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Call XXCPC_CALL_ACTV_USR_WF_SCLD_PKG' );
        BEGIN
            XXCPC_CALL_ACTV_USR_WF_SCLD_PKG.CALL_ACTV_USER_WF_SCHD;
        END;
     END IF;
     COMMIT;
     ------------End--------------
     --  
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );       
EXCEPTION 
WHEN OTHERS THEN 
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );   
   apex_error.add_error (p_message            => sqlerrm,
                         p_display_location   => apex_error.c_inline_in_notification);
   RAISE;
END XXCPC_USER_ROLES_AIUD;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_USER_ROLES_AIUD" ENABLE;

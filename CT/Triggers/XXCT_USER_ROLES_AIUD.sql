--------------------------------------------------------
--  DDL for Trigger XXCT_USER_ROLES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_USER_ROLES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_USER_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCT_USER_ROLES_AIUD';  
    l_new_values_string      VARCHAR2(32000);  
    l_old_values_string      VARCHAR2(32000);  
    l_api_return_value       VARCHAR2(32000);      
    l_sp_table_name          VARCHAR2(50) := 'spUserRole';  
    l_sp_pk_field            VARCHAR2(50) := 'PayeeID,Role,StartDate';  
    l_ruis_name              xxct_users.ruis_name%TYPE;
    l_role_key               xxct_roles.role_key%TYPE;
    l_active_inactive        VARCHAR2(1);
    l_end_date               DATE;
    l_GrantedByRole          VARCHAR2(200) := '""';  
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );   
      SELECT  ruis_name
      INTO  l_ruis_name
      FROM  xxct_users
      WHERE id = :new.user_id
      ;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_ruis_name = '||l_ruis_name );   
      SELECT  role_key
      INTO  l_role_key
      FROM  xxct_roles
      WHERE id = :new.role_id
      ;
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_key = '||l_role_key );   
      IF :new.composed_role_id is not null then
          SELECT  '"'||role_key||'"'
          INTO  l_GrantedByRole
          FROM  xxct_roles
          WHERE id = :new.composed_role_id
          ;
      END IF;    
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_key = '||l_role_key );         
      --
      IF :new.active_flag = 'Y' THEN
         l_active_inactive := 'A';
      ELSE
         l_active_inactive:= 'I';
      END IF;
      IF :new.end_date IS NULL THEN
          l_end_date  := TO_DATE('31-12-9998','DD-MM-YYYY');
      ELSE    
         l_end_date  := :new.end_date;
      END IF;    
      l_new_values_string :=  '"'|| l_ruis_name                                       ||'",'||  --PayeeID
                              '"'|| l_role_key                                        ||'",'||  --Role
                              '"'|| l_active_inactive                                 ||'",'||  --Active
                              '"'|| to_char(:new.start_date,'YYYY-MM-DD')||'T00:00:00'||'",'||  --StartDate  
                              '"'|| to_char(l_end_date     ,'YYYY-MM-DD')||'T00:00:00'||'",'||  --EndDate  
                               ''|| l_GrantedByRole                                  ;      --GrantedByRole   ;  
   END IF;
   IF updating OR deleting THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );   
      IF :old.active_flag = 'Y' THEN
         l_active_inactive := 'A';
      ELSE
         l_active_inactive:= 'I';
      END IF;
      --
      IF :old.end_date IS NULL THEN
          l_end_date  := TO_DATE('31-12-9998','DD-MM-YYYY');
      ELSE
         l_end_date  := :old.end_date;
      END IF;    
      --      
      l_GrantedByRole:= '""';  
      IF :old.composed_role_id is not null then
          SELECT  '"'||role_key||'"'
          INTO  l_GrantedByRole
          FROM  xxct_roles
          WHERE id = :old.composed_role_id;
          
      END IF;    

      l_old_values_string :=  '"'|| l_ruis_name                                        ||'",'||  --PayeeID
                              '"'|| l_role_key                                         ||'",'||  --Role
                              '"'|| l_active_inactive                                  ||'",'||  --Active
                              '"'|| to_char(:old.start_date,'YYYY-MM-DD')||'T00:00:00' ||'",'||  --StartDate  
                              '"'|| to_char(l_end_date     ,'YYYY-MM-DD')||'T00:00:00' ||'",'||  --EndDate  
                               ''|| l_GrantedByRole                                    ;     --GrantedByRole   ;  
                               
    END IF;
    --
    IF inserting THEN       
        xxct_gen_rest_apis.insert_row
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
    --  
    IF deleting THEN  
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
       xxct_gen_rest_apis.delete_row
       ( p_table_name    => l_sp_table_name 
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string 
       );
    END IF;
    xxct_gen_debug_pkg.debug_t( c_trigger_name, 'Before (end)' );
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
END XXCT_USER_ROLES_AIUD;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_USER_ROLES_AIUD" ENABLE;

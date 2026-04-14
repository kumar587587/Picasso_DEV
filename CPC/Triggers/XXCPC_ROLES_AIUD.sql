--------------------------------------------------------
--  DDL for Trigger XXCPC_ROLES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_ROLES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_ROLES_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value       VARCHAR2(32000);      
    l_pl_table_name          VARCHAR2(50) := 'plIAMRole';  
    l_pl_pk_field            VARCHAR2(50) := 'ID';  

BEGIN       
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting or updating THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );   
      l_new_values_string :=  '"'|| :new.role_key                ||'",'||  --RoleId
                              '"'|| :new.role_name               ||'",'||  --AccessLevelName
                              '"'|| :new.INDICATOR_WORKFLOW_ROLE ||'",'||  --IndicatorWorkflowRole
                              '"'|| 'CPC'                        ||'",'||  --Model
                             '""'|| ','                          ||        --PartnerType
                              '' || '0'                          ||',' ||   --ApprovalLevels   
                              '"'|| :new.ADMINROLE          ||'"'  -- ADMINROLE added TechM team agenst MWT-736
                               ;  

   END IF;        
   IF updating or deleting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' );   
      l_old_values_string :=  '"'|| :old.role_key                ||'",'||  --RoleId
                              '"'|| :old.role_name               ||'",'||  --AccessLevelName
                              '"'|| :new.INDICATOR_WORKFLOW_ROLE ||'",'||  --IndicatorWorkflowRole
                              '"'|| 'CPC'                        ||'",'||  --Model
                             '""'|| ','                           ||        --PartnerType
                              '' || '0'                          ||',' ||   --ApprovalLevels
                              '"'|| :old.ADMINROLE          ||'"'  -- ADMINROLE added TechM team agenst MWT-736
                               ;  
   END IF;        
   -- 
   IF inserting THEN       
        xxcpc_gen_rest_apis.insert_row
        ( p_table_name      => l_pl_table_name
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
        ( p_table_name     => l_pl_table_name 
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
       ( p_table_name    => l_pl_table_name 
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string 
       );  
    END IF; 
    --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
EXCEPTION 
WHEN OTHERS THEN 
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );   
   apex_error.add_error (p_message            => sqlerrm,
                         p_display_location   => apex_error.c_inline_in_notification);
   RAISE;
END xxcpc_roles_aiud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_ROLES_AIUD" ENABLE;

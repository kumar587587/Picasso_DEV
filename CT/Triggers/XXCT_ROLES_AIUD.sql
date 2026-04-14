--------------------------------------------------------
--  DDL for Trigger XXCT_ROLES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_ROLES_AIUD" 
  AFTER INSERT OR UPDATE ON "WKSP_XXCT"."XXCT_ROLES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCT_ROLES_AIUD';  
    l_new_values_string      VARCHAR2(32000);  
    l_old_values_string      VARCHAR2(32000);  
    l_api_return_value       VARCHAR2(32000);      
    l_pl_table_name          VARCHAR2(50) := 'plIAMRole';  
    l_pl_pk_field            VARCHAR2(50) := 'ID';  
    l_approvallevels         VARCHAR2(20) := '0';  
    l_partnertype            VARCHAR2(50);  
BEGIN 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   --
   IF substr( :new.role_key, length(:new.role_key)-1,1) = 'L' THEN
      l_approvallevels      := substr( :new.role_key, length(:new.role_key)-0,1);       
   END IF;
   --
   IF instr(:new.role_key, 'RETAIL' ) > 0 THEN
      l_partnertype  := 'RETAIL';
   END IF;   
   --
   IF instr(:new.role_key, 'DIGITAL') > 0 THEN
      l_partnertype  := 'DIGITAL';
   END IF;   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_approvallevels = '||l_approvallevels );   
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_partnertype    = '||l_partnertype );   
   --
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );   
      l_new_values_string :=  '"'|| :new.role_key                ||'",'||  --RoleId
                              '"'|| :new.role_name               ||'",'||  --AccessLevelName
                              '"'|| :new.indicator_workflow_role ||'",'||  --IndicatorWorkflowRole
                              '"'|| :new.model                   ||'",'||  --Model
                              '"'|| l_partnertype                ||'",'||  --PartnerType
                              '' || l_approvallevels             ||',' || --ApprovalLevels 
                              '"'|| :new.ADMINROLE          ||'"'  -- ADMINROLE added TechM team agenst MWT-736
                               ;  
   END IF;
   IF updating OR deleting THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );   
      l_old_values_string :=  '"'|| :old.role_key                ||'",'||  --RoleId
                              '"'|| :old.role_name               ||'",'||  --AccessLevelName
                              '"'|| :old.indicator_workflow_role ||'",'||  --IndicatorWorkflowRole
                              '"'|| :old.model                   ||'",'||  --Model
                              '"'|| l_partnertype                ||'",'||  --PartnerType                                                            
                              '' || l_approvallevels             ||',' || --ApprovalLevels 
                              '"'|| :old.ADMINROLE          ||'"'  -- ADMINROLE added TechM team agenst MWT-736
                               ;  
    END IF;
    --
    IF inserting THEN       
        xxct_gen_rest_apis.insert_row
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
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );                                                        
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );                                                        
        xxct_gen_rest_apis.update_row 
        ( p_table_name     => l_pl_table_name 
        , p_key_values     => l_new_values_string
        , p_apex_id        => :new.id  
        , p_new_values     => l_new_values_string
        , p_old_values     => l_old_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => NULL
        , p_overwrite      => FALSE
        );  
        --  
    END IF;  
    --  
    IF deleting THEN  
       xxct_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
       xxct_gen_rest_apis.delete_row
       ( p_table_name    => l_pl_table_name 
       , p_key_values    => l_old_values_string
       , p_old_values    => l_old_values_string 
       );  
    END IF;     
     --  
    xxct_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );       
EXCEPTION 
WHEN OTHERS THEN 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||sqlerrm );   
   apex_error.add_error (p_message            => sqlerrm,
                         p_display_location   => apex_error.c_inline_in_notification);
   RAISE;
END xxct_roles_aiud;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_ROLES_AIUD" ENABLE;

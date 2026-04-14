--------------------------------------------------------
--  DDL for Trigger XXCT_SPCTWFLEVELS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_SPCTWFLEVELS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_SPCTWFLEVELS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXCT_SPCTWFLEVELS_AIUD';  
    l_new_values_string      VARCHAR2(32000);  
    l_old_values_string      VARCHAR2(32000);  
    l_api_return_value       VARCHAR2(32000);      
    l_sp_table_name          VARCHAR2(50) := 'spCTWFLevels';  
    l_sp_pk_field            VARCHAR2(150) := 'SwimLane,BonusPartnerType,DossierType,ActionType,Level';  
    l_role_key               xxct_spusersdelegates.roleID%TYPE;
    l_active_inactive        VARCHAR2(1);
    l_end_date               DATE;
    l_role_from              VARCHAR2(200);
    l_role_from_nr           number;
    l_role_to                VARCHAR2(200);
    l_role_to_nr             number;  
    l_dossiertype            VARCHAR2(200);
    l_bonuspartnertype       VARCHAR2(200); 
    l_actiontype             VARCHAR2(200);       
BEGIN 
   xxct_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' ); 
      --
      /*SELECT  role_key
      INTO  l_role_from
      FROM  xxct_roles
      WHERE id = :new.RoleApprovalLevelFrom;*/
      
      SELECT to_number( substr(role_key,-1)) INTO l_role_from FROM xxct_roles WHERE ID = :NEW.RoleApprovalLevelFrom;---Added by TechM Team for MWT-634
      
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_from = '||l_role_from );  
      l_role_from_nr := substr( l_role_from, -1,1);
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_from_nr = '||l_role_from_nr );   
      --
      /*SELECT  role_key
      INTO  l_role_to
      FROM  xxct_roles
      WHERE id = :new.RoleApprovalLevelFrom;*/ --Commented by TechM Team for MWT-634
      
      SELECT to_number( substr(role_key,-1)) INTO l_role_to FROM xxct_roles WHERE ID = :NEW.RoleApprovalLevelTo; --added by TechM Team for MWT-634
      
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_to = '||l_role_to );  
      l_role_from_nr := substr( l_role_from, -1,1);
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_to_nr = '||l_role_to_nr );        
      --
      SELECT code
      into l_dossiertype
      from xxct_lookup_values
      where lookup_type ='DOSSIER_TYPES'
      and id = :new.dossiertype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_dossiertype = '||l_dossiertype ); 
      --
      SELECT code
      into l_bonuspartnertype
      from xxct_lookup_values
      where lookup_type ='BONUSPARTNER_TYPES'
      and id = :new.bonuspartnertype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_bonuspartnertype = '||l_bonuspartnertype );       
      --
      SELECT code
      into l_actiontype
      from xxct_lookup_values
      where lookup_type ='ACTION_TYPES'
      and id = :new.actiontype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_actiontype = '||l_actiontype );       

      l_new_values_string :=  '"' ||:new.swimlane                                        ||'",' || --SwimLane
                              '"'||l_bonuspartnertype                                    ||'",'|| --BonusPartnerType
                              '"'||l_dossiertype                                         ||'",'|| --DossierType 
                              '"'||l_actiontype                                          ||'",'|| --ActionType   
                              '"' ||:new.approvallevel                                   ||'",' || --Level
                              '"' ||to_char(:new.minamount             )                 ||'",' || --MinAmount
                              '"' ||to_char(:new.maxamount             )                 ||'",' || --MaxAmount
                              '"' ||l_role_from                                          ||'",' || --RoleApprovalLevelFrom
                              '"' ||l_role_to                                            ||'",' || --RoleApprovalLevelTo
                              '"'||:new.Description                                      ||'"';   --Description
      --                         
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string = '||l_new_values_string );                         
   END IF;
   --
   IF updating OR deleting THEN
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'IF UPDATING OR DELETING' );   
      
    /*  SELECT  role_key
      INTO  l_role_from
      FROM  xxct_roles
      WHERE id = :old.RoleApprovalLevelFrom;*/  --Commented by TechM Team for MWT-634
           
      SELECT to_number( substr(role_key,-1)) INTO l_role_from FROM xxct_roles WHERE ID = :OLD.RoleApprovalLevelFrom;  ---Added by TechM Team for MWT-634
      
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_from = '||l_role_from );  
      l_role_from_nr := substr( l_role_from, -1,1);
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_from_nr = '||l_role_from_nr );   
      --
      /*SELECT  role_key
      INTO  l_role_to
      FROM  xxct_roles
      WHERE id = :old.RoleApprovalLevelFrom;*/---Commented by TechM Team for MWT-634
      
    SELECT to_number( substr(role_key,-1)) INTO l_role_to FROM xxct_roles WHERE ID = :OLD.RoleApprovalLevelTo; --Added by TechM Team for MWT-634
      
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_to = '||l_role_to );  
      l_role_from_nr := substr( l_role_from, -1,1);
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_role_to_nr = '||l_role_to_nr );        
      --
      SELECT code
      into l_dossiertype
      from xxct_lookup_values
      where lookup_type ='DOSSIER_TYPES'
      and id = :old.dossiertype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_dossiertype = '||l_dossiertype ); 
      --
      SELECT code
      into l_bonuspartnertype
      from xxct_lookup_values
      where lookup_type ='BONUSPARTNER_TYPES'
      and id = :old.bonuspartnertype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_bonuspartnertype = '||l_bonuspartnertype );       
      --
      SELECT code
      into l_actiontype
      from xxct_lookup_values
      where lookup_type ='ACTION_TYPES'
      and id = :old.actiontype_id
      ;  
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_actiontype = '||l_actiontype );       

      --        
      l_old_values_string :=  '"' ||:old.swimlane                                        ||'",' || --SwimLane
                              '"'||l_bonuspartnertype                                    ||'",'|| --BonusPartnerType
                              '"'||l_dossiertype                                         ||'",'|| --DossierType 
                              '"'||l_actiontype                                          ||'",'|| --ActionType   
                              '"' ||:old.approvallevel                                   ||'",' || --Level
                              '"' ||to_char(:old.minamount             )                 ||'",' || --MinAmount
                              '"' ||to_char(:old.maxamount             )                 ||'",' || --MaxAmount
                              '"' ||l_role_from                                          ||'",' || --RoleApprovalLevelFrom
                              '"' ||l_role_to                                            ||'",' || --RoleApprovalLevelTo
                              '"'||:old.Description                                      ||'"';   --Description
      --                         
      xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string = '||l_new_values_string );          
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
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string = 204'||l_new_values_string );
        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string = 205'||l_old_values_string );
        
        xxct_gen_rest_apis.update_row 
        ( p_table_name     => l_sp_table_name 
        , p_key_values     => l_new_values_string
        , p_apex_id        => :old.id  
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
       ( p_table_name    => l_sp_table_name 
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
END XXCT_SPCTWFLEVELS_AIUD;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_SPCTWFLEVELS_AIUD" ENABLE;

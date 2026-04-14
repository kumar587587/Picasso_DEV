--------------------------------------------------------
--  DDL for Trigger XXPM_CONTACTS_2TV_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_CONTACTS_2TV_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXPM"."XXPM_CONTACTS"
  REFERENCING FOR EACH ROW
DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXPM_CONTACTS_2TV_AIUD';  
    l_count                  NUMBER;
    l_stm                    VARCHAR2(30000);
    l_partner_classification VARCHAR2(30);
    l_partner_type           VARCHAR2(30);
    l_indicator_in_ex        VARCHAR2(30);
    l_partner_name           VARCHAR2(3000);
    l_partner_vcode          VARCHAR2(30);
    l_end_date               date;
    c_url                    VARCHAR2(200) := 'contacts/';
    l_chain_id               NUMBER;
    --
BEGIN       
--   xxpm_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   IF inserting OR updating THEN
       select partner_classification  ,  partner_type,   indicator_in_ex,   partner_name,   partner_vcode,   end_date,CHAIN_ID
       into   l_partner_classification,l_partner_type, l_indicator_in_ex, l_partner_name, l_partner_vcode, l_end_date,l_chain_id
       from xxpm_partners
       where partner_id = :new.partner_id
       ;
  --     xxpm_gen_debug_pkg.debug_t( c_trigger_name, ':NEW.PARTNER_ID = '||:NEW.PARTNER_ID ); 
   else
       select partner_classification  ,  partner_type,   indicator_in_ex,   partner_name,   partner_vcode,   end_date,CHAIN_ID
       into   l_partner_classification,l_partner_type, l_indicator_in_ex, l_partner_name, l_partner_vcode, l_end_date,l_chain_id
       from xxpm_partners
       where partner_id = :old.partner_id
       ;
--       xxpm_gen_debug_pkg.debug_t( c_trigger_name, ':OLD.PARTNER_ID = '||:OLD.PARTNER_ID ); 
   end if;
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_partner_classification = ' || l_partner_classification);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_partner_type           = ' || l_partner_type);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_indicator_in_ex        = ' || l_indicator_in_ex);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_partner_name           = ' || l_partner_name);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_partner_vcode          = ' || l_partner_vcode);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_end_date               = ' || l_end_date);
--   xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_chain_id               = ' || l_chain_id);
   --
   IF l_partner_classification in (1,5,8,9)  then
     IF (l_chain_id <> 22896 OR l_chain_id IS NULL) THEN
       if   --l_partner_type                    = 'M'  -- deactivated on 01-10-2024
            l_indicator_in_ex                 = 'E' 
       and  nvl(l_end_date,sysdate+10000)     > TO_DATE('01-01-2022','DD-MM-YYYY')  
       and  upper(l_partner_name)             NOT LIKE '%IVR%'   
       and  upper(l_partner_name)             NOT LIKE '%TEST%'  
       and  upper(l_partner_vcode)            NOT LIKE 'AA%'     
       then 
          IF inserting OR updating THEN
             xxpm_gen_debug_pkg.debug_t( c_trigger_name, 'IF inserting OR updating' );   
             l_stm := '{';
             l_stm := l_stm||' "partner_id":"'||:new.PARTNER_ID||'"';
             l_stm := l_stm||',"contact_id":"'||:new.CONTACT_ID||'"';
             l_stm := l_stm||',"contact_id_salesforce":"'||:new.CONTACT_ID_SALESFORCE||'"';
             l_stm := l_stm||',"contact_first_name":"'||:new.CONTACT_FIRST_NAME||'"';
             l_stm := l_stm||',"contact_initials":"'||:new.CONTACT_INITIALS||'"';
             l_stm := l_stm||',"contact_prefix":"'||:new.CONTACT_PREFIX||'"';
             l_stm := l_stm||',"contact_last_name":"'||:new.CONTACT_LAST_NAME||'"';
             l_stm := l_stm||',"contact_title":"'||:new.CONTACT_TITLE||'"';
             l_stm := l_stm||',"contact_phone_number":"'||:new.CONTACT_PHONE_NUMBER||'"';
             l_stm := l_stm||',"contact_phone_number_mobile":"'||:new.CONTACT_PHONE_NUMBER_MOBILE||'"';
             if :new.contact_date_of_birth is null then
                l_stm := l_stm||',"contact_date_of_birth":null';
             else
                l_stm := l_stm||',"contact_date_of_birth":"'||replace(to_char(:new.contact_date_of_birth,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
             end if;   
             l_stm := l_stm||',"contact_email_address":"'||:new.CONTACT_EMAIL_ADDRESS||'"';
             l_stm := l_stm||',"contact_type":"'||:new.CONTACT_TYPE||'"';
             l_stm := l_stm||',"contact_type_other":"'||:new.CONTACT_TYPE_OTHER||'"';
             l_stm := l_stm||',"contact_function":"'||:new.CONTACT_FUNCTION||'"';
             l_stm := l_stm||',"contact_remarks":"'||:new.CONTACT_REMARKS||'"';
             l_stm := l_stm||',"contact_active_indicator":"'||:new.CONTACT_ACTIVE_INDICATOR||'"';
             l_stm := l_stm||',"creation_date":"'||replace(to_char(:new.creation_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
             l_stm := l_stm||',"created_by":"'||:new.CREATED_BY||'"';
             l_stm := l_stm||',"last_update_date":"'||replace(to_char(:new.last_update_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
             l_stm := l_stm||',"last_updated_by":"'||:new.LAST_UPDATED_BY||'"';
             l_stm := l_stm||'}';
--             xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_stm  = ' ||l_stm);   
             --
          END IF;
          --
          IF inserting THEN
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'inserting :new.contact_id = '||:new.contact_id);
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url
              , p_method  => 'POST'
              , p_body    => l_stm
              )
              ;
          ELSIF updating THEN
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'updating :new.contact_id = '||:new.contact_id);
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url||:old.contact_id
              , p_method  => 'PUT'
              , p_body    => l_stm
              )
              ;
          ELSIF deleting THEN
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'deleting :old.contact_id = '||:old.contact_id);
              l_stm := '{';
              l_stm := l_stm||' "partner_id":"'||:old.PARTNER_ID||'"';
              l_stm := l_stm||',"contact_id":"'||:old.CONTACT_ID||'"';
              l_stm := l_stm||',"contact_id_salesforce":"'||:old.CONTACT_ID_SALESFORCE||'"';
              l_stm := l_stm||',"contact_first_name":"'||:old.CONTACT_FIRST_NAME||'"';
              l_stm := l_stm||',"contact_initials":"'||:old.CONTACT_INITIALS||'"';
              l_stm := l_stm||',"contact_prefix":"'||:old.CONTACT_PREFIX||'"';
              l_stm := l_stm||',"contact_last_name":"'||:old.CONTACT_LAST_NAME||'"';
              l_stm := l_stm||',"contact_title":"'||:old.CONTACT_TITLE||'"';
              l_stm := l_stm||',"contact_phone_number":"'||:old.CONTACT_PHONE_NUMBER||'"';
              l_stm := l_stm||',"contact_phone_number_mobile":"'||:old.CONTACT_PHONE_NUMBER_MOBILE||'"';
              if :old.contact_date_of_birth is null then
                 l_stm := l_stm||',"contact_date_of_birth":null';
              else
                 l_stm := l_stm||',"contact_date_of_birth":"'||replace(to_char(:old.contact_date_of_birth,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
              end if;   
              l_stm := l_stm||',"contact_email_address":"'||:old.CONTACT_EMAIL_ADDRESS||'"';
              l_stm := l_stm||',"contact_type":"'||:old.CONTACT_TYPE||'"';
              l_stm := l_stm||',"contact_type_other":"'||:old.CONTACT_TYPE_OTHER||'"';
              l_stm := l_stm||',"contact_function":"'||:old.CONTACT_FUNCTION||'"';
              l_stm := l_stm||',"contact_remarks":"'||:old.CONTACT_REMARKS||'"';
              l_stm := l_stm||',"contact_active_indicator":"'||:old.CONTACT_ACTIVE_INDICATOR||'"';
              l_stm := l_stm||',"creation_date":"'||replace(to_char(:old.creation_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
              l_stm := l_stm||',"created_by":"'||:old.CREATED_BY||'"';
              l_stm := l_stm||',"last_update_date":"'||replace(to_char(:old.last_update_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
              l_stm := l_stm||',"last_updated_by":"'||:old.LAST_UPDATED_BY||'"';
              l_stm := l_stm||'}';
--              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_stm  = ' ||l_stm);   
              --
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url||:old.contact_id
              , p_method  => 'DELETE'
              , p_body    => l_stm
              )
             ;
          END IF;
          --
        END IF;   
    END IF;--END OF l_chain_id CONDITION
    END IF; --End of l_partner_classification condition
    --  
--    xxpm_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
EXCEPTION 
WHEN OTHERS THEN 
   XXPM_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||SQLERRM );   
   apex_error.add_error (p_message            => SQLERRM, p_display_location   => apex_error.c_inline_in_notification);
   raise;
END XXPM_CONTACTS_2TV_AIUD;
/
ALTER TRIGGER "WKSP_XXPM"."XXPM_CONTACTS_2TV_AIUD" ENABLE;

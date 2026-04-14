--------------------------------------------------------
--  DDL for Trigger XXPM_ADDRESSES_2TV_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_ADDRESSES_2TV_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXPM"."XXPM_ADDRESSES"
  REFERENCING FOR EACH ROW
DECLARE     
    c_trigger_name  CONSTANT VARCHAR2(50):= 'XXPM_ADDRESSES_2TV_AIUD';  
    l_count                  NUMBER;
    l_stm                    VARCHAR2(30000);
    l_partner_classification VARCHAR2(30);
    l_partner_type           VARCHAR2(30);
    l_indicator_in_ex        VARCHAR2(30);
    l_partner_name           VARCHAR2(3000);
    l_partner_vcode          VARCHAR2(30);
    l_end_date               date;
    c_url                    VARCHAR2(200) := 'addresses/';
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
--       xxpm_gen_debug_pkg.debug_t( c_trigger_name, ':NEW.PARTNER_ID = '||:NEW.PARTNER_ID ); 
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
             l_stm := l_stm|| '"partner_id":"'||:new.PARTNER_ID||'"';
             l_stm := l_stm||',"address_id":"'||:new.ADDRESS_ID||'"';
             l_stm := l_stm||',"address_street":"'||:new.ADDRESS_STREET||'"';
             l_stm := l_stm||',"address_house_number":"'||:new.ADDRESS_HOUSE_NUMBER||'"';
             l_stm := l_stm||',"address_house_number_suffix":"'||:new.ADDRESS_HOUSE_NUMBER_SUFFIX||'"';
             l_stm := l_stm||',"address_zip_code":"'||:new.ADDRESS_ZIP_CODE||'"';
             l_stm := l_stm||',"address_residence":"'||:new.ADDRESS_RESIDENCE||'"';
             l_stm := l_stm||',"address_type":"'||:new.ADDRESS_TYPE||'"';
             l_stm := l_stm||',"address_type_other":"'||:new.ADDRESS_TYPE_OTHER||'"';
             l_stm := l_stm||',"postbus":"'||:new.POSTBUS||'"';
             l_stm := l_stm||',"address_country":"'||:new.ADDRESS_COUNTRY||'"';
             l_stm := l_stm||',"address_function":"'||:new.ADDRESS_FUNCTION||'"';
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
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'inserting :new.address_id = '||:new.address_id);
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url
              , p_method  => 'POST'
              , p_body    => l_stm
              )
              ;
          ELSIF updating THEN
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'updating :new.address_id = '||:new.address_id);
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url||:old.address_id
              , p_method  => 'PUT'
              , p_body    => l_stm
              )
              ;
          ELSIF deleting THEN
              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'deleting :old.address_id = '||:old.address_id);
              l_stm := '{';
              l_stm := l_stm|| '"partner_id":"'||:old.PARTNER_ID||'"';
              l_stm := l_stm||',"address_id":"'||:old.ADDRESS_ID||'"';
              l_stm := l_stm||',"address_street":"'||:old.ADDRESS_STREET||'"';
              l_stm := l_stm||',"address_house_number":"'||:old.ADDRESS_HOUSE_NUMBER||'"';
              l_stm := l_stm||',"address_house_number_suffix":"'||:old.ADDRESS_HOUSE_NUMBER_SUFFIX||'"';
              l_stm := l_stm||',"address_zip_code":"'||:old.ADDRESS_ZIP_CODE||'"';
              l_stm := l_stm||',"address_residence":"'||:old.ADDRESS_RESIDENCE||'"';
              l_stm := l_stm||',"address_type":"'||:old.ADDRESS_TYPE||'"';
              l_stm := l_stm||',"address_type_other":"'||:old.ADDRESS_TYPE_OTHER||'"';
              l_stm := l_stm||',"postbus":"'||:old.POSTBUS||'"';
              l_stm := l_stm||',"address_country":"'||:old.ADDRESS_COUNTRY||'"';
              l_stm := l_stm||',"address_function":"'||:old.ADDRESS_FUNCTION||'"';
              l_stm := l_stm||',"creation_date":"'||replace(to_char(:old.creation_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
              l_stm := l_stm||',"created_by":"'||:old.CREATED_BY||'"';
              l_stm := l_stm||',"last_update_date":"'||replace(to_char(:old.last_update_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
              l_stm := l_stm||',"last_updated_by":"'||:old.LAST_UPDATED_BY||'"';
              l_stm := l_stm||'}';
--              xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_stm  = ' ||l_stm);                  
              xxpm_gen_rest_apis.generic_apex_request   
              ( p_url     => c_url||:old.address_id
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
END XXPM_ADDRESSES_2TV_AIUD;
/
ALTER TRIGGER "WKSP_XXPM"."XXPM_ADDRESSES_2TV_AIUD" ENABLE;

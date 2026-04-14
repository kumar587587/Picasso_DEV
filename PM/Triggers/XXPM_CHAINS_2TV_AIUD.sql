--------------------------------------------------------
--  DDL for Trigger XXPM_CHAINS_2TV_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXPM"."XXPM_CHAINS_2TV_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXPM"."XXPM_CHAINS"
  REFERENCING FOR EACH ROW
DECLARE
    c_trigger_name CONSTANT VARCHAR2(50) := 'XXPM_CHAINS_2TV_AIUD';
    l_stm                   VARCHAR2(30000);
    c_url                   VARCHAR2(200) := 'chains/';
BEGIN
--    xxpm_gen_debug_pkg.debug_t(c_trigger_name, '(start)');
IF :NEW.sub_sales_channel           != 'VAR partner' THEN        
    IF inserting or updating THEN

        l_stm := '{';
        l_stm := l_stm||'"chain_id":"'                     ||:NEW.chain_id                       ||'"';
        l_stm := l_stm||',"chain_name":"'                  ||:NEW.chain_name                     ||'"' ;
        l_stm := l_stm||',"indicator_in_ex":"'             ||:NEW.indicator_in_ex                ||'"';
        l_stm := l_stm||',"center_code":"'                 ||:NEW.center_code                    ||'"';
        l_stm := l_stm||',"sales_channel_distribution":"'  ||:NEW.sales_channel_distribution     ||'"' ;
        l_stm := l_stm||',"sales_channel":"'               ||:NEW.sales_channel                  ||'"' ;
        l_stm := l_stm||',"sub_sales_channel":"'           ||:NEW.sub_sales_channel              ||'"' ;
        l_stm := l_stm||',"channel_mix":"'                 ||:NEW.channel_mix                    ||'"' ;
        l_stm := l_stm||',"creation_date":"'               ||replace(to_char(:new.creation_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
        l_stm := l_stm||',"created_by":"'                  ||:NEW.created_by||'"';
        l_stm := l_stm||',"last_update_date":"'            ||replace(to_char(:new.last_update_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
        l_stm := l_stm||',"last_updated_by":"'             ||:NEW.last_updated_by||'"';
        l_stm := l_stm||'}';
--        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_stm  = ' ||l_stm);   
    END IF;
    --
    IF inserting THEN
        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'inserting :new.chain_id = '||:new.chain_id);
        xxpm_gen_rest_apis.generic_apex_request   
        ( p_url     => c_url
        , p_method  => 'POST'
        , p_body    => l_stm
        )
        ;
    ELSIF updating THEN
        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'updating :new.chain_id = '||:new.chain_id);
        xxpm_gen_rest_apis.generic_apex_request   
        ( p_url     => c_url||:old.chain_id
        , p_method  => 'PUT'
        , p_body    => l_stm
        )
        ;
    ELSIF deleting THEN
        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'deleting :old.chain_id = '||:old.chain_id);
        l_stm := '{';
--        l_stm := l_stm||'"chain_id":"'                     ||:OLD.chain_id||'"';
--        l_stm := l_stm||',"chain_name":"'                  ||:OLD.chain_name||'"';
--        l_stm := l_stm||',"indicator_in_ex":"'             ||:OLD.indicator_in_ex||'"';
--        l_stm := l_stm||',"center_code":"'                 ||:OLD.center_code||'"';
--        l_stm := l_stm||',"sales_channel_distribution":"'  ||:OLD.sales_channel_distribution||'"';
--        l_stm := l_stm||',"sales_channel":"'               ||:OLD.sales_channel||'"';
--        l_stm := l_stm||',"sub_sales_channel":"'           ||:OLD.sub_sales_channel||'"';
--        l_stm := l_stm||',"channel_mix":"'                  ||:OLD.channel_mix||'"';
--        l_stm := l_stm||',"creation_date":"'               ||replace(to_char(:OLD.creation_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
--        l_stm := l_stm||',"created_by":"'                  ||:OLD.created_by||'"';
--        l_stm := l_stm||',"last_update_date":"'            ||replace(to_char(:OLD.last_update_date,'YYYY-MM-DD HH24:MI:SS'),' ','T')||'Z"';
--        l_stm := l_stm||',"last_updated_by":"'             ||:OLD.last_updated_by||'"';
        l_stm := l_stm||'}';
        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'l_stm  = ' ||l_stm);   

        xxpm_gen_rest_apis.generic_apex_request   
        ( p_url     => c_url||:old.chain_id
        , p_method  => 'DELETE'
        , p_body    => l_stm
        )
        ;

    END IF;
END IF;
--    xxpm_gen_debug_pkg.debug_t(c_trigger_name, '(end)');
EXCEPTION
    WHEN OTHERS THEN
        xxpm_gen_debug_pkg.debug_t(c_trigger_name, 'ERROR: ' || sqlerrm);
        apex_error.add_error(p_message => sqlerrm, p_display_location => apex_error.c_inline_in_notification);
        RAISE;
END xxpm_chains_2tv_aiud;
/
ALTER TRIGGER "WKSP_XXPM"."XXPM_CHAINS_2TV_AIUD" ENABLE;

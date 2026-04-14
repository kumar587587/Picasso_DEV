--------------------------------------------------------
--  DDL for Trigger XXCT_LOOKUP_VALUES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_LOOKUP_VALUES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_LOOKUP_VALUES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCT_LOOKUP_VALUES_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    --l_api_return_value     VARCHAR2(32000);      
    l_pl_table_name        VARCHAR2(50);
    --l_sp_table_name        VARCHAR2(50);
    l_pl_pk_field          VARCHAR2(50);
    --l_sp_pk_field          VARCHAR2(50);
    --select * from XXCT_LOOKUP_VALUES
BEGIN       
--   IF XXCT_GEN_REST_APIS.g_varicent_api_active then 
      XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
--      IF inserting THEN       
--         --  
--         IF :NEW.LOOKUP_TYPE in ( 'PLANELEMENT_TYPE','COMMISSION_TYPE','DIMENSIONS','PRODUCT_TYPE') then  
--            XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
--            IF :NEW.LOOKUP_TYPE = 'PLANELEMENT_TYPE' THEN  
--               -- Only insert if the row does not already exist.           
--               l_pl_table_name := 'plPlanElementType';  
--               l_pl_pk_field    := 'PlanElementType';  
--            ELSIF :NEW.LOOKUP_TYPE = 'COMMISSION_TYPE' THEN     
--               l_pl_table_name := 'plCommissionType';  
--               l_pl_pk_field    := 'CommissionType';  
--            ELSIF :NEW.LOOKUP_TYPE = 'DIMENSIONS' THEN     
--               l_pl_table_name := 'plDimensions';  
--               l_pl_pk_field    := 'ID';  
--            ELSIF :NEW.LOOKUP_TYPE = 'PRODUCT_TYPE' THEN     
--               l_pl_table_name := 'plProductType';  
--               l_pl_pk_field    := 'ProductType';  
--            END IF;     
--            --IF NOT XXCT_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||XXCT_gen_rest_apis.escape(upper(:new.code) )  ) then     
--            --   IF :NEW.LOOKUP_TYPE in ('PAYMENTTERM','VATCODE') THEN  
--            --      XXCT_gen_rest_apis.insert_row( l_pl_table_name,'"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0'));  
--            --   ELSE  
--            XXCT_gen_rest_apis.insert_row
--            --( l_pl_table_name
--            --, :new.lookup_type||'|'||:new.meaning
--            --, null
--            --, '"'||upper(:new.code)||'","'||:new.meaning||'"'
--            --);  
--            ( p_table_name      => l_pl_table_name
--            , p_key_values      => :new.lookup_type||'|'||:new.meaning
--            --, p_apex_id          IN VARCHAR2
--            , p_new_values      => '"'||upper(:new.code)||'","'||:new.meaning||'"'
--            , p_effective_date  => null
--            , p_overwrite       => null
--            );            
--            --   END IF;     
--            --END IF;     
--         END IF;     
--         --  
--      END IF;       
--      IF updating THEN  
--         IF :NEW.LOOKUP_TYPE in ( 'PLANELEMENT_TYPE','COMMISSION_TYPE','DIMENSIONS','PRODUCT_TYPE') then  
--            XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
--            --  
--            IF :NEW.LOOKUP_TYPE = 'PLANELEMENT_TYPE' THEN  
--               -- Only insert if the row does not already exist.           
--               l_pl_table_name := 'plPlanElementType';  
--               l_pl_pk_field    := 'PlanElementType';  
--            ELSIF :NEW.LOOKUP_TYPE = 'COMMISSION_TYPE' THEN     
--               l_pl_table_name := 'plCommissionType';  
--               l_pl_pk_field    := 'CommissionType';  
--            ELSIF :NEW.LOOKUP_TYPE = 'DIMENSIONS' THEN     
--               l_pl_table_name := 'plDimensions';  
--               l_pl_pk_field    := 'ID';  
--            ELSIF :NEW.LOOKUP_TYPE = 'PRODUCT_TYPE' THEN     
--               l_pl_table_name := 'plProductType';  
--               l_pl_pk_field    := 'ProductType';  
--            END IF;
--            --
--            l_new_values_string := '"'||upper(:new.code)||'",'||  
--                                   '"'||:new.meaning||'"';
--            l_old_values_string:=  '"'||upper(:old.code)||'",'||  
--                                   '"'||:old.meaning||'"';  
--            XXCT_gen_rest_apis.update_row 
--            ( l_pl_table_name 
--            , l_new_values_string
--            , null 
--            , l_new_values_string
--            , l_old_values_string,:old.rowid
--            );  
--         END IF;     
--         --  
--      END IF;  
--      --  
--      IF deleting THEN  
--         IF :OLD.LOOKUP_TYPE in ( 'PLANELEMENT_TYPE','COMMISSION_TYPE','DIMENSIONS','PRODUCT_TYPE') then  
--            XXCT_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
--            if :OLD.LOOKUP_TYPE in ( 'PLANELEMENT_TYPE') then  
--               -- Delete from plTable  
--               l_pl_table_name := 'plPlanElementType';  
--               l_pl_pk_field   := 'PlanElementType';  
--            ELSIF :OLD.LOOKUP_TYPE = 'COMMISSION_TYPE' THEN     
--               l_pl_table_name := 'plCommissionType';  
--               l_pl_pk_field    := 'CommissionType';  
--            ELSIF :OLD.LOOKUP_TYPE = 'DIMENSIONS' THEN     
--               l_pl_table_name := 'plDimensions';  
--               l_pl_pk_field    := 'ID';  
--            ELSIF :OLD.LOOKUP_TYPE = 'PRODUCT_TYPE' THEN     
--               l_pl_table_name := 'plProductType';  
--               l_pl_pk_field    := 'ProductType';  
--            END IF;     
--            l_old_values_string:=  '"'||upper(:old.code)||'",'||  
--                                   '"'||:old.meaning||'"';  
--
--            XXCT_gen_rest_apis.delete_row
--            ( l_pl_table_name
--            , l_old_values_string
--            --, null
--            , l_old_values_string
--            );  
--         END IF;   
--      END IF;  
--      --  
      XXCT_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
--   END IF;   
END xxcpc_lookups_aiud;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_LOOKUP_VALUES_AIUD" ENABLE;

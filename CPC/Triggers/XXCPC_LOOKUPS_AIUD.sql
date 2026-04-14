--------------------------------------------------------
--  DDL for Trigger XXCPC_LOOKUPS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_LOOKUPS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_LOOKUPS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_LOOKUPS_AIUD';
    l_new_values_string    VARCHAR2(32000);
    l_old_values_string    VARCHAR2(32000);
    l_api_return_value     VARCHAR2(32000);
    l_pl_table_name        VARCHAR2(50) := 'plProvider';
    l_sp_table_name        VARCHAR2(50) := 'spProvider';
    l_pl_pk_field          VARCHAR2(50) := 'ProviderName';
    l_sp_pk_field          VARCHAR2(50) := 'ProviderName';
BEGIN
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
   IF inserting THEN
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );
      --
      if :new.type not in ( 'xxVATCODE','API','INVOICE_STATUS','ISO_COUNTRY_CODE','ROLES','USERS_AND_ROLES') then
         IF :new.type = 'MEMOLINE' THEN
            -- Only insert if the row does not already exist.
            l_pl_table_name := 'plMemoLine';
            l_pl_pk_field    := 'MemoLine';
         ELSIF :new.type = 'VATCODE' THEN
            l_pl_table_name := 'plVATCode';
            l_pl_pk_field    := 'VATCode';
         ELSIF :new.type = 'CONTRACT_TYPE' THEN
            l_pl_table_name := 'plCPCContractType';
            l_pl_pk_field    := 'ContractTypes';
         ELSIF :new.type = 'PAYMENTTERM' THEN
            l_pl_table_name := 'plCPCPaymentTerm';
            l_pl_pk_field    := 'PaymentTerm';
         END IF;
         if (instr( sys_context('USERENV'   , 'DB_NAME') ,'APXPRD') > 0 
         and :old.type  = 'VATCODE')  then 
            null;
         else
            IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:new.code) ) , null ) then     
               IF :new.type = 'PAYMENTTERM' THEN  
                  --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0'));  
                  xxcpc_gen_rest_apis.insert_row
                    ( p_table_name      => l_pl_table_name
                    , p_key_values      => '"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')
                    , p_new_values      => '"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')
                    , p_effective_date  => NULL
                    , p_overwrite       => NULL
                    );

               ELSIF :new.type = 'VATCODE' THEN     
                  --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')||','||:new.remarks||',"Y"' );  
                  --xxcpc_gen_debug_pkg.debug_t( c_trigger_name,'aaarabi---'|| '"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')||',"'||:new.remarks||'","'||:NEW.ACTIVE_FLAG||'"' );
                  
                  xxcpc_gen_rest_apis.insert_row
                    ( p_table_name      => l_pl_table_name
                    , p_key_values      => '"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')||',"'||:new.remarks||'","'||:NEW.ACTIVE_FLAG||'"'
                    , p_new_values      => '"'||:new.code||'","'||:new.description||'",'||nvl(:new.number_value,'0')||',"'||:new.remarks||'","'||:NEW.ACTIVE_FLAG||'"'
                    , p_effective_date  => NULL
                    , p_overwrite       => NULL
                    );            

               ELSE  
                  --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||upper(:new.code)||'","'||:new.description||'"');  
                  xxcpc_gen_rest_apis.insert_row
                    ( p_table_name      => l_pl_table_name
                    , p_key_values      => '"'||upper(:new.code)||'","'||:new.description||'"'
                    , p_new_values      => '"'||upper(:new.code)||'","'||:new.description||'"'
                    , p_effective_date  => NULL
                    , p_overwrite       => NULL
                    );

               END IF;
            END IF;     
         end if;
      END IF;
      --  
   END IF;       
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      if :new.type not in ( 'xxVATCODE','API','INVOICE_STATUS','ISO_COUNTRY_CODE','ROLES','USERS_AND_ROLES') then  
         --  
         IF :new.type = 'MEMOLINE' THEN  
            -- Only insert if the row does not already exist.           
            l_pl_table_name := 'plMemoLine';  
            l_pl_pk_field    := 'MemoLine';  
         ELSIF :new.type = 'VATCODE' THEN      
            l_pl_table_name := 'plVATCode';  
            l_pl_pk_field    := 'VATCode';  
         ELSIF :new.type = 'CONTRACT_TYPE' THEN      
            l_pl_table_name := 'plCPCContractType';  
            l_pl_pk_field    := 'ContractTypes';  
         ELSIF :new.type = 'PAYMENTTERM' THEN      
            l_pl_table_name := 'plCPCPaymentTerm';  
            l_pl_pk_field    := 'PaymentTerm';           
         END IF;     
         IF :new.type = 'PAYMENTTERM' THEN  
            l_new_values_string := '"'||upper(:new.code)||'",'||  
                                   '"'||:new.description||'",'||  
                                   nvl(:new.number_value,'0');  
            l_old_values_string:=  '"'||upper(:old.code)||'",'||  
                                   '"'||:old.description||'",'||  
                                   nvl(:old.number_value,'0');  
         ELSIF :new.type = 'VATCODE' THEN  
            l_new_values_string := '"'||upper(:new.code)||'",'||  
                                   '"'||:new.description||'",'||  
                                   --nvl(:new.number_value,'0') ||','||--Commented By TechM Team for MWT-
                                   --'"'||:new.remarks||'","Y"'--Commented By TechM Team for MWT-
                                   ''||nvl(:new.number_value,'0') ||','||--AAdded By TechM Team for MWT-
                                   case when :new.remarks is not null then '"'||:new.remarks||'"' else '""' end ||',"'||:NEW.ACTIVE_FLAG||'"';--AAdded By TechM Team for MWT-
                                   
            l_old_values_string:=  '"'||upper(:old.code)||'",'||  
                                   '"'||:old.description||'",'||  
                                   --nvl(:old.number_value,'0')||','||
                                   --'"'||:new.remarks||'","Y"';
                                   ''||nvl(:old.number_value,'0.00') ||','||--AAdded By TechM Team for MWT-
                                   case when :old.remarks is not null then '"'||:old.remarks||'"' else '""' end ||',"'||:OLD.ACTIVE_FLAG||'"'; --AAdded By TechM Team for MWT-
         ELSE  
            l_new_values_string := '"'||upper(:new.code)||'",'||  
                                   '"'||:new.description||'"';  
            l_old_values_string:=  '"'||upper(:old.code)||'",'||  
                                   '"'||:old.description||'"';  
         END IF;
         XXCPC_GEN_DEBUG_PKG.DEBUG(c_trigger_name||' == TEST VATCODE--1','LINE 119');
         if (instr( sys_context('USERENV'   , 'DB_NAME') ,'APXPRD') > 0 
         and :old.type  = 'VATCODE')  then 
            null;
         else
         XXCPC_GEN_DEBUG_PKG.DEBUG(c_trigger_name||' == TEST VATCODE--2','LINE 124=='||l_pl_table_name ||'=='|| l_new_values_string ||'=='||:new.id||'=='||
         l_old_values_string ||'=='|| :old.rowid );
            --xxcpc_gen_rest_apis.update_row ( l_pl_table_name , l_new_values_string, l_old_values_string,:old.rowid );  
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

         end if;   
      END IF;     
      --  
   END IF;  
   --  
   IF deleting THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
      if :old.type  not in ( 'xxVATCODE','API','INVOICE_STATUS','ISO_COUNTRY_CODE','ROLES','USERS_AND_ROLES') then  
         -- Delete from plTable  
          -- Only delete if the row exist in plTable.      
         IF :old.type = 'MEMOLINE' THEN  
            -- Only insert if the row does not already exist.           
            l_pl_table_name := 'plMemoLine';  
            l_pl_pk_field    := 'MemoLine';  
         ELSIF :old.type = 'VATCODE' THEN      
            l_pl_table_name := 'plVATCode';  
            l_pl_pk_field    := 'VATCode';  
         ELSIF :old.type = 'CONTRACT_TYPE' THEN      
            l_pl_table_name := 'plCPCContractType';  
            l_pl_pk_field    := 'ContractTypes';  
         ELSIF :old.type = 'PAYMENTTERM' THEN      
            l_pl_table_name := 'plCPCPaymentTerm';  
            l_pl_pk_field    := 'PaymentTerm';           
         END IF;     
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Calling get_table_data' );   
         if (instr( sys_context('USERENV'   , 'DB_NAME') ,'APXPRD') > 0 
         and :old.type  = 'VATCODE')  then 
            null;
         else
            IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.code) )  , null ) then  
               xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from plTable' );   
               IF :old.type = 'VATCODE' THEN  
                  l_old_values_string:=  '"'||upper(:old.code)||'",'||  
                                         '"'||:old.description||'",'||  
                                         to_char(nvl(:old.number_value,0),'0.99') ||','||
                                         '"'||:old.remarks||'","'||:old.active_flag||'"' ;
               ELSIF :old.type = 'PAYMENTTERM' THEN
                  l_old_values_string:=  '"'||upper(:old.code)||'",'||
                                         '"'||:old.description||'",'||
                                         to_char(nvl(:old.number_value,0));

               ELSE
                  l_old_values_string:=  '"'||upper(:old.code)||'",'||
                                         '"'||:old.description||'"';
               END IF;
               xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_old_values_string = '||l_old_values_string );
               xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_values_string , l_old_values_string );
            END IF;
         end if;
      END IF;
   END IF;
   --
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );
END xxcpc_lookups_aiud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_LOOKUPS_AIUD" ENABLE;

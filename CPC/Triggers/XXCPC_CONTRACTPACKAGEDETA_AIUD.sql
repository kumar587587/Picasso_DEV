--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTRACTPACKAGEDETA_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTPACKAGEDETA_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTRACTPACKAGEDETAILS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTRACTPACKAGEDETA_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);  
    l_expected_result      VARCHAR2(32000);  
    --l_pl_table_name        VARCHAR2(50) := 'plProvider';  
    --l_plpk_field           VARCHAR2(50) := 'ProviderName';  
    l_sp_table_name        VARCHAR2(50) := 'spContractPackageDetails';      
    l_sp_pk_field          VARCHAR2(50) := 'ContractID,PackageName,StartPeriod';  
    l_contract_nr          VARCHAR2(50);  
    l_packagename          VARCHAR2(150);    
    l_found                BOOLEAN;
    FUNCTION get_contract_nr (p_id IN NUMBER )  
    RETURN VARCHAR2  
    IS  
       l_contract_nr VARCHAR2(20);  
       --PRAGMA autonomous_transaction;      
    BEGIN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_contract_nr', '(start) p_id = '||p_id );   
      SELECT contractnr  
      INTO l_contract_nr  
      FROM xxcpc_contracts  
      WHERE id = p_id  
      ;  
      --COMMIT;  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_contract_nr', '(end) l_contract_nr = '||l_contract_nr );   
      RETURN l_contract_nr;  
    EXCEPTION  
    WHEN OTHERS THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_contract_nr', 'ERROR: (end) l_contract_nr = null' );   
       RETURN '';  
    END get_contract_nr;  
    --  
BEGIN       
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );  
    --
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.startdate );
       xxcpc_gen_rest_apis.insert_date( :new.enddate );
    END IF;
    --
    IF updating THEN
       IF :old.startdate <> :new.startdate THEN
          xxcpc_gen_rest_apis.insert_date( :new.startdate );
       END IF;
       IF :old.enddate <> :new.enddate THEN
          xxcpc_gen_rest_apis.insert_date( :new.enddate );
       END IF;
    END IF;
    --    
    IF inserting OR updating THEN   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );   
      l_contract_nr := nvl( get_contract_nr ( :new.contractid ) , xxcpc_gen_rest_apis.get_contractnr );  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_contract_nr = '||l_contract_nr );   
      --  
      SELECT upper(packagename)  
      INTO l_packagename  
      FROM xxcpc_packages  
      WHERE id = :new.packageid  
      ;  
      l_new_values_string :=  '"'||upper(l_contract_nr)||'",'||  
                              '"'||l_packagename||'",'||  
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'",'||  
                              '""';  --Comment  
   END IF;
    --
    IF updating OR deleting THEN   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting :old.id = '||:old.id ); 
      l_contract_nr := nvl( get_contract_nr ( :old.contractid ) , xxcpc_gen_rest_apis.get_contractnr );  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_contract_nr = '||l_contract_nr );  
      --
      l_new_values_string :=  '"'||upper(l_contract_nr)||'",'||  
                              '"'||l_packagename||'",'||  
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'",'||  
                              '""';  --Comment  
      SELECT upper(packagename)  
      INTO l_packagename  
      FROM xxcpc_packages  
      WHERE id = :old.packageid  
      ;  
      l_old_values_string :=  '"'||upper(l_contract_nr)||'",'||  
                              '"'||l_packagename||'",'||  
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.enddate  ,'MM/DD/YYYY')||'",'||  
                              '""';  --Comment  
      l_found :=  xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape( upper(l_contract_nr) )||';PackageName='||xxcpc_gen_rest_apis.escape( l_packagename )  ||';StartPeriod='||to_char(:old.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00', null );                       
      if l_found then
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Found 1' );   
      else    
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Not Found 1' );   
      end if;      
   END IF;   

   --
   IF inserting THEN       
   --if l_found then
   --   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Found 2' );   
   --else    
   --   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'Not Found 2' );   
   --end if;   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      -- Only insert if the row does not already exist.                          
      --IF NOT l_found THEN  
         --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'not found so inserting  l_new_values_string = '||l_new_values_string );   
         --xxcpc_gen_rest_apis.insert_row( l_sp_table_name, l_new_values_string );  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_sp_table_name
         , p_key_values      => l_new_values_string
         , p_new_values      => l_new_values_string
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            
      --END IF;     
      --  
   END IF;       
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      --  
      --xxcpc_gen_rest_apis.update_row ( l_sp_table_name , l_new_values_string, l_old_values_string,:old.rowid );  
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
      -- Only delete if the row exist in spTable.      
      IF l_found THEN        
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
      END IF;      
      --  
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_contractpackagedeta_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTPACKAGEDETA_AIUD" ENABLE;

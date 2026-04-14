--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTRACTS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTRACTS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTRACTS_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    --  
    l_pl_table_name        VARCHAR2(50) := 'plContract';  
    l_pl_pk_field          VARCHAR2(50) := 'ContractID';  
    --  
    l_sp_table_name        VARCHAR2(50) := 'spContracts';  
    l_sp_pk_field          VARCHAR2(50) := 'ContractID,StartDate';  
    --  
    l_partnernumber        VARCHAR2(50);      
    l_contracttype         VARCHAR2(50);        
BEGIN       
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.startdate );
       xxcpc_gen_rest_apis.insert_date( :new.enddate );
       xxcpc_gen_rest_apis.insert_date( :new.endreminderby );
       xxcpc_gen_rest_apis.insert_date( :new.inflationreminderby );
    END IF;
    --
    IF updating THEN
       IF :old.startdate <> :new.startdate THEN
          xxcpc_gen_rest_apis.insert_date( :new.startdate );
       END IF;
       IF :old.enddate <> :new.enddate THEN
          xxcpc_gen_rest_apis.insert_date( :new.enddate );
       END IF;
       IF :old.endreminderby <> :new.endreminderby THEN
          xxcpc_gen_rest_apis.insert_date( :new.endreminderby );
       END IF;
       IF :old.inflationreminderby <> :new.inflationreminderby THEN
          xxcpc_gen_rest_apis.insert_date( :new.inflationreminderby );
       END IF;
    END IF;
    --       
   IF inserting OR updating THEN    
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );   
      SELECT partnernumber   
      INTO l_partnernumber  
      FROM xxcpc_contentpartners  
      WHERE id = :new.contentpartnerid  
      ;  
      SELECT code  
      INTO l_contracttype  
      FROM xxcpc_lookups  
      WHERE type ='CONTRACT_TYPE'  
      AND id = :new.contracttypeid  
      ;  
      l_new_values_string :=  '"'||upper(:new.contractnr)||'",'||  
                              '"'||:new.contractname||'",'||  
                              '"'||l_partnernumber||'",'||                                  
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.endreminderby  ,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.inflationreminderby  ,'MM/DD/YYYY')||'",'||  
                              '"'||:new.holdpayment||'",'||  
                              '"",'||  
                              '"'||l_contracttype||'",'||  
                              '"'||:new.paywithcomarch||'"'||  
                              '';  
   END IF;        
   IF updating OR deleting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' );   
      SELECT partnernumber   
      INTO l_partnernumber  
      FROM xxcpc_contentpartners  
      WHERE id = :old.contentpartnerid  
      ;  
      SELECT code  
      INTO l_contracttype  
      FROM xxcpc_lookups  
      WHERE type ='CONTRACT_TYPE'  
      AND id = :old.contracttypeid  
      ;  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
      l_old_values_string :=  '"'||upper(:old.contractnr)||'",'||  
                              '"'||:old.contractname||'",'||  
                              '"'||l_partnernumber||'",'||                                  
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.endreminderby  ,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.inflationreminderby  ,'MM/DD/YYYY')||'",'||  
                              '"'||:old.holdpayment||'",'||  
                              '"",'||  
                              '"'||l_contracttype||'",'||  
                              '"'||:old.paywithcomarch||'"'||  
                              '';  
   END IF;     
   --  
   IF inserting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(:new.contractnr) ) , null  ) THEN    
         --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||upper(:new.contractnr)||'","'||:new.contractname||'"');  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_pl_table_name
         , p_key_values      => '"'||upper(:new.contractnr)||'","'||:new.contractname||'"'
         , p_new_values      => '"'||upper(:new.contractnr)||'","'||:new.contractname||'"'
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            

      END IF;     
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(:new.contractnr) )  ||';StartDate='||to_char(:new.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' , null ) THEN                                 
         --xxcpc_gen_rest_apis.insert_row( l_sp_table_name, l_new_values_string );  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_sp_table_name
         , p_key_values      => l_new_values_string
         , p_new_values      => l_new_values_string
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            

      END IF;     
      --  
   END IF;     
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      --xxcpc_gen_rest_apis.update_row ( l_pl_table_name , '"'||upper(:new.contractnr)||'",'||'"'||:new.contractname||'"', '"'||upper(:old.contractnr)||'",'||'"'||:old.contractname||'"' ,null); 
      xxcpc_gen_rest_apis.update_row 
        ( p_table_name     => l_pl_table_name 
        , p_key_values     => '"'||upper(:new.contractnr)||'",'||'"'||:new.contractname||'"' 
        , p_apex_id        => :new.id  
        , p_new_values     => '"'||upper(:new.contractnr)||'",'||'"'||:new.contractname||'"'
        , p_old_values     => '"'||upper(:old.contractnr)||'",'||'"'||:old.contractname||'"'
        , p_old_rowid      => :old.rowid
        , p_effective_date => null
        , p_overwrite      => false
        );  

      --xxcpc_gen_rest_apis.update_row ( l_sp_table_name , l_new_values_string, l_old_values_string ,:old.rowid);  
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
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(:old.contractnr) )  ||';StartDate='||to_char(:old.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00'  , null )THEN                                 
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string, l_old_values_string );  
      END IF;      
      --  
      -- Delete from plTable  
       -- Only delete if the row exist in plTable.      
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.contractnr) )  , null )THEN   
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from plTable' );   
         l_old_values_string := '"'||upper(:old.contractnr)||'",'||  
                                '"'||:old.contractnr||'"';  
         --l_old_values_string := '"'||xxcpc_gen_rest_apis.escape(upper(:old.contractnr) )||'",'||  
         --                       '"'||:old.contractnr||'"';  
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from '||l_pl_table_name||' l_old_values_string'||l_old_values_string );                                   
         xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_values_string , l_old_values_string);  
      ELSE   
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from '||l_pl_table_name||' NOT FOUND?????');
      END IF;     
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_contracts_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTS_AIUD" ENABLE;

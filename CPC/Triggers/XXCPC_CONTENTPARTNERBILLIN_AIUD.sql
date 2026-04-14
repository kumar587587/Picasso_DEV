--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTENTPARTNERBILLIN_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERBILLIN_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTENTPARTNERBILLINGINF"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name          CONSTANT VARCHAR2(50):= 'XXCPC_CONTENTPARTNERBILLIN_AIUD';  
    l_new_values_string     VARCHAR2(32000);  
    l_old_values_string     VARCHAR2(32000);  
    l_api_return_value      VARCHAR2(32000);      
    l_sp_table_name         VARCHAR2(50) := 'spContentPartnerBillingInformation';  
    l_sppk_field            VARCHAR2(50) := 'PartnerNumber,MemoLine,VATCode';  
    l_partnernumber         VARCHAR2(50);      
    l_partnerName           VARCHAR2(250);     
    l_email                 VARCHAR2(250);      
    l_language              VARCHAR2(250);      
    l_cpcode                VARCHAR2(250);      
    l_holdpaymentsindicator VARCHAR2(250);      
    l_memoline              VARCHAR2(50);  
    l_vatcode               VARCHAR2(50);  
    --  
    FUNCTION get_partnernumber
    ( p_id                      IN NUMBER
    , p_partnername             OUT VARCHAR2
    , p_language                OUT VARCHAR2
    , p_cpcode                  OUT VARCHAR2 
    , p_holdpaymentsindicator   OUT VARCHAR2
    , p_email                   OUT VARCHAR2
    )   
    RETURN VARCHAR2  
    IS  
       l_partnernumber        VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_partnerNumber', '(start)' );   
       SELECT partnernumber, partnername  , partnerlanguage, cpcode  , holdpaymentsindicator  , email
       INTO l_partnernumber, p_partnername, p_language     , p_cpcode, p_holdpaymentsindicator, p_email
       FROM xxcpc_contentpartners        
       WHERE id = p_id  
       ;  
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_partnerNumber', '(end) l_partnernumber = '||l_partnernumber );   
       RETURN l_partnernumber;  
    EXCEPTION 
    WHEN OTHERS THEN
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_partnernumber', 'ERROR: '||SQLERRM );   
       raise;
    END get_partnernumber;   
    --  
   FUNCTION get_lookup_code( p_type IN VARCHAR2, p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_code        VARCHAR2(50);     
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_lookup_code', '(start) p_id = '||p_id );   
       SELECT upper(code)  
       INTO l_code  
       FROM  xxcpc_lookups  
       WHERE type = p_type  
       AND id = p_id  
       ;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_code = '||l_code );   
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_lookup_code', '(end) l_code = '||l_code );   
       RETURN l_code;  
    EXCEPTION 
    WHEN OTHERS THEN
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_lookup_code', 'ERROR: '||SQLERRM );   
       raise;
    END get_lookup_code;       
BEGIN       
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      l_partnernumber := get_partnernumber( :new.partnernumberid, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator ,l_email);
      l_memoline := get_lookup_code ( 'MEMOLINE', :new.memolineid );  
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_memoline = '||l_memoline );   
      l_vatcode := get_lookup_code ( 'VATCODE', :new.vatcodeid );  
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_vatcode = '||l_vatcode );   
      --xxcpc_synchronize_api.handle_payee( l_partnernumber, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email );  
xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '1' );   
      xxcpc_synchronize_api.handle_payee( l_partnernumber, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email , null );  
xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '2' );   
      -- Only insert if the row does not already exist.              
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sppk_field, 'PartnerNumber='||xxcpc_gen_rest_apis.escape(upper(l_partnernumber) )||';MemoLine='||xxcpc_gen_rest_apis.escape(upper(l_memoline)  ) ||';VATCode='||xxcpc_gen_rest_apis.escape(upper(l_vatcode)  ), null ) THEN  
xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '3' );         
         l_new_values_string :=  '"'||upper(l_partnernumber)||'",'||  
                                 '"'||l_memoline||'",'||  
                                 '"'||l_vatcode||'",'||                                  
                                 '"'||:new.defaultindicator||'"';  
xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '4' );                                    
         --xxcpc_gen_rest_apis.insert_row( l_sp_table_name, l_new_values_string );  
         xxcpc_gen_rest_apis.insert_row
            ( p_table_name      => l_sp_table_name
            , p_key_values      => l_new_values_string
            , p_new_values      => l_new_values_string
            , p_effective_date  => NULL
            , p_overwrite       => NULL
            );            
xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '5' );            
      END IF;     
      --  
   END IF;       
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      --  
      l_partnernumber := get_partnernumber( :new.partnernumberid, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email );   
      l_memoline := get_lookup_code ( 'MEMOLINE', :new.memolineid );  
      l_vatcode := get_lookup_code ( 'VATCODE', :new.vatcodeid );  
      --xxcpc_synchronize_api.handle_payee( l_partnernumber, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email );  
      xxcpc_synchronize_api.handle_payee( l_partnernumber, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email , null );  
      --     
      l_new_values_string :=  '"'||upper(l_partnernumber)||'",'||  
                              '"'||l_memoline||'",'||  
                              '"'||l_vatcode||'",'||                                  
                              '"'||:new.defaultindicator||'"';  
      --  
      l_memoline := get_lookup_code ( 'MEMOLINE', :old.memolineid );  
      l_vatcode := get_lookup_code ( 'VATCODE', :old.vatcodeid );  
      l_old_values_string:=   '"'||upper(l_partnernumber)||'",'||  
                              '"'||l_memoline||'",'||  
                              '"'||l_vatcode||'",'||                                  
                              '"'||:old.defaultindicator||'"';  
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
      --  
      l_partnernumber := get_partnernumber( :old.partnernumberid, l_partnerName, l_language, l_cpcode , l_holdpaymentsindicator,l_email );
      l_memoline := get_lookup_code ( 'MEMOLINE', :old.memolineid );  
      l_vatcode := get_lookup_code ( 'VATCODE', :old.vatcodeid );  
      -- Only delete if the row does not already exist.                          
      --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_sp_table_name, l_sppk_field, 'PartnerNumber='||upper(l_partnernumber)||';MemoLine='||upper(l_memoline)||';VATCode='||upper(l_vatcode));        
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_api_return_value = '||l_api_return_value );   
      --IF nvl(l_api_return_value,'Does not exists in Varicent') = '"'||upper(l_partnernumber)||'","'||upper(l_memoline)||'","'||upper(l_vatcode)||'"' THEN       
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sppk_field, 'PartnerNumber='||xxcpc_gen_rest_apis.escape(upper(l_partnernumber) )||';MemoLine='||xxcpc_gen_rest_apis.escape( upper(l_memoline)  ) ||';VATCode='||xxcpc_gen_rest_apis.escape( upper(l_vatcode)  ), null ) THEN  
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         l_memoline := get_lookup_code ( 'MEMOLINE', :old.memolineid );  
         l_vatcode := get_lookup_code ( 'VATCODE', :old.vatcodeid );  
         l_old_values_string:=   '"'||upper(l_partnernumber)||'",'||  
                                 '"'||l_memoline||'",'||  
                                 '"'||l_vatcode||'",'||                                  
                                 '"'||:old.defaultindicator||'"';  
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string, l_old_values_string );  
      END IF;      
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
EXCEPTION 
WHEN OTHERS THEN
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||SQLERRM );   
   raise;
END xxcpc_contentpartnerbillin_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERBILLIN_AIUD" ENABLE;

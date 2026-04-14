--------------------------------------------------------
--  DDL for Trigger XXCPC_MANUALPRTERINVSPLT_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTERINVSPLT_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_MANUALPARTNERINVOICESPLI"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_MANUALPRTERINVSPLT_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);  
    --  
    l_sp_table_name        VARCHAR2(50) := 'spCPCManualPartnerInvoiceSplit';  
    l_sp_pk_field          VARCHAR2(50) := 'SplitID';  
    --  
    l_partnerinvoicenumber  VARCHAR2(50);      
    l_vatcode               VARCHAR2(50);        
    l_memoline              VARCHAR2(50);        
    l_date_format           VARCHAR2(20) := 'MM/DD/YYYY';  
    l_number_format         VARCHAR2(50) := '999999999.99999999999999';  
BEGIN      
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting OR updating THEN  
       SELECT upper(v.code), upper(m.code)  
       INTO l_vatcode, l_memoline  
       FROM xxcpc_contentpartnerbillinginf  cpb  
       ,    xxcpc_lookups   v  
       ,    xxcpc_lookups   m  
       WHERE cpb.id = :new.contentpartnerbillinginfid  
       AND   v.id = cpb.vatcodeid  
       AND   m.id = cpb.memolineid  
       ;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_vatcode ='||l_vatcode );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_memoline ='||l_memoline );   
       l_new_values_string := '"'||:new.id||'",'||  
                              '"'||:new.manualpartnerinvoiceid||'",'||  
                              '"'||:new.splitdescription||'",'||  
                              --'"'||:new.splitamount||'",'||  
                              '"'||ltrim(to_char(:new.splitamount,l_number_format))||'",'||  
                              '"'||l_vatcode||'",'||  
                              '"'||l_memoline||'"';  

    END IF;  
    IF updating OR deleting THEN  
       SELECT upper(v.code), upper(m.code)  
       INTO l_vatcode, l_memoline  
       FROM xxcpc_contentpartnerbillinginf  cpb  
       ,    xxcpc_lookups   v  
       ,    xxcpc_lookups   m  
       WHERE cpb.id = :old.contentpartnerbillinginfid  
       AND   v.id = cpb.vatcodeid  
       AND   m.id = cpb.memolineid  
       ;      
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_vatcode ='||l_vatcode );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_memoline ='||l_memoline );   
       l_old_values_string := '"'||:old.id||'",'||  
                              '"'||:old.manualpartnerinvoiceid||'",'||  
                              '"'||:old.splitdescription||'",'||  
                              --'"'||:old.splitamount||'",'||  
                              '"'||ltrim(to_char(:old.splitamount,l_number_format))||'",'||  
                              '"'||l_vatcode||'",'||  
                              '"'||l_memoline||'"';  

    END IF;  
    IF inserting THEN      
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        --  
        -- Only insert if the row does not already exist.                          
        IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:new.id||';' , null  ) THEN              
           --xxcpc_gen_rest_apis.insert_row( l_sp_table_name,l_new_values_string );  
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
    --  
    IF updating THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
       --  
       --xxcpc_gen_rest_apis.update_row (l_sp_table_name , l_new_values_string, l_old_values_string ,:old.rowid);  
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
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:old.id  , null  ) THEN              
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name, l_old_values_string , l_old_values_string);  
      END IF;  
      --  
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
   --  
END xxcpc_manualprterinvsplt_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTERINVSPLT_AIUD" ENABLE;

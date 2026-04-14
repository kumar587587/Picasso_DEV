--------------------------------------------------------
--  DDL for Trigger XXCPC_CORRECTIONAMOUNTS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CORRECTIONAMOUNTS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CORRECTIONAMOUNTS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CORRECTIONAMOUNTS_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);  
    --  
    l_sp_table_name        VARCHAR2(50) := 'dtCPCPartnerInvoices';  
    l_sp_pk_field          VARCHAR2(50) := 'ID';  
    --  
    l_partnernumber         VARCHAR2(50);      
    l_partnername           VARCHAR2(150);        
    --l_memoline              VARCHAR2(50);        
    l_date_format           VARCHAR2(20) := 'MM/DD/YYYY';  
BEGIN      
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.invoicedate );
    END IF;
    --
    IF updating THEN
       IF :old.invoicedate <> :new.invoicedate THEN
          xxcpc_gen_rest_apis.insert_date( :new.invoicedate );
       END IF;
    END IF;   
    IF inserting OR updating THEN  
       SELECT partnernumber, partnername  
       INTO l_partnernumber, l_partnername  
       FROM xxcpc_contentpartners  
       WHERE id = :new.partnerid  
       ;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_partnernumber ='||l_partnernumber );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_partnername ='||l_partnername );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, ':new.paymentamount ='||:new.paymentamount );   
       --
       l_new_values_string := '"'||:new.id||'",'||  
                              '"'||l_partnernumber||'",'||  
                              '"'||l_partnername||'",'||  
                              '"",'||   --InvoiceNo  
                              '"'||to_char(:new.invoicedate    ,l_date_format)||'",'||  -- In varicent InvoicePeriod
                              '"'||:new.duedateoverride||'",'||    --DueDateOverride  
                              '"'||xxcpc_gen_rest_apis.amount2canonical(:new.paymentamount)||'",'||  
                               '"",'||    --paymentdescription  
                              '"'||:new.displayonspecification||'",'||  
                              '"'||:new.referenceonspecification||'",'||  
                              '"NORMAL",'||   --TransactionType  
                                 '"",'||            --Source  
                              '"'||to_char(:new.created    ,l_date_format)||'",'||  
                              '"'||to_char(:new.EndDateCompPeriod,l_date_format)||'"'  
                              ;  

    END IF;  
    IF updating OR deleting THEN  
       SELECT partnernumber, partnername  
       INTO l_partnernumber, l_partnername  
       FROM xxcpc_contentpartners  
       WHERE id = :old.partnerid  
       ;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_partnernumber ='||l_partnernumber );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_partnername ='||l_partnername );   
       l_old_values_string := '"'||:old.id||'",'||  
                              '"'||l_partnernumber||'",'||  
                              '"'||l_partnername||'",'||  
                              '"",'||   --InvoiceNo  
                              '"'||to_char(:old.invoicedate    ,l_date_format)||'",'||  
                              '"'||:old.duedateoverride||'",'||    --DueDateOverride  
                              '"'||xxcpc_gen_rest_apis.amount2canonical(:old.paymentamount)||'",'||  
                              --'"'||:old.referenceonspecification||'",'||    --paymentdescription  
                              '"",'||    --paymentdescription  
                              '"'||:old.displayonspecification||'",'||  
                              '"'||:old.referenceonspecification||'",'||  
                              '"NORMAL",'||   --TransactionType  
                              '"",'||            --Source  
                              '"'||to_char(:old.created    ,l_date_format)||'",'||
                              '"'||to_char(:old.EndDateCompPeriod,l_date_format)||'"'  
                              ;  
    END IF;  
    IF inserting THEN      
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        --  
        -- Only insert if the row does not already exist.                          
        IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:new.id||';' , null ) THEN              
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
       --xxcpc_gen_rest_apis.update_row (l_sp_table_name , l_new_values_string, l_old_values_string,:old.rowid );  
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
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:old.id  , null ) THEN              
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name, l_old_values_string , l_old_values_string);  
      END IF;  
      --  
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
   --  
END xxcpc_correctionamounts_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CORRECTIONAMOUNTS_AIUD" ENABLE;

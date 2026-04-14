--------------------------------------------------------
--  DDL for Trigger XXCPC_MANUALPRTNRINVOICE_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTNRINVOICE_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_MANUALPARTNERINVOICE"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_MANUALPRTNRINVOICE_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);  
    --  
    --l_pl_table_name        VARCHAR2(50) := 'spCPCManualPartnerInvoice';  
    --l_pl_pk_field          VARCHAR2(50) := 'Name';  
    --  
    l_sp_table_name        VARCHAR2(50) := 'spCPCManualPartnerInvoice';  
    l_sp_pk_field          VARCHAR2(50) := 'PartnerInvoiceID';  
    --  
    l_partnernumber        VARCHAR2(50);      
    l_invoicestatus        VARCHAR2(50);        
    l_number_format        VARCHAR2(50) := '999999999.99999999999999';  
    l_billinginvoicedate   VARCHAR2(50);
    l_extracttobillingdate VARCHAR2(50);
BEGIN       
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    --
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.invoicedate );
       xxcpc_gen_rest_apis.insert_date( :new.billinginvoicedate );
       xxcpc_gen_rest_apis.insert_date( :new.duedate );
       xxcpc_gen_rest_apis.insert_date( :new.extracttobillingdate );
    END IF;
    --
    IF updating THEN
       IF :old.invoicedate <> :new.invoicedate THEN
          xxcpc_gen_rest_apis.insert_date( :new.invoicedate );
       END IF;
       IF :old.billinginvoicedate <> :new.billinginvoicedate THEN
          xxcpc_gen_rest_apis.insert_date( :new.billinginvoicedate );
       END IF;
       IF :old.duedate <> :new.duedate THEN
          xxcpc_gen_rest_apis.insert_date( :new.duedate );
       END IF;
       IF :old.extracttobillingdate <> :new.extracttobillingdate THEN
          xxcpc_gen_rest_apis.insert_date( :new.extracttobillingdate );
       END IF;

    END IF;
    --       
    if inserting or updating then  
       --if inserting then
          select partnernumber  
          into l_partnernumber  
          from xxcpc_contentpartners  
          where id  = :new.partnerid  
          ;  
       --else
       --   select partnernumber  
       --   into l_partnernumber  
       --   from xxcpc_contentpartners  
       --   where id  = :old.partnerid  
       --   ;  
       --end if;
       select description  
       into l_invoicestatus  
       from xxcpc_lookups  
       where id = :new.invoicestatusid  
       ;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, ' insert or update :new.billinginvoicedate ='||:new.billinginvoicedate );   
       if :new.billinginvoicedate is null then
          l_billinginvoicedate := 'null';
       else
          l_billinginvoicedate :=    '"'||to_char(:new.billinginvoicedate    ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'"';
       end if;
       if :new.extracttobillingdate is null then
          l_extracttobillingdate:= 'null';
       else
          l_extracttobillingdate:=   '"'||to_char(:new.extracttobillingdate  ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'"';  
       end if;       
       l_new_values_string := '"'||:new.id||'",'||  
                              '"'||l_partnernumber||'",'||  
                              '"'||to_char(:new.invoicedate ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'",'||  
                              '"'||to_char(:new.duedate     ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'",'||  
                              '"'||:new.partnerinvoicenumber||'",'||  
                              ltrim(to_char(:new.invoiceamount,l_number_format))||','||  
                              '"'||l_invoicestatus||'",'||  
                              '"'||:new.paymentterm||'",'||  
                              '"'||:new.holdpayment||'",'||  
                              '"'||:new.billinginvoicenumber||'",'||  
                              l_billinginvoicedate||','||  
                              l_extracttobillingdate||','||  
                             '"",'||  -- Vatcode obsolete  
                             '"",'||   -- Memolinse obsolete  
                             --replace(replace('"'||:new.invoicedescription,'\','\\'),'&','\&')    ||'"';   
                             '"'||:new.invoicedescription||'",'||   
                             '"'||:new.paywithcomarch||'"';   
    end if;  
    if updating or deleting then  
       select partnernumber  
       into l_partnernumber  
       from xxcpc_contentpartners  
       where id  = :old.partnerid  
       ;  
       select description  
       into l_invoicestatus  
       from xxcpc_lookups  
       where id = :old.invoicestatusid  
       ;         
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, ' update or delete :old.billinginvoicedate ='||:old.billinginvoicedate );
       if :old.billinginvoicedate is null then
          l_billinginvoicedate := 'null';
       else
          l_billinginvoicedate :=    '"'||to_char(:old.billinginvoicedate    ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'"';
       end if;
       if :old.extracttobillingdate is null then
          l_extracttobillingdate:= 'null';
       else
          l_extracttobillingdate:=   '"'||to_char(:old.extracttobillingdate  ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'"';  
       end if;

       l_old_values_string := '"'||:old.id||'",'||  
                              '"'||l_partnernumber||'",'||  
                              '"'||to_char(:old.invoicedate ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'",'||  
                              '"'||to_char(:old.duedate     ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00' ||'",'||  
                              '"'||:old.partnerinvoicenumber||'",'||  
--                              '"'||:old.invoicedescription||'",'||  
                              ltrim(to_char(:old.invoiceamount,l_number_format))||','||  
                              '"'||l_invoicestatus||'",'||  
                              '"'||:old.paymentterm||'",'||  
                              '"'||:old.holdpayment||'",'||  
                              '"'||:old.billinginvoicenumber||'",'||  
                              l_billinginvoicedate||','||  
                              l_extracttobillingdate||','||  
                              '"",'||  -- Vatcode obsolete  
                              '"",'||   -- Memolinse obsolete  
                              --replace(replace('"'||:old.invoicedescription,'\','\\'),'&','\&')    ||'"';                                
                             '"'||:old.invoicedescription||'",'||   
                             '"'||:old.paywithcomarch||'"';   
    end if;  
    IF inserting THEN       
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
        --  
        -- Only insert if the row does not already exist.   
        --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_pl_table_name,l_pl_pk_field ,l_pl_pk_field ||'='||upper(:new.channelname));   
        --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );  
        --IF nvl(l_api_return_value,'Does not exists in Varicent') <> upper(:new.channelname) THEN  
        --   xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||upper(:new.channelname)||'","'||:new.channelname||'"');  
        --END IF;     
        --  
        -- Only insert if the row does not already exist.                          
        IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:new.id||';' , null ) then             
           xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_new_values_string ='||l_new_values_string );
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
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_new_values_string ='||l_new_values_string );
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating l_old_values_string ='||l_old_values_string );
       --xxcpc_gen_rest_apis.update_row (l_sp_table_name , l_new_values_string, l_old_values_string, :old.rowid ); 
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
      if xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||:old.id  , null ) then              
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name, l_old_values_string , l_old_values_string );  
      END IF;  
      --  
      -- Delete from plTable  
      -- Only delete if the row exist in plTable.      
      --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||upper(:old.channelname));                                   
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );   
      --IF nvl(l_api_return_value,'Does not exists in Varicent') = '"'||upper(:old.channelname)||'"' THEN      
      --if xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||upper(:old.channelname) ) Then  
      --   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from plTable' );   
      --   l_old_values_string := '"'||upper(:old.channelname)||'",'||  
      --                         '"'||:old.channelname||'"';                      
      --   xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_values_string );  
      --END IF;     
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
   --  
END XXCPC_MANUALPRTNRINVOICE_AIUD;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_MANUALPRTNRINVOICE_AIUD" ENABLE;

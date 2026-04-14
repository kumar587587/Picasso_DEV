--------------------------------------------------------
--  DDL for Trigger XXCPC_SUBSCRIBER_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBER_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_SUBSCRIBER"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_SUBSCRIBER_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    l_sp_table_name        VARCHAR2(50) := 'dtCPCSubscriberV2';--'dtCPCSubscriber';  
    l_sp_pk_field          VARCHAR2(50) := 'Provider,PeriodCounted,Package';  
    l_providername         VARCHAR2(50);      
    l_packagename          VARCHAR2(50);  
    l_found                BOOLEAN;
    --  
    FUNCTION get_packagename( p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_packagename       VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       --xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_packagename', '(start)' );   
       SELECT p.packagename   
       INTO l_packagename  
       FROM  xxcpc_packages               p  
       WHERE id  = p_id  
       ;  
       COMMIT;  
       --xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_packagename', '(end) l_packagename = '||l_packagename );   
       RETURN l_packagename;  
    END get_packagename;           
    --  
    FUNCTION get_providername( p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_providername       VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       --xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_providername', '(start) p_id = '||p_id );   
       SELECT p.providername   
       INTO l_providername  
       FROM xxcpc_providers p  
       WHERE p.id  = p_id  
       ;  
       COMMIT;  
       --xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_providername', '(end) l_providername = '||l_providername );   
       RETURN l_providername;  
    END get_providername;           
    --      
BEGIN   
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    --
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.periodcounted );
       xxcpc_gen_rest_apis.insert_date( :new.importdate );
    END IF;
    --
    IF updating THEN
       IF :old.periodcounted <> :new.periodcounted THEN
          xxcpc_gen_rest_apis.insert_date( :new.periodcounted );
       END IF;
       IF :old.importdate <> :new.importdate THEN
          xxcpc_gen_rest_apis.insert_date( :new.importdate );
       END IF;
    END IF;
    --      
    IF inserting OR updating THEN   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );   
      --  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'new packageid,providerid==00 =='||:new.packageid||'=='||:new.providerid ); 
      l_packagename := get_packagename( :new.packageid);   
      l_providername := get_providername( :new.providerid);

      l_new_values_string :=  '"'||upper(l_providername)||'",'||  
                              '"'||to_char(:new.periodcounted,'MM/DD/YYYY')||'",'||  
                              '"'||upper(l_packagename)||'",'||      
                              '"'||:new.endquantity||'",'||
                              '"'||:new.startquantity||'",'||
                              '"'||upper(:new.transactiontype)||'",'||      
                              '"'||upper(:new.source)||'",'||      
                              '"'||to_char(:new.importdate,'MM/DD/YYYY')||'",'||  
                              '"'||upper(:new.sourcefile)||'"';
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string =='||l_new_values_string);
   END IF;     
   --
   IF updating OR deleting THEN   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' ); 
      --
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_providername,l_packagename==00 =='||:old.packageid||'=='||:old.providerid ); 
      l_packagename := get_packagename( :old.packageid);   
      l_providername := get_providername( :old.providerid);
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_providername,l_packagename=='||l_providername||'=='||l_packagename ); 
      l_old_values_string :=  '"'||upper(l_providername)||'",'||  
                              '"'||to_char(:old.periodcounted,'MM/DD/YYYY')||'",'||  
                              '"'||upper(l_packagename)||'",'||      
                              '"'||:old.endquantity||'",'||
                              '"'||:old.startquantity||'",'||
                              '"'||upper(:old.transactiontype)||'",'||      
                              '"'||upper(:old.source)||'",'||      
                              '"'||to_char(:old.importdate,'MM/DD/YYYY')||'",'||  
                              '"'||upper(:old.sourcefile)||'"';
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_old_values_string==000'||l_old_values_string ); 

      l_found := xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'Provider='||xxcpc_gen_rest_apis.escape( upper(l_providername) )  ||';PeriodCounted='||to_char(:old.periodcounted,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00;Package='||xxcpc_gen_rest_apis.escape( upper(l_packagename) ) , null  );                              

    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_old_values_string==1111'||l_old_values_string ); 
    --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_found=='||l_found ); 
   END IF;  
   --
   IF inserting  THEN   
      -- Only insert if the row does not already exist.                          
      --IF NOT l_found THEN  
         --xxcpc_gen_rest_apis.insert_row( l_sp_table_name, l_new_values_string ); 
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting 00==' ); 
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
   --
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      --     
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
      --  
      -- Only delete if the row does not already exist.                          
      IF l_found THEN  
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
      END IF;      
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' ); 
exception
when others then
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'ERROR: '||SQLERRM ); 
   raise;
END xxcpc_subscriber_aiud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBER_AIUD" ENABLE;

--------------------------------------------------------
--  DDL for Trigger XXCPC_CHANNELS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CHANNELS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CHANNELS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CHANNELS_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);  
    --  
    l_pl_table_name        VARCHAR2(50) := 'plChannelInformation';  
    l_pl_pk_field          VARCHAR2(50) := 'Name';  
    --  
    l_sp_table_name        VARCHAR2(50) := 'spCPCChannel';  
    l_sp_pk_field          VARCHAR2(50) := 'ChannelName,StartDate';  
    --  
    l_partnernumber        VARCHAR2(50);      
    l_contracttype         VARCHAR2(50);        
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
    IF inserting THEN       
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting upper(:new.channelname) ='||upper(:new.channelname ));   
        --  
        -- Only insert if the row does not already exist.   
        l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_pl_table_name,l_pl_pk_field ,l_pl_pk_field ||'='||xxcpc_gen_rest_apis.escape(upper(:new.channelname) ) ,0 , null);   
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );  
        IF nvl(l_api_return_value,'Does not exists in Varicent') <> upper(:new.channelname) THEN  
           --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||upper(:new.channelname)||'","'||:new.channelname||'"');  
           xxcpc_gen_rest_apis.insert_row
            ( p_table_name      => l_pl_table_name
            , p_key_values      => '"'||upper(:new.channelname)||'","'||:new.channelname||'"'
            , p_new_values      => '"'||upper(:new.channelname)||'","'||:new.channelname||'"'
            , p_effective_date  => NULL
            , p_overwrite       => NULL
            );            

        END IF;     
        --  
        -- Only insert if the row does not already exist.                          
        l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_sp_table_name, l_sp_pk_field, 'ChannelName='||xxcpc_gen_rest_apis.escape(upper(:new.channelname) )||';StartDate='||to_char(:new.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00',0, null );                                   
        xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );   
        l_new_values_string := '"'||upper(:new.channelname)||'",'||  
                               '"'||:new.hideflag||'",'||  
                               '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                               '"'||to_char(nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'"';  
        --xxcpc_gen_rest_apis.insert_row( l_sp_table_name,l_new_values_string );  
        xxcpc_gen_rest_apis.insert_row
            ( p_table_name      => l_sp_table_name
            , p_key_values      => l_new_values_string
            , p_new_values      => l_new_values_string
            , p_effective_date  => NULL
            , p_overwrite       => NULL
            );            

        --  
    END IF;       
    IF updating THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
       --  
       l_new_values_string := '"'||upper(:new.channelname)||'",'||  
                               '"'||:new.hideflag||'",'||  
                               '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                               '"'||to_char(nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'"';         
       l_old_values_string := '"'||upper(:old.channelname)||'",'||  
                               '"'||:old.hideflag||'",'||  
                               '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                               '"'||to_char(nvl(:old.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'"';         
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

    IF deleting THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
       -- Only delete if the row exist in spTable.                          
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field,  'ChannelName='||xxcpc_gen_rest_apis.escape(upper(:old.channelname) )||';StartDate='||to_char(:old.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00', null )  THEN    
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         l_old_values_string := '"'||upper(:old.channelname)||'",'||  
                                '"'||:old.hideflag||'",'||  
                                '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                                '"'||to_char(nvl(:old.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'"';         
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name, l_old_values_string, l_old_values_string );  
      END IF;  
      --  
      -- Delete from plTable  
      -- Only delete if the row exist in plTable.      
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.channelname) ), null ) THEN  
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from plTable' );   
         l_old_values_string := '"'||upper(:old.channelname)||'",'||  
                                '"'||:old.channelname||'"';                      
         xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_values_string , l_old_values_string);  
      END IF;     
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
   --  
EXCEPTION   
WHEN OTHERS THEN  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end) ERROR: '||:new.channelname||' sqlerrm='||sqlerrm  );   
   RAISE;  
END xxcpc_channels_aiud;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CHANNELS_AIUD" ENABLE;

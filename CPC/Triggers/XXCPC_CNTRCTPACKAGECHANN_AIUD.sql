--------------------------------------------------------
--  DDL for Trigger XXCPC_CNTRCTPACKAGECHANN_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CNTRCTPACKAGECHANN_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTRACTPACKAGECHANNELS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CNTRCTPACKAGECHANN_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    l_sp_table_name        VARCHAR2(50) := 'spContractPackageChannel';  
    l_sp_pk_field          VARCHAR2(50) := 'ContractID,PackageName,ChannelName,StartDate';  
    l_channelname          VARCHAR2(50);      
    l_packagename          VARCHAR2(50);  
    l_contractnr           VARCHAR2(50);  
    l_found                BOOLEAN;
    --  
    FUNCTION get_channelname( p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_channelname       VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_channelname', '(start)' );   
       SELECT channelname  
       INTO l_channelname  
       FROM xxcpc_channels  
       WHERE id = p_id  
       ;  
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_channelname', '(end) l_channelname = '||l_channelname );   
       RETURN l_channelname;  
    END get_channelname;   
    --  
    FUNCTION get_packagename( p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_packagename       VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_packagename', '(start)' );   
       SELECT p.packagename   
       INTO l_packagename  
       FROM xxcpc_contractpackagedetails cpd  
       ,    xxcpc_packages               p  
       WHERE cpd.id  = p_id  
       AND p.id = cpd.packageid   
       ;  
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_packagename', '(end) l_packagename = '||l_packagename );   
       RETURN l_packagename;  
    END get_packagename;       
    --  
    FUNCTION get_contractnumber( p_id  IN NUMBER )   
    RETURN VARCHAR2  
    IS  
       l_contractnr       VARCHAR2(50);      
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_contractNumber', '(start)' );   
       SELECT c.contractnr  
       INTO l_contractnr  
       FROM xxcpc_contractpackagedetails cpd  
       ,    xxcpc_packages               p  
       ,    xxcpc_contracts              c  
       WHERE cpd.id  = p_id  
       AND p.id = cpd.packageid  
       AND c.id = cpd.contractid       
       ;  
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_contractNumber', '(end) l_contractnr = '||l_contractnr );   
       RETURN l_contractnr;  
    END get_contractnumber;   
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
      l_channelname := get_channelname( :new.channelid);  
      l_packagename := get_packagename( :new.contractpackageid);   
      l_contractnr  := get_contractnumber( :new.contractpackageid);   
      l_new_values_string :=  '"'||upper(l_contractnr)||'",'||  
                              '"'||upper(l_packagename)||'",'||  
                              '"'||upper(l_channelname)||'",'||      
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'"';         
    END IF;    
    --
    IF updating OR deleting THEN   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting :old.id = '||:old.id ); 
      --
      l_channelname := get_channelname( :old.channelid);  
      l_packagename := get_packagename( :old.contractpackageid);
      l_contractnr  := get_contractnumber( :old.contractpackageid);   
      l_old_values_string :=  '"'||upper(l_contractnr)||'",'||  
                              '"'||upper(l_packagename)||'",'||  
                              '"'||upper(l_channelname)||'",'||      
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.enddate  ,'MM/DD/YYYY')||'"';         
      l_found := xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(l_contractnr) )||';PackageName='||xxcpc_gen_rest_apis.escape(upper(l_packagename) ) ||';ChannelName='||xxcpc_gen_rest_apis.escape(upper(l_channelname) ) ||';StartDate='||to_char(:old.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00', null );                               
    END IF;
    --
    IF inserting THEN      
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      -- Only insert if the row does not already exist.                          
      --IF NOT l_found THEN  
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
   --
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
      --  
      -- Only delete if the row does not already exist.                          
      IF l_found  THEN  
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string, l_old_values_string );  
      END IF;      
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END xxcpc_cntrctpackagechann_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CNTRCTPACKAGECHANN_AIUD" ENABLE;

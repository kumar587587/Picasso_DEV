--------------------------------------------------------
--  DDL for Trigger XXCPC_PACKAGES_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_PACKAGES_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_PACKAGES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_PACKAGES_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_pl_table_name        VARCHAR2(50) := 'plPackage';  
    l_pl_pk_field          VARCHAR2(50) := 'PackageID';  
    l_sp_table_name        VARCHAR2(50) := 'spPackage';  
    l_sp_pk_field           VARCHAR2(50) := 'PackageName,StartDate';  
    l_is_specialpackage    VARCHAR2(1)  := 'N';  
    l_date_format           VARCHAR2(20) := 'MM/DD/YYYY';  
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
   IF inserting or updating THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );   
      l_new_values_string :=  '"'||upper(:new.packagename)||'",'||  
                              '"'||to_char(:new.startdate,l_date_format)||'",'||  
                              '"'||to_char(:new.enddate  ,l_date_format)||'",'||  
                              '"'||:new.hideflag||'",'||                                  
                              '"'||:new.sequencenr||'"';  
   END IF;        
   IF updating or deleting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' );   
      l_old_values_string :=  '"'||upper(:old.packagename)||'",'||  
                              '"'||to_char(:old.startdate,l_date_format)||'",'||  
                              '"'||to_char(:old.enddate  ,l_date_format)||'",'||  
                              '"'||:old.hideflag||'",'||                                  
                              '"'||:old.sequencenr||'"';  
   END IF;        
   IF inserting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:new.packagename) ) , null  ) then     
         --xxcpc_gen_rest_apis.insert_row( l_pl_table_name,'"'||upper(:new.packagename)||'","'||:new.packagename||'","N"' );  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_pl_table_name
         , p_key_values      => '"'||upper(:new.packagename)||'","'||:new.packagename||'","N"'
         , p_new_values      => '"'||upper(:new.packagename)||'","'||:new.packagename||'","N"'
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            
      END IF;     
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'PackageName='||xxcpc_gen_rest_apis.escape(upper(:new.packagename) )||';StartDate='||to_char(:new.startdate    ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00'  , null ) then     
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
      -- Only delete if the row exist in spTable.                          
      --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||upper(:old.packagename));                                   
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );   
      ---IF nvl(l_api_return_value,'Does not exists in Varicent') = upper(:old.packagename) THEN      
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'PackageName='||xxcpc_gen_rest_apis.escape(upper(:old.packagename) )||';StartDate='||to_char(:old.startdate    ,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00'  , null ) then     
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
      END IF;      
      --  
      -- Delete from plTable  
       -- Only delete if the row exist in spTable.      
      --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||upper(:old.packagename));                                   
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, l_api_return_value );   
      --IF nvl(l_api_return_value,'Does not exists in Varicent') = upper(:old.packagename) THEN      
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.packagename) )  , null ) then     
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from plTable' );   
         l_old_values_string := '"'||upper(:old.packagename)||'",'||  
                                '"'||:old.packagename||'",'||  
                                '"N"';  
         xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_values_string, l_old_values_string );  
      END IF;     
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END XXCPC_PACKAGES_AIUD;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_PACKAGES_AIUD" ENABLE;

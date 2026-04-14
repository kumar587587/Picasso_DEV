--------------------------------------------------------
--  DDL for Trigger XXCPC_SPECIALPACKAGESDETAI_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SPECIALPACKAGESDETAI_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_SPECIALPACKAGESDETAILS"
  REFERENCING FOR EACH ROW
  DECLARE     
   c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_SPECIALPACKAGESDETAI_AIUD';  
   l_new_values_string    VARCHAR2(32000);  
   l_old_values_string    VARCHAR2(32000);  
   l_api_return_value     VARCHAR2(32000);      
   --l_pl_table_name        VARCHAR2(50) := 'plPackage';  
   l_sp_table_name        VARCHAR2(150) := 'spSpecialPackagesDetails';  
   --l_plpk_field           VARCHAR2(50) := 'PackageID';  
   l_sp_pk_field           VARCHAR2(150) := 'SpecialPackageName,PackageName';  
   l_is_specialpackage    VARCHAR2(1)  := 'N';  
   l_specialpackagename   VARCHAR2(200);  
   l_packagename          VARCHAR2(200);  
   FUNCTION get_specialpackagename ( p_id IN NUMBER ) RETURN VARCHAR2  
   IS  
      PRAGMA autonomous_transaction;  
   BEGIN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_specialpackagename', '(start)' );   
      SELECT specialpackagename  
      INTO   l_specialpackagename  
      FROM   xxcpc_specialpackages  
      WHERE  id  = p_id  
      ;     
      COMMIT;  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_specialpackagename', '(end) l_specialPackageName = '||l_specialpackagename );   
      RETURN l_specialpackagename;  
   END get_specialpackagename;  

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
   if inserting or updating then
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );
      --
      --SELECT specialpackagename  
      --INTO   l_specialpackagename  
      --FROM   xxcpc_specialpackages  
      --WHERE  id  = :new.specialpackageid   
      --;  
      l_specialpackagename   := get_specialpackagename ( :new.specialpackageid );
      --
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_specialPackageName = '||l_specialpackagename );   
      SELECT packagename  
      INTO   l_packagename  
      FROM   xxcpc_packages  
      WHERE  id  = :new.packageid   
      ;        
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_packageName = '||l_packagename );        
      l_new_values_string :=  '"'||upper(l_specialpackagename)||'",'||  
                              '"'||upper(l_packagename)||'",'||   
                              '"'||:new.operation||'",'||   
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'",'||  
                              '""';  --Comment        
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_new_values_string = '||l_new_values_string );                           
   end if;
   if updating or deleting then
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' );
      --SELECT specialpackagename  
      --INTO   l_specialpackagename  
      --FROM   xxcpc_specialpackages  
      --WHERE  id  = :old.specialpackageid   
      --;  
      l_specialpackagename   := get_specialpackagename ( :old.specialpackageid );
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_specialPackageName = '||l_specialpackagename );   
      SELECT packagename  
      INTO   l_packagename  
      FROM   xxcpc_packages  
      WHERE  id  = :old.packageid   
      ;        
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_packageName = '||l_packagename );                                 
      l_old_values_string :=  '"'||upper(l_specialpackagename)||'",'||  
                              '"'||upper(l_packagename)||'",'||   
                              '"'||:old.operation||'",'||   
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(nvl(:old.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'",'||  
                              '""';  --Comment       
   end if; 
   IF inserting THEN      
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      -- Only insert if the row does not already exist.   
      IF not xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'SpecialPackageName='||xxcpc_gen_rest_apis.escape( upper(l_specialpackagename) )  ||';PackageName='||xxcpc_gen_rest_apis.escape( upper(l_packagename) ) , null  ) then 
         --xxcpc_gen_rest_apis.insert_row( l_sp_table_name, l_new_values_string );  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_sp_table_name
         , p_key_values      => l_new_values_string
         , p_new_values      => l_new_values_string
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            

      END IF;     
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
      --l_specialpackagename := get_specialpackagename ( :old.specialpackageid );  
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_specialPackageName = '||l_specialpackagename );   
      --SELECT packagename  
      --INTO   l_packagename  
      --FROM   xxcpc_packages  
      --WHERE  id  = :old.packageid   
      --;         
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'l_packageName = '||l_packagename );   
      -- Only delete if the row exist in spTable.                          
      --l_api_return_value := xxcpc_gen_rest_apis.get_table_data (l_sp_table_name, l_sppk_field, 'SpecialPackageName='||upper(l_specialpackagename)||';PackageName='||upper(l_packagename));                                   
      --xxcpc_gen_debug_pkg.debug_t( c_trigger_name,'l_api_return_value ='|| l_api_return_value );   
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'SpecialPackageName='||xxcpc_gen_rest_apis.escape( upper(l_specialpackagename) )  ||';PackageName='||xxcpc_gen_rest_apis.escape( upper(l_packagename) )  , null  ) then 
         xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
      END IF;      
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
   --  
END xxcpc_specialpackagesdetai_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SPECIALPACKAGESDETAI_AIUD" ENABLE;

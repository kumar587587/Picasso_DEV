--------------------------------------------------------
--  DDL for Trigger XXCPC_SPECIALPACKAGES_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SPECIALPACKAGES_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_SPECIALPACKAGES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_SPECIALPACKAGES_BIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    l_pl_table_name        VARCHAR2(50) := 'plPackage';  
    l_sp_table_name        VARCHAR2(50) := 'spPackage';  
    l_sppk_field           VARCHAR2(50) := 'PackageName';      
    l_plpk_field           VARCHAR2(50) := 'PackageID';  
    l_is_specialpackage    VARCHAR2(1)  := 'N';  
    l_date_format          VARCHAR2(20) := 'MM/DD/YYYY';  
    l_iud                  varchar2(1);
    l_open_period_i        varchar2(15);
    l_open_period_u        varchar2(15);
    l_open_period_d        varchar2(15);
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
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      l_iud := 'I';
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         :new.created := sysdate;      
         :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);      
         --INSERT INTO xxcpc_packages(id,packagename,startdate,enddate,updatedflag) VALUES(:new.id*-1,:new.specialpackagename,TO_DATE('1-1-1900','DD-MM-YYYY'),TO_DATE('1-1-1900','DD-MM-YYYY'),'N');    
         --INSERT INTO xxcpc_packages(id,packagename,startdate,enddate,updatedflag) VALUES(:new.id*-1,:new.specialpackagename,TO_DATE(:new.startdate,'DD-MM-YYYY'),TO_DATE(:new.enddate,'DD-MM-YYYY'),'N');   
         INSERT INTO xxcpc_packages(id,packagename,startdate,enddate,updatedflag) VALUES(:new.id*-1,:new.specialpackagename,:new.startdate,:new.enddate,'N');   
         --  
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag :='Y';       
         :new.enddate := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY'));     
      END IF;   
      l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
      l_old_values_string :=  '"'||upper(:new.specialpackagename)||'",'||  
                              '"'||:new.specialpackagename||'",'||  
                              '"N"';                                   
      l_new_values_string :=  '"'||upper(:new.specialpackagename)||'",'||  
                              '"'||:new.specialpackagename||'",'||  
                              '"Y"';                               
      --xxcpc_gen_rest_apis.update_row ( 'plPackage' , l_new_values_string, l_old_values_string,null ); 
      xxcpc_gen_rest_apis.update_row 
        ( p_table_name     => 'plPackage'
        , p_key_values     => l_new_values_string
        , p_apex_id        => :new.id  
        , p_new_values     => l_new_values_string
        , p_old_values     => l_old_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => null
        , p_overwrite      => false
        );  

   END IF;      
   --  
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      l_iud := 'U';
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         UPDATE xxcpc_packages SET enddate = nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')) WHERE id = :new.id*-1;    
         --  
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag :='Y';       
         :new.enddate := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY'));      
      END IF;   
      --  
      l_new_values_string :=  '"'||upper(:new.specialpackagename)||'",'||  
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'",'||  
                              '"N",'||   --hideflag  
                              '""';   -- sequencenr  
      l_old_values_string :=  '"'||upper(:old.specialpackagename)||'",'||  
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              --'"'||to_char(nvl(:old.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'",'||  
                              '"'||to_char(nvl(:new.enddate,TO_DATE('31-12-4000','DD/MM/YYYY')),'MM/DD/YYYY')||'",'||  
                              '"N",'||   --hideflag  
                              '""';   -- sequencenr  
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

      l_open_period_i := :old.open_period_i;
      l_open_period_u := coalesce( :old.open_period_u,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
      --
   END IF;  
   IF deleting THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
      l_iud := 'D';
      xxcpc_page_sppa.delete_package ( :old.specialpackagename );  
      l_open_period_i := :old.open_period_i;
      l_open_period_u := :old.open_period_u;
      l_open_period_d := coalesce( xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;  
    --
    insert into XXCPC_SPECIALPACKAGES_A( IUD,ID,SPECIALPACKAGENAME,STARTDATE,ENDDATE,UPDATEDFLAG,CREATED,CREATED_BY,UPDATED,UPDATED_BY,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,SPECIALPACKAGENAME_OLD,STARTDATE_OLD,ENDDATE_OLD,UPDATEDFLAG_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD,delete_period)   
    values ( l_iud, :new.ID, :new.SPECIALPACKAGENAME, :new.STARTDATE, :new.ENDDATE, :new.UPDATEDFLAG, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, l_open_period_i, l_open_period_u , :old.ID, :old.SPECIALPACKAGENAME, :old.STARTDATE, :old.ENDDATE, :old.UPDATEDFLAG, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.OPEN_PERIOD_I, l_open_period_u, l_open_period_d);
    --
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
exception   
when others then  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end) sqlerrm = '||sqlerrm );   
   raise;  
END xxcpc_specialpackages_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SPECIALPACKAGES_BIUD" ENABLE;

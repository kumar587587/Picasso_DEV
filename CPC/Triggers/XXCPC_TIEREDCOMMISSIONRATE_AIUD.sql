--------------------------------------------------------
--  DDL for Trigger XXCPC_TIEREDCOMMISSIONRATE_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_TIEREDCOMMISSIONRATE_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_TIEREDCOMMISSIONRATES"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_TIEREDCOMMISSIONRATE_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    l_sp_table_name        VARCHAR2(50) := 'spCPCTieredCommissionRate';  
    l_sp_pk_field          VARCHAR2(50) := 'ContractID,StartDate,TierID';  
    l_startdate            date;  
    l_enddate              date;  
    l_contractnr           VARCHAR2(50);  
    --  
    PROCEDURE get_data( p_id in number , p_startdate out date, p_enddate out date, p_Contractnr out varchar2 )   
    IS  
       PRAGMA autonomous_transaction;  
    BEGIN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', '(start) p_id ='||p_id );   
       select tp.startdate,tp.enddate,c.contractnr   
       into p_startdate, p_enddate, p_Contractnr  
       from xxcpc_tierperiods  tp  
       ,    xxcpc_contracts    c   
       where 1=1  
       and c.id  = tp.contractid  
       and tp.id =  p_id  
       ;    
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', 'p_startdate = '||p_startdate );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', 'p_enddate = '||p_enddate );   
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', 'p_Contractnr = '||p_Contractnr );   
       COMMIT;  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', '(end)');   
    EXCEPTION  
    WHEN OTHERS THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name||'.get_data', 'ERROR: '||SQLERRM);   
       raise;  
    END get_data;       
BEGIN       
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
    IF inserting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      --  
      get_data ( :new.tierperiodid, l_startdate, l_enddate, l_Contractnr );  
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape( upper(l_Contractnr) ) ||';StartDate='||to_char(l_startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00'||';TierID='||:new.tierid , null ) THEN  
         l_new_values_string :=  '"'||upper(l_Contractnr)||'",'||  
                                 '"'||to_char(l_startdate,'MM/DD/YYYY')||'",'||  
                                 '"'||to_char(l_enddate  ,'MM/DD/YYYY')||'",'||  
                                 '"'||:new.tierid||'",'||  
                                 '"'||:new.min_value||'",'||  
                                 '"'||:new.max_value||'",'||                                  
                                 '"'||xxcpc_gen_rest_apis.reformat_number( :new.rateamount) ||'",'||  
                                 '""'   -- comment  
                                 ;  
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
      get_data ( :new.tierperiodid, l_startdate, l_enddate, l_Contractnr );  
      --     
      l_new_values_string :=  '"'||upper(l_Contractnr)||'",'||  
                              '"'||to_char(l_startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(l_enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||:new.tierid||'",'||  
                              '"'||:new.min_value||'",'||  
                              '"'||:new.max_value||'",'||                                  
                              '"'||xxcpc_gen_rest_apis.reformat_number( :new.rateamount) ||'",'||  
                              '""'   -- comment  
                              ;  
      select tp.startdate,tp.enddate,c.contractnr   
      into l_startdate, l_enddate, l_Contractnr  
      from XXCPC_TIERPERIODS  tp  
      ,    xxcpc_contracts    c   
      where 1=1  
      and c.id  = tp.contractid  
      and tp.id =  :old.tierperiodid  
      ;  
      l_old_values_string :=  '"'||upper(l_Contractnr)||'",'||  
                              '"'||to_char(l_startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(l_enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||:old.tierid||'",'||  
                              '"'||:old.min_value||'",'||  
                              '"'||:old.max_value||'",'||                                  
                              '"'||xxcpc_gen_rest_apis.reformat_number( :old.rateamount) ||'",'||  
                              '""'   -- comment  
                              ;  
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
      get_data ( :old.tierperiodid, l_startdate, l_enddate, l_Contractnr );  
      --  
      -- Only delete if the row does not already exist.                          
      IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_sp_table_name, l_sp_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape( upper(l_Contractnr) ) ||';StartDate='||to_char(l_startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00'||';TierID='||:old.tierid , null  ) THEN  
         l_old_values_string :=  '"'||upper(l_Contractnr)||'",'||  
                                 '"'||to_char(l_startdate,'MM/DD/YYYY')||'",'||  
                                 '"'||to_char(l_enddate  ,'MM/DD/YYYY')||'",'||  
                                 '"'||:old.tierid||'",'||  
                                 '"'||:old.min_value||'",'||  
                                 '"'||:old.max_value||'",'||                                  
                                 '"'||xxcpc_gen_rest_apis.reformat_number( :old.rateamount) ||'",'||  
                                 '""'   -- comment  
                                 ;  
         xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
      END IF;      
   END IF;  
   --  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   
END XXCPC_TIEREDCOMMISSIONRATE_AIUD;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_TIEREDCOMMISSIONRATE_AIUD" ENABLE;

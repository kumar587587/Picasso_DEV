--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTENTPARTNERS_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERS_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTENTPARTNERS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTENTPARTNERS_AIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_new_payee_values_string    VARCHAR2(32000);  
    l_old_payee_values_string    VARCHAR2(32000);  

    l_api_return_value     VARCHAR2(32000);      
    l_sp_table_name        VARCHAR2(50) := 'spContentPartner';  
    l_sp_pk_field          VARCHAR2(50) := 'PartnerNumber';  
    l_pl_table_name        VARCHAR2(50) := 'Payee_';  
    l_pl_pk_field          VARCHAR2(50) := 'PayeeID_';  
    l_country_new          VARCHAR2(200);   
    l_country_old          VARCHAR2(200);  
    --
    function get_iso_code (p_code in varchar2)
    return varchar2
    is
       l_country  varchar2(200);
    begin
       select description 
       into l_country
       from xxcpc_lookups 
       where type = 'ISO_COUNTRY_CODE' 
       and code = p_code;
       return l_country;
   exception
   when others then
       return '';
   end get_iso_code;      
   --
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
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting :new.billingcountrycode ='||:new.billingcountrycode );   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting :new.email ='||:new.email );   

      l_country_new := nvl(get_iso_code( :new.billingcountrycode ),null);
      --  
      -- Only insert if the row does not already exist.                          
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:new.partnernumber) ) , null ) THEN  
         l_new_payee_values_string :=   '"'||upper(:new.partnernumber)||'",'||  --PayeeID
                                        '"'||:new.partnername||'",'||           --Name
                                        nvl(:new.parent,'null,')||                --Parent
                                        --'null,'||                               --Parent                                   
                                        'null,'||                               --Salutation      
                                        '"'||:new.billingemailaddress||'",'||                 --Email
                                        '"",'||                                 --Phone    
                                        '"",'||                                 --Extension     
                                        'null,'||                               --TitleId     
                                        'null,'||                               --Reports_To      
                                        'null,'||                               --Payee_Currency      
                                        'null,'||                               --Data_of_Hire      
                                        'null,'||                               --Termination_Date      
                                        '"",'||                                 --Comment      
                                        'null,'||                               --Status    
                                        'null,'||                               --Admin      
                                        '"'||:new.partnerlanguage||'",'||       --Language      
                                        '"'||:new.cpcode||'",'||                --CenterCode    
                                        '"",'||                                 --Role    
                                        'null,'||                               --AdminTypeRole       
                                        '"CONTENT PARTNER",'||                  --PayeeType                   
                                        '"'||:new.partnername||'('||ltrim(to_char(:new.partnernumber))||')",'||           --PayeeNameID    
                                        '"'||:new.holdpaymentsindicator||'"'    --HoldPayment
                                        ;  
         --xxcpc_gen_rest_apis.insert_row( l_pl_table_name, l_new_payee_values_string );  
         xxcpc_gen_rest_apis.insert_row
         ( p_table_name      => l_pl_table_name
         , p_key_values      => l_new_payee_values_string
         , p_new_values      => l_new_payee_values_string
         , p_effective_date  => NULL
         , p_overwrite       => NULL
         );            

      END IF;  
      IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:new.partnernumber) )  , null ) THEN  
         l_new_values_string :=  '"'||upper(:new.partnernumber)||'",'||  
                                 '"'||:new.partnername||'",'||  
                                 '"'||:new.cpcode||'",'||  
                                 '"'||:new.billingdebtornr||'",'||  
                                 '"'||:new.billinglocation||'",'||  
                                 '"'||:new.partnerlanguage||'",'||  
                                 '"'||:new.createspecificationindicator||'",'||  
                                 '"'||:new.holdpaymentsindicator||'",'||  
                                 '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                                 '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'",'||  
                                 '"'||:new.partnerpaymentterms||'",'||  
                                 '"CPC",'||   --IdentifierType  
                                 '"'||:new.billingcity||'",'||  
                                 '"'||l_country_new||'",'||                     --BillingCountry  
                                 '"'||:new.billingcountrycode||'",'||  
                                 --'" ",'|| --BillingDeliverTo  
                                 '"'||:new.partnerbillingname||'",'||                  --BillingDeliverTo 
                                 '"'||:new.billingiban||'",'||  
                                 '"'||:new.billingpostalcode||'",'||  
                                 '" ",'||  --BillingState  
                                 '"'||:new.billingstreet||'",'||
                                 '"'||:new.billingvatnumber||'",'||
                                 '"'||:new.billingemailaddress||'"'
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
      --         
   END IF;       
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating old.startdate='||:old.startdate );   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating new.cpcode='||:new.cpcode );   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating old.cpcode='||:old.cpcode );
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting :new.email ='||:new.email );   
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting :old.email ='||:old.email );               
      --
      l_country_new := nvl(get_iso_code( :new.billingcountrycode ),null);
      l_country_old := nvl(get_iso_code( :old.billingcountrycode ),null);
      --  
      --l_new_payee_values_string :=   '"'||upper(:new.partnernumber)||'","'||:new.partnername||'",null,null,"","", "", null,null,null,null,null,"",null,null,null,"","", null,"CONTENT PARTNER","",null';  
      l_new_payee_values_string :=   '"'||upper(:new.partnernumber)||'",'||     --PayeeID
                                        '"'||:new.partnername||'",'||           --Name
                                        --'"'||:new.parent||'",'||                --Parent
                                        nvl(:new.parent,'null')||','||                --Parent
                                        --'null,'||                               --Parent                                   
                                        'null,'||                               --Salutation      
                                        '"'||:new.billingemailaddress||'",'||                 --Email
                                        '"",'||                                 --Phone    
                                        '"",'||                                 --Extension     
                                        'null,'||                               --TitleId     
                                        'null,'||                               --Reports_To      
                                        'null,'||                               --Payee_Currency      
                                        'null,'||                               --Data_of_Hire      
                                        'null,'||                               --Termination_Date      
                                        '"",'||                                 --Comment      
                                        'null,'||                               --Status    
                                        'null,'||                               --Admin      
                                        '"'||:new.partnerlanguage||'",'||       --Language      
                                        '"'||:new.cpcode||'",'||                --CenterCode    
                                        '"",'||                                 --Role    
                                        'null,'||                               --AdminTypeRole       
                                        '"CONTENT PARTNER",'||                  --PayeeType                   
                                        '"'||:new.partnername||'('||ltrim(to_char(:new.partnernumber))||')",'||           --PayeeNameID     
                                        '"'||:new.holdpaymentsindicator||'"'    --HoldPayment  
                                        ;  
      --l_old_payee_values_string :=   '"'||upper(:old.partnernumber)||'","'||:old.partnername||'",null,null,"","", "", null,null,null,null,null,"",null,null,null,"","", null,"CONTENT PARTNER","",null';  
      l_old_payee_values_string :=   '"'||upper(:old.partnernumber)||'",'||     --PayeeID
                                        '"'||:old.partnername||'",'||           --Name
                                        --'"'||:old.parent||'",'||                --Parent
                                        nvl(:old.parent,'null')||','||                --Parent
                                        --'null,'||                               --Parent                                   
                                        'null,'||                               --Salutation      
                                        '"'||:old.billingemailaddress||'",'||                 --Email
                                        '"",'||                                 --Phone    
                                        '"",'||                                 --Extension     
                                        'null,'||                               --TitleId     
                                        'null,'||                               --Reports_To      
                                        'null,'||                               --Payee_Currency      
                                        'null,'||                               --Data_of_Hire      
                                        'null,'||                               --Termination_Date      
                                        '"",'||                                 --Comment      
                                        'null,'||                               --Status    
                                        'null,'||                               --Admin      
                                        '"'||:old.partnerlanguage||'",'||       --Language      
                                        '"'||:old.cpcode||'",'||                --CenterCode    
                                        '"",'||                                 --Role    
                                        'null,'||                               --AdminTypeRole       
                                        '"CONTENT PARTNER",'||                  --PayeeType                   
                                        '"'||:old.partnername||'('||ltrim(to_char(:old.partnernumber))||')",'||           --PayeeNameID     
                                        '"'||:old.holdpaymentsindicator||'"'    --HoldPayment  
                                         ;  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_new_payee_values_string ='||l_new_payee_values_string );                                                        
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting l_old_payee_values_string ='||l_old_payee_values_string );                                                        
      --xxcpc_gen_rest_apis.update_row ( l_pl_table_name , l_new_payee_values_string, l_old_payee_values_string, :old.rowid ); 
      xxcpc_gen_rest_apis.update_row 
        ( p_table_name     => l_pl_table_name 
        , p_key_values     => l_new_payee_values_string
        , p_apex_id        => :new.id  
        , p_new_values     => l_new_payee_values_string
        , p_old_values     => l_old_payee_values_string
        , p_old_rowid      => :old.rowid
        , p_effective_date => null
        , p_overwrite      => false
        );  


      l_new_values_string :=  '"'||upper(:new.partnernumber)||'",'||  
                              '"'||:new.partnername||'",'||  
                              '"'||:new.cpcode||'",'||  
                              '"'||:new.billingdebtornr||'",'||  
                              '"'||:new.billinglocation||'",'||  
                              '"'||:new.partnerlanguage||'",'||  
                              '"'||:new.createspecificationindicator||'",'||  
                              '"'||:new.holdpaymentsindicator||'",'||  
                              '"'||to_char(:new.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:new.enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||:new.partnerpaymentterms||'",'||  
                              '"CPC",'||                                        --IdentifierType  
                              '"'||:new.billingcity||'",'||  
                              '"'||l_country_new||'",'||                        --BillingCountry  
                              '"'||:new.billingcountrycode||'",'||  
                              --'" ",'|| --BillingDeliverTo  
                              '"'||:new.partnerbillingname||'",'||                     --BillingDeliverTo 
                              '"'||:new.billingiban||'",'||  
                              '"'||:new.billingpostalcode||'",'||  
                              '" ",'||  --BillingState  
                              '"'||:new.billingstreet||'",'||  
                              '"'||:new.billingvatnumber||'",'||  
                              '"'||:new.billingemailaddress||'"';
      l_old_values_string :=  '"'||upper(:old.partnernumber)||'",'||  
                              '"'||:old.partnername||'",'||  
                              '"'||:old.cpcode||'",'||  
                              '"'||:old.billingdebtornr||'",'||  
                              '"'||:old.billinglocation||'",'||  
                              '"'||:old.partnerlanguage||'",'||  
                              '"'||:old.createspecificationindicator||'",'||  
                              '"'||:old.holdpaymentsindicator||'",'||  
                              '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                              '"'||to_char(:old.enddate  ,'MM/DD/YYYY')||'",'||  
                              '"'||:old.partnerpaymentterms||'",'||  
                              '"CPC",'||                                        --IdentifierType  
                              '"'||:old.billingcity||'",'||  
                              '"'||l_country_old||'",'||                        --BillingCountry  
                              '"'||:old.billingcountrycode||'",'||  
                              '"'||:old.partnerbillingname||'",'||                     --BillingDeliverTo 
                              '"'||:old.billingiban||'",'||  
                              '"'||:old.billingpostalcode||'",'||  
                              '" ",'||                                          --BillingState  
                              '"'||:old.billingstreet||'",'||    
                              '"'||:old.billingvatnumber||'",'||    
                              '"'||:old.billingemailaddress||'"';
       --xxcpc_gen_rest_apis.update_row ( l_sp_table_name , l_new_values_string, l_old_values_string, :old.rowid );    
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
        l_country_old := nvl(get_iso_code( :old.billingcountrycode ),null);
        --
        IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_sp_table_name, l_sp_pk_field, l_sp_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.partnernumber) )  , null ) THEN  
           xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );   
           l_old_values_string :=  '"'||upper(:old.partnernumber)||'",'||  
                                   '"'||:old.partnername||'",'||  
                                   '"'||:old.cpcode||'",'||  
                                   '"'||:old.billingdebtornr||'",'||  
                                   '"'||:old.billinglocation||'",'||  
                                   '"'||:old.partnerlanguage||'",'||  
                                   '"'||:old.createspecificationindicator||'",'||  
                                   '"'||:old.holdpaymentsindicator||'",'||  
                                   '"'||to_char(:old.startdate,'MM/DD/YYYY')||'",'||  
                                   '"'||to_char(:old.enddate  ,'MM/DD/YYYY')||'",'||  
                                   '"'||:old.partnerpaymentterms||'",'||  
                                   '"CPC",'||                                   --IdentifierType  
                                   '"'||:old.billingcity||'",'||  
                                   '"'||l_country_old||'",'||                   --BillingCountry  
                                   '"'||:old.billingcountrycode||'",'||  
                                   --'" ",'||                                     --BillingDeliverTo  
                                   '"'||:old.partnerbillingname||'",'||                     --BillingDeliverTo 
                                   '"'||:old.billingiban||'",'||  
                                   '"'||:old.billingpostalcode||'",'||  
                                   '" ",'||                                     --BillingState  
                                   '"'||:old.billingstreet||'",'||   
                                   '"'||:old.billingvatnumber||'",'||    
                                   '"'||:old.billingemailaddress||'"';

           xxcpc_gen_rest_apis.delete_row( l_sp_table_name , l_old_values_string , l_old_values_string);  
        END IF;     
        -- Delete from plTable  
        -- Only delete if the row exist in plTable.      
        IF xxcpc_gen_rest_apis.does_row_with_pk_exist ( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(:old.partnernumber) )  , null  ) THEN  
           xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from Payee' );   
           l_old_payee_values_string :=   '"'||upper(:old.partnernumber)||'","'||:old.partnername||'",null,null,"","", "", null,null,null,null,null,"",null,null,null,"","", null,"CONTENT PARTNER","",null';  
           xxcpc_gen_rest_apis.delete_row( l_pl_table_name, l_old_payee_values_string , l_old_payee_values_string);  
        END IF;     
       --  
    END IF;  
    --  
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   

END xxcpc_contentpartners_aiud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERS_AIUD" ENABLE;

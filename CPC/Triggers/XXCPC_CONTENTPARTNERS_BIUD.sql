--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTENTPARTNERS_BIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERS_BIUD" 
  BEFORE INSERT OR DELETE OR UPDATE ON "XXCPC_CONTENTPARTNERS"
  REFERENCING FOR EACH ROW
  DECLARE     
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTENTPARTNERS_BIUD';  
    l_new_values_string    VARCHAR2(32000);  
    l_old_values_string    VARCHAR2(32000);  
    l_api_return_value     VARCHAR2(32000);      
    l_sp_table_name        VARCHAR2(50) := 'spContentPartner';  
    l_sppk_field           VARCHAR2(50) := 'PartnerNumber';  
    l_error_message        VARCHAR2(500);
    l_iud                  varchar2(1);
    l_open_period_i        varchar2(15);
    l_open_period_u        varchar2(15);
    l_open_period_d        varchar2(15);
BEGIN       
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );   
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'PARTNERPAYMENTTERMS = |'||:new.partnerpaymentterms||'|' );  
   xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'PARTNERBILLINGNAME = |'||:new.partnerbillingname||'|' );  
   IF inserting THEN       
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );   
      l_iud               := 'I';   
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         :new.partnernumber  :=XXCPC_CONTENTPARTNER_SEQ.nextval;
         :new.created        := sysdate;       
         :new.created_by     := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updated        := sysdate;       
         :new.updated_by     := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag    :='Y';       
         :new.enddate        := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY'));   
         :new.startdate      := TO_DATE('01-01-2017','DD-MM-YYYY');
      END IF;   
      l_open_period_i := coalesce( :new.open_period_i,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
   END IF;       
   --  
   IF updating THEN  
      xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );   
      l_iud        := 'U';   
      IF XXSPM_TOOLS_PKG.g_biu_triggers_active then 
         :new.updated := sysdate;       
         :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);       
         :new.updatedflag :='Y';       
         :new.enddate := nvl(:new.enddate,TO_DATE('31-12-4000','DD-MM-YYYY')); 
      END IF;   
      l_open_period_i := :old.open_period_i;
      l_open_period_u := coalesce( :old.open_period_u,xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;  
    --  
    IF deleting THEN  
       xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );   
       l_iud               := 'D';   
       l_error_message := xxcpc_page_cnpr.checkusedincontract (:old.id);
       IF l_error_message IS NOT NULL THEN
          raise_application_error(-20000, l_error_message );
       END IF;   
       l_open_period_i := :old.open_period_i;
       l_open_period_u := :old.open_period_u;
       l_open_period_d := coalesce( xxcpc_gen_rest_apis.get_open_period,xxcpc_gen_rest_apis.get_comp_period);
    END IF;  
    --
    insert into XXCPC_CONTENTPARTNERS_A( IUD,ID,PARTNERNUMBER,PARTNERNAME,STARTDATE,ENDDATE,CPCODE,BILLINGDEBTORNR,PARTNERPAYMENTTERMS,BILLINGLOCATION,CREATESPECIFICATIONINDICATOR,HOLDPAYMENTSINDICATOR,PARTNERLANGUAGE,UPDATEDFLAG,CREATED,CREATED_BY,UPDATED,UPDATED_BY,BILLINGIBAN,BILLINGVATNUMBER,BILLINGSTREET,BILLINGPOSTALCODE,BILLINGCITY,BILLINGCOUNTRYCODE,EMAIL,ODIS_RESOURCE_NR,PARTNERBILLINGNAME,BILLINGEMAILADDRESS,OPEN_PERIOD_I,OPEN_PERIOD_U,ID_OLD,PARTNERNUMBER_OLD,PARTNERNAME_OLD,STARTDATE_OLD,ENDDATE_OLD,CPCODE_OLD,BILLINGDEBTORNR_OLD,PARTNERPAYMENTTERMS_OLD,BILLINGLOCATION_OLD,CREATESPECIFICATIONINDICATOR_OLD,HOLDPAYMENTSINDICATOR_OLD,PARTNERLANGUAGE_OLD,UPDATEDFLAG_OLD,CREATED_OLD,CREATED_BY_OLD,UPDATED_OLD,UPDATED_BY_OLD,BILLINGIBAN_OLD,BILLINGVATNUMBER_OLD,BILLINGSTREET_OLD,BILLINGPOSTALCODE_OLD,BILLINGCITY_OLD,BILLINGCOUNTRYCODE_OLD,EMAIL_OLD,ODIS_RESOURCE_NR_OLD,PARTNERBILLINGNAME_OLD,BILLINGEMAILADDRESS_OLD,OPEN_PERIOD_I_OLD,OPEN_PERIOD_U_OLD,delete_period)   
    values ( l_iud, :new.ID, :new.PARTNERNUMBER, :new.PARTNERNAME, :new.STARTDATE, :new.ENDDATE, :new.CPCODE, :new.BILLINGDEBTORNR, :new.PARTNERPAYMENTTERMS, :new.BILLINGLOCATION, :new.CREATESPECIFICATIONINDICATOR, :new.HOLDPAYMENTSINDICATOR, :new.PARTNERLANGUAGE, :new.UPDATEDFLAG, :new.CREATED, :new.CREATED_BY, :new.UPDATED, :new.UPDATED_BY, :new.BILLINGIBAN, :new.BILLINGVATNUMBER, :new.BILLINGSTREET, :new.BILLINGPOSTALCODE, :new.BILLINGCITY, :new.BILLINGCOUNTRYCODE, :new.EMAIL, :new.ODIS_RESOURCE_NR, :new.PARTNERBILLINGNAME, :new.BILLINGEMAILADDRESS, l_open_period_i, l_open_period_u , :old.ID, :old.PARTNERNUMBER, :old.PARTNERNAME, :old.STARTDATE, :old.ENDDATE, :old.CPCODE, :old.BILLINGDEBTORNR, :old.PARTNERPAYMENTTERMS, :old.BILLINGLOCATION, :old.CREATESPECIFICATIONINDICATOR, :old.HOLDPAYMENTSINDICATOR, :old.PARTNERLANGUAGE, :old.UPDATEDFLAG, :old.CREATED, :old.CREATED_BY, :old.UPDATED, :old.UPDATED_BY, :old.BILLINGIBAN, :old.BILLINGVATNUMBER, :old.BILLINGSTREET, :old.BILLINGPOSTALCODE, :old.BILLINGCITY, :old.BILLINGCOUNTRYCODE, :old.EMAIL, :old.ODIS_RESOURCE_NR, :old.PARTNERBILLINGNAME, :old.BILLINGEMAILADDRESS, :old.OPEN_PERIOD_I, l_open_period_u, l_open_period_d);
    --  
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );   

END xxcpc_contentpartners_biud;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTENTPARTNERS_BIUD" ENABLE;

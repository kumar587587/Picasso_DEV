--------------------------------------------------------
--  DDL for Procedure MIGRATE_ALL_PM_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXPM"."MIGRATE_ALL_PM_DATA" 
is
  c_proc_name varchar2(50) :='migrate_all_pm_data'; 
  l_col_list varchar2(20000);
  l_col_vals varchar2(20000);
  l_ins_stm  varchar2(20000);
  l_max_id   number; 
begin 
   xxpm_gen_debug_pkg.debug(c_proc_name,'(start)');
   if instr( sys_context('USERENV'   , 'DB_NAME') ,'APXPRD') = 0 then
      update xxpm_partners_mig set email_address = partner_vcode||'@kpnconsumer'
      --, email_address_invoice='picasso@kpn.com'
      , email_address_invoice= partner_vcode||'@kpnconsumer'
      , vat_reverse_charge = nvl( vat_reverse_charge,'N')
      ;
      commit;
   end if;   
   --
   update xxpm_partners_mig
   set ip_whitelist = replace(ip_whitelist,'_x000D_','')
   where ip_whitelist is not null
   and ip_whitelist like '%_x000D_%'
   ;
   commit;
   -- Disable all triggers
   for r_row in ( select 'alter trigger '||trigger_name||' disable' stm from all_triggers where trigger_name like 'XXPM%' and trigger_name not like 'XXPM%DEBUG%' ) loop
       execute immediate r_row.stm;
   end loop;
   --xxpm_gen_debug_pkg.debug(c_proc_name,'1');
   -- Truncate all tables
   for r_row in ( select 'truncate table '||table_name stm from all_tables where table_name in ('XXPM_ADDRESSES','XXPM_PARTNERS','XXPM_CHAINS','XXPM_CONTACTS','XXPM_VCODES','XXPM_AUDIT_DATA') order by table_name) loop
      execute immediate r_row.stm;
   end loop;

   for r_row in ( select 'truncate table '||table_name stm from all_tables where table_name in ('XXPM_ALL_ASSIGNMENTS' ) order by table_name) loop
      execute immediate r_row.stm;
   end loop;
   for r_row in ( select 'truncate table '||table_name stm from all_tables where table_name in ('XXPM_ALL_JOBS','XXPM_ALL_PEOPLE') order by table_name) loop
      execute immediate r_row.stm;
   end loop;

   -- Enable all triggers
   --for r_row in ( select 'alter trigger '||trigger_name||' enable' stm from all_triggers where trigger_name like 'XXPM%') loop
   --    execute immediate r_row.stm;
   --end loop;

   -----People-------------------------------------------------------------
    insert into xxpm_all_jobs(JOB_ID, NAME, CREATION_DATE ,CREATED_BY, LAST_UPDATE_DATE,LAST_UPDATED_BY)
    select a.*,sysdate CREATION_DATE , -1 CREATED_BY,sysdate LAST_UPDATE_DATE,-1 LAST_UPDATED_BY from xxpm_all_jobs_mig a;

    insert into xxpm_all_people(PERSON_ID, FULL_NAME, NATIONAL_IDENTIFIER, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE
    ,creation_date,created_by,last_update_date,last_updated_by) 
    select a.*,sysdate, -1,sysdate,-1 from xxpm_all_people_mig a;

    insert into xxpm_all_assignments(ASSIGNMENT_ID, PERSON_ID, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, JOB_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY) 
    select a.*,sysdate, -1,sysdate,-1 from xxpm_all_assignments_mig a;

    insert into xxpm_audit_data select * from xxpm_audit_data_mig
    ;


   -----Chains-------------------------------------------------------------
   select listagg(column_name,', ') 
   into l_col_list
   from all_tab_columns 
   where table_name = 'XXPM_CHAINS' 
   ;
   select listagg(column_name,', ') within group (order by column_id)
   into l_col_vals
   from (
      select column_name,column_id
      from all_tab_columns 
      where table_name = 'XXPM_CHAINS' 
      and data_type <> 'DATE'
      union
      select 'to_date('||column_name||',''MONYYYYDD'')', column_id
      from all_tab_columns 
      where table_name = 'XXPM_CHAINS' 
      and data_type = 'DATE'
     )      
   ;
   l_ins_stm := 'insert into xxpm_chains('||l_col_list||') select '||l_col_vals||' from xxpm_chains_mig';
   xxpm_gen_debug_pkg.debug(c_proc_name,'l_ins_stm = '||l_ins_stm);
   execute immediate l_ins_stm;
   --
   execute immediate 'drop sequence XXPM_CHAINS_SEQ';
   select max(chain_id)+1
   into l_max_id
   from xxpm_chains
   ;
   execute immediate 'create sequence XXPM_CHAINS_SEQ start with '||l_max_id;
   ---PARTNERS---------------------------------------------------------------
   select listagg(column_name,', ')  within group (order by column_id)
   into l_col_list
   from all_tab_columns 
   where table_name = 'XXPM_PARTNERS' 
   --and column_name not in ('CREATION_DATE','LAST_UPDATE_DATE','SHARE_DOCUMENTS','USE_IN_CREDITTOOL_CM','PARTNER_FLOW_TYPE','GPG_PUBLIC_KEY_ID') --,'START_DATE','END_DATE','CERTIFICATE_DATE'
   --and column_name not in ('SHARE_DOCUMENTS','USE_IN_CREDITTOOL_CM') --,'START_DATE','END_DATE','CERTIFICATE_DATE'
   --and column_name not in ('PAYEE_ACTIVE','TV_MAIL_SPECIFICATION') --,'START_DATE','END_DATE','CERTIFICATE_DATE'
   --and column_id < 58
   ;
   select listagg(column_name,', ') within group (order by column_id)
   into l_col_vals
   from (
      select column_name,column_id
      from all_tab_columns 
      where table_name = 'XXPM_PARTNERS' 
      --and column_name not in ('SHARE_DOCUMENTS','USE_IN_CREDITTOOL_CM') 
      --and column_name not in ('PAYEE_ACTIVE','TV_MAIL_SPECIFICATION')
      and data_type <> 'DATE'
      --and column_id < 58
      union
      --select 'to_date(substr('||column_name||',2),''MONYYYYDD'')', column_id
      select 'to_date('||column_name||',''MONYYYYDD'')', column_id
      from all_tab_columns 
      where table_name = 'XXPM_PARTNERS' 
      --and column_name not in ('SHARE_DOCUMENTS','USE_IN_CREDITTOOL_CM') 
      --and column_name not in ('PAYEE_ACTIVE','TV_MAIL_SPECIFICATION')
      and data_type = 'DATE'
      --and column_id < 58
     )      
   ;
   --
   --l_col_vals := l_col_list;--||', sysdate, sysdate';
   --l_col_list := l_col_list;--||', CREATION_DATE,LAST_UPDATE_DATE,START_DATE';
   l_ins_stm := 'insert into xxpm_partners('||l_col_list||') select '||l_col_vals||' from xxpm_partners_mig';
   xxpm_gen_debug_pkg.debug(c_proc_name,'l_ins_stm = '||l_ins_stm);
   execute immediate l_ins_stm;
   --
   execute immediate 'drop sequence XXPM_PARTNERS_SEQ';
   select max(partner_id)+1
   into l_max_id
   from xxpm_partners
   ;
   execute immediate 'create sequence XXPM_PARTNERS_SEQ start with '||l_max_id;

   -----Contacts-------------------------------------------------------------
   select listagg(column_name,', ') within group (order by column_id)
   into l_col_list
   from all_tab_columns 
   where table_name = 'XXPM_CONTACTS' 
   ;
   select listagg(column_name,', ') within group (order by column_id)
   into l_col_vals
   from (
      select column_name,column_id
      from all_tab_columns 
      where table_name = 'XXPM_CONTACTS' 
      and data_type <> 'DATE'
      union
      select 'to_date('||column_name||',''MONYYYYDD'')', column_id
      from all_tab_columns 
      where table_name = 'XXPM_CONTACTS' 
      and data_type = 'DATE'
     )      
   ;
   l_ins_stm := 'insert into xxpm_contacts('||l_col_list||') select '||l_col_vals||' from xxpm_contacts_mig';
   xxpm_gen_debug_pkg.debug(c_proc_name,'l_ins_stm = '||l_ins_stm);
   execute immediate l_ins_stm;   
   --
   execute immediate 'drop sequence XXPM_CONTACTS_SEQ';
   select max(contact_id)+1
   into l_max_id
   from xxpm_contacts
   ;
   execute immediate 'create sequence XXPM_CONTACTS_SEQ start with '||l_max_id;

   -----Addresses-------------------------------------------------------------
   select listagg(column_name,', ') WITHIN GROUP (ORDER BY column_id) 
   into l_col_list
   from all_tab_columns 
   where table_name = 'XXPM_ADDRESSES' 
   ;
   select listagg(column_name,', ') within group (order by column_id)
   into l_col_vals
   from (
      select column_name,column_id
      from all_tab_columns 
      where table_name = 'XXPM_ADDRESSES' 
      and data_type <> 'DATE'
      union
      select 'to_date('||column_name||',''MONYYYYDD'')', column_id
      from all_tab_columns 
      where table_name = 'XXPM_ADDRESSES' 
      and data_type = 'DATE'
     )      
   ;
   l_ins_stm := 'insert into xxpm_addresses('||l_col_list||') select '||l_col_vals||' from xxpm_addresses_mig';
   xxpm_gen_debug_pkg.debug(c_proc_name,'l_ins_stm = '||l_ins_stm);
   execute immediate l_ins_stm;
   --
   update xxpm_addresses set ADDRESS_RESIDENCE = replace(ADDRESS_RESIDENCE,'#APOSTROF#','''') where instr(ADDRESS_RESIDENCE,'#APOSTROF#') > 0;

   execute immediate 'drop sequence XXPM_ADDRESSES_SEQ';
   select max(address_id)+1
   into l_max_id
   from xxpm_addresses
   ;
   execute immediate 'create sequence XXPM_ADDRESSES_SEQ start with '||l_max_id;


   -- Enable all triggers
   for r_row in ( select 'alter trigger '||trigger_name||' enable' stm from all_triggers where trigger_name like 'XXPM%') loop
       execute immediate r_row.stm;
   end loop;
   xxpm_gen_debug_pkg.debug(c_proc_name,'(end)');
exception
when others then
   xxpm_gen_debug_pkg.debug(c_proc_name,'ERROR: '||SQLERRM);
   raise;
end;

/

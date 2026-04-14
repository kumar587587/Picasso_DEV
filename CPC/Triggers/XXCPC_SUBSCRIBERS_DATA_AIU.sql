--------------------------------------------------------
--  DDL for Trigger XXCPC_SUBSCRIBERS_DATA_AIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_AIU" 
  AFTER INSERT OR UPDATE ON "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA"
  REFERENCING FOR EACH ROW
  BEGIN
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU','(start)');   
    IF inserting THEN
       xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU','inserting');
       xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU',':new.id = '||:new.id);
      xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU',':length bob = '||length(:new.file_data));       
       xxcpc_import_excel.main( :new.file_name, :new.file_data, :new.id, :new.open_period_i );
        --:new.created := sysdate;
        --:new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    END IF;
    IF updating THEN
       xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU','updating');
       xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU',':new.id = '||:new.id);
       xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU',':old.id = '||:old.id);
    --    :new.created := sysdate;
    --    :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    END IF;

    --:new.updated := sysdate;
    --:new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    --
    --IF substr(:new.file_name,-5) <> '.xlsx' THEN
    --   raise_application_error(-20000,  'File needs to be in Excel 2010 format with .xlsx as extention.');
    --END IF;
    -- other genral checks
    --IF length(:new.file_name)<5 THEN
    --   raise_application_error(-20000, 'Please use the correct filename. ( "<name>.xlsx" )');
    --ELSIF nvl(dbms_lob.getlength(:new.file_data),0) > 15728640 THEN
    --   raise_application_error(-20000, 'The size of the uploaded file was over 15MB. Please upload a smaller sized file.');
    --END IF;
    --XXCPC_IMPORT_EXCEL.set_file_id( :new.id );
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_AIU','(end');   
    --
END xxcpc_subscribers_data_aiu;
/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_AIU" ENABLE;

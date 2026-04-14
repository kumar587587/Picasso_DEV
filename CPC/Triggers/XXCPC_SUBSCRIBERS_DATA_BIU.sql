--------------------------------------------------------
--  DDL for Trigger XXCPC_SUBSCRIBERS_DATA_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_BIU" 
    BEFORE INSERT OR UPDATE 
    ON xxcpc_subscribers_data
    FOR EACH ROW
BEGIN
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_BIU','(start');   
    IF inserting THEN
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
        xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_BIU','Inserting :new.file_content_type = '||:new.file_content_type); 
        xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_BIU','Inserting :new.file_name = '||:new.file_name);   


        --xxcpc_import_excel.main( :new.file_data );
    END IF;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    IF updating THEN
        xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_BIU','Updating :new.file_name = '||:old.file_name);   
    END IF;    
    --
    IF substr(:new.file_name,-5) <> '.xlsx' THEN
       raise_application_error(-20000,  'File needs to be in Excel 2010 format with .xlsx as extention.');
    END IF;
    -- other genral checks
    IF length(:new.file_name)<5 THEN
       raise_application_error(-20000, 'Please use the correct filename. ( "<name>.xlsx" )');
    ELSIF nvl(dbms_lob.getlength(:new.file_data),0) > 15728640 THEN
       raise_application_error(-20000, 'The size of the uploaded file was over 15MB. Please upload a smaller sized file.');
    END IF;
    --
    xxcpc_gen_debug_pkg.debug( 'XXCPC_SUBSCRIBERS_DATA_BIU','(end)');   
END xxcpc_subscribers_data_biu;



/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_SUBSCRIBERS_DATA_BIU" ENABLE;

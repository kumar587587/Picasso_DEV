--------------------------------------------------------
--  DDL for Trigger XXCT_EXCEL_OUTPUT_FILES_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_EXCEL_OUTPUT_FILES_BIU" BEFORE INSERT OR UPDATE ON XXCT_EXCEL_OUTPUT_FILES
REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'XXCT_EXCEL_OUTPUT_FILES';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_EXCEL_OUTPUT_FILES_BIU.sql,v 1.1 2019/02/11 13:30:07 rikke493 Exp $';
   --
   l_ebs_user_name           VARCHAR2(255);
   --
   FUNCTION get_ebs_user_name
   RETURN varchar2
   IS
      l_user_id         number;
      l_user_name       varchar2(255);
   BEGIN
      l_user_id := apex_util.get_session_state('G_USER_ID');
      --
      BEGIN
       SELECT user_name
       INTO   l_user_name
       FROM   xxct_users
       WHERE  id = l_user_id;
       --
      EXCEPTION
      WHEN OTHERS THEN
         l_user_name := NULL;
      END;
      --
      RETURN l_user_name;
   END;
   --
BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,'Start.');
   IF NVL(dbms_lob.getlength(:new.file_data),0) > 15728640 THEN
      raise_application_error(-20000, 'The size of the uploaded file was over 15MB. Please upload a smaller sized file.');
   ELSE
      l_ebs_user_name := get_ebs_user_name;
      --
      IF inserting THEN
        :new.creation_date := sysdate;
        :new.created_by :=  nvl(l_ebs_user_name,nvl(wwv_flow.g_user,user));
        :new.file_id := XXCT_EXCEL_OUTPUT_FILES_seq.nextval;
      END IF;
      --
      IF inserting or updating THEN
         :new.last_update_date := sysdate;
         :new.last_updated_by  := nvl(l_ebs_user_name,nvl(wwv_flow.g_user,user));
      END IF;
   END IF;
   xxct_gen_debug_pkg.debug( c_trigger_name,'End.');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   --
   raise_application_error( -20001, Sqlerrm );
END;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_EXCEL_OUTPUT_FILES_BIU" ENABLE;

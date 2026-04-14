--------------------------------------------------------
--  DDL for Trigger XXCT_EXHIBITS_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_EXHIBITS_BIU" BEFORE INSERT OR UPDATE ON XXCT_EXHIBITS
REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'XXCT_EXHIBITS_BIU';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_EXHIBITS_BIU.sql,v 1.1 2018/12/05 15:12:18 rikke493 Exp $';
   --
   l_ebs_user_name           VARCHAR2(255);
   --
   PROCEDURE set_file_id(p_file_id IN NUMBER)
   IS
      pragma autonomous_transaction;
   BEGIN
      apex_util.set_session_state( p_name => 'P105_FILE_ID', p_value => p_file_id);
      commit;
   END;
   --
/*   FUNCTION get_ebs_user_name
   RETURN varchar2
   IS
      l_user_id         number;
      l_user_name       varchar2(255);
   BEGIN
      l_user_id := apex_util.get_session_state('EBS_USER_ID');
      --
      BEGIN
       SELECT user_name
       INTO   l_user_name
       FROM   apps.apex_ebs_user_v
       WHERE  user_id = l_user_id;
       --
      EXCEPTION
      WHEN OTHERS THEN
         l_user_name := NULL;
      END;
      --
      RETURN l_user_name;
   END;
*/   
   --
BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,'(start)');
   IF NVL(dbms_lob.getlength(:new.file_data),0) > 15728640 THEN
      raise_application_error(-20000, 'The size of the uploaded file was over 15MB. Please upload a smaller sized file.');
   ELSE
      --l_ebs_user_name := get_ebs_user_name;
      --
      IF inserting THEN
        :new.creation_date := sysdate;
        :new.created_by :=  v('APP_USER'); --nvl(l_ebs_user_name,nvl(wwv_flow.g_user,user));
        :new.file_id := xxct_exhibits_seq.nextval;
        set_file_id(:new.file_id);
      END IF;
      --
      IF inserting or updating THEN
         --:new.org_id := apex_util.get_session_state('EBS_ORG_ID');
         :new.last_update_date := sysdate;
         :new.last_updated_by  := v('APP_USER'); --nvl(l_ebs_user_name,nvl(wwv_flow.g_user,user));
      END IF;
   END IF;
   xxct_gen_debug_pkg.debug( c_trigger_name,'(end)');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   --
   raise_application_error( -20001, Sqlerrm );
END;




/
ALTER TRIGGER "WKSP_XXCT"."XXCT_EXHIBITS_BIU" ENABLE;

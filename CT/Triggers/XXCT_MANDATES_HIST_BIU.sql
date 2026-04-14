--------------------------------------------------------
--  DDL for Trigger XXCT_MANDATES_HIST_BIU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_MANDATES_HIST_BIU" 
  BEFORE INSERT OR UPDATE ON "WKSP_XXCT"."XXCT_MANDATES_HIST"
  REFERENCING FOR EACH ROW
  DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'Xxct_Mandates_Biu';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_MANDATES_BIU.sql,v 1.1 2018/12/05 15:12:55 rikke493 Exp $';
   --
BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,'Start.');
   --
   IF INSERTING THEN
      :NEW.creation_date := SYSDATE;
      :NEW.created_by :=  NVL(wwv_flow.g_user,USER);
      --:NEW.MANDATE_ID := XXCT_MANDATES_SEQ.nextval;
      :NEW.OBJECT_VERSION_NUMBER := 0;
      --
      --SELECT position_id
      --INTO   :NEW.POSITION_ID
      --FROM   xxct_persons_v
      --WHERE  person_Id = 1--:NEW.person_Id
      --;
   END IF;
   --
   IF UPDATING THEN
      IF  NVL(WWV_FLOW.G_USER,USER) <> 'APPS'
      THEN
         :NEW.last_update_date := SYSDATE;
         :NEW.last_updated_by  := v('EBS_USER_ID');
      END IF;
      --
      IF v('REQUEST') = 'APPLY_CHANGES_ACCEPT' then
         :NEW.APPROVAL_STATUS := 'Akkoord';
      ELSIF v('REQUEST') = 'APPLY_CHANGES_REJECT' then
         :NEW.APPROVAL_STATUS := 'Afgekeurd';
       END IF;
       --
   END IF;
   xxct_gen_debug_pkg.debug( c_trigger_name,'End.');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   --
   raise_application_error( -20001, Sqlerrm );
END;



/
ALTER TRIGGER "WKSP_XXCT"."XXCT_MANDATES_HIST_BIU" ENABLE;

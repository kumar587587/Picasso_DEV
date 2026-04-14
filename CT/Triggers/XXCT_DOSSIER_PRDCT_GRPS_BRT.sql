--------------------------------------------------------
--  DDL for Trigger XXCT_DOSSIER_PRDCT_GRPS_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_DOSSIER_PRDCT_GRPS_BRT" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_DOSSIER_PRODUCT_GROUPS"
  REFERENCING FOR EACH ROW
  DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'Xxct_Dossier_Prdct_Grps_Brt';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_DOSSIER_PRDCT_GRPS_BRT.sql,v 1.11 2021/10/14 06:50:27 engbe502 Exp $';
   l_count                   NUMBER;
   l_type                    VARCHAR2(30);
   l_type_other              VARCHAR2(30);
BEGIN
    xxct_gen_debug_pkg.debug( c_trigger_name,'(start)');
    l_type_other := v('P102_DOSSIER_TYPE_OTHER');
    l_type       := v('P102_DOSSIER_TYPE');
    if l_type = xxct_page_102_pkg.C_RESERVATION or l_type_other = xxct_page_102_pkg.C_PAYMENT then
       if inserting then
         l_count := xxct_page_102_pkg.count_product_groups(:new.dossier_id , :NEW.product_group_code, null);
       else
          l_count := xxct_page_102_pkg.count_product_groups_at(:new.dossier_id , :NEW.product_group_code, :OLD.dossier_product_group_id);
       end if;
       if l_count > 0 then
          raise_application_error( -20011, '.XXCT_DSSR_PRDCT_GRPS_IG_V_IIT' );
       end if;
       null;
   end if;
   IF inserting OR updating THEN
         SELECT mandate_cycle
         INTO   :NEW.mandate_cycle
         FROM xxct_dossiers
         WHERE dossier_id = :NEW.dossier_id
         ;
         :NEW.CREATION_DATE := SYSDATE;
   END IF;
   --
   IF UPDATING THEN
      IF :NEW.PRODUCT_GROUP_CODE <> :OLD.PRODUCT_GROUP_CODE THEN
         update XXCT_DSSR_PRDCT_GRPS_HST
         set   product_group_code = :NEW.PRODUCT_GROUP_CODE
         where dossier_id         = :NEW.DOSSIER_ID
         and   product_group_code = :OLD.PRODUCT_GROUP_CODE
         ;
      END IF;
   END IF;
   --
   IF DELETING THEN

      delete from XXCT_DSSR_PRDCT_GRPS_HST
      where dossier_id = :OLD.DOSSIER_ID
      and   product_group_code = :OLD.PRODUCT_GROUP_CODE
      and   mandate_cycle =  (select max(h2.mandate_cycle)
                              from   xxct_dssr_prdct_grps_hst h2
                              where h2.dossier_id = :OLD.DOSSIER_ID
                             )
      ;
      --IF NOT apps.xxct_general_pkg.g_circumvent_insert_actns THEN
         --if not xxct_page_102_pkg.g_restore_to_prev_status then
         --   xxct_page_102_pkg.approval_list ( :OLD.DOSSIER_ID, :OLD.AMOUNT,'XXCT_DOSSIER_PRDCT_GRPS_BRT' );
         --end if;
      --end if;
   END IF;
   --
   xxct_gen_debug_pkg.debug( c_trigger_name,'(end)');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   --
   raise_application_error( -20001, Sqlerrm );
END;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_DOSSIER_PRDCT_GRPS_BRT" ENABLE;

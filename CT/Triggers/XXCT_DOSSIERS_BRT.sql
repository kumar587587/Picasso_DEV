--------------------------------------------------------
--  DDL for Trigger XXCT_DOSSIERS_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_BRT" 
  BEFORE INSERT OR DELETE OR UPDATE ON "WKSP_XXCT"."XXCT_DOSSIERS"
  REFERENCING FOR EACH ROW
  DECLARE
   c_trigger_name            CONSTANT VARCHAR2(30)  := 'XXCT_DOSSIERS_BRT';
   c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_DOSSIERS_BRT.sql,v 1.9 2019/03/20 15:58:44 rikke493 Exp $';
   -- 
   l_next_number               NUMBER;
   l_prod_group_rec            xxct_dssr_prdct_grps_rec; 
   l_xxct_product_groups_array xxct_dssr_prdct_grps_tab:= xxct_dssr_prdct_grps_tab() ;
   l_xxct_old_versus_new_rec   xxct_old_versus_new_rec;
   l_xxct_old_versus_new_array xxct_old_versus_new_tab:= xxct_old_versus_new_tab();
   l_sum number;
   --
   FUNCTION get_number
           ( p_year in number
           )
   RETURN NUMBER
   IS
      l_next  number;
      pragma autonomous_transaction;
   BEGIN
      SELECT nvl(max(letter_number_sequence),599)+1 
      INTO l_next
      FROM XXCT_DOSSIERS
      --WHERE letter_number_year = p_year
      ;
      commit;
      RETURN l_next;
   END;
   --   

BEGIN
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'(start)');
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||':NEW.STATUS  top= '||:NEW.STATUS);
   IF inserting OR updating THEN
      xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'inserting OR updating');
      IF :NEW.LETTER_NUMBER_SEQUENCE is null THEN
         -- 
         xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'2');
         l_next_number := get_number(nvl(:NEW.LETTER_NUMBER_YEAR,to_char(:NEW.ACTION_START_DATE,'YYYY')));
         xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'3');
         -- 
        :NEW.letter_number_sequence := l_next_number;
     END IF;
     --
     IF inserting THEN
        xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'inserting 4');
        --:NEW.DOSSIER_ID := XXCT_DOSSIERS_SEQ.NEXTVAL;
        --IF NOT xxct_general_pkg.g_circumvent_insert_actns THEN  /* functionality to add scenarios (not needed in production).*/ 
           :NEW.STATUS := 'OPEN';
           :NEW.MANDATE_CYCLE    := 1;
        --END IF;   
        :NEW.CREATION_DATE := SYSDATE;
        :NEW.STATUS_DATE := SYSDATE;
        :NEW.LETTER_NUMBER_YEAR := to_char(:NEW.ACTION_START_DATE,'YYYY');
        :NEW.LAST_UPDATE_DATE := SYSDATE;
        :NEW.ACTION_TYPE :='NORMAL';
     END IF;
     --   
     IF updating THEN
        xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'updating 5');
        for r_row in (Select * from xxct_dossier_product_groups where dossier_id = :new.dossier_id) loop
            xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'6');
            l_prod_group_rec := xxct_dssr_prdct_grps_rec(null,null,null,null,null,null,null,null,null);
            l_xxct_product_groups_array.extend();
            l_prod_group_rec.dossier_product_group_id := r_row.dossier_product_group_id;
            l_prod_group_rec.dossier_id               := r_row.dossier_id;
            l_prod_group_rec.product_group_code       := r_row.product_group_code;
            l_prod_group_rec.target                   := r_row.target;
            l_prod_group_rec.contribution             := r_row.contribution;
            l_prod_group_rec.amount                   := r_row.amount;
            l_prod_group_rec.remarks                  := r_row.remarks;
            l_prod_group_rec.mandate_cycle            := r_row.mandate_cycle;
            l_prod_group_rec.creation_date            := r_row.creation_date;
            l_xxct_product_groups_array(l_xxct_product_groups_array.last) := l_prod_group_rec; 
        end loop;
        xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'7');
        xxct_page_102_pkg.g_XXCT_DSSR_PRDCT_GRPS_TAB := l_xxct_product_groups_array;     
        xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'8');
        --
        --xxice_debug_pkg.debug( c_trigger_name,'UPDATING');
        IF v('REQUEST') = 'SAVE_AND_CHECK' THEN
           xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||:NEW.STATUS||'=='||'SAVE_AND_CHECK 9');
           :NEW.STATUS := 'CONTROLE';
           xxct_page_102_pkg.approval_list( :NEW.DOSSIER_ID, 0,'XXCT_DOSSIERS_BRT' );
           select sum(amount) amount
           into l_sum
           from  xxct_dossier_product_groups dpg1 
           where dpg1.dossier_id = :new.dossier_id 
           ;   
           xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'10');
           for r_row in (select * from xxct_old_versus_new_v where dossier_id = :new.dossier_id) loop
              xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'11');
              l_xxct_old_versus_new_rec := xxct_old_versus_new_rec(null,null,null,null);
              l_xxct_old_versus_new_rec.product_group_code  := r_row.product_group_code;
              l_xxct_old_versus_new_rec.product_group       := r_row.product_group;
              l_xxct_old_versus_new_rec.amount_old          := r_row.amount_old;
              l_xxct_old_versus_new_rec.amount_new          := r_row.amount_new;
              l_xxct_old_versus_new_array.extend();
              l_xxct_old_versus_new_array(l_xxct_old_versus_new_array.last):= l_xxct_old_versus_new_rec;
           end loop;
           xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'12');
           --
           xxct_page_102_pkg.add_save_and_check_remarks( :NEW.DOSSIER_ID ,l_xxct_old_versus_new_array, l_sum);
           xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'13');
        ELSIF v('REQUEST') = 'SAVE_AND_START_APPROVAL' THEN 
           xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'SAVE_AND_START_APPROVAL 14');
           :NEW.STATUS := 'PROCURATIE';
           xxct_page_102_pkg.approval_list( :NEW.DOSSIER_ID, 0, 'XXCT_DOSSIERS_BRT' );
        ELSIF v('REQUEST') = 'APPLY_CHANGES_AND_CLOSE' THEN  
           :NEW.STATUS := 'AFGESLOTEN';
        END IF;
        xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'80');
        --
        IF :NEW.STATUS <>  :OLD.STATUS THEN
           :NEW.STATUS_DATE := sysdate; 
         END IF;
         --
         IF :NEW.FINANCIAL_CLOSE = 'Y' AND nvl(:OLD.FINANCIAL_CLOSE,'N') = 'N' THEN
            :NEW.STATUS_DATE := sysdate;
         END IF;
         --
         IF :NEW.INVOICE_NUMBER is not null and :OLD.INVOICE_NUMBER is null THEN
            :NEW.EXTRACT_TO_AR := 'N';
         END IF;
         --         
         :NEW.LAST_UPDATE_DATE := sysdate;
         --
--         IF :NEW.DOSSIER_TYPE IN  (xxct_page_102_pkg.c_payment, xxct_page_102_pkg.c_crediting) THEN
--            :NEW.REQUEST_ID := xxct_page_102_pkg.start_partner_creation_cr(:new.dossier_id, 'fnd_global.user_id' ,'fnd_global.resp_id','fnd_global.resp_appl_id','fnd_global.security_group_id');
--         END IF;
         --if not
         xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'90');
         xxct_page_102_pkg.insert_into_history_table(:new.dossier_id, :old.status, :new.status,:new.mandate_cycle,l_xxct_product_groups_array);
         --
      END IF;  
      xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'100');
   END IF;    
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||':NEW.STATUS  bottom = '||:NEW.STATUS);
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'110');
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'(end)');
EXCEPTION
WHEN OTHERS THEN
   xxct_gen_debug_pkg.debug( c_trigger_name,:NEW.DOSSIER_ID||'=='||'ERROR: '||sqlerrm);
   --     
   raise_application_error( -20001, Sqlerrm );   
END XXCT_DOSSIERS_BRT;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_BRT" ENABLE;

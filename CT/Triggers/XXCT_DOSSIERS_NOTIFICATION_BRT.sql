--------------------------------------------------------
--  DDL for Trigger XXCT_DOSSIERS_NOTIFICATION_BRT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_NOTIFICATION_BRT" 
      BEFORE UPDATE ON XXCT_DOSSIERS
      FOR EACH ROW
      FOLLOWS  XXCT_DOSSIERS_BRT
   DECLARE
      c_trigger_name            CONSTANT VARCHAR2(30)  := 'XXCT_DOSSIERS_NOTIFICATION_BRT';
      c_trigger_version         CONSTANT VARCHAR2(200) := '$Id: trg_XXCT_DOSSIERS_NOTIFICATION_BRT.sql,v 1.7 2021/04/28 16:18:01 bakke619 Exp $';
   BEGIN
      --
       xxct_gen_debug_pkg.debug( c_trigger_name,'(start)');
--      --  move to XXCT_DOSSIERS_BRT trigger if needed
--      -- send notifications
--      xxct_gen_debug_pkg.debug( c_trigger_name,'1 :new.dossier_id = '||:new.dossier_id);
--      xxct_gen_debug_pkg.debug( c_trigger_name,'1 :old.status = '||:old.status);
--      xxct_gen_debug_pkg.debug( c_trigger_name,'1 :new.status = '||:new.status);
--      xxct_gen_debug_pkg.debug( c_trigger_name,'1 :new.partner_id = '||:new.partner_id);
--      xxct_alerts.send_notification ( p_dossier_id       => :new.dossier_id
--                                    , p_status_old       => :old.status
--                                    , p_status_new       => :new.status
--                                    , p_resource_id_new  => :new.partner_id
--                                    );
--      xxct_gen_debug_pkg.debug( c_trigger_name,'2');                                    
--      -- send dealer email
--      xxct_partner_communication.set_notification  ( p_dossier_id     => :new.dossier_id
--                                                   , p_status_old     => :old.status
--                                                   , p_status_new     => :new.status
--                                                   );
--      --
      xxct_gen_debug_pkg.debug( c_trigger_name,'(end)');
      --
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
         xxct_gen_debug_pkg.debug( c_trigger_name,'ERROR: '||sqlerrm);
   END;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_NOTIFICATION_BRT" ENABLE;

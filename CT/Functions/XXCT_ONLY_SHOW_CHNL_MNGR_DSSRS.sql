--------------------------------------------------------
--  DDL for Function XXCT_ONLY_SHOW_CHNL_MNGR_DSSRS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_XXCT"."XXCT_ONLY_SHOW_CHNL_MNGR_DSSRS" 
          ( p_dossier_id              IN     NUMBER
          , p_owned_by_me             IN     VARCHAR2
          , p_user_id                 IN     NUMBER
          , p_status                  IN     VARCHAR2
          , p_resource_id             IN     NUMBER
          , p_count_mandates          IN     NUMBER
          , p_max_mandate_cycle       IN     NUMBER
          , p_channel_manager_user_id IN     NUMBER
          , p_change_type             IN     VARCHAR2
          , p_decrease_user_id        IN     NUMBER
          )
   RETURN VARCHAR2 IS
      c_routine_name CONSTANT VARCHAR2(30) := 'Only_Show_Channel_Mngr_Dssrs';
      l_return_value            VARCHAR2(3) := 'NO';
      l_channel_manager_user_id NUMBER;
      l_change_type            xxct_mandates_hist.change_type%TYPE;
   BEGIN
      IF p_count_mandates > 0 THEN
         l_change_type := p_change_type;
      ELSE
         -- This is the case when a dossiers gets rejected by the Controleur immediatly following dossier creation.
         l_change_type := NULL;
      END IF;

      IF l_change_type = 'DECREASE' THEN
         l_channel_manager_user_id := p_decrease_user_id; --get_channel_manager_user_id;
      ELSE
         l_channel_manager_user_id := p_channel_manager_user_id;
      END IF;

      IF p_status IN ('CONTROLE') THEN
         -- if only 'Owned' records are wanted, do not show Controle records
         -- that are not owned by me.
         IF nvl( p_owned_by_me ,'N') = 'Y' THEN
            IF p_user_id = l_channel_manager_user_id THEN
               -- This is my record, so show.
               l_return_value := 'YES';
            ELSE
               -- This is not my record, so do not show.
               l_return_value := 'NO';
            END IF;
         ELSE
            -- Not looking for only my records, so show every record.
            l_return_value := 'YES';
         END IF;
      ELSE
         -- All other statuses should always be shown.
         l_return_value := 'YES';
      END IF;

      RETURN l_return_value;
      --
   EXCEPTION
   WHEN OTHERS THEN
      XXCT_GEN_DEBUG_PKG.debug(c_routine_name,'ERROR: ' || sqlerrm||'   p_dossier_id = '||p_dossier_id);
      RAISE;
   END XXCT_ONLY_SHOW_CHNL_MNGR_DSSRS;

/

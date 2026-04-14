--------------------------------------------------------
--  DDL for Package Body XXAPI_GEN_DEBUG_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_XXAPI"."XXAPI_GEN_DEBUG_PKG" IS 
  /**************************************************************** 
   * 
   * PROGRAM NAME 
   *  ICE009 - XXAPI_DEBUG_PKG 
   * 
   * DESCRIPTION 
   * Program to send debug messages to a XXAPI_DEBUG table 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Wiljo Bakker        14-12-2018  Initial Version 
   * Geert Engbers       24-05-2019  ODO-749 Make debugging optional. Default is no debugging. 
   **************************************************************/ 

   -- $Id: XXAPI_DEBUG_PKG.pkb,v 1.7 2019/06/07 15:12:49 engbe502 Exp $ 
   -- $Log: XXAPI_DEBUG_PKG.pkb,v $ 
   -- Revision 1.7  2019/06/07 15:12:49  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.6  2019/06/07 15:02:00  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.10  2019/06/07 15:01:32  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.9  2019/06/07 15:00:50  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.8  2019/06/07 15:00:10  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.7  2019/06/07 14:59:35  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.6  2019/06/07 14:58:46  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.18  2019/06/07 14:55:42  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.17  2019/06/07 14:43:14  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.16  2019/06/07 14:36:55  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.4  2019/06/05 11:35:01  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.2  2019/05/29 08:51:07  engbe502 
   -- ODO-749 
   -- 
   -- Revision 1.1  2018/11/15 12:20:18  bakke619 
   -- Initial revision 
   -- 

   g_level   NUMBER := 0; 

   -- 
   --------------------------------------------------------------------------------------------- 
   -- 
   --------------------------------------------------------------------------------------------- 
   FUNCTION is_debugging_on 
   RETURN BOOLEAN 
   DETERMINISTIC 
   IS 
      c_routine_name constant varchar2(30) := 'is_debugging_on'; 
      -- 
      l_value        varchar2(10); 
      l_return_value BOOLEAN := TRUE; 
   BEGIN 
      -- 
      -- 
      --SELECT  fnd_profile.value_specific('XXAPI_DEBUGGING') 
      --INTO l_value 
      --FROM dual; 
      -- 
      DBMS_OUTPUT.PUT_LINE ( 'l_value = ' || l_value ); 
      --IF l_value = 'On' THEN 
         l_return_value := TRUE; 
      --END IF; 
      -- 
      RETURN l_return_value; 
      -- 
   EXCEPTION 
   WHEN OTHERS THEN 
      debug(c_routine_name,'ERROR: ' || sqlerrm); 
      RAISE; 
   END is_debugging_on; 
   -- 
   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug                   ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      --IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
      --   IF INSTR (p_message, ' Start.') > 0 --or instr(p_message, 'Start ') >0 
      --   THEN 
      --      g_level   := g_level + 1; 
      --   END IF; 

         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE , user_name, timestamp , proc_level, session_id) 
         VALUES   ( p_routine , SUBSTR  ( stuff (g_level) || p_message , 1 , 4000) , coalesce(sys_context('APEX$SESSION','APP_USER'),user), SYSDATE, g_level, sys_context('userenv','sessionid') ) ; 

     --    IF    INSTR (p_message, ' End.')   > 0 
     --       OR INSTR (p_message, 'ERROR: ') > 0 THEN 
     --       g_level   := g_level - 1; 
     --    END IF; 

         COMMIT; 
     -- END IF; 
   END debug; 
   PROCEDURE debug_duration          ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2
                                     , p_duration     in     NUMBER
                                     ) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      --IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
      --   IF INSTR (p_message, ' Start.') > 0 --or instr(p_message, 'Start ') >0 
      --   THEN 
      --      g_level   := g_level + 1; 
      --   END IF; 

         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE , user_name, timestamp , proc_level, duration, session_id) 
         VALUES   ( p_routine , SUBSTR  ( stuff (g_level) || p_message , 1 , 4000) , coalesce(sys_context('APEX$SESSION','APP_USER'),user), SYSDATE, g_level, p_duration, sys_context('userenv','sessionid') ) ;  

     --    IF    INSTR (p_message, ' End.')   > 0 
     --       OR INSTR (p_message, 'ERROR: ') > 0 THEN 
     --       g_level   := g_level - 1; 
     --    END IF; 

         COMMIT; 
     -- END IF; 
   END debug_duration; 
   

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_cs                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_clob         in     CLOB 
                                     ) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      --IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE , MESSAGE_clob, user_name , timestamp, session_id) 
         VALUES   ( p_routine , p_message , p_clob , coalesce(sys_context('APEX$SESSION','APP_USER'),user) , SYSDATE, sys_context('userenv','sessionid') ) ; 

         COMMIT; 
      --END IF; 
   END debug_cs; 

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_bs                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_blob         in     BLOB 
                                     ) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE, message_blob, user_name , timestamp, session_id) 
         VALUES ( p_routine ,p_message, p_blob, coalesce(sys_context('APEX$SESSION','APP_USER'),user) , SYSDATE, sys_context('userenv','sessionid') ) ; 

         COMMIT; 
      END IF; 
   END debug_bs; 

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_st                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
      l_clob   CLOB := DBMS_UTILITY.format_call_stack; 
   BEGIN 
      IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE, message_clob, user_name , timestamp, session_id) 
         VALUES   ( p_routine ,p_message, l_clob, coalesce(sys_context('APEX$SESSION','APP_USER'),user) , SYSDATE, sys_context('userenv','sessionid') ) ; 

         COMMIT; 
      END IF; 
   END debug_st; 

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_prcc              ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_message_clob in     CLOB 
                                     ) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
         INSERT INTO XXAPI_DEBUG ( ROUTINE , message_clob, MESSAGE, user_name , timestamp, session_id) 
         VALUES   ( p_routine ,p_message_clob, p_message, coalesce(sys_context('APEX$SESSION','APP_USER'),user) , SYSDATE, sys_context('userenv','sessionid') ) ; 

         COMMIT; 
      END IF; 
   END debug_prcc; 

   -- 
   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_t                   ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2) 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      debug( p_routine, p_message);
   END debug_t; 


   ------------------------------------------------------------- 
   -- Function to 
   ------------------------------------------------------------- 
   FUNCTION debug                    ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     CLOB                 ) RETURN VARCHAR2 
   IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      --IF is_debugging_on OR INSTR(UPPER(p_message),'ERROR') > 0 THEN 
         INSERT INTO XXAPI_DEBUG ( ROUTINE , MESSAGE, user_name, timestamp, session_id) 
         VALUES   ( p_routine ,p_message, coalesce(sys_context('APEX$SESSION','APP_USER'),user), SYSDATE, sys_context('userenv','sessionid') ) ; 

         COMMIT; 
      --END IF; 
      RETURN '1'; 
   END debug; 

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
--   PROCEDURE debug_wkf               ( itemtype       in     VARCHAR2 
--                                     , itemkey        in     VARCHAR2 
--                                     , actid          in     NUMBER 
--                                     , funcmode       in     VARCHAR2 
--                                     , resultout         out NOCOPY VARCHAR2 
--                                     ) 
--   IS 
--      l_info           VARCHAR2 (50); 
--      l_process_name   wf_activities_tl.display_name%TYPE; 
--      /* Maak in de Worfklow builder een function aan en laat de functie naar deze package en procedure 
--      verwijzen. Het attribuut  XXAPI_DEBUG_INFO is een vereiste. Je hoeft deze echter niet te vullen. 
--      Als je hem niet vult dan laat deze stap alleen zien in welk proces je zit (zelfde als wf_start maar dan zoner 
--      het woordje start). 
--      */ 
--   BEGIN 
--      --IF c_debug_status THEN 
--      SELECT wat.display_name 
--      INTO   l_process_name 
--      FROM   wf_process_activities wpa, wf_activities_tl wat 
--      WHERE  wpa.process_name = wat.name 
--      AND    wpa.process_item_type = wat.item_type 
--      AND    wpa.process_version = wat.version 
--      AND    wpa.instance_id = actid 
--      AND    wat.language = 'US'; 
-- 
--      l_info      := SUBSTR (wf_engine.getactivityattrtext ( itemtype  => itemtype 
--                                                           , itemkey   => itemkey 
--                                                           , actid     => actid 
--                                                           , aname     => 'XXICE_BOODSCHAP' 
--                                                           , ignore_notfound => TRUE) 
--                           , 1 
--                           , 50); 
-- 
--      debug ( p_routine => 'WF' 
--            , p_message => itemtype || ': ' || l_process_name || ': ' || l_info); 
-- 
--      resultout := wf_engine.eng_completed || ':' || wf_engine.eng_null; 
--      --END IF; 
--   EXCEPTION 
--      WHEN OTHERS THEN 
--         debug ( p_routine => 'WF' 
--               , p_message => 'ERROR in XXICE_debug_wft: ' || SQLERRM); 
--         resultout      := wf_engine.eng_completed || ':' || wf_engine.eng_null; 
--   END debug_wkf; 

   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE delete_debug IS 
      PRAGMA AUTONOMOUS_TRANSACTION; 
   BEGIN 
      DELETE FROM XXAPI_DEBUG; 
      COMMIT; 
   END delete_debug; 

   ------------------------------------------------------------- 
   -- Function to 
   ------------------------------------------------------------- 
   FUNCTION stuff                    ( p_level        in     NUMBER             ) RETURN VARCHAR2 
   IS 
      l_string   VARCHAR2 (32000) := ''; 
   BEGIN 
      FOR i IN 2 .. p_level LOOP 
         l_string  := l_string || '    '; 
      END LOOP; 

      RETURN l_string; 
   END stuff; 

   ------------------------------------------------------------- 
   -- Function to 
   ------------------------------------------------------------- 
   FUNCTION get_version_nr_from_long ( p_long_value   in     LONG               ) RETURN VARCHAR2 
   IS 
      l_clob           CLOB; 
      l_pos            NUMBER; 
      l_return_value   VARCHAR2 (80); 
   BEGIN 
      l_clob   := TO_CLOB (p_long_value); 
      l_pos    := INSTR (l_clob, '$Id:'); 

      IF l_pos > 0 THEN 
         l_clob           := SUBSTR (l_clob, l_pos); 
         l_return_value   := SUBSTR (l_clob, 1, INSTR (l_clob, '$', 2) + 1); 
      END IF; 

      RETURN l_return_value; 
   END get_version_nr_from_long; 

   ------------------------------------------------------------- 
   -- Function to 
   ------------------------------------------------------------- 
   FUNCTION get_trigger_verion_nr    ( p_trigger_name in     VARCHAR2 
                                     , p_owner        in     VARCHAR2           ) RETURN VARCHAR2 
   IS 
      l_long   LONG; 
   BEGIN 
      SELECT trigger_body 
      INTO   l_long 
      FROM   all_triggers 
      WHERE  owner IN ('APPS', 'XXCUST', 'APEX_EBS') 
      AND    trigger_name = p_trigger_name 
      AND owner = p_owner; 

      RETURN get_version_nr_from_long (l_long); 
   END get_trigger_verion_nr; 

END XXAPI_GEN_DEBUG_PKG;

/

  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_GEN_DEBUG_PKG" TO "WKSP_XXPM";
  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_GEN_DEBUG_PKG" TO "WKSP_XXTV";
  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_GEN_DEBUG_PKG" TO "WKSP_XXCPC";
  GRANT EXECUTE ON "WKSP_XXAPI"."XXAPI_GEN_DEBUG_PKG" TO "WKSP_XXCT";

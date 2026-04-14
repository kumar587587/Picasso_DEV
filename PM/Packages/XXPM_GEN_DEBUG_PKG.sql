--------------------------------------------------------
--  DDL for Package XXPM_GEN_DEBUG_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_GEN_DEBUG_PKG" IS 
 
  /**************************************************************** 
   * 
   * PROGRAM NAME 
   *  ICE009 - XXPM_GEN_DEBUG_PKG 
   * 
   * DESCRIPTION 
   * Program to send debug messages to a specific table 
   * 
   * CHANGE HISTORY 
   * Who                 When         What 
   * ------------------------------------------------------------- 
   * Wiljo Bakker        14-12-2018  Initial Version 
   **************************************************************/ 

   -- $Id: XXICE_DEBUG_PKG.pks,v 1.1 2018/11/15 12:20:36 bakke619 Exp $ 
   -- $Log: XXICE_DEBUG_PKG.pks,v $ 
   -- Revision 1.1  2018/11/15 12:20:36  bakke619 
   -- Initial revision 
   -- 

   PROCEDURE delete_debug; 

   PROCEDURE debug                   ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2); 

   PROCEDURE debug_cs                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_clob         in     CLOB 
                                     ); 

   PROCEDURE debug_bs                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_blob         in     BLOB 
                                     ); 

   PROCEDURE debug_st                ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2); 

   PROCEDURE debug_prcc              ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2 
                                     , p_message_clob in     CLOB 
                                     ); 

--   PROCEDURE debug_wkf               ( itemtype       in     VARCHAR2 
--                                     , itemkey        in     VARCHAR2 
--                                     , actid          in     NUMBER 
--                                     , funcmode       in     VARCHAR2 
--                                     , resultout         out NOCOPY VARCHAR2 
--                                     ); 
   -- 
   ------------------------------------------------------------- 
   -- Procedure to 
   ------------------------------------------------------------- 
   PROCEDURE debug_t                 ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     VARCHAR2) 
   ;                                  
   FUNCTION debug                    ( p_routine      in     VARCHAR2 DEFAULT NULL 
                                     , p_message      in     CLOB               ) RETURN VARCHAR2; 

   FUNCTION stuff                    ( p_level        in     NUMBER             ) RETURN VARCHAR2; 

   FUNCTION get_version_nr_from_long ( p_long_value   in     LONG               ) RETURN VARCHAR2; 

   FUNCTION get_trigger_verion_nr    ( p_trigger_name in     VARCHAR2 
                                     , p_owner        in     VARCHAR2           ) RETURN VARCHAR2; 

END XXPM_GEN_DEBUG_PKG;




/

  GRANT EXECUTE ON "WKSP_XXPM"."XXPM_GEN_DEBUG_PKG" TO "ADMIN";

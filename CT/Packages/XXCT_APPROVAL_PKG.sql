--------------------------------------------------------
--  DDL for Package XXCT_APPROVAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_APPROVAL_PKG" AUTHID DEFINER AS
   /***************************************************************************
   *
   * PROGRAM NAME
   *    CT603 - XXCT_APPROVAL_PKG
   *
   * DESCRIPTION
   *    Package for handling approval maintenance updates
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * W.J. Bakker         30/11/2018  Initial Version
   **************************************************************/

   -- $Id: XXCT_APPROVAL_PKG.pks,v 1.2 2018/12/06 14:03:58 bakke619 Exp $
   -- $Log: XXCT_APPROVAL_PKG.pks,v $
   -- Revision 1.2  2018/12/06 14:03:58  bakke619
   -- Bugfixes
   --
   -- Revision 1.1  2018/12/05 16:51:46  bakke619
   -- Initial revision
   --

   -- GLOBALS VARIABLES

   g_user_id                      NUMBER              := -1;
   g_session_id                   NUMBER              := -1;
   g_payrun_name                  VARCHAR2(200)       := NULL;
   g_org_id                       NUMBER              := 82;

   -- GLOBAL CONSTANTS
   gc_package_name               CONSTANT VARCHAR2(50)                   := 'XXCT_APPROVAL_PKG';
   gc_package_spec_version       CONSTANT VARCHAR2(200)                  := '$Id: XXCT_APPROVAL_PKG.pks,v 1.2 2018/12/06 14:03:58 bakke619 Exp $';

   gc_test                       CONSTANT BOOLEAN                        := FALSE;
   gc_tab                        CONSTANT VARCHAR2(1)                    := CHR(9);
   gc_eol                        CONSTANT VARCHAR2(1)                    := CHR(10);


   gc_max_amount                 CONSTANT NUMBER                         :=  99999999.99;
   gc_min_amount                 CONSTANT NUMBER                         := gc_max_amount * -1;

   -- Procedures
   PROCEDURE init;

   PROCEDURE debug_trigger                   ( p_routine              IN         VARCHAR2
                                             , p_message              IN         VARCHAR2      );

   PROCEDURE create_init_approval_amounts    ( p_approval_id          IN         NUMBER        );

   PROCEDURE cascade_approval_amounts        ( p_approval_id          IN         NUMBER        );

   PROCEDURE reload_to_page                  ( p_page_id              IN         VARCHAR2
                                             , p_parameters           IN         VARCHAR2      );

   PROCEDURE rearrange_approver_sequences    ( p_approval_amount_id   IN         NUMBER        );

   -- Functions
   FUNCTION  get_dossiertype_by_id           ( p_value                IN         VARCHAR2      ) RETURN VARCHAR2;

   FUNCTION  page_validation_error_text      ( p_validation_name      IN         VARCHAR2      ) RETURN VARCHAR2;

   FUNCTION  page_validation                 ( p_validation_name      IN         VARCHAR2      ) RETURN BOOLEAN;

   FUNCTION  check_readonly                  ( p_page_item_name       IN         VARCHAR2      ) RETURN BOOLEAN;

   FUNCTION  check_conditional_display       ( p_page_item_name       IN         VARCHAR2      ) RETURN BOOLEAN;


END XXCT_APPROVAL_PKG;





/

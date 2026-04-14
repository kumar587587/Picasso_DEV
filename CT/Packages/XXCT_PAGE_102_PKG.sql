--------------------------------------------------------
--  DDL for Package XXCT_PAGE_102_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_PAGE_102_PKG" 
AS
  /****************************************************************
   *
   * PROGRAM NAME
   *  CPC601 - XXCT_PAGE_102_PKG
   *
   * DESCRIPTION
   * Program to support Credit Tool (CT) functionality
   *
   * CHANGE HISTORY
   * Who                 When         What
   * -------------------------------------------------------------
   * Geert Engbers        04-12-2018  Initial Version
   * Geert Engbers        16-12-2018  Added new functionlaty.
   * Geert Engbers        19-12-2018  Added parameter to approvel_list function.
   * Geert Engbers        04-01-2019  Bug-fixing and new functionality.
   * Geert Engbers        24-01-2019  Added get_partner_timer_status.
   * Geert Engbers        31-01-2019  Added resend_letter, financial_close and fix_wrong_status.
   * Geert Engbers        20-03-2019  Changes required as result of APEX 18 migration + minor bug fixing.
   * Geert Engbers        07-05-2019  ODO-612 Added financial_close_all
   * Geert Engbers        21-05-2019  ODO-461 Moved private functions to Public in order to reuse from page 108.
   * Geert Engbers        30-07-2019  ODO-757 Added procedure update_approvals.
   **************************************************************/
   --
-- $Id: XXCT_PAGE_102_PKG.pks,v 1.12 2021/10/14 06:50:15 engbe502 Exp $
-- $Log: XXCT_PAGE_102_PKG.pks,v $
-- Revision 1.12  2021/10/14 06:50:15  engbe502
-- ODO-1455
--
-- Revision 1.11  2020/12/01 11:32:07  engbe502
-- ODO-1216 ODO-1218
--
-- Revision 1.10  2020/01/22 19:03:56  engbe502
-- ODO-936
--
-- Revision 1.9  2019/07/30 12:16:34  engbe502
-- ODO-757
--
-- Revision 1.8  2019/05/29 08:50:58  engbe502
-- ODO-461 ODO-612
--
-- Revision 1.7  2019/03/20 12:06:36  rikke493
-- Apex 18 upgrade.
--
-- Revision 1.6  2019/01/31 11:57:11  rikke493
-- Added resend_letter, financial_close and fix_wrong_status.
--
-- Revision 1.5  2019/01/24 12:32:33  rikke493
-- Added get_partner_timer_status
--
-- Revision 1.4  2019/01/04 08:31:32  rikke493
-- Bug fixing.
--
-- Revision 1.3  2018/12/19 19:41:15  rikke493
-- Added parameter to approvel_list function.
--
-- Revision 1.2  2018/12/16 13:52:19  rikke493
-- Added new functionlaty.
--
-- Revision 1.1  2018/12/05 15:06:54  rikke493
-- Initial revision
--

   c_Package_Spec_Version        CONSTANT VARCHAR2(200) := '$Id: XXCT_PAGE_102_PKG.pks,v 1.12 2021/10/14 06:50:15 engbe502 Exp $';
   --
   C_RESERVATION                  CONSTANT VARCHAR2(20)  := 'RESERVATION';
   C_PAYMENT                      CONSTANT VARCHAR2(20)  := 'PAYMENT';
   C_CREDITING                    CONSTANT VARCHAR2(20)  := 'CREDITING';
   --
   C_OPEN                         CONSTANT VARCHAR2(20)  := 'OPEN';
   C_AFGEKEURD                    CONSTANT VARCHAR2(20)  := 'AFGEKEURD';
   C_CONTROLE                     CONSTANT VARCHAR2(20)  := 'CONTROLE';
   C_FACTURATIE                   CONSTANT VARCHAR2(20)  := 'FACTURATIE';
   C_AFGESLOTEN                   CONSTANT VARCHAR2(20)  := 'AFGESLOTEN';
   C_HEROPEND                     CONSTANT VARCHAR2(20)  := 'HEROPEND';
   C_PROCURATIE                   CONSTANT VARCHAR2(20)  := 'PROCURATIE';
   --
   C_CT_CONTROLEUR                CONSTANT VARCHAR2(20)  := 'CT Controleur';
   C_CT_RETAIL_SUPPORT            CONSTANT VARCHAR2(20)  := 'CT Retail Support';
   C_CT_FINANCEDESK               CONSTANT VARCHAR2(20)  := 'CT Financedesk';
   C_CT_ACCORDEUR                 CONSTANT VARCHAR2(20)  := 'CT Accordeur';
   --
   g_deactivate_dpg_trigger boolean := false;
   g_restore_to_prev_status boolean := false;
   --
   type t_totals is record( total_count number,akkoord_count number, nog_tekenen_count number, afgekeurd_count number);
   g_xxct_dssr_prdct_grps_tab  xxct_dssr_prdct_grps_tab;
   ----------------------------------------------------------------------------------
   function get_product_group_array return xxct_dssr_prdct_grps_tab;
   ----------------------------------------------------------------------------------
   function get_package_body_version
   return varchar2;
   ----------------------------------------------------------------------------------
   function get_package_spec_version
   return varchar2;
   ----------------------------------------------------------------------------------
   function region_updateable
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shw_region
          ( p_region_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shbutton
          ( p_button_name   in varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function check_condition
          ( p_condition_name in varchar2
          )
    return boolean;
   ----------------------------------------------------------------------------------
   function default_value
          ( p_page_number       in     varchar2
          , p_field_name        in     varchar2
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   procedure approval_list_at
           ( p_dossier_id              in     number
           , p_amount_deleted          in     number
           , p_called_from             in     varchar2
           , p_amount                  in     number
           );
   procedure approval_list
          ( p_dossier_id              in     number
          , p_amount_deleted          in     number
          , p_called_from             in     varchar2
          );
   ----------------------------------------------------------------------------------
--   function is_next_approver
--          ( p_dossier_id              in     number
--          )
--   return boolean;
   ----------------------------------------------------------------------------------
   procedure create_new_payment
          ( p_dossier_id               in     number
          );
   ----------------------------------------------------------------------------------
   function is_read_only
          ( p_field_name           in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
   function shfield
          ( p_field_name              in     varchar2
          )
   return boolean;
   ----------------------------------------------------------------------------------
--   procedure check_for_approval_completionx
--          ( p_dossier_id             in     number
--          );
   ----------------------------------------------------------------------------------
   procedure go_back_after_final_approval
          ( p_dossier_id             in     number
          );
   ----------------------------------------------------------------------------------
   function is_approved_or_rejected
          ( p_dossier_id              in     number
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   function validation_function
          ( p_validation_name           in     varchar2
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   procedure insert_into_history_table
           ( p_dossier_id              in     varchar2
           , p_old_status              in     varchar2
           , p_new_status              in     varchar2
           , p_mandate_cycle           in     number
           , p_product_groups_array    in     xxct_dssr_prdct_grps_tab
           );
   ----------------------------------------------------------------------------------
   procedure save_and_close
           ( p_dossier_id      in number);
   ----------------------------------------------------------------------------------
   function execute_validation
          ( p_validation_name     in varchar2)
   return boolean;
   ----------------------------------------------------------------------------------
   function shf_letter_suffix
   return boolean;
   ----------------------------------------------------------------------------------
   function execute_dynamic_actions
          ( p_dynamic_action_name in varchar2)
   return boolean;
   ----------------------------------------------------------------------------------
   procedure get_lov_values
          ( p_dossier_category_id      in     number
          , p_parent_dossier_id        in     number
          , p_dossier_type             in     varchar2
          );
   ----------------------------------------------------------------------------------
   function start_partner_creation_cr
          ( p_dossier_id              in     number
          , p_user_id                 in     number
          , p_resp_id                 in     number
          , p_resp_appl_id            in     number
          , p_security_group_id       in     number
          )
   return number;
   ----------------------------------------------------------------------------------
   procedure create_partnerletter
          ( p_error_buf             out varchar2
          , p_ret_code              out varchar2
          , p_dossier_id            in  number
          );
   ----------------------------------------------------------------------------------
   procedure check_request_status;
   ----------------------------------------------------------------------------------
   procedure reject_dossier
          ( p_dossier_id          in     number
          );
   ----------------------------------------------------------------------------------
   procedure reopen_dossier
          ( p_dossier_id              in     number
          );
   ----------------------------------------------------------------------------------
   procedure add_save_and_check_remarks
          ( p_dossier_id             in     varchar2
          , p_xxct_old_versus_new    in     xxct_old_versus_new_tab
          , p_dossier_total          in     number
          );
   ----------------------------------------------------------------------------------
   function get_partner_timer_status
          ( p_dossier_id              in     number
          )
   return varchar2;
   ----------------------------------------------------------------------------------
   function resend_letter
          ( p_dossier_id              in     number
          , p_email_address           in     varchar2
          )
    return varchar2;
   ---------------------------------------------------------------------------------------------
   function financial_close
          ( p_dossier_id           in     number
          )
   return varchar2;
   ---------------------------------------------------------------------------------------------
--   procedure fix_wrong_statusx;
   --
   function shr_facturatie
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          )
   return boolean
   ;
   function shr_partner_brief
          ( p_responsibility_name         in varchar2
          , p_dossier_type                in varchar2
          , p_status                      in varchar2
          , p_update_or_new               in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_financiele_afsluiting
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_prdctgrpn_uitbetalingen
          ( p_dossier_type         in varchar2
          , p_status               in varchar2
          , p_responsibility_name  in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_uitbetalingen_alle
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          , p_dossier_id     in number
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_aanvullende_opmerkingen
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_bewijsstukken
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          , p_dossier_id     in number
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_procuratie
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shr_fitar_export
          ( p_dossier_type   in varchar2
          , p_status         in varchar2
          , p_update_or_new  in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   procedure financial_close_all
           ( p_errbuf  OUT VARCHAR2
           , p_retcode OUT NUMBER
           )
    ;
   ---------------------------------------------------------------------------------------------
   function dv_dossier_number
          ( p_dossier_id           in number
          , p_dossier_type         in varchar2
          , p_dossier_type_other   in varchar2
          , p_letter_number_period in varchar2
          , p_update_or_new        in varchar2
          , p_letter_number_year   in varchar2
          , p_letter_number_seq    in varchar2
          , p_letter_suffix        in varchar2
          , p_status               in varchar2
          )
   return varchar2
   ;
   ---------------------------------------------------------------------------------------------
   function dv_dossier_number_full
          ( p_page_number          in varchar2
          , p_dossier_type         in varchar2
          , p_dossier_type_other   in varchar2
          , p_letter_number_period in varchar2
          , p_update_or_new        in varchar2
          , p_letter_number_year   in varchar2
          , p_letter_number_seq    in varchar2
          , p_letter_suffix        in varchar2
          )
   return varchar2
   ;
   ---------------------------------------------------------------------------------------------
   function shf_dossier_info_cate
          ( p_dossier_type      in varchar2
          )
   return boolean
   ;
   ---------------------------------------------------------------------------------------------
   function shf_dossier_info_cat_uit
          ( p_dossier_type      in varchar2
          )
   return boolean;
   ---------------------------------------------------------------------------------------------
--   procedure update_approvals
--          ( p_person_id_old              in     number
--          , p_person_id_new              in     number
--          , p_approval_amount_app_id     in     number
--          )
--    ;
   function count_product_groups (p_dossier_id in number, p_product_group_code in varchar2, p_dossier_product_group_id in number)
   return number;
   function count_product_groups_at (p_dossier_id in number, p_product_group_code in varchar2, p_dossier_product_group_id in number)
   return number;
   procedure add2WF_table
   ( p_dossier_id   in  number )
   ;
   function get_underpinnedfocumentsurl ( p_dossier_id in varchar2 )
   return varchar2
   ;
END XXCT_PAGE_102_PKG;







/

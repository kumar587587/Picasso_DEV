--------------------------------------------------------
--  DDL for Package XXCT_CALL_ACTV_USR_WF_SCLD_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXCT"."XXCT_CALL_ACTV_USR_WF_SCLD_PKG" AS 
/****************************************************************       
   *
   * PROGRAM NAME
   * XXCT_CALL_ACTV_USR_WF_SCLD_PKG
   *
   * DESCRIPTION
   * Package to send User_roles Data to Varicent and Call "Update Active Users in Workflow and Portal Access" Scheduler
   *
   * CHANGE HISTORY
   * Who             When         What
   * -------------------------------------------------------------
   * RABINDRA        08-16-2025   Initial Version
   **************************************************************/

    gc_package_name            CONSTANT    VARCHAR(50)  := 'XXCT_CALL_ACTV_USR_WF_SCLD_PKG';   

   PROCEDURE CALL_ACTV_USER_WF_SCHD;

   --PROCEDURE PROC_DROP_VARICENT_SCHLD;

   PROCEDURE CALL_VARICENT_SCHEDULER;

END XXCT_CALL_ACTV_USR_WF_SCLD_PKG;

/

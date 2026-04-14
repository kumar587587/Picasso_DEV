--------------------------------------------------------
--  DDL for View XXCT_WF_HISTORY_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_WF_HISTORY_TMP_V" ("ID", "WORKFLOWID", "NODENAME", "INITIATOR", "INITIATORNAME", "ACTOR", "ACTORNAME", "ISFORCEDBY", "ACTION", "DATEACTIONED", "WEBREPORTNAME", "ATTACHMENTS", "DOCUMENTID", "TOKENID", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT id
  ,      workflowid
  ,      nodename
  ,      initiator
  ,      initiatorname
  ,      actor
  ,      actorname
  ,      isforcedby
  ,      action
  ,      dateactioned
  ,      webreportname
  ,      attachments
  ,      documentid
  ,      tokenid
  ,      username 
  FROM xxct_wf_history_tmp
  WHERE lower( username ) = nvl(  v('APP_USER') ,xxct_general_pkg.get_developer_user )
;

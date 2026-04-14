--------------------------------------------------------
--  DDL for View XXCT_WF_CT_DOSSIER_APPROVAL_HISTORY_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_WF_CT_DOSSIER_APPROVAL_HISTORY_V" ("ID", "WORKFLOWID", "NODENAME", "INITIATOR", "INITIATORNAME", "ACTOR", "ACTORNAME", "ISFORCEDBY", "ACTION", "DATEACTIONED", "WEBREPORTNAME", "ATTACHMENTS", "DOCUMENTID", "TOKENID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select ID
  ,      WORKFLOWID
  ,      NODENAME
  ,      INITIATOR
  ,      INITIATORNAME
  ,      ACTOR
  ,      ACTORNAME
  ,      ISFORCEDBY
  ,      ACTION
  ,      DATEACTIONED
  ,      WEBREPORTNAME
  ,      ATTACHMENTS
  ,      DOCUMENTID
  ,      TOKENID 
  from table (  xxct_gen_rest_apis.get_workflow_history ( 'CT Dossier Approval', null ) )
;

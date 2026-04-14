--------------------------------------------------------
--  DDL for Type XXCT_WORKFLOW_HIST_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_WORKFLOW_HIST_TYPE" AS OBJECT (
         ID                VARCHAR2(100),
         WORKFLOWID        NUMBER,
         NODENAME          VARCHAR2(100),
         INITIATOR         VARCHAR2(100),
         INITIATORNAME     VARCHAR2(100),
         ACTOR             VARCHAR2(100),
         ACTORNAME         VARCHAR2(100),
         ISFORCEDBY        VARCHAR2(100),
         ACTION            VARCHAR2(100),
         DATEACTIONED      VARCHAR2(100),
         WEBREPORTNAME     VARCHAR2(100),
         ATTACHMENTS       VARCHAR2(100),
         DOCUMENTID        NUMBER,
         TOKENID           VARCHAR2(100)
);



/

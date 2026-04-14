--------------------------------------------------------
--  DDL for Type XXCT_CTAPPROVERSCOMMENTSWF_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_CTAPPROVERSCOMMENTSWF_TYPE" AS OBJECT (
         WorkflowFormID           VARCHAR2(100),
         CommentID                VARCHAR2(100),
         Approver                 VARCHAR2(100),
         "Date"                   VARCHAR2(100),
         "Comment"                VARCHAR2(100),
         DossierID                VARCHAR2(100),
         DossierKey               VARCHAR2(100) 
);

/

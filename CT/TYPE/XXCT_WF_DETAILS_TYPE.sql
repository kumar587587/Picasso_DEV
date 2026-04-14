--------------------------------------------------------
--  DDL for Type XXCT_WF_DETAILS_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_WF_DETAILS_TYPE" AS OBJECT (
         DossierKey        VARCHAR2(100),
         ApproverID        VARCHAR2(100),
         FormID            VARCHAR2(100),
         DossierID         VARCHAR2(100),
         ApprovalCycle     NUMBER       ,
         DossierType       VARCHAR2(100),
         ActionType        VARCHAR2(100),
         ApproverType      VARCHAR2(100),
         SwimLane          NUMBER       ,
         AssignedDateTime  DATE,
         ApprovalStatus    VARCHAR2(100),
         ApprovalDateTime  DATE,
         Comments          VARCHAR2(4000),
         CommentDate       DATE,
         RoleID            VARCHAR2(200)
);



/

--------------------------------------------------------
--  DDL for Type XXCT_SPCTWFLEVELS_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_SPCTWFLEVELS_TYPE" AS OBJECT (
         SwimLane                VARCHAR2(100),
         BonusPartnerType        VARCHAR2(100),
         DossierType             VARCHAR2(100),
         ActionType              VARCHAR2(100),
         ApprovalLevel           NUMBER,
         MinAmount               NUMBER,
         MaxAmount               NUMBER,
         RoleApprovalLevelFrom   NUMBER,
         RoleApprovalLevelTo     NUMBER,
         Description             VARCHAR2(1000)
);



/

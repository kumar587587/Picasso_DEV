--------------------------------------------------------
--  DDL for Type XXCT_PLIAMROLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_PLIAMROLE_TYPE" AS OBJECT (
         RoleID                   VARCHAR2(100),
         AccessLevelName          VARCHAR2(100),
         IndicatorWorkflowRole    VARCHAR2(100),
         Model                    VARCHAR2(100),
         PartnerType              VARCHAR2(100),
         ApprovalLevels           NUMBER
);



/

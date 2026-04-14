--------------------------------------------------------
--  DDL for Type XXCT_SPUSERROLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_SPUSERROLE_TYPE" AS OBJECT (
         PayeeID                VARCHAR2(100),
         Role                   VARCHAR2(500),
         Active                 VARCHAR2(10),
         StartDate              DATE,
         EndDate                DATE 
);



/

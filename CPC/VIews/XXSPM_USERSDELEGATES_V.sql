--------------------------------------------------------
--  DDL for View XXSPM_USERSDELEGATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_USERSDELEGATES_V" ("PAYEEID", "ROLEID", "STARTDATE", "ENDDATE", "PAYEEID_REGULAR_USER") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT PAYEEID, ROLEID,STARTDATE, ENDDATE, PAYEEID_REGULAR_USER FROM xxcpc_spusersdelegates
;

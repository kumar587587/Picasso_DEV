--------------------------------------------------------
--  DDL for View XXSPM_SPUSERSDELEGATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXSPM_SPUSERSDELEGATES_V" ("PAYEEID", "ROLEID", "STARTDATE", "ENDDATE", "LAST_UPDATE_OR_CREATION_DATE", "DELEGATEFORPAYEEID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select payeeid
  ,      roleid
  ,      startdate
  ,      enddate 
  ,      greatest( created, updated ) last_update_or_creation_date
  ,      null DelegateForPayeeID
  from xxct_spusersdelegates
;

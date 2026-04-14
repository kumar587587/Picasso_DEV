--------------------------------------------------------
--  DDL for View XXCT_SPUSERROLE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_SPUSERROLE_V" ("PAYEEID", "ROLE", "ACTIVE", "STARTDATE", "ENDDATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select PAYEEID
,      ROLE
,      ACTIVE
,      STARTDATE
,      ENDDATE 
from table( XXCT_GEN_REST_APIS.get_spUserRole)
where role like 'CT %'
;

--------------------------------------------------------
--  DDL for View XXCT_SPUSERROLE_TMP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_SPUSERROLE_TMP_V" ("PAYEEID", "ROLE", "ACTIVE", "STARTDATE", "ENDDATE", "USERNAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.payeeid
,      a.role
,      a.active
,      a.startdate
,      a.enddate 
,      a.username
FROM xxct_spuserrole_tmp a
WHERE lower( username ) = nvl( v('APP_USER'), xxct_general_pkg.get_developer_user )
;

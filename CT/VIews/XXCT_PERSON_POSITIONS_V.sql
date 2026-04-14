--------------------------------------------------------
--  DDL for View XXCT_PERSON_POSITIONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PERSON_POSITIONS_V" ("PERSON_ID", "LAST_NAME", "FIRST_NAME", "FULL_NAME", "POSITION_ID", "NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 0 person_id
      ,      'per.last_name'
      ,      'per.first_name'
      ,      'per.full_name'
      ,   1   position_id
      ,      'pos.name'
FROM DUAL
;

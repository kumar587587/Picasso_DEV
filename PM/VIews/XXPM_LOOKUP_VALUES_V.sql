--------------------------------------------------------
--  DDL for View XXPM_LOOKUP_VALUES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_LOOKUP_VALUES_V" ("LOOKUP_TYPE", "MEANING", "CODE", "ENABLED_FLAG", "START_DATE_ACTIVE", "END_DATE_ACTIVE", "ATTRIBUTE1") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a.lookup_type, b."MEANING",b."CODE",b."ENABLED_FLAG",b."START_DATE_ACTIVE",b."END_DATE_ACTIVE",b."ATTRIBUTE1" 
from XXPM_LOOKUPS a 
,    XXPM_LOOKUP_VALUES b 
where 1=1 
and b.lookup_type = a.lookup_type
;

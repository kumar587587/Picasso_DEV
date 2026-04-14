--------------------------------------------------------
--  DDL for View ORDS_REST_ENABLED_ENTITIES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."ORDS_REST_ENABLED_ENTITIES_V" ("TYPE", "PARSING_OBJECT", "OBJECT_ALIAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  'Enabled Object'       type
,        NULL                  parsing_object
,        object_alias          object_alias
FROM user_ords_enabled_objects uoeo
WHERE  1=1
AND uoeo.status    = 'ENABLED'
AND uoeo.type_path = 'ENABLED'
UNION
SELECT 'Module'           type
,      NAME               parsing_object   
,      NULL               object_alias
FROM user_ords_modules 
WHERE status = 'PUBLISHED'
;

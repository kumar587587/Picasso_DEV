--------------------------------------------------------
--  DDL for View ORDS_APIS_WITHOUT_PROTECTION_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."ORDS_APIS_WITHOUT_PROTECTION_V" ("PARSING_OBJECT", "OBJECT_ALIAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT parsing_object
,      object_alias 
FROM ords_rest_enabled_entities_v
WHERE 1=1
AND parsing_object is not null
AND parsing_object NOT IN (     
                          SELECT module_name  
                          FROM   ords_credentials_give_access_to_v    
                          WHERE module_name is not null
                          )
UNION
SELECT parsing_object
,      object_alias 
FROM ords_rest_enabled_entities_v
WHERE 1=1
AND object_alias is not null
AND object_alias  NOT IN  ( 
                          SELECT substr( REPLACE( PATTERN,'/*',''),2) 
                          FROM ords_credentials_give_access_to_v
                          WHERE 1=1
                          AND pattern is not null
                          )
;

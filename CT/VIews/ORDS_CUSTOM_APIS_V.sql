--------------------------------------------------------
--  DDL for View ORDS_CUSTOM_APIS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."ORDS_CUSTOM_APIS_V" ("TYPE", "OBJECT_ALIAS", "PROTECTED", "TOTAL_ROWS", "SUM_PROTECTED", "ORA_INVOKING_USER") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT TYPE                      TYPE 
,      object_alias              object_alias
,      protected                 protected 
,      COUNT(*)  OVER ( )        total_rows
,      SUM( protected) OVER ()   sum_protected
,      ORA_INVOKING_USER         xxx
FROM 
(
    SELECT ree.TYPE
    ,      ree.object_alias
    ,      DECODE( awp.object_alias, NULL, 1, 0 ) protected
    FROM ords_rest_enabled_entities_v    ree
    ,    ords_apis_without_protection_v  awp 
    WHERE ree.TYPE ='Enabled Object'
    AND   awp.object_alias(+) = ree.object_alias
    UNION
    SELECT ree.TYPE
    ,      ree.parsing_object
    ,      DECODE( awp.parsing_object, NULL, 1, 0 ) protected
    FROM ords_rest_enabled_entities_v    ree
    ,    ords_apis_without_protection_v  awp 
    WHERE ree.TYPE ='Module'
    AND   awp.parsing_object(+) = ree.parsing_object
) bas
where bas.object_alias not in ( select object_alias from ords_protected_not_linked_creds_v )
;

--------------------------------------------------------
--  DDL for View XXAPI_API_PROTECTION_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_API_PROTECTION_V" ("APPLICATION", "OBJECT_TYPE", "URI", "PROTECTED") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select 'TV'    application
,      field1  object_type
,      field2  uri
,      field3  Protected
from table( xxapi_dispatcher_pkg.get_ords_data('TV', '/v1/securedApis'))
union
select 'PM'    application
,      field1  object_type
,      field2  uri
,      field3  Protected
from table( xxapi_dispatcher_pkg.get_ords_data('PM', '/v1/securedApis'))
union
select 'CT'    application
,      field1  object_type
,      field2  uri
,      field3  Protected
from table( xxapi_dispatcher_pkg.get_ords_data('CT', '/v1/securedApis'))
union
select 'CPC'    application
,      field1  object_type
,      field2  uri
,      field3  Protected
from table( xxapi_dispatcher_pkg.get_ords_data('CPC', '/v1/securedApis'))
union
select 'API'                           application   
,      type                            object_type
,      object_alias                    uri
,      decode( protected,1,'Yes','No') protected
from ORDS_CUSTOM_APIS_V
;

--------------------------------------------------------
--  DDL for View XXAPI_CUSTOM_APIS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_CUSTOM_APIS_V" ("APPLICATION", "LABEL", "VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with data as
( select * from ords_custom_apis_v
)
select field1                 application
,      field2                 label
,      to_number( field3)     value
from table( xxapi_dispatcher_pkg.get_ords_data('TV', '/v1/apis'))
union
select field1                 application
,      field2                 label
,      to_number(field3)      value
from table( xxapi_dispatcher_pkg.get_ords_data('CPC', '/v1/apis'))
union
select field1                 application
,      field2                 label
,      to_number( field3)     value
from table( xxapi_dispatcher_pkg.get_ords_data('CT', '/v1/apis'))
union
select field1                 application
,      field2                 label
,      to_number( field3)     value
from table( xxapi_dispatcher_pkg.get_ords_data('PM', '/v1/apis'))
union
select  'API' application, 'Unprotected' label,  trunc( ( ( max(total_rows)-max(sum_protected) ) / max(total_rows ) ) * 100 ) value
from data
union
select  'API' application, 'Protected' label, trunc( ( max(sum_protected)  / max(total_rows ) ) * 100 ) correct_percentage
from data
;

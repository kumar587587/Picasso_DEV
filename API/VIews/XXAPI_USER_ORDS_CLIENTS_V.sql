--------------------------------------------------------
--  DDL for View XXAPI_USER_ORDS_CLIENTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_USER_ORDS_CLIENTS_V" ("APPLICATION", "CLIENT_NAME", "CLIENT_ID", "CLIENT_SECRET", "UPDATED_ON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select 'CT'       application
,      a.field1   client_name
,      a.field2   client_id
,      a.field3   client_secret
,      a.field4   updated_on
from table(xxapi_dispatcher_pkg.get_ords_data  ( 'CT', '/v1/clients' ) ) a
union 
select 'PM', a.field1, a.field2, a.field3, a.field4
from table(xxapi_dispatcher_pkg.get_ords_data  ( 'PM', '/v1/clients'  ) ) a
union 
select 'CPC', a.field1, a.field2, a.field3, a.field4
from table(xxapi_dispatcher_pkg.get_ords_data  ( 'CPC', '/v1/clients'  ) ) a
union 
select 'TV', a.field1, a.field2, a.field3, a.field4
from table(xxapi_dispatcher_pkg.get_ords_data  ( 'TV', '/v1/clients'  ) ) a
;

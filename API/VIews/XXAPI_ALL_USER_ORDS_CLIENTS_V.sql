--------------------------------------------------------
--  DDL for View XXAPI_ALL_USER_ORDS_CLIENTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_ALL_USER_ORDS_CLIENTS_V" ("SCHEMA", "NAME", "PASSED", "LAST_UPDATED") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select 'API' schema, name,decode(XXAPI_DISPATCHER_PKG.test_user_ords_clients( 'API', client_id, client_secret ),0,'N','Y') passed, updated_on last_updated
from user_ords_clients a
union
select application 
,      client_name
,      decode(XXAPI_DISPATCHER_PKG.test_user_ords_clients(application, client_id, client_secret ),0,'N','Y') passed
,      cast( to_timestamp_tz(updated_on, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') as date  ) last_updated
from xxapi_user_ords_clients_v
order by 1
;

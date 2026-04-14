--------------------------------------------------------
--  DDL for View XXAPI_WEB_CREDENTIALS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_WEB_CREDENTIALS_V" ("APPLICATION", "CREDENTIAL_NAME", "LAST_UPDATED_ON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select substr(field1,3)    application
,      field2              credential_name
,      to_date( rtrim( replace( field3,'T'),'Z') , 'YYYY-MM-DDHH24:MI:SS')   last_updated_on
from table( xxapi_dispatcher_pkg.get_ords_data ( 'CPC' ,'/v1/getWebCreds') )
union
select substr(field1,3)    application
,      field2              credential_name
,      to_date( rtrim( replace( field3,'T'),'Z') , 'YYYY-MM-DDHH24:MI:SS')   last_updated_on
from table( xxapi_dispatcher_pkg.get_ords_data ( 'CT' ,'/v1/getWebCreds') )
union
select substr(field1,3)    application
,      field2              credential_name
,      to_date( rtrim( replace( field3,'T'),'Z') , 'YYYY-MM-DDHH24:MI:SS')   last_updated_on
from table( xxapi_dispatcher_pkg.get_ords_data ( 'TV' ,'/v1/getWebCreds') )
union
select substr(field1,3)    application
,      field2              credential_name
,      to_date( rtrim( replace( field3,'T'),'Z') , 'YYYY-MM-DDHH24:MI:SS')   last_updated_on
from table( xxapi_dispatcher_pkg.get_ords_data ( 'PM' ,'/v1/getWebCreds') )
union
select substr(workspace,3) application
,      name                credential_name
,      last_updated_on     last_updated_on
from apex_workspace_credentials
where credential_type_code = 'OAUTH2_CLIENT_CREDENTIALS'
;

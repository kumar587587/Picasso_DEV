--------------------------------------------------------
--  DDL for View XXAPI_EXECUTED_REQUESTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXAPI"."XXAPI_EXECUTED_REQUESTS_V" ("ID", "URL", "HTTP_METHOD", "REQUEST_RESPONSE", "REQUEST_TIMESTAMP", "HEADER_PARAMETERS", "REQUEST_BODY", "CLOB_DATA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  a."ID",a."URL",a."HTTP_METHOD",a."REQUEST_RESPONSE",a."REQUEST_TIMESTAMP",a."HEADER_PARAMETERS",a."REQUEST_BODY", TO_CLOB(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(a.request_body, 32000, 1)))  clob_data 
from xxapi_executed_requests a
;

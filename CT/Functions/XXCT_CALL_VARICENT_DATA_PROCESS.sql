--------------------------------------------------------
--  DDL for Function XXCT_CALL_VARICENT_DATA_PROCESS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_XXCT"."XXCT_CALL_VARICENT_DATA_PROCESS" return number
is
l_user varchar2(200) := v('APP_USER');
begin
   XXCT_GET_VARICENT_DATA ( l_user ,'Y');
   return 1;
end xxct_call_varicent_data_process;

/

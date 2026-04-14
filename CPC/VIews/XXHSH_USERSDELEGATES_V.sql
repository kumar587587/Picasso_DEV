--------------------------------------------------------
--  DDL for View XXHSH_USERSDELEGATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_USERSDELEGATES_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper( PAYEEID)   id
,     '['||
      concat('"'||upper( PAYEEID )||'",'
,     concat(decode( ROLEID            ,NULL,'null','"' || ROLEID      ||'"')||','
,     concat(decode( startdate         ,NULL,'null','"' || to_char(startdate,'YYYY-MM-DD')  ||'T00:00:00"')||','
,     concat(decode( enddate           ,NULL,'null','"' || to_char(enddate,'YYYY-MM-DD')  ||'T00:00:00"')||','
,     decode( PAYEEID_REGULAR_USER     ,NULL,'""','"'   || PAYEEID_REGULAR_USER  ||'"') ||''
))))
||
      ']' concatenated_values  
,     '['||'"'||upper(PAYEEID)||'"]'  concatenated_pk    
FROM XXSPM_USERSDELEGATES_V pnr
WHERE 1=1
ORDER BY upper( PAYEEID )
;

--------------------------------------------------------
--  DDL for View XXHSH_SPUSERSDELEGATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_SPUSERSDELEGATES_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper( payeeid)   id
,     '['||
      concat('"'||upper( payeeId )||'",'
,     concat(decode( roleid            ,NULL,'null','"' || roleid      ||'"')||','
,     concat(decode( startdate         ,NULL,'null','"' || to_char(startdate,'YYYY-MM-DD')  ||'T00:00:00"')||','
,            decode( enddate           ,NULL,'null','"' || to_char( enddate,'YYYY-MM-DD')  ||'T00:00:00"') ||','
,            'null'
)))
||
      ']' concatenated_values  
,     '['||'"'||upper(payeeid)||'"]'  
concatenated_pk    
FROM XXSPM_SPUSERSDELEGATES_V pnr
WHERE 1=1
ORDER BY upper( payeeId )
;

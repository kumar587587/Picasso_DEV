--------------------------------------------------------
--  DDL for View XXHSH_USER_ROLES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_USER_ROLES_V" ("ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper( payeeid)   id
,     '['||
      concat('"'||upper( payeeId )||'",'
,     concat(decode( role              ,NULL,'null','"' || role      ||'"')||','
,     concat(decode( active            ,NULL,'""'  ,'"' || active    ||'"')||','
,     concat(decode( startdate         ,NULL,'null','"' || to_char(startdate,'YYYY-MM-DD')  ||'T00:00:00"')||','
,     concat(decode( enddate           ,NULL,'null','"' || to_char(enddate,'YYYY-MM-DD')  ||'T00:00:00"')||','
,     decode( grantedbyRole            ,NULL,'""','"' || grantedbyRole  ||'"') ||''
)))))
||
      ']' concatenated_values  
,     '['||'"'||upper(payeeid)||'"]'  
concatenated_pk    
FROM xxspm_user_roles_v pnr
WHERE 1=1
ORDER BY upper( payeeId )
;

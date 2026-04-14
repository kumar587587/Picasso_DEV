--------------------------------------------------------
--  DDL for View XXHSH_VATCODE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_VATCODE_V" ("VATCODE", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT upper(vatcode)  vatcode
,      '['||
       concat('"'||upper(vatcode)||'",'
,      concat('"'||description||'",'
--,      concat('"'||(percentage)||'",'
--,concat('"'||rtrim(ltrim(to_char(percentage,'fm999999999999999990D9999999999')),'.')||'",'
--,      concat(  decode(reversechargeflag,null,'null,', '"'||reversechargeflag||'",')
,concat(''||rtrim(ltrim(to_char(percentage,'fm999999999999999990D9999999999')),'.')||','
,      concat(  decode(reversechargeflag,null,'null,', '"'||reversechargeflag||'",')
,      '"'||active||'"')))) ||
       ']' concatenated_values
,      '['||'"'||upper(vatcode)||'"]' concatenated_pk
FROM xxspm_vatcode_v 
ORDER BY upper(vatcode)
;

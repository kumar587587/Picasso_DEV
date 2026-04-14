--------------------------------------------------------
--  DDL for View XXHSH_MANUALPARTNERINVOICESPLI_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXHSH_MANUALPARTNERINVOICESPLI_V" ("SPLITID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT splitid,
  '['||
  concat('"'||splitid||'",',
  concat('"'||manualpartnerinvoiceid||'",',
  concat('"'||splitdescription||'",',
  --concat(''||splitamount||',',--Commented By TechM Team For MWT-489
  concat(''||RTRIM(to_char(splitamount,'FM999999999999990.99'),'.')||',',--Added By TechM Team For MWT-489
  concat('"'||vatcode||'",',
  '"'||memoline||'"')))))||
  ']' concatenated_values  
  , '['||'"'||splitid||'"]' concatenated_pk
  FROM xxspm_manualpartnerinvoicespli_v 
  ORDER BY splitid
;

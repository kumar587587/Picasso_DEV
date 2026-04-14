--------------------------------------------------------
--  DDL for View XXSPM_SUBSCRIBER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_SUBSCRIBER_V" ("PROVIDER", "PERIODCOUNTED", "PACKAGE", "ENDQUANTITY", "STARTQUANTITY", "TRANSACTIONTYPE", "SOURCE", "IMPORTDATE", "SOURCEFILE", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT p.providername  provider
--,      to_char(periodcounted,'DD-MM-YYYY') periodcounted  --geactivverd voor synchronisatie slag     gaat fout op l_query_del
--,      to_char(periodcounted,'YYYY-MM-DD') periodcounted  --geactivverd voor synchronisatie slag  ivm l_query_del
,      periodcounted periodcounted  -- gedeactiveerd ivm fout in synchronisatie slag  gaat fout op l_url get  maar het moet gewoon een date zijn toch????
,      pck.packagename package
,      endquantity
,      startquantity
,      transactiontype
,      source
--,      to_char(importdate,'DD-MM-YYYY') importdate
,      to_char(importdate,'YYYY-MM-DD')||'T00:00:00' importdate
,      upper(sourcefile)  sourcefile
,      greatest(s.updated, s.created) last_update_or_creation_date
FROM xxcpc_subscriber s
,    xxcpc_providers  p
,    xxcpc_packages   pck
WHERE p.id   = s.providerid
AND   pck.id = s.packageid
AND TO_DATE(S.periodcounted,'DD-MM-YY') >= TO_DATE('01-01-22','DD-MM-YY')
;

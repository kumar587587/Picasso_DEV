--------------------------------------------------------
--  DDL for View XXCT_REOPEND_DOSSIERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REOPEND_DOSSIERS_V" ("DOSSIER_ID", "REOPEND") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT xd.dossier_id                            dossier_id
                                     ,     (
                                           SELECT DECODE (COUNT (*), 0, 'NO', 'YES')
                                           FROM xxct_dssr_prdct_grps_hst pgh
                                           WHERE     1 = 1
                                           AND pgh.dossier_id = xd.dossier_id
                                           AND pgh.dossier_status_new = 'HEROPEND'
                                           )                                         reopend
                                     FROM xxct_dossiers xd
;

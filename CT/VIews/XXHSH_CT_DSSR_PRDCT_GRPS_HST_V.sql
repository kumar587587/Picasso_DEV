--------------------------------------------------------
--  DDL for View XXHSH_CT_DSSR_PRDCT_GRPS_HST_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_CT_DSSR_PRDCT_GRPS_HST_V" ("DSSR_PRDCT_GRP_HST_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.DSSR_PRDCT_GRP_HST_ID
          ,'['|| 
     CONCAT ('"' || to_char(a.dossier_id)|| '",',
     CONCAT ('"' || a.product_group_code || '",',
     CONCAT ('"' || to_char( a.target) || '",',
     CONCAT ('"' || to_char( a.contribution) || '",',
     CONCAT ('"' || to_char( a.amount) || '",',
     CONCAT ('"' || a.remarks || '",',
     '"'||  to_char( a.mandate_cycle)|| '"'
)))))) 
            || ']'                concatenated_values
       FROM XXCT_DSSR_PRDCT_GRPS_HST a
      WHERE     1 = 1   
   ORDER BY a.DSSR_PRDCT_GRP_HST_ID
;

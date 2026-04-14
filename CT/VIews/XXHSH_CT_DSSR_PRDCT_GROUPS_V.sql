--------------------------------------------------------
--  DDL for View XXHSH_CT_DSSR_PRDCT_GROUPS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_CT_DSSR_PRDCT_GROUPS_V" ("DOSSIER_PRODUCT_GROUP_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.dossier_product_group_id
          ,'['|| 
     CONCAT ('"' || to_char(a.dossier_id)|| '",',
     CONCAT ('"' || a.product_group_code || '",',
     CONCAT ('"' || to_char( a.target) || '",',
     CONCAT ('"' || to_char( a.contribution) || '",',
     CONCAT ('"' || to_char( a.amount) || '",',
     CONCAT ('"' || a.remarks || '",',
     CONCAT ('"'||  to_char( a.mandate_cycle)|| '",',
     (DECODE (a.creation_date,NULL, 'null','"'|| TO_CHAR (a.creation_date,'YYYY-MM-DD')|| 'T00:00:00"')
     )
)))))))
            || ']'                concatenated_values

       FROM xxct_dossier_product_groups a
      WHERE     1 = 1   
   ORDER BY a.dossier_product_group_id
;

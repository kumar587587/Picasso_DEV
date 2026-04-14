--------------------------------------------------------
--  DDL for View XXHSH_CT_MANDATES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_CT_MANDATES_V" ("MANDATE_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.mandate_id
          ,'['|| 
     CONCAT ('"' || to_char(a.mandate_id)|| '",',
     CONCAT ('"' || to_char(a.dossier_id)|| '",',
     CONCAT ('"' || u.ruis_name|| '",',
     CONCAT ('"' || a.remarks || '",',
     CONCAT ('"' || a.approval_status || '",',
     CONCAT ('"' || to_char( a.object_version_number) || '",',
     CONCAT ('"' || to_char( a.mandate_cycle) || '",',
     '"'||  a.change_type|| '"'
)))))))
            || ']'                concatenated_values
       FROM XXCT_MANDATES_HiST a
       ,    xxct_users u
      WHERE     1 = 1   
      and a.person_id = u.id
   ORDER BY a.mandate_id
;

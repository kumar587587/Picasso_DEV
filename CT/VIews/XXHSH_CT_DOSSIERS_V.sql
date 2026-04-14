--------------------------------------------------------
--  DDL for View XXHSH_CT_DOSSIERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXHSH_CT_DOSSIERS_V" ("DOSSIER_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.dossier_id
          ,'['|| 
     CONCAT ('"' || to_char(a.dossier_id)|| '",',
     CONCAT ('"' || a.dossier_type || '",',
     CONCAT ('"' || to_char( a.dossier_category_id) || '",',
     CONCAT ('"' || to_char( a.partner_id) || '",',
     CONCAT ('"' || status || '",',
     CONCAT (DECODE (a.action_start_date,NULL, 'null','"'|| TO_CHAR (a.action_start_date,'YYYY-MM-DD')|| 'T00:00:00"')|| ',',
     CONCAT (DECODE (a.action_end_date,NULL, '"4000-12-31T00:00:00"','"'|| TO_CHAR (a.action_end_date,'YYYY-MM-DD')|| 'T00:00:00"')|| ',',
     CONCAT ('"' || a.letter_number_year || '",',
     CONCAT ('"'||  to_char( a.letter_number_sequence)|| '",',
     CONCAT ('"'||  a.letter_suffix|| '",',
     CONCAT ('"'||  a.payment_type|| '",',
     CONCAT ('"'||  a.remarks || '",',
     CONCAT ('"'||  a.addition_remarks|| '",' ,
     CONCAT ('"'||  to_char(a.subdealer_resource_id) || '",',
     CONCAT ('"'||  to_char( a.child_group_id ) || '",',
     CONCAT ('"'||  to_char( nvl(a.object_version_number,0))|| '",',
     CONCAT (DECODE (a.creation_date,NULL, 'null','"'|| TO_CHAR (a.creation_date,'YYYY-MM-DD')|| 'T00:00:00"')|| ',',
     CONCAT (DECODE (a.status_date,NULL, 'null','"'|| TO_CHAR (a.status_date,'YYYY-MM-DD')|| 'T00:00:00"')|| ',',     
     CONCAT ('"'||  a.financial_close|| '",',
     CONCAT ('"'||  invoice_number|| '",',
     CONCAT ('"'||  to_char( parent_dossier_id) || '",',
     CONCAT (DECODE (a.last_update_date,NULL, 'null','"'|| TO_CHAR (a.last_update_date,'YYYY-MM-DD')|| 'T00:00:00"')|| ',',     
     CONCAT ('"'||  to_char( a.mandate_cycle )|| '",',
     CONCAT ('"'||  to_char( a.request_id )|| '",',
     CONCAT ('"'||  a.invoice_remark || '",',
     CONCAT ('"'||  a.extract_to_ar || '",',
     CONCAT ('"'||  to_char( a.extract_payrun_id ) || '",',               
     CONCAT ('"'||  a.hold_payment ,'XXX'
     || '"')
)))))))))))))))))))))))))))
            || ']'                concatenated_values
       FROM xxct_dossiers_migration_v a
      WHERE     1 = 1
;

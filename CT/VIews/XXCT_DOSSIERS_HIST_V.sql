--------------------------------------------------------
--  DDL for View XXCT_DOSSIERS_HIST_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIERS_HIST_V" ("LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "START_DATE", "END_DATE", "PAYMENT_TYPE_MEANING", "AMOUNT", "DOSSIER_TYPE_MEANING", "DOSSIER_ID", "CATEGORY", "LETTER_NUMBER_YEAR", "DOSSIER_CATEGORY_ID", "MAIN_CATEGORY_CODE", "INVOICE_NUMBER", "DEPARTMENT_NAME", "DELETED", "SUBPARTNER_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT    d.year
          || '-CM-'
          || d.volgnummer
          || t.letter
          || d.period
          || d.volgletter
             letter_number,
          d.vcode v_code_business_partner,
          d.partnername Business_partner,
          d.startdate start_Date,
          d.enddate end_Date,
          b.name payment_type_meaning,
          d.totaalbedrag_cached amount,
          t.name dossier_type_meaning,
          d.id dossier_Id,
          c.name category,
          d.year letter_number_year,
          c.id dossier_category_id,
          CASE
             WHEN INSTR (c.name, 'Coop') > 0 THEN 'COAD'
             WHEN INSTR (c.name, 'Delta') > 0 THEN 'DELTA'
             ELSE '%'
          END
             main_category_code,
          d.factuurnummer invoice_number,
          a.name department_name,
          d.deleted,
          d.subpartner_name
     FROM xxct_hist_user.DOSSIER d,
          xxct_hist_user.DEPARTMENT a,
          xxct_hist_user.DOSSIER_TYPE t,
          xxct_hist_user.CATEGORY c,
          xxct_hist_user.betaling b,
          xxct_hist_user.CRS_RAPPORTAGE_TYPE r,
          xxct_hist_user.TEKENRONDE tr
    WHERE     1 = 1
          AND a.id = d.department_id
          AND t.id = d.dossier_type_id
          AND c.id = d.category_id
          AND b.id = d.betaling_id
          AND r.id(+) = c.crs_rapportage_type_id
          AND tr.id(+) = d.huidige_tekenronde_Id
;

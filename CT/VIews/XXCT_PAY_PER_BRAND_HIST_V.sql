--------------------------------------------------------
--  DDL for View XXCT_PAY_PER_BRAND_HIST_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_PAY_PER_BRAND_HIST_V" ("DOSSIER_ID", "PARENT_DOSSIER_ID", "BRAND", "EPB1", "FUNDED_AMOUNT_PB", "EPB2", "AMOUNT_PAID_PB", "EPB3", "AMOUNT_OUTSTANDING_PB", "COLOR_FOR_NEGATIVES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT r.dossier_id,
          u.parent_dossier_id,
          r.brand brand,
          '?' epb1,
          r.funded_amount_pb funded_amount_pb,
          '?' epb2,
          u.amount_paid_PB amount_paid_PB,
          '?' epb3,
          (r.funded_amount_pb - NVL (u.amount_paid_PB, 0))
             amount_outstanding_pb,
          CASE
             WHEN r.funded_amount_pb - NVL (u.amount_paid_PB, 0) < 0
             THEN
                'red'
             ELSE
                'black'
          END
             color_for_negatives
     FROM (  SELECT xdr.dossier_id,
                    flvr.brand brand,
                    SUM (dpgr.amount) funded_amount_pb
               FROM xxct_dossiers xdr,
                    xxct_dssr_prdct_grps_hst dpgr,
                    xxct_product_groups flvr
              WHERE     1 = 1
                    AND xdr.dossier_type = 'RESERVATION'
                    AND dpgr.dossier_id = xdr.dossier_id
                    AND flvr.code = dpgr.product_group_code
                    AND xdr.dossier_id =  
                           NVL (v ('P102_PARENT_DOSSIER_ID'),
                                v ('P102_DOSSIER_ID'))
                    AND dpgr.dossier_status_new = 'HEROPEND'
                    AND dpgr.mandate_cycle =
                           (SELECT MAX (dpgr2.mandate_cycle)
                              FROM xxct_dssr_prdct_grps_hst dpgr2
                             WHERE     dpgr2.dossier_id = dpgr.dossier_id
                                   AND dpgr2.dossier_status_new = 'HEROPEND')
                    AND dpgr.reopend_sequence =
                           (SELECT MAX (dpgr2.reopend_sequence)
                              FROM xxct_dssr_prdct_grps_hst dpgr2
                             WHERE     dpgr2.dossier_id = dpgr.dossier_id
                                   AND dpgr2.dossier_status_new = 'HEROPEND'
                                   AND dpgr2.mandate_cycle = dpgr.mandate_cycle)
           GROUP BY xdr.dossier_id, flvr.brand) r,
          ( 
          SELECT xdu.parent_dossier_id,
                    flvu.brand brand,
                    SUM (dpgu.amount) amount_paid_PB
               FROM xxct_dossiers xdu,
                    xxct_dssr_prdct_grps_hst dpgu,
                    xxct_product_groups flvu
              WHERE     1 = 1
                    AND xdu.parent_dossier_id = 
                           NVL (v ('P102_PARENT_DOSSIER_ID'),
                                v ('P102_DOSSIER_ID'))
                    AND xdu.dossier_type = 'PAYMENT'
                    AND dpgu.dossier_id = xdu.dossier_id
                    AND flvu.code = dpgu.product_group_code
           GROUP BY xdu.parent_dossier_id, flvu.brand
           ) u
    WHERE u.brand(+) = r.brand
;

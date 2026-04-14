--------------------------------------------------------
--  DDL for View XXPM_CHAINS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM_CHAINS_V" ("CHAIN_ID", "CHAIN_NAME", "INDICATOR_IN_EX", "CENTER_CODE", "SALES_CHANNEL_DISTRIBUTION", "SALES_CHANNEL", "SUB_SALES_CHANNEL", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY", "PARTNER_CLASSIFICATION_CODE", "EDITABLE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT bas."CHAIN_ID", 
          bas."CHAIN_NAME", 
          bas."INDICATOR_IN_EX", 
          bas."CENTER_CODE", 
          bas."SALES_CHANNEL_DISTRIBUTION", 
          bas."SALES_CHANNEL", 
          bas."SUB_SALES_CHANNEL", 
          bas."CREATION_DATE", 
          bas."CREATED_BY", 
          bas."LAST_UPDATE_DATE", 
          bas."LAST_UPDATED_BY", 
          bas."PARTNER_CLASSIFICATION_CODE", 
          CASE 
             WHEN     xxpm_general_pkg.get_role = 
                         xxpm_general_pkg.get_pm_kpn_callcenters 
                  AND instr (bas.partner_classification_code, '3') = 0 
             THEN 
                'Nee' 
             WHEN     xxpm_general_pkg.get_role = 
                         xxpm_general_pkg.get_pm_kpn_shops 
                  AND instr (bas.partner_classification_code, '4') = 0 
             THEN 
                'Nee' 
             WHEN xxpm_general_pkg.get_role = 
                     xxpm_general_pkg.get_pm_view_partners 
             THEN 
                'Nee' 
             WHEN instr (bas.partner_classification_code, '9') > 0 
             THEN 
                'Nee' 
             ELSE 
                'Ja' 
          END 
             editable 
     FROM (  SELECT c.chain_id, 
                    c.chain_name, 
                    (SELECT t.meaning 
                       FROM xxpm_lookup_values_v t 
                      WHERE     1 = 1 
                            AND t.lookup_type = 'INTERN_EXTERN' 
                            AND t.enabled_flag = 'Y' 
                            AND t.code = c.indicator_in_ex) 
                       indicator_in_ex, 
                    c.center_code, 
                    c.sales_channel_distribution, 
                    c.sales_channel, 
                    c.sub_sales_channel, 
                    c.creation_date, 
                    c.created_by, 
                    c.last_update_date, 
                    c.last_updated_by, 
                    nvl ( 
                       LISTAGG (partner_classification, '-') 
                          WITHIN GROUP (ORDER BY partner_classification), 
                       NULL) 
                       AS partner_classification_code 
               FROM xxpm_chains c, 
                    (SELECT DISTINCT chain_id, partner_classification 
                       FROM xxpm_partners) p 
              WHERE 1 = 1 AND p.chain_id(+) = c.chain_id 
           GROUP BY c.chain_id, 
                    c.chain_name, 
                    c.center_code, 
                    c.sales_channel_distribution, 
                    c.sales_channel, 
                    c.sub_sales_channel, 
                    c.creation_date, 
                    c.created_by, 
                    c.last_update_date, 
                    c.last_updated_by, 
                    c.indicator_in_ex) bas
;

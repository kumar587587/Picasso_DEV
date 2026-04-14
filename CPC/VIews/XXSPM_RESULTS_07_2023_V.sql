--------------------------------------------------------
--  DDL for View XXSPM_RESULTS_07_2023_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_RESULTS_07_2023_V" ("FILE_NAME", "CLOB_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT                'dtCPCSubscriber_Vari_2023_07.txt' file_name, xxspm_get_concatenated_values('dtCPCSubscriber'                    ,'07-2023', '2023, MONTH 07') clob_value FROM dual
UNION ALL
SELECT      'spCPCManualPartnerInvoice_Vari_2023_07.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoice'          ,'07-2023', '2023, MONTH 07') clob_value FROM dual
UNION ALL
SELECT 'spCPCManualPartnerInvoiceSplit_Vari_2023_07.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoiceSplit'     ,'07-2023', '2023, MONTH 07') clob_value FROM dual
UNION ALL
SELECT           'dtCPCPartnerInvoices_Vari_2023_07.txt' file_name, xxspm_get_concatenated_values('dtCPCPartnerInvoices'               ,'07-2023', '2023, MONTH 07') clob_value FROM dual
;

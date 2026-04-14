--------------------------------------------------------
--  DDL for View XXSPM_RESULTS_01_2023_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_RESULTS_01_2023_V" ("FILE_NAME", "CLOB_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 'dtCPCSubscriber_Vari2023_01.txt' file_name, xxspm_get_concatenated_values('dtCPCSubscriber','01-2023', '2023, MONTH 01') clob_value FROM dual
UNION ALL
SELECT 'spCPCManualPartnerInvoice_Vari2023_01.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoice','01-2023', '2023, MONTH 01') clob_value FROM dual
UNION ALL
SELECT 'spCPCManualPartnerInvoiceSplit_Vari2023_01.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoiceSplit','01-2023', '2023, MONTH 01') clob_value FROM dual
UNION ALL
SELECT 'dtCPCPartnerInvoices_Vari2023_01.txt' file_name, xxspm_get_concatenated_values('dtCPCPartnerInvoices','01-2023', '2023, MONTH 01') clob_value FROM dual
;

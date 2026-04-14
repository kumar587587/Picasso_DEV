--------------------------------------------------------
--  DDL for View XXSPM_RESULTS_12_2022_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_RESULTS_12_2022_V" ("FILE_NAME", "CLOB_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 'dtCPCSubscriber_Vari2022_12.txt' file_name, xxspm_get_concatenated_values('dtCPCSubscriber','12-2022', '2022, MONTH 12') clob_value FROM dual
UNION ALL
SELECT 'spCPCManualPartnerInvoice_Vari2022_12.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoice','12-2022', '2022, MONTH 12') FROM dual
UNION ALL
SELECT 'spCPCManualPartnerInvoiceSplit_Vari2022_12.txt' file_name, xxspm_get_concatenated_values('spCPCManualPartnerInvoiceSplit','12-2022', '2022, MONTH 12') FROM dual
UNION ALL
SELECT 'dtCPCPartnerInvoices_Vari2022_12.txt' file_name, xxspm_get_concatenated_values('dtCPCPartnerInvoices','12-2022', '2022, MONTH 12') FROM dual
;

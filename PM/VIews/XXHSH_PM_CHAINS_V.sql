--------------------------------------------------------
--  DDL for View XXHSH_PM_CHAINS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_PM_CHAINS_V" ("CHAIN_ID", "CONCATENATED_VALUES") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select chain_id,
CONCAT ('"' || c.chain_id||'",',            --chain_id
CONCAT ('"' || c.chain_name||'",',            --chain_name
CONCAT ('"' || c.indicator_in_ex||'",',            --indicator_in_ex
CONCAT ('"' || c.center_code||'",',            --center_code
CONCAT ('"' || c.sales_channel_distribution||'",',            --sales_channel_distribution
CONCAT ('"' || c.sales_channel||'",',            --sales_channel
CONCAT ('"' || c.sub_sales_channel||'",',            --sub_sales_channel
CONCAT ('"' || c.channel_mix||'",',            --channel_mix
CONCAT ('"' || to_char( c.creation_date,'MONYYYYDD')||'",',            --creation_date
CONCAT ('"' || c.created_by||'",',            --created_by
CONCAT ('"' || to_char( c.last_update_date,'MONYYYYDD') ||'",',            --last_update_date
'"' || c.last_updated_by||'"')            --last_updated_by
)))))))))) concatenated_values
from XXPM_CHAINS c
;

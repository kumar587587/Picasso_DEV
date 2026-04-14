--------------------------------------------------------
--  DDL for View XXPM4TV_CHAINS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXPM4TV_CHAINS_V" ("CHAIN_ID", "CHAIN_NAME", "INDICATOR_IN_EX", "CENTER_CODE", "SALES_CHANNEL_DISTRIBUTION", "SALES_CHANNEL", "SUB_SALES_CHANNEL", "CHANNEL_MIX", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  c.chain_id 
,       c.chain_name 
,       c.indicator_in_ex 
,       c.center_code 
,       c.sales_channel_distribution 
,       c.sales_channel 
,       c.sub_sales_channel 
,       c.channel_mix 
,      to_char(c.creation_date,'YYYY-MM-DD')||'T'||to_char(c.creation_date,'HH24:MI:SS')||'Z'        creation_date
,       c.created_by 
,      to_char(c.last_update_date,'YYYY-MM-DD')||'T'||to_char(c.last_update_date,'HH24:MI:SS')||'Z'        last_update_date
,       c.last_updated_by
from xxpm_chains c
   where 1=1
   AND sub_sales_channel           != 'VAR partner'
   --and chain_id in (select distinct chain_id from xxpm4tv_partners_v) --alle chains need to be transferred. At creation time it is not know if this chain will be used for a TV partner.
;

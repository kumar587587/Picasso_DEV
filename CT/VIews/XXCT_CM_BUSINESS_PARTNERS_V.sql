--------------------------------------------------------
--  DDL for View XXCT_CM_BUSINESS_PARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CM_BUSINESS_PARTNERS_V" ("RESOURCE_NAME", "RESOURCE_ID", "V_CODE", "CHANNEL_MANAGER_PERSON_ID", "CHANNEL_MANAGER", "RETAIL_SUPPORT_PERSON_ID", "RETAIL_SUPPORT", "CENTER_CODE", "RELATED_GROUP_NAME", "CHILD_GROUP_ID", "ORACLE_CUSTOMER_NUMBER", "PARTNER_NAME", "SITE_NR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select partner_name             resource_name
,      partner_id               resource_id
,      v_code                   v_code
,      u.id                     channel_manager_person_id   
,      u.display_name           channel_manager
,      rs.id                    retail_support_person_id
,      rs.display_name          retail_support
,      null                     center_code
,      null                     related_group_name
,      null                     child_group_Id
,      oracle_customer_nr       oracle_customer_number
,      partner_name             partner_name
,      null                     site_nr
from xxct_partners_tmp_v  p
,    xxct_users           u  
,    xxct_users           rs
where u.ruis_name = p.channel_manager_person_id
and rs.ruis_name  = 'JAGER060'
;

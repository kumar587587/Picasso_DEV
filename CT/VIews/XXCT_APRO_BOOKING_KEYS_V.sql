--------------------------------------------------------
--  DDL for View XXCT_APRO_BOOKING_KEYS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APRO_BOOKING_KEYS_V" ("BRAND", "DIVISION", "CATEGORY_NAME", "CENTER_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select b.code brand, div.meaning division, cat.meaning category_name, xba.center_code
from xxct_brand_apro_booking_key xba
,    xxct_brands b
,    xxct_lookup_values div
,    xxct_lookup_values cat
where b.id =xba.brand_id
and div.lookup_type  ='DIVISIONS' 
and div.id           = xba.division_id 
and cat.lookup_type  ='MAIN_CATEGORIES' 
and cat.id           = xba.category_name_id
;

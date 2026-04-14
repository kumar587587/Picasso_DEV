--------------------------------------------------------
--  DDL for Procedure XXMIG_INSERT_BOOKING_KEYS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCT"."XXMIG_INSERT_BOOKING_KEYS" ( p_brand in varchar2,p_division in varchar2, p_category in varchar2, p_center_code in number)
is
  l_brand_id      number;
  l_division_id   number;
  l_category_id   number;
begin
   select id into l_brand_id     from xxct_brands where  code = p_brand;
   select id into l_division_id  from xxct_lookup_values where lookup_type ='DIVISIONS' and meaning = p_division;
   select id into l_category_id  from xxct_lookup_values where lookup_type ='MAIN_CATEGORIES' and meaning = p_category;
   insert into xxct_brand_apro_booking_key( brand_id, division_id, category_name_id, center_code) values (l_brand_id, l_division_id, l_category_id, p_center_code );
   commit;
end;



/

--------------------------------------------------------
--  DDL for Type XXCT_PARTNER_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXCT"."XXCT_PARTNER_TYPE" AS OBJECT (
  partner_id    NUMBER,
  partner_name  VARCHAR2(2000),
  v_code        VARCHAR2(10),  
  channel_manager VARCHAR2(200),  
  resource_id     NUMBER,
  channel_manager_person_id varchar2(150),
  partner_number number,
  email_address_invoice VARCHAR2(200) ,
  partner_flow_type     VARCHAR2(200) ,
  oracle_customer_nr     VARCHAR2(200),
  vat_reverse_charge     VARCHAR2(20)
);



/

--------------------------------------------------------
--  DDL for View XXSPM_ADDRESSES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXSPM_ADDRESSES_V" ("PARTNER_ID", "BILLINGSTREET", "BILLINGCITY", "BILLINGSTATE", "BILLINGPOSTALCODE", "BILLINGCOUNTRYCODE", "BILLINGCOUNTRY", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a.partner_id                                                                  partner_id
,      address_street ||' '||address_house_number||' '||address_house_number_suffix  billingStreet
,      address_residence                                                             billingCity
,      null                                                                          billingState
,      address_zip_code                                                              billingPostalCode
,      address_country                                                               billingCountryCode
,      c.country_name                                                                billingCountry 
,      greatest(last_update_date, creation_date)                                     last_update_or_creation_date
from xxpm_addresses   a
,    xxpm_general_pkg.get_iso_country_codes() c
,    (select  partner_id,min(decode(a.address_type,4,'A',2,'B',1,'C',3,'D','E')) use_order
      from xxpm_addresses  a
      group by partner_id
      ) g
where c.iso3(+)  = a.address_country
and  a.partner_id = g.partner_id
and  decode(a.address_type,4,'A',2,'B',1,'C',3,'D','E')  = g.use_order
;

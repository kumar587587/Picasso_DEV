--------------------------------------------------------
--  DDL for View XXCT_DOSSIERS_OVERV_HIST_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIERS_OVERV_HIST_V" ("LETTER_NUMBER", "V_CODE_BUSINESS_PARTNER", "BUSINESS_PARTNER", "START_DATE", "END_DATE", "PAYMENT_TYPE_MEANING", "AMOUNT", "DOSSIER_TYPE_MEANING", "DOSSIER_ID", "CATEGORY", "INVOICE_NUMBER", "LETTER_NUMBER_YEAR", "DELETED", "SUBPARTNER_NAME", "DEPARTMENT_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select xd.letter_number                                         letter_number
,      xd.v_code_business_partner                               v_code_business_partner
,      xd.Business_partner                                      Business_partner
,      to_char(xd.start_date,'DD-MM-YYYY')                      start_date
,      to_char(xd.end_date,'DD-MM-YYYY')                        end_date
,      xd.payment_type_meaning                                  payment_type_meaning
,      xd.amount                                                amount
,      xd.dossier_type_meaning                                  dossier_type_meaning
,      xd.dossier_id                                            dossier_id
,      xd.category                                              category
,      xd.invoice_number
,      xd.letter_number_year
,      xd.deleted
,      xd.subpartner_name
,      xd.department_name
from xxct_dossiers_hist_v xd
where 1=1
--and   '1' = xxice_debug_pkg.debug('XXCT_DOSSIERS_HIST_V','De XXCT_DOSSIERS_HIST_V query gebruikt v(P115_TYPE_FILTER) = '||v('P115_TYPE_FILTER') ||' als filter criteria')
--and   '1' = xxice_debug_pkg.debug('XXCT_DOSSIERS_HIST_V','De XXCT_DOSSIERS_HIST_V query gebruikt v(P115_CRS) = '||v('P115_CRS') ||' als filter criteria')
--
and instr (nvl (initcap(v ('P115_TYPE_FILTER')), '!'), xd.dossier_type_meaning) >   0
and start_date >=  nvl (to_date (v ('P115_START_DATE'), 'DD-MM-YYYY'), sysdate - 1000000)
and end_date <=    nvl (to_date (v ('P115_END_DATE'), 'DD-MM-YYYY'),  sysdate + 1000000)
and dossier_category_id like  nvl (v ('P115_CATEGORY_ID'), '%')
and business_partner like nvl (v ('P115_RESOURCE_ID'), '%')
and letter_number_year like nvl (v ('P115_YEAR'), '%')
and nvl (amount, 0) between nvl (v ('P115_AMOUNT_FROM'),-99999999999) and nvl (v ('P115_AMOUNT_TO'), 99999999999)
and main_category_code like nvl (v ('P115_CRS'), '%');

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_DOSSIERS_OVERV_HIST_V"  IS '$Id: vw_XXCT_DOSSIERS_OVERV_HIST_V.sql,v 1.2 2019/10/15 20:46:59 engbe502 Exp $'
;

--------------------------------------------------------
--  DDL for View XXCT_CTPAYOUTAPPROVALWF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_CTPAYOUTAPPROVALWF_V" ("DOSSIERID", "DOSSIERTYPE", "ACTIONTYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select "DOSSIERID","DOSSIERTYPE","ACTIONTYPE"
from table( XXCT_GEN_REST_APIS.get_ctpayoutapprovalwf )
;

--------------------------------------------------------
--  DDL for View XXCT_REP_2_MAX_ID_BCSD_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_REP_2_MAX_ID_BCSD_V" ("DOSSIER_ID", "PRODUCT_GROUP_CODE", "DSSR_PRDCT_GRP_HST_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select dgh2.dossier_id                            dossier_id
,      dgh2.product_group_code                    product_group_code
,      max(dgh2.dssr_prdct_grp_hst_id)            dssr_prdct_grp_hst_id
from  xxct_dssr_prdct_grps_hst dgh2
where 1                        = 1
and   trunc(dgh2.status_date)  < to_date(nvl(v('P111_CHANGE_START_DATE'),'01-01-1900'),'DD-MM-YYYY')
group by dgh2.dossier_id
,        dgh2.product_group_code;

   COMMENT ON TABLE "WKSP_XXCT"."XXCT_REP_2_MAX_ID_BCSD_V"  IS '$Id: vw_XXCT_REP_2_MAX_ID_BCSD_V.sql,v 1.1 2019/02/12 09:23:51 rikke493 Exp $'
;

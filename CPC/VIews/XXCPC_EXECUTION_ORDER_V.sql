--------------------------------------------------------
--  DDL for View XXCPC_EXECUTION_ORDER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXCPC_EXECUTION_ORDER_V" ("EXE_ORDER", "IUD", "TABLE_NAME", "ID", "PARENT_ID", "OPEN_PERIOD_I", "OPEN_PERIOD_U", "DELETE_PERIOD", "OPEN_PERIOD_I_OLD", "OPEN_PERIOD_U_OLD") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT a.exe_order
,      a.iud
,      a.table_name
,      a.id
,      a.parent_id        
,      open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old
FROM (
SELECT exe_order,iud,'XXCPC_CHANNELS'                    table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old FROM xxcpc_channels_a UNION 
SELECT exe_order,iud,'XXCPC_CONTENTPARTNERBILLINGINF'    table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_contentpartnerbillinginf_a UNION 
SELECT exe_order,iud,'XXCPC_CONTENTPARTNERS'             table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_contentpartners_a UNION 
SELECT exe_order,iud,'XXCPC_CONTRACTPACKAGECHANNELS'     table_name ,nvl(id,id_old) id, nvl(contractpackageid,contractpackageid_old)           parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_contractpackagechannels_a UNION 
SELECT exe_order,iud,'XXCPC_CONTRACTPACKAGEDETAILS'      table_name ,nvl(id,id_old) id, nvl(contractid,contractid_old)                         parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old FROM xxcpc_contractpackagedetails_a UNION 
SELECT exe_order,iud,'XXCPC_CONTRACTS'                   table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_contracts_a UNION 
SELECT exe_order,iud,'XXCPC_CORRECTIONAMOUNTS'           table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_correctionamounts_a UNION 
SELECT exe_order,iud,'XXCPC_MANUALPARTNERINVOICESPLI'    table_name ,nvl(id,id_old) id, nvl(manualpartnerinvoiceid,manualpartnerinvoiceid_old) parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old FROM xxcpc_manualpartnerinvoicespli_a UNION 
SELECT exe_order,iud,'XXCPC_MANUALPARTNERINVOICE'        table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_manualpartnerinvoice_a UNION 
SELECT exe_order,iud,'XXCPC_PACKAGES'                    table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_packages_a UNION 
SELECT exe_order,iud,'XXCPC_PROVIDERS'                   table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_providers_a UNION 
SELECT exe_order,iud,'XXCPC_SPECIALPACKAGESDETAILS'      table_name ,nvl(id,id_old) id, nvl(specialpackageid,specialpackageid_old)             parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old FROM xxcpc_specialpackagesdetails_a UNION 
SELECT exe_order,iud,'XXCPC_SPECIALPACKAGES'             table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_specialpackages_a UNION 
SELECT exe_order,iud,'XXCPC_SUBSCRIBER'                  table_name ,nvl(id,id_old) id, NULL                   parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_subscriber_a UNION 
SELECT exe_order,iud,'XXCPC_TIEREDCOMMISSIONRATES'       table_name ,nvl(id,id_old) id, nvl(tierperiodid,tierperiodid_old)                     parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_tieredcommissionrates_a UNION 
SELECT exe_order,iud,'XXCPC_TIERPERIODS'                 table_name ,nvl(id,id_old) id, nvl(contractid,contractid_old)                         parent_id,open_period_i,open_period_u,delete_period,open_period_i_old,open_period_u_old  FROM xxcpc_tierperiods_a
) a
;

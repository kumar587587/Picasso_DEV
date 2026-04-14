--------------------------------------------------------
--  DDL for View XXCT_DOSSIERS_ACTIONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_DOSSIERS_ACTIONS_V" ("DOSSIER_ID", "ACTION_START_DATE", "ACTION_END_DATE", "NUMBER_OF_ACTION_PERIODS", "MONTHS_PASSED", "COMPLETION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT dossier_id
                                          ,      action_start_date
                                          ,      action_end_date
                                          ,      number_of_action_periods
                                          ,      months_passed
                                          ,      CASE
                                                 WHEN LAST_DAY ( TO_DATE (v ('P114_TRANSPOST_PERIOD'),'YYYYMM')) 
                                                      BETWEEN TRUNC ( action_start_date, 'MONTH')
                                                      AND LAST_DAY  ( action_end_date)
                                                 THEN
                                                    ROUND ( (100 / number_of_action_periods) * months_passed, 0)
                                                 WHEN LAST_DAY ( TO_DATE (v ('P114_TRANSPOST_PERIOD'), 'YYYYMM')) > LAST_DAY (action_end_date)
                                                 THEN
                                                     100
                                                 ELSE
                                                     0
                                                 END                completion
                                          FROM (
                                               SELECT xd.dossier_id
                                               ,      xd.action_end_date
                                               ,      xd.action_start_date
                                               ,      MONTHS_BETWEEN ( LAST_DAY (xd.action_end_date), LAST_DAY (xd.action_start_date)) + 1 number_of_action_periods
                                               ,      MONTHS_BETWEEN ( LAST_DAY ( TO_DATE ( v ('P114_TRANSPOST_PERIOD'),'YYYYMM')), LAST_DAY (xd.action_start_date)) + 1 months_passed
                                               FROM xxct_dossiers xd
                                               )
;

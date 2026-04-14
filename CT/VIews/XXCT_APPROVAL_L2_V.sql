--------------------------------------------------------
--  DDL for View XXCT_APPROVAL_L2_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCT"."XXCT_APPROVAL_L2_V" ("MANDATE_CYCLE", "DISPLAY_NAME", "ROLE_NAME", "APPROVAL_STATUS", "APPROVAL_DATE", "APPROVAL_COMMENTS", "ROLEID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select substr( h.initiator,instr(h.initiator,'-')+1) mandate_cycle
--,      decode (au.approvertype,'DELEGATE', u.display_name||' (delegate)', u.display_name) display_name
--,      decode (ud.payeeid, null, u.display_name, u.display_name||' (delegate)' ) display_name
,       ur.display_name
,      r.role_name
,       nvl( decode( h.action,'Approve','Akkoord','Reject','Afgekeurd',h.action),'nog tekenen')  approval_status
,      to_char( to_date(substr( h.dateactioned,1,9),'DD-MM-YY'),'DD-MM-YYYY')                    approval_date
,      null                                                                                      approval_comments
,      r.role_key                                                                                roleid
--;
--select *
from xxct_wf_history_tmp_v           h   
,    xxct_dossiers                   d
,    xxct_users                      u
,    (
      select ur.role_id,ur.user_id, ur.start_date, ur.end_date, u.display_name
      from xxct_user_roles     ur
      ,    xxct_users          u
      where u.id = ur.user_id
      union
      select r.id, u.id, ud.startdate, ud.enddate, u.display_name||' (delegate)' 
      from xxct_spusersdelegates ud
      ,    xxct_users            u
      ,    xxct_roles            r
      where u.ruis_name = ud.payeeid 
      and r.role_key    = ud.roleid
       )                 ur
,    xxct_roles                      r
,    xxct_partners_tmp               p
where 1=1
and instr( h.initiator, v('P102_DOSSIER_ID') ) > 0
and h.action            in ('Approve','Reject')
and h.nodename          like '%L2'
and d.dossier_id        = to_number( to_char( v('P102_DOSSIER_ID') ) )
and u.ruis_name         = h.actor
and ur.user_id          = u.id
and to_date(substr( h.dateactioned,1,8),'DD-MM-YY') between  ur.start_date and ur.end_date
and r.id                = ur.role_id 
and r.role_key          NOT like '%L1'
and p.partner_id        = d.partner_id
and instr( r.role_key,p.partner_flow_type) > 0 
and p.username          = v('APP_USER')
;

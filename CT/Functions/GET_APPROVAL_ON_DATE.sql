--------------------------------------------------------
--  DDL for Function GET_APPROVAL_ON_DATE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_XXCT"."GET_APPROVAL_ON_DATE" ( p_role_key in varchar2, p_date in date) 
return varchar2
is
   c_routine_name  CONSTANT VARCHAR2(200) := 'get_approval_on_date';
   l_approver varchar2(200);
begin   
    select user_name
    into l_approver
    from 
    (
        select roleid,payeeid,startdate,enddate, daydistance, min(daydistance) over (partition by roleid) nearestdates, user_name
        from 
        (
            select roleid, ud.payeeid, nvl(u.display_name, u.user_name)||' (delegate)' user_name,startdate,enddate--, ( abs( p_date-to_date(ud.startdate,'dd-mm-yyyy')) + abs( p_date-to_date(ud.enddate,'dd-mm-yyyy'))) daydistance
                   , ( abs( p_date-ud.startdate) + abs( p_date-ud.enddate)) daydistance
            from xxct_spusersdelegates ud
            ,    xxct_users            u
            where  ud.roleid = p_role_key
            and u.ruis_name = ud.payeeid
            --and to_date(ud.enddate,'dd-mm-yyyy') >= to_date(p_date,'dd-mm-yyyy')
            and to_date(sysdate,'dd-mm-yyyy') between to_date(ud.startdate,'dd-mm-yyyy') and to_date(ud.enddate,'dd-mm-yyyy') --Added By TechM Team For MWT-740
            union
            select r.role_key, u.ruis_name, nvl(u.display_name, u.user_name) user_name, ur.start_date, ur.end_date  
                   ,( abs( p_date-ur.start_date) + abs( p_date-ur.end_date)) daydistance 
            from xxct_user_roles  ur
            ,    xxct_roles       r
            ,    xxct_users       u
            where r.id = ur.role_id
            and u.id = ur.user_id
            and r.role_key = p_role_key
            --and ur.end_date >= p_date
            and to_date(p_date,'dd-mm-yyyy') between to_date(ur.start_date,'dd-mm-yyyy') and to_date(ur.end_date,'dd-mm-yyyy')
        )
    )
    where daydistance = nearestdates
    ;
    return l_approver;
exception 
when others then
   xxct_gen_debug_pkg.debug( c_routine_name, 'ERROR: '||SQLERRM);
   raise;
end get_approval_on_date;

/

--------------------------------------------------------
--  DDL for Trigger XXCT_DOSSIERS_AU_STATUS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_AU_STATUS" 
AFTER UPDATE ON XXCT_DOSSIERS 
REFERENCING FOR EACH ROW
DECLARE
c_trigger_name           CONSTANT VARCHAR2(50)  := 'XXCT_DOSSIERS_AU_STATUS';
l_sp_table_name                   VARCHAR2(200) := 'CTPayoutApprovalWF';
l_new_values_string               VARCHAR2(32000);
l_old_values_string               VARCHAR2(32000);
L_DOSSIERID                       XXCT_CTPAYOUTAPPROVALWF.DOSSIERID%TYPE;
L_LINENR                          XXCT_CTPAYOUTAPPROVALWF.LINENR%TYPE;
L_DOSSIERTYPE                     XXCT_CTPAYOUTAPPROVALWF.DOSSIERTYPE%TYPE;
L_ACTIONTYPE                      XXCT_CTPAYOUTAPPROVALWF.ACTIONTYPE%TYPE;
L_DOSSIERNUMBER                   XXCT_CTPAYOUTAPPROVALWF.DOSSIERNUMBER%TYPE;
L_PARTNERVCODE                    XXCT_CTPAYOUTAPPROVALWF.PARTNERVCODE%TYPE;
L_PARTNERNAME                     XXCT_CTPAYOUTAPPROVALWF.PARTNERNAME%TYPE;
L_BONUSPARTNERTYPE                XXCT_CTPAYOUTAPPROVALWF.BONUSPARTNERTYPE%TYPE;
L_PRODUCTGROUPNAME                XXCT_CTPAYOUTAPPROVALWF.PRODUCTGROUPNAME%TYPE;
L_PRODUCTGROUPCOMMENT             XXCT_CTPAYOUTAPPROVALWF.PRODUCTGROUPCOMMENT%TYPE;
L_PAYMENTTYPE                     XXCT_CTPAYOUTAPPROVALWF.PAYMENTTYPE%TYPE;
L_VATCODE                         XXCT_CTPAYOUTAPPROVALWF.VATCODE%TYPE;
L_LINEAMOUNT                      XXCT_CTPAYOUTAPPROVALWF.LINEAMOUNT%TYPE;
L_TOTALAMOUNT                     XXCT_CTPAYOUTAPPROVALWF.TOTALAMOUNT%TYPE;
L_DOSSIERUNDERPINNEDDOCUMENTSURL  XXCT_CTPAYOUTAPPROVALWF.DOSSIERUNDERPINNEDDOCUMENTSURL%TYPE;
L_COMMENT                         VARCHAR2(200);
L_APPROVED                        XXCT_CTPAYOUTAPPROVALWF.APPROVED%TYPE;
L_APPROVEDANDSYNCHED              XXCT_CTPAYOUTAPPROVALWF.APPROVEDANDSYNCHED%TYPE;
L_DELETE                          VARCHAR2(3);
L_FORMIDAPPROVAL                  XXCT_CTPAYOUTAPPROVALWF.FORMIDAPPROVAL%TYPE;
L_FORMIDPAY                       XXCT_CTPAYOUTAPPROVALWF.FORMIDPAY%TYPE;
L_INVOICENUMBER                   XXCT_CTPAYOUTAPPROVALWF.INVOICENUMBER%TYPE;
L_PAID                            XXCT_CTPAYOUTAPPROVALWF.PAID%TYPE;
L_PAIDANDSYNCHED                  XXCT_CTPAYOUTAPPROVALWF.PAIDANDSYNCHED%TYPE;
L_PAYDATE                         XXCT_CTPAYOUTAPPROVALWF.PAYDATE%TYPE;
L_COMMENTFLAG                     XXCT_CTPAYOUTAPPROVALWF.COMMENTFLAG%TYPE;
L_SHAREPARTNERFLAG                XXCT_CTPAYOUTAPPROVALWF.SHAREPARTNERFLAG%TYPE;
L_PAYMENTINCLUDE                  XXCT_CTPAYOUTAPPROVALWF.PAYMENTINCLUDE%TYPE;
L_MANDATE_CYCLE                   NUMBER;

BEGIN
    xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'start');
    xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||:OLD.STATUS||'=='||:NEW.STATUS);

    IF :OLD.STATUS = 'PROCURATIE' AND :NEW.STATUS IN ('AFGESLOTEN','FACTURATIE') THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'Under IF Condition');
        --SELECT * FROM XXCT_CTPAYOUTAPPROVALWF WHERE DOSSIERID = 5708 AND APPROVED IS NULL;
        UPDATE XXCT_CTPAYOUTAPPROVALWF SET APPROVED = 'Y',APPROVEDANDSYNCHED = 'Y' WHERE DOSSIERID = :OLD.DOSSIER_ID AND APPROVED IS NULL;

    ELSIF :OLD.STATUS = 'PROCURATIE' AND :NEW.STATUS = 'OPEN' THEN
        xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'Under ELSIF Condition');

        --UPDATE XXCT_CTPAYOUTAPPROVALWF SET APPROVED = 'N' WHERE DOSSIERID = :OLD.DOSSIER_ID AND APPROVED IS NULL;

        xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'2ND');

        BEGIN
            SELECT * INTO L_DOSSIERID,L_LINENR,L_DOSSIERTYPE,L_ACTIONTYPE,L_DOSSIERNUMBER,L_PARTNERVCODE,L_PARTNERNAME,L_BONUSPARTNERTYPE,
                          L_PRODUCTGROUPNAME,L_PRODUCTGROUPCOMMENT,L_PAYMENTTYPE,L_VATCODE,L_LINEAMOUNT,L_TOTALAMOUNT,L_DOSSIERUNDERPINNEDDOCUMENTSURL,
                          --L_COMMENT,
                          L_APPROVED,L_APPROVEDANDSYNCHED,--L_DELETE,
                          L_FORMIDAPPROVAL,L_FORMIDPAY,L_INVOICENUMBER,L_PAID,L_PAIDANDSYNCHED,
                          L_PAYDATE,L_COMMENTFLAG,L_SHAREPARTNERFLAG,L_PAYMENTINCLUDE
            FROM (SELECT DOSSIERID,LINENR,DOSSIERTYPE,ACTIONTYPE,DOSSIERNUMBER,PARTNERVCODE,PARTNERNAME,BONUSPARTNERTYPE,PRODUCTGROUPNAME, 
                         PRODUCTGROUPCOMMENT,PAYMENTTYPE,VATCODE,LINEAMOUNT,TOTALAMOUNT,DOSSIERUNDERPINNEDDOCUMENTSURL,--COMMENT,
                         APPROVED,APPROVEDANDSYNCHED,--DELETE,
                         FORMIDAPPROVAL,FORMIDPAY,INVOICENUMBER,PAID,PAIDANDSYNCHED,PAYDATE,COMMENTFLAG,SHAREPARTNERFLAG, 
                         PAYMENTINCLUDE
                    FROM XXCT_CTPAYOUTAPPROVALWF
                   WHERE DOSSIERID = :OLD.DOSSIER_ID AND APPROVED IS NULL
                   );
        EXCEPTION
            WHEN OTHERS THEN
                L_DOSSIERID := NULL;
                xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'error in select statement == '||SQLERRM);
        END;
        ----------Get Mendate Cycle----------
        SELECT COUNT(DOSSIER_STATUS_OLD) INTO L_MANDATE_CYCLE FROM xxct_dssr_prdct_grps_hst 
        WHERE DOSSIER_ID = :OLD.DOSSIER_ID AND DOSSIER_STATUS_OLD IN ('OPEN','HEROPEND');

        xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'L_MANDATE_CYCLE == '||L_MANDATE_CYCLE);
        xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'L_DOSSIERID,L_LINENR,L_DOSSIERTYPE,L_ACTIONTYPE = '||L_DOSSIERID||', '||L_LINENR||', '||L_DOSSIERTYPE||', '||L_ACTIONTYPE);

        l_old_values_string := '"'||L_DOSSIERID||'",'||
                               '"'||L_LINENR||'",'||
                               '"'||L_DOSSIERTYPE||'",'||
                               '"'||L_ACTIONTYPE||'",'||
                               '"'||L_DOSSIERNUMBER||'",'||
                               '"'||L_PARTNERVCODE||'",'||
                               '"'||L_PARTNERNAME||'",'||
                               '"'||L_BONUSPARTNERTYPE||'",'||
                               '"'||L_PRODUCTGROUPNAME||'",'||
                               '"'||L_PRODUCTGROUPCOMMENT||'",'||
                               '"'||L_PAYMENTTYPE||'",'||
                               '"'||L_VATCODE||'",'||
                               '"'||L_LINEAMOUNT||'",'||
                               '"'||L_TOTALAMOUNT||'",'||
                               '"'||L_DOSSIERUNDERPINNEDDOCUMENTSURL||'",'||
                               '"'||L_COMMENT||'",'||
                               '"'||L_FORMIDAPPROVAL||'",'||--NEED TO FormIDApproval Column
                               '"'||'N'||'",'||--L_APPROVED
                               '"'||L_FORMIDPAY||'",'||
                               '"'||L_PAID||'",'||
                               '"'||L_PAYDATE||'",'||
                               '"'||L_INVOICENUMBER||'",'||
                               '"'||'Y'||'",'||--DELETE
                               '"'||L_APPROVEDANDSYNCHED||'",'||
                               '"'||L_PAIDANDSYNCHED||'",'||
                               '"",'||--PaymentPostpone
                               '"'||L_SHAREPARTNERFLAG||'",'||
                               '"'||L_COMMENTFLAG||'",'||
                               '"'||L_PAYMENTINCLUDE||'",'||
                               '"'||L_DOSSIERID||'-'||L_MANDATE_CYCLE ||'"';

        xxct_gen_debug_pkg.debug_t( c_trigger_name, 'l_old_values_string == '||l_old_values_string);

        xxct_gen_rest_apis.delete_row(p_table_name    => l_sp_table_name 
                                    , p_key_values    => l_old_values_string
                                    , p_old_values    => l_old_values_string 
       );

       xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'After delete from Varicent');

       DELETE FROM XXCT_CTPAYOUTAPPROVALWF WHERE DOSSIERID = :OLD.DOSSIER_ID AND APPROVED IS NULL;

       xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'After delete in Apex');
    END IF;
    xxct_gen_debug_pkg.debug_t( c_trigger_name,:OLD.DOSSIER_ID||'=='||'End');

END XXCT_DOSSIERS_AU_STATUS;
/
ALTER TRIGGER "WKSP_XXCT"."XXCT_DOSSIERS_AU_STATUS" ENABLE;

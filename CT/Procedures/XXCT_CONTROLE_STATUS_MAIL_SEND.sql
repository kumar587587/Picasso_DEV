--------------------------------------------------------
--  DDL for Procedure XXCT_CONTROLE_STATUS_MAIL_SEND
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_XXCT"."XXCT_CONTROLE_STATUS_MAIL_SEND" AS
C_PROCESS_NAME  VARCHAR2(50):='XXCT_CONTROLE_STATUS_MAIL_SEND';
CURSOR C1 IS
SELECT DISTINCT C.RUIS_NAME,c.USER_NAME USER_EMAIL,NVL(C.DISPLAY_NAME,C.USER_NAME) USER_NAME
FROM XXCT_DOSSIERS A,WKSP_XXPM.XXPM_PARTNERS_EXTRA_V B,XXCT_USERS C
WHERE A.STATUS = 'CONTROLE'
AND A.PARTNER_ID = B.PARTNER_ID
AND B.CHANNEL_MANAGER_OTHER = C.RUIS_NAME
AND A.DOSSIER_ID NOT IN (SELECT B.DOSSIER_ID
  FROM XXCT_DOSSIERS B,
(
SELECT MANDATE_ID,DOSSIER_ID,CHANGE_TYPE ACTION_TYPE FROM XXCT_MANDATES_HIST WHERE (DOSSIER_ID,MANDATE_ID) IN (
SELECT DOSSIER_ID,MANDATE_ID FROM (
SELECT DOSSIER_ID,MAX(MANDATE_ID) MANDATE_ID FROM XXCT_MANDATES_HIST GROUP BY DOSSIER_ID ORDER BY 1 DESC
))) A
WHERE A.DOSSIER_ID = B.DOSSIER_ID
   AND B.STATUS = 'CONTROLE'
   AND A.ACTION_TYPE = 'DECREASE')
ORDER BY 2;

CURSOR C2 (P_RUIS_NAME VARCHAR2) IS
SELECT DISTINCT D.DOSSIER_ID,D.LETTER_NUMBER,D.V_CODE_BUSINESS_PARTNER VCODE,D.BUSINESS_PARTNER,D.DOSSIER_TYPE,TO_CHAR(D.AMOUNT,'999G999G999G999G999G990D00') AMOUNT
  FROM XXCT_DOSSIERS_V D
 WHERE DOSSIER_ID IN (select distinct B.DOSSIER_ID
                        FROM WKSP_XXPM.XXPM_PARTNERS_EXTRA_V A,XXCT_DOSSIERS B,XXCT_USERS C
                       WHERE B.PARTNER_ID = A.PARTNER_ID
                         AND A.CHANNEL_MANAGER_OTHER = C.RUIS_NAME
                         AND C.RUIS_NAME = P_RUIS_NAME
                         AND B.STATUS = 'CONTROLE'
                         AND B.DOSSIER_ID NOT IN (SELECT B.DOSSIER_ID FROM XXCT_DOSSIERS B,
                    (
                    SELECT MANDATE_ID,DOSSIER_ID,CHANGE_TYPE ACTION_TYPE FROM XXCT_MANDATES_HIST WHERE (DOSSIER_ID,MANDATE_ID) IN (
                    SELECT DOSSIER_ID,MANDATE_ID FROM (
                    SELECT DOSSIER_ID,MAX(MANDATE_ID) MANDATE_ID FROM XXCT_MANDATES_HIST GROUP BY DOSSIER_ID ORDER BY 1 DESC
                    ))) A
                    WHERE A.DOSSIER_ID = B.DOSSIER_ID
                       AND B.STATUS = 'CONTROLE'
                       AND A.ACTION_TYPE = 'DECREASE'))
ORDER BY 1 DESC;

CURSOR C3_DECREASE IS
WITH TBL_MANDATES_HIST AS (
SELECT MANDATE_ID,DOSSIER_ID,CHANGE_TYPE ACTION_TYPE FROM XXCT_MANDATES_HIST WHERE (DOSSIER_ID,MANDATE_ID) IN (
SELECT DOSSIER_ID,MANDATE_ID FROM (
SELECT DOSSIER_ID,MAX(MANDATE_ID) MANDATE_ID FROM XXCT_MANDATES_HIST GROUP BY DOSSIER_ID ORDER BY 1 DESC
)))
SELECT D.DOSSIER_ID,D.LETTER_NUMBER,D.V_CODE_BUSINESS_PARTNER VCODE,D.BUSINESS_PARTNER,
D.DOSSIER_TYPE,TO_CHAR(D.AMOUNT,'999G999G999G999G999G990D00') AMOUNT
  FROM TBL_MANDATES_HIST A,XXCT_DOSSIERS B,XXCT_DOSSIERS_V D
 WHERE A.DOSSIER_ID = B.DOSSIER_ID
   AND B.DOSSIER_ID = D.DOSSIER_ID
   AND B.STATUS = 'CONTROLE'
   AND A.ACTION_TYPE = 'DECREASE';

LV_BODY                     VARCHAR2(32000);
LV_BODY_DESC                VARCHAR2(32000);
LV_HEADER                   VARCHAR2(2000);
LV_USER_EMAIL               VARCHAR2(100);
LV_DSSR_CHK                 NUMBER:=0;
LV_ENVIRONMENT              VARCHAR2(20);
LV_DECRS                    NUMBER:=0;
LV_DRCS_USER_EMAIL          VARCHAR2(200);
LV_DRCS_USER_NAME           VARCHAR2(200);
LV_NON_DECRS                NUMBER:=0;
LV_DOSSIER_OVERVIEW_LINK    VARCHAR2(2000);
l_instance_url              VARCHAR2(2000);
LV_DOSSIER_NO_LINK          VARCHAR2(2000);
BEGIN
    SELECT COUNT(*) INTO LV_DECRS FROM XXCT_DOSSIERS WHERE STATUS = 'CONTROLE' AND ACTION_TYPE = 'DECREASE';

    SELECT COUNT(*) INTO LV_NON_DECRS FROM XXCT_DOSSIERS WHERE STATUS = 'CONTROLE' AND ACTION_TYPE != 'DECREASE';
    SELECT COUNT(B.DOSSIER_ID) INTO LV_DECRS FROM XXCT_DOSSIERS B,
    (
    SELECT MANDATE_ID,DOSSIER_ID,CHANGE_TYPE ACTION_TYPE FROM XXCT_MANDATES_HIST WHERE (DOSSIER_ID,MANDATE_ID) IN (
    SELECT DOSSIER_ID,MANDATE_ID FROM (
    SELECT DOSSIER_ID,MAX(MANDATE_ID) MANDATE_ID FROM XXCT_MANDATES_HIST GROUP BY DOSSIER_ID ORDER BY 1 DESC
    ))) A
    WHERE A.DOSSIER_ID = B.DOSSIER_ID
       AND B.STATUS = 'CONTROLE'
       AND A.ACTION_TYPE = 'DECREASE';

        LV_HEADER := '<p>Beste [[USER_NAME]],</p>
                      <p>Ter informatie laten we hierbij weten dat onderstaande dossiers gereed staan [[LV_DOSSIER_OVERVIEW_LINK]]
                      voor controle in de Credittool</a>.</p>
                      <table style="width: 700px; height: 75px;">
                      <tbody>
                      <tr style="height: 13px;">
                      <td style="width: 80px; height: 13px;background-color: #4A9942;text-align: center;"><span ><strong>ID</strong></span></td>
                      <td style="width: 220px; height: 13px;background-color: #4A9942;"><span ><strong>Dossier</strong></span></td>
                      <td style="width: 300px; height: 13px;background-color: #4A9942;"><span ><strong>Partner</strong></span></td>
                      <td style="width: 60px; height: 13px;background-color: #4A9942;text-align: center;"><span ><strong>V-Code</strong></span></td>
                      <td style="width: 90px; height: 13px;background-color: #4A9942;"><span ><strong>Type</strong></span></td>
                      <td style="width: 90px; height: 13px;background-color: #4A9942;text-align: right;"><span ><strong>Amount</strong></span></td>
                      </tr>';
    LV_DOSSIER_OVERVIEW_LINK := '<a href="https://g1cb1b3dd717dd7-[[LV_ENVIRONMENT]].adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/ct/xxct/">';

        FOR I IN C1 LOOP
            LV_BODY := LV_HEADER;
            FOR J IN C2(I.RUIS_NAME) LOOP
                LV_BODY := LV_BODY||'
                <tr style="height: 13px;">
                <td style="width: 80px; height: 13px;text-align: center;">[[ID]]</td>
                <td style="width: 220px; height: 13px;">[[LV_DOSSIER_NO_LINK]][[DOSSIER_NUMBER]]</a></td> 
                <td style="width: 300px; height: 13px;">[[PARTNER_NAME]]</td>
                <td style="width: 60px; height: 13px;text-align: center;">[[VCODE]]</td>
                <td style="width: 90px; height: 13px;">[[DOSSIER_TYPE]]</td>
                <td style="width: 90px; height: 13px; text-align: right;">[[AMOUNT]]</td>
                </tr>';

                LV_BODY := REPLACE(LV_BODY,'[[ID]]',J.DOSSIER_ID);
                LV_BODY := REPLACE(LV_BODY,'[[DOSSIER_NUMBER]]',J.LETTER_NUMBER);
                LV_BODY := REPLACE(LV_BODY,'[[PARTNER_NAME]]',J.BUSINESS_PARTNER);
                LV_BODY := REPLACE(LV_BODY,'[[VCODE]]',J.VCODE);
                LV_BODY := REPLACE(LV_BODY,'[[DOSSIER_TYPE]]',J.DOSSIER_TYPE);
                LV_BODY := REPLACE(LV_BODY,'[[AMOUNT]]',J.AMOUNT);
                LV_BODY := REPLACE(LV_BODY,'[[LV_DOSSIER]]',J.DOSSIER_ID);
                LV_DOSSIER_NO_LINK := '<a href="https://g1cb1b3dd717dd7-[[LV_ENVIRONMENT]].adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/ct/xxct/global-page?P3_FROM_EMAIL_TO_DOSSIER=Y&P3_PREV=DSSR_DTLS&P3_DOSSIER_ID=[[LV_DSSR_ID]]">';
                LV_DOSSIER_NO_LINK := REPLACE(LV_DOSSIER_NO_LINK,'[[LV_DSSR_ID]]',J.DOSSIER_ID);
                LV_BODY := REPLACE(LV_BODY,'[[LV_DOSSIER_NO_LINK]]',LV_DOSSIER_NO_LINK);
                --dbms_output.put_line('LV_BODY 2=='||LV_BODY); <--[[LV_DOSSIER_NO_LINK]]-->
            END LOOP;----END C2 LOOP
            LV_BODY := LV_BODY||'</tbody>
            </table>
            <p><strong>Belangrijk:</strong> om vertraging van betalingen te voorkomen verzoeken wij je deze dossiers zo veel mogelijk <strong>op de dag van ontvangst (van deze mail) af te handelen.</strong></p>
            <p>Met vriendelijke groet,</p>
            <p>Retail Support</p>';

        IF instr( sys_context('USERENV','DB_NAME'),'APXDEV') > 0 THEN
            LV_ENVIRONMENT := 'apxdev';
            LV_USER_EMAIL := 'picasso@kpn.com';
        ELSIF instr( sys_context('USERENV','DB_NAME'),'APXTST') > 0 THEN
            LV_ENVIRONMENT := 'apxtst';
            LV_USER_EMAIL := 'picasso@kpn.com';
        ELSIF instr( sys_context('USERENV','DB_NAME'),'APXACC') > 0 OR instr( sys_context('USERENV', 'DB_NAME') ,'APXPRODCLONE') > 0 THEN
            LV_ENVIRONMENT := 'apxacc';
            LV_USER_EMAIL := 'picasso@kpn.com';
        ELSIF instr( sys_context('USERENV','DB_NAME'),'APXPRD') > 0 THEN
            LV_ENVIRONMENT := 'apxprd';
            LV_USER_EMAIL := I.USER_EMAIL;
        END IF;

        LV_BODY := REPLACE(LV_BODY,'[[USER_NAME]]',I.USER_NAME);
        LV_DOSSIER_OVERVIEW_LINK := REPLACE(LV_DOSSIER_OVERVIEW_LINK,'[[LV_ENVIRONMENT]]',LV_ENVIRONMENT);
        LV_DOSSIER_NO_LINK := REPLACE(LV_DOSSIER_NO_LINK,'[[LV_ENVIRONMENT]]',LV_ENVIRONMENT);
        LV_BODY := REPLACE(LV_BODY,'[[LV_DOSSIER_OVERVIEW_LINK]]',LV_DOSSIER_OVERVIEW_LINK);
        LV_BODY := REPLACE(LV_BODY,'[[LV_DOSSIER_NO_LINK]]',LV_DOSSIER_NO_LINK);
        LV_BODY := REPLACE(LV_BODY,'[[LV_ENVIRONMENT]]',LV_ENVIRONMENT);
        dbms_output.put_line('LV_BODY 3=='||LV_BODY);
        XXCT_GEN_DEBUG_PKG.DEBUG(C_PROCESS_NAME,'LV_BODY=='||LV_BODY);

        --dbms_output.put_line('Email Send to=='||LV_USER_EMAIL);
        XXCT_GEN_DEBUG_PKG.DEBUG(C_PROCESS_NAME,'Email Send to=='||LV_USER_EMAIL);

        SELECT COUNT(*) INTO LV_DSSR_CHK
          FROM XXCT_DOSSIERS_V D
         WHERE DOSSIER_ID IN (select distinct B.DOSSIER_ID
                from WKSP_XXPM.XXPM_PARTNERS_EXTRA_V A,XXCT_DOSSIERS B,XXCT_USERS C
                WHERE B.PARTNER_ID = A.PARTNER_ID
                AND A.CHANNEL_MANAGER_OTHER = C.RUIS_NAME
                AND C.RUIS_NAME = I.RUIS_NAME
                AND B.STATUS = 'CONTROLE');

            IF LV_DSSR_CHK > 0 THEN --NULL;
                wksp_xxapi.xxapi_send_email(
                                p_from        => 'noreply@kpn.com'
                             ,  p_to          => LV_USER_EMAIL
                             ,  p_cc          => NULL
                             ,  p_bcc         => NULL
                             ,  p_subject     => 'Credittool - Dossier Controle gewenst'
                             ,  p_body_clob   => LV_BODY
                             ,  p_html        => NULL
                             ,  p_message     => NULL
                             ,  p_print_att   => NULL
                             ,  p_attachments => NULL
                             );
            END IF;
        END LOOP;----END C1 LOOP
    dbms_output.put_line('C1 LOOP END==');
    --END IF;--END OF LV_NON_DECRS > 0

    dbms_output.put_line('LV_DECRS1=='||LV_DECRS);
    IF LV_DECRS > 0 THEN
        dbms_output.put_line('Start Decrease dossier==');
        LV_BODY_DESC := '<p>Beste [[USER_NAME]],</p>
                           <p>Ter informatie laten we hierbij weten dat onderstaande dossiers gereed staan [[LV_DOSSIER_OVERVIEW_LINK]]
                           voor controle in de Credittool</a>.</p>
                           <table style="width: 700px; height: 75px;">
                           <tbody>
                           <tr style="height: 13px;">
                           <td style="width: 80px; height: 13px;background-color: #4A9942;text-align: center;"><span ><strong>ID</strong></span></td>
                           <td style="width: 220px; height: 13px;background-color: #4A9942;"><span ><strong>Dossier</strong></span></td>
                           <td style="width: 300px; height: 13px;background-color: #4A9942;"><span ><strong>Partner</strong></span></td>
                           <td style="width: 60px; height: 13px;background-color: #4A9942;text-align: center;"><span ><strong>V-Code</strong></span></td>
                           <td style="width: 90px; height: 13px;background-color: #4A9942;"><span ><strong>Type</strong></span></td>
                           <td style="width: 90px; height: 13px;background-color: #4A9942;text-align: right;"><span ><strong>Amount</strong></span></td>
                           </tr>';

        LV_DOSSIER_OVERVIEW_LINK := '<a href="https://g1cb1b3dd717dd7-[[LV_ENVIRONMENT]].adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/ct/xxct/">';

        FOR K IN C3_DECREASE LOOP
            dbms_output.put_line('LV_DECRS3=='||LV_DECRS);
            LV_BODY_DESC := LV_BODY_DESC||'
            <tr style="height: 13px;">
            <td style="width: 80px; height: 13px;text-align: center;">[[ID]]</td>
            <td style="width: 220px; height: 13px;">[[LV_DOSSIER_NO_LINK]][[DOSSIER_NUMBER]]</a></td>
            <td style="width: 300px; height: 13px;">[[PARTNER_NAME]]</td>
            <td style="width: 60px; height: 13px;text-align: center;">[[VCODE]]</td>
            <td style="width: 90px; height: 13px;">[[DOSSIER_TYPE]]</td>
            <td style="width: 90px; height: 13px; text-align: right;">[[AMOUNT]]</td>
            </tr>';

            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[ID]]',K.DOSSIER_ID);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[DOSSIER_NUMBER]]',K.LETTER_NUMBER);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[PARTNER_NAME]]',K.BUSINESS_PARTNER);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[VCODE]]',K.VCODE);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[DOSSIER_TYPE]]',K.DOSSIER_TYPE);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[AMOUNT]]',K.AMOUNT);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[LV_DOSSIER]]',K.DOSSIER_ID);
            LV_DOSSIER_NO_LINK := '<a href="https://g1cb1b3dd717dd7-[[LV_ENVIRONMENT]].adb.eu-frankfurt-1.oraclecloudapps.com/ords/r/ct/xxct/global-page?P3_FROM_EMAIL_TO_DOSSIER=Y&P3_PREV=DSSR_DTLS&P3_DOSSIER_ID=[[LV_DSSR_ID]]">';
            LV_DOSSIER_NO_LINK := REPLACE(LV_DOSSIER_NO_LINK,'[[LV_DSSR_ID]]',K.DOSSIER_ID);
            LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[LV_DOSSIER_NO_LINK]]',LV_DOSSIER_NO_LINK);
            dbms_output.put_line('LV_BODY_DESC 4=='||LV_BODY_DESC);
        END LOOP;---END C3_DECREASE LOOP
        LV_BODY_DESC := LV_BODY_DESC||'</tbody>
        </table>
        <p><strong>Belangrijk:</strong> om vertraging van betalingen te voorkomen verzoeken wij je deze dossiers zo veel mogelijk <strong>op de dag van ontvangst (van deze mail) af te handelen.</strong></p>
        <p>Met vriendelijke groet,</p>
        <p>Retail Support</p>';

    BEGIN
        SELECT B.USER_NAME USER_EMAIL,MEANING USER_NAME
          INTO LV_DRCS_USER_EMAIL,LV_DRCS_USER_NAME
          FROM xxct_lookup_values A,XXCT_USERS B 
         WHERE A.CODE = B.RUIS_NAME
           AND LOOKUP_TYPE = 'VRIJVAL_CONTROLEUR'
           AND TO_DATE(SYSDATE,'DD-MM-YYYY') BETWEEN NVL(TO_DATE(START_DATE_ACTIVE,'DD-MM-YYYY'),TO_DATE(SYSDATE,'DD-MM-YYYY'))
                AND NVL(TO_DATE(END_DATE_ACTIVE,'DD-MM-YYYY'),TO_DATE(SYSDATE,'DD-MM-YYYY'))
           AND ENABLED_FLAG = 'Y';
    EXCEPTION
        WHEN OTHERS THEN
            LV_DRCS_USER_EMAIL := NULL;
            LV_DRCS_USER_NAME := NULL;
    END;    

       IF instr( sys_context('USERENV','DB_NAME'),'APXDEV') > 0 THEN
            LV_ENVIRONMENT := 'apxdev';
            LV_USER_EMAIL := 'picasso@kpn.com';
       ELSIF instr( sys_context('USERENV','DB_NAME'),'APXTST') > 0 THEN
            LV_ENVIRONMENT := 'apxtst';
            LV_USER_EMAIL := 'picasso@kpn.com';
       ELSIF instr( sys_context('USERENV','DB_NAME'),'APXACC') > 0 OR instr( sys_context('USERENV', 'DB_NAME') ,'APXPRODCLONE') > 0 THEN
            LV_ENVIRONMENT := 'apxacc';
            LV_USER_EMAIL := 'picasso@kpn.com';
       ELSIF instr( sys_context('USERENV','DB_NAME'),'APXPRD') > 0 THEN
            LV_ENVIRONMENT := 'apxprd';
            LV_USER_EMAIL := LV_DRCS_USER_EMAIL;
       END IF;

       LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[USER_NAME]]',LV_DRCS_USER_NAME);
       LV_DOSSIER_OVERVIEW_LINK := REPLACE(LV_DOSSIER_OVERVIEW_LINK,'[[LV_ENVIRONMENT]]',LV_ENVIRONMENT);
       LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[LV_DOSSIER_OVERVIEW_LINK]]',LV_DOSSIER_OVERVIEW_LINK);
       LV_BODY_DESC := REPLACE(LV_BODY_DESC,'[[LV_ENVIRONMENT]]',LV_ENVIRONMENT);
       dbms_output.put_line('LV_BODY_DESC 3 DECREASE=='||LV_BODY_DESC);
       XXCT_GEN_DEBUG_PKG.DEBUG(C_PROCESS_NAME,'LV_BODY_DESC DECREASE=='||LV_BODY_DESC);

       --dbms_output.put_line('Email Send to=='||LV_USER_EMAIL);
       XXCT_GEN_DEBUG_PKG.DEBUG(C_PROCESS_NAME,'Email Send to Decrease=='||LV_USER_EMAIL);

       wksp_xxapi.xxapi_send_email(
                            p_from        => 'noreply@kpn.com'
                         ,  p_to          => LV_USER_EMAIL
                         ,  p_cc          => NULL
                         ,  p_bcc         => NULL
                         ,  p_subject     => 'Credittool - Dossier Controle gewenst'
                         ,  p_body_clob   => LV_BODY_DESC
                         ,  p_html        => NULL
                         ,  p_message     => NULL
                         ,  p_print_att   => NULL
                         ,  p_attachments => NULL
                         );
    END IF; --END OF LV_DECRS > 0

END XXCT_CONTROLE_STATUS_MAIL_SEND;

/

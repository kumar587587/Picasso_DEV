--------------------------------------------------------
--  DDL for Function FAIL_ON_PRODUCTION 
-- Git Testing 
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_XXAPI"."FAIL_ON_PRODUCTION" RETURN BOOLEAN
AS
      /**************************************************************************************************************************************
      *
      *
      * PROGRAM NAME
      *   GENERIC - FAIL_ON_PRODUCTION.fnc
      *
      * DESCRIPTION
      *   Function to always fail on the prod instance when called
      *
      * CHANGE HISTORY
      * Who                 When         What
      * -------------------------------------------------------------
      * Wiljo Bakker        26-09-2024  Initial Version
      ****************************************************************************************************************************************/

      -- $Id: FAIL_ON_PRODUCTION.fnc,v 1.1 2024/10/17 08:27:47 bakke619 Exp $
      -- $Log: FAIL_ON_PRODUCTION.fnc,v $
      -- Revision 1.1  2024/10/17 08:27:47  bakke619
      -- Initial revision
      --

   lc_routine_name               CONSTANT VARCHAR2(50)      := 'fail_on_production';
   lc_production_instance        CONSTANT VARCHAR2(200)     := 'APXPRD';   
   l_errormsg                             VARCHAR2(2000)    := NULL; 
   --
   l_return                               BOOLEAN           := TRUE;
   E_PROD_ERROR                           EXCEPTION;
BEGIN
   CASE when instr( sys_context('USERENV', 'DB_NAME') ,lc_production_instance) > 0 THEN l_return := FALSE;  RAISE E_PROD_ERROR;
        ELSE NULL; 
   END CASE; 
   --
   RETURN l_return;
EXCEPTION
   WHEN E_PROD_ERROR THEN
      l_errormsg := 'ERROR: Script cannot be executed on Production Instance: '||lc_production_instance;
      xxapi_gen_debug_pkg.debug( lc_routine_name ,l_errormsg);
      RAISE_APPLICATION_ERROR(-20000,l_errormsg);
      RETURN FALSE;
END fail_on_production;

-- Procedures

/

  GRANT EXECUTE ON "WKSP_XXAPI"."FAIL_ON_PRODUCTION" TO "WKSP_XXTV";
  GRANT EXECUTE ON "WKSP_XXAPI"."FAIL_ON_PRODUCTION" TO "WKSP_XXPM";
  GRANT EXECUTE ON "WKSP_XXAPI"."FAIL_ON_PRODUCTION" TO "WKSP_XXCPC";

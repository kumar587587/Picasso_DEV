--------------------------------------------------------
--  DDL for Package XXPM_PAGE_700_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_XXPM"."XXPM_PAGE_700_PKG" IS
   /****************************************************************
    *
    * PROGRAM NAME
    *  PM700 - XXPM_PAGE_700_PKG
    *
    * DESCRIPTION
    * Program to support PL/SQL functionality for page 700
    *
    * CHANGE HISTORY
    * Who                 When         What
    * -------------------------------------------------------------
    * Geert Engbers       26-10-2020  Initial Version.
    **************************************************************/
   --
   -- GLOBAL CONSTANTS
   gc_package_name             CONSTANT VARCHAR2 ( 50 )     := 'XXPM_PAGE_700_PKG';
   gc_package_spec_version     CONSTANT VARCHAR2 ( 200 )    := '$Id: XXPM_PAGE_700_PKG.pks,v 1.2 2022/10/24 14:35:36 bakke619 Exp $';
   gc_bah_code                 CONSTANT VARCHAR2(50)        := 'PM700';
   gc_directory_encrypt        CONSTANT VARCHAR2(30)        := 'XXICE_TV_DIGISPEC_ENCRYPT';
   gc_directory_working        CONSTANT VARCHAR2(30)        := 'XXICE_TV_DIGISPEC_WORKING';
   gc_directory_archive        CONSTANT VARCHAR2(30)        := 'XXICE_TV_DIGISPEC_ARCHIVE';
   gc_directory_error          CONSTANT VARCHAR2(30)        := 'XXICE_TV_DIGISPEC_ERROR';
   gc_directory_export_cm      CONSTANT VARCHAR2(30)        := 'XXICE_TV_DIGISPEC_EXPORT_CM';

   ---------------------------------------------------------------------------------------------
   -- Procedure to be used for debugging purposes.
   ---------------------------------------------------------------------------------------------
   PROCEDURE debug ( p_routine           IN VARCHAR2
,                    p_message           IN VARCHAR2 );

   ---------------------------------------------------------------------------------------------
   FUNCTION get_package_body_version      RETURN VARCHAR2;

   ---------------------------------------------------------------------------------------------
   FUNCTION get_package_spec_version      RETURN VARCHAR2;

   PROCEDURE encrypt_files;

END XXPM_PAGE_700_PKG;





/

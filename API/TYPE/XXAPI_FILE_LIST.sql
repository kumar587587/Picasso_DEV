--------------------------------------------------------
--  DDL for Type XXAPI_FILE_LIST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "WKSP_XXAPI"."XXAPI_FILE_LIST" IS OBJECT  ( FILE_NAME       VARCHAR2(2000)
                                                                 , FILE_TYPE       VARCHAR2(1)
                                                                 , FILE_MIME_TYPE  VARCHAR2(200)
                                                                 , FILE_DIRECTORY  VARCHAR2(300)
                                                                 , FILE_CONTENTS_A CLOB
                                                                 , FILE_CONTENTS_B BLOB
   )

/

--------------------------------------------------------
--  DDL for View XXSPM_CONTENTPARTNERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXCPC"."XXSPM_CONTENTPARTNERS_V" ("PARTNERNUMBER", "PARTNERNAME", "CPCODE", "BILLINGDEBTORNR", "BILLINGLOCATION", "PARTNERLANGUAGE", "CREATESPECIFICATIONINDICATOR", "HOLDPAYMENTSINDICATOR", "STARTDATE", "ENDDATE", "PARTNERPAYMENTTERMS", "INDENTIFIERTYPE", "BILLINGCITY", "BILLINGCOUNTRY", "BILLINGCOUNTRYCODE", "BILLINGDELIVERTO", "BILLINGIBAN", "BILLINGPOSTALCODE", "BILLINGSTATE", "BILLINGSTREET", "BILLINGVATNUMBER", "BILLINGEMAILADDRESS", "LAST_UPDATE_OR_CREATION_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT partnernumber                     partnernumber  
,      partnername                         partnername
,      cpcode                              cpcode
,      billingdebtornr                     billingdebtornr 
,      billinglocation                     billinglocation
,      partnerlanguage                     partnerlanguage
,      createspecificationindicator        createspecificationindicator
,      holdpaymentsindicator               holdpaymentsindicator  
,      startdate                           startdate
,      enddate                             enddate
,      partnerpaymentterms                 partnerpaymentterms   
,      'CPC'                               indentifiertype
,      billingcity                         billingcity 
,      l.description                       billingcountry
,      billingcountrycode                  billingcountrycode 
,      partnerbillingname                  billingdeliverto
,      billingiban                         billingiban 
,      billingpostalcode                   billingpostalcode
,      NULL                                billingstate
,      billingstreet                       billingstreet  
,      billingvatnumber                    billingvatnumber
,      billingemailaddress                 billingemailaddress
,      greatest(cp.updated, cp.created)    last_update_or_creation_date
--,      parent                              parent /* when adding this one, you also need to add an extra field to the table in Varicent*/
FROM xxcpc_contentpartners cp
,    xxcpc_lookups l
WHERE l.type(+) ='ISO_COUNTRY_CODE'
AND   l.code(+) = cp.billingcountrycode
;

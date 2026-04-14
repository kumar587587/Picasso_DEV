--------------------------------------------------------
--  DDL for View XXHSH_CHAINS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_XXPM"."XXHSH_CHAINS_V" ("CHAIN_ID", "CONCATENATED_VALUES", "CONCATENATED_PK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
      chain_id chain_id
      , '{'
          || concat('"chain_id":'                  || chain_id  || ','
          , concat('"chain_name":'                 || decode(chain_name                , NULL, 'null', '"' || chain_name                 || '"') || ','
          , concat('"indicator_in_ex":'            || decode(indicator_in_ex           , NULL, 'null', '"' || indicator_in_ex            || '"') || ','
          , concat('"center_code":'                || decode(center_code               , NULL, 'null', '"' || center_code                || '"') || ','
          , concat('"sales_channel_distribution":' || decode(sales_channel_distribution, NULL, 'null', '"' || sales_channel_distribution || '"') || ','
          , concat('"sales_channel":'              || decode(sales_channel             , NULL, 'null', '"' || sales_channel              || '"') || ','
          , concat('"sub_sales_channel":'          || decode(sub_sales_channel         , NULL, 'null', '"' || sub_sales_channel          || '"') || ','
          , concat('"channel_mix":'                || decode(channel_mix               , NULL, 'null', '"' || channel_mix                || '"') || ','
          , concat('"creation_date":'              || decode(creation_date             , NULL, 'null', '"' || creation_date              || '"') || ','
          , concat('"created_by":'                 || decode(created_by                , NULL, 'null', '"' || created_by                 || '"') || ','
          , concat('"last_update_date":'           || decode(last_update_date          , NULL, 'null', '"' ||last_update_date            || '"') || ',', '"last_updated_by":'|| decode(last_updated_by, NULL, 'null', '"'||last_updated_by||'"')
          )))))))))))
          || '}'   concatenated_values
      , '[' || '"' || chain_id || '"]'  concatenated_pk
    FROM
        xxpm4tv_chains_v pnr
    WHERE  1 = 1
--and chain_id in (select distinct chain_id from xxpm4tv_partners_v ) alle chains need to be transferred. At creation time it is not know if this chain will be used for a TV partner.
    ORDER BY chain_id
;

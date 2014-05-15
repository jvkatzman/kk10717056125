-- (c) 2006 DS Data Systems UK Ltd, All rights reserved.
-- 
-- DS Data Systems and KonaKart and their respective logos, are
-- trademarks of DS Data Systems UK Ltd. All rights reserved.
-- 
-- The information in this document below this text is free software; you can redistribute
-- it and/or modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
-- 
-- This software is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
-- 
-- -----------------------------------------------------------
-- KonaKart upgrade database script for DB2
-- From version 6.2.0.0 to version 6.3.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.2.0.0, the upgrade
-- scripts must be run sequentially.
-- 

set echo on
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (NEXTVAL FOR kk_config_seq, 'HISTORY', '6.3.0.0 U', current timestamp);
UPDATE kk_config SET kk_config_value='6.3.0.0 DB2', date_added=current timestamp WHERE kk_config_key='VERSION';

-- Add affiliate id field to order
ALTER TABLE orders ADD affiliate_id varchar(128);

-- For specifying whether or not to return configuration parameters in API calls
ALTER TABLE configuration ADD return_by_api INTEGER NOT NULL DEFAULT 0;

-- Set some defaults by configuration_group
UPDATE configuration set return_by_api = 1 where configuration_group_id in (1, 2, 3, 4, 5, 11, 19);
UPDATE configuration set return_by_api = 1 where configuration_key in ('ADMIN_CURRENCY_DECIMAL_PLACES', 'CLIENT_CONFIG_CACHE_CHECK_FLAG', 'DEFAULT_CURRENCY', 'DEFAULT_LANGUAGE');
UPDATE configuration set return_by_api = 1 where configuration_key in ('ALLOW_BASKET_PRICE', 'DEFAULT_REVIEW_STATE', 'ENABLE_ANALYTICS', 'ENABLE_SSL', 'SSL_BASE_URL');
UPDATE configuration set return_by_api = 1 where configuration_key in ('ENABLE_PDF_INVOICE_DOWNLOAD', 'ENABLE_REWARD_POINTS', 'SSL_PORT_NUMBER', 'STANDARD_PORT_NUMBER');
UPDATE configuration set return_by_api = 1 where configuration_key in ('SEND_EMAILS', 'SEND_ORDER_CONF_EMAIL', 'USE_DB_FOR_MESSAGES');
UPDATE configuration set return_by_api = 1 where configuration_key in ('STOCK_CHECK', 'STOCK_ALLOW_CHECKOUT', 'ALLOW_MULTIPLE_BASKET_ENTRIES');
UPDATE configuration set return_by_api = 1 where configuration_key in ('USE_SOLR_SEARCH');

-- Correct a typo
UPDATE configuration set configuration_description = 'Whether or not the SMTP server needs user authentication' where configuration_description='Whether or no the SMTP server needs user authentication';

-- Extend the size of the city columns
ALTER TABLE address_book ALTER COLUMN entry_city SET DATA TYPE VARCHAR(64) ;
ALTER TABLE orders ALTER COLUMN customers_city SET DATA TYPE VARCHAR(64) ;
ALTER TABLE orders ALTER COLUMN delivery_city SET DATA TYPE VARCHAR(64) ;
ALTER TABLE orders ALTER COLUMN billing_city SET DATA TYPE VARCHAR(64) ;
ALTER TABLE kk_wishlist ALTER COLUMN customers_city SET DATA TYPE VARCHAR(64);

-- Regex for SOLR suggested search
DELETE FROM configuration WHERE configuration_key = 'SOLR_TERMS_PRE_REGEX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, return_by_api, store_id) SELECT nextval for configuration_seq, 'Suggested Search prepend regex','SOLR_TERMS_PRE_REGEX','.*','Regex prepended to search string used for searching within SOLR term',24, 3, current timestamp, 0, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'SOLR_TERMS_POST_REGEX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, return_by_api, store_id) SELECT nextval for configuration_seq, 'Suggested Search append regex','SOLR_TERMS_POST_REGEX','.*','Regex appended to search string used for searching within SOLR term',24, 4, current timestamp, 0, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'SOLR_DELETE_ON_COMMIT';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT nextval for configuration_seq, 'Delete from index on commit','SOLR_DELETE_ON_COMMIT','true','On commit, delete from index products marked for deletion',24, 5, 'choice(''true'', ''false'')', current timestamp, 0, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

exit;

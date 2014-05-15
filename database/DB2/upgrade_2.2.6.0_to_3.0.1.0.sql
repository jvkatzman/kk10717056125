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
-- From version 2.2.6.0 to version 3.0.1.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.6.0, the upgrade
-- scripts must be run sequentially.
-- 

set echo on
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'updateCachedConfigurations','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getKonakartPropertyValue','', current timestamp);

-- Run Initial Search on Customer Panel
delete from configuration where configuration_key = 'CUST_PANEL_RUN_INITIAL_SEARCH';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Run Initial Customer Search', 'CUST_PANEL_RUN_INITIAL_SEARCH', 'true', 'Set to true to always run the initial Customer Search', 21, 12, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Clear button clears results on Customer Panel
delete from configuration where configuration_key = 'CUST_PANEL_CLEAR_REMOVES_RESULTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Clear button on Customer Panel removes results', 'CUST_PANEL_CLEAR_REMOVES_RESULTS', 'false', 'Set to true to clear both the search criteria AND the results when the clear button is clicked', 21, 13, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

--Oracle -- For Oracle Only - Increase size of Auditing column
--Oracle ALTER TABLE kk_audit ADD tempcol CLOB;
--Oracle UPDATE kk_audit SET tempcol = object_to_string;
--Oracle ALTER TABLE kk_audit DROP COLUMN object_to_string;
--Oracle ALTER TABLE kk_audit RENAME COLUMN tempcol to object_to_string;

-- For DB2 Only - Increase size of Auditing Column
ALTER TABLE kk_audit ALTER COLUMN object_to_string SET DATA TYPE VARCHAR(7000);

-- Add the ENABLE_ANALYTICS config variable
delete from configuration where configuration_key = 'ENABLE_ANALYTICS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Enable Analytics', 'ENABLE_ANALYTICS', 'false', 'Enable analytics to have the analytics.code (in your Messages.properties file) inserted into the JSPs', 20, 3, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Google Data Feed
DROP TABLE kk_product_feed;
CREATE TABLE kk_product_feed (
  product_id INTEGER NOT NULL,
  language_id INTEGER NOT NULL,
  feed_type INTEGER NOT NULL,
  feed_key VARCHAR(255) NOT NULL,
  last_updated TIMESTAMP NOT NULL,
  PRIMARY KEY(product_id, language_id, feed_type)
);

-- Google Data Feed - Google Username config variable
delete from configuration where configuration_key = 'GOOGLE_DATA_ENABLED';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Google Data Enabled', 'GOOGLE_DATA_ENABLED', '', 'Set to true to enable Google Data updates when products are amended in KonaKart', 23, 1, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);
delete from configuration where configuration_key = 'GOOGLE_API_KEY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Google API Key', 'GOOGLE_API_KEY', '', 'Google API Key (obtain from Google) for populating Google Data with Product Information', 23, 2, current timestamp);
delete from configuration where configuration_key = 'GOOGLE_DATA_USERNAME';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Google Data Username', 'GOOGLE_DATA_USERNAME', '', 'Username (obtain from Google) for populating Google Data with Product Information', 23, 3, current timestamp);
delete from configuration where configuration_key = 'GOOGLE_DATA_PASSWORD';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Google Data Password', 'GOOGLE_DATA_PASSWORD', '', 'Password (obtain from Google) for populating Google Data with Product Information', 23, 4, 'password', current timestamp);
delete from configuration where configuration_key = 'GOOGLE_DATA_LOCATION';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Store Location', 'GOOGLE_DATA_LOCATION', 'Lake Buena Vista, FL 32830, USA', 'Store location (address) to be published to Google Data', 23, 5, current timestamp);

-- Panel for configuring Data Feeds
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_dataFeeds','Configure Data Feeds', current timestamp);

-- Panel for Publishing Products
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_publishProducts','Publish Products', current timestamp);

-- publishProducts API call
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'publishProducts','', current timestamp);

-- Solr 
delete from configuration where configuration_key = 'USE_SOLR_SEARCH';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Use Solr Search Server','USE_SOLR_SEARCH','false','Use Solr search server to search for products',24, 1, 'tep_cfg_select_option(array(''true'', ''false'') ', current timestamp);
delete from configuration where configuration_key = 'SOLR_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Base URL of Solr Search Server','SOLR_URL','http://localhost:8780/solr','Base URL of Solr Search Server',24, 2, current timestamp);

-- New Solr API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'addAllProductsToSearchEngine','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'addProductToSearchEngine','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'removeAllProductsFromSearchEngine','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'removeProductFromSearchEngine','', current timestamp);

-- Configuration variable for enabling/disabling storage of credit card details
delete from configuration where configuration_key = 'STORE_CC_DETAILS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Store Credit Card Details', 'STORE_CC_DETAILS', 'false', 'Store credit card details', 9, 4, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Save encrypted Credit Card details
ALTER TABLE orders add cc_cvv varchar(10);
ALTER TABLE orders add e1 varchar(100);
ALTER TABLE orders add e2 varchar(100);
ALTER TABLE orders add e3 varchar(100);
ALTER TABLE orders add e4 varchar(100);
ALTER TABLE orders add e5 varchar(100);
ALTER TABLE orders add e6 varchar(100);

-- Add the custom1 privilege to enable/disable the reading and editing of credit card details on the Edit Order Panel
UPDATE kk_role_to_panel set custom1=0, custom1_desc='Set to allow read and edit of credit card details' where panel_id=17;

-- Panel for Configuring Solr
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_solr_search','Solr Search Engine', current timestamp);

-- Panel for Controling products in Solr
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_solr_control','Solr Search Engine Control', current timestamp);

-- KonaKart Application Base URL
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Store Base URL', 'KK_BASE_URL', 'http://localhost:8780/konakart/', 'KonaKart Base URL', 1, 25, current timestamp);









exit;

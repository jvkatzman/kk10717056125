# (c) 2006 DS Data Systems UK Ltd, All rights reserved.
# 
# DS Data Systems and KonaKart and their respective logos, are
# trademarks of DS Data Systems UK Ltd. All rights reserved.
# 
# The information in this document below this text is free software; you can redistribute
# it and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# -----------------------------------------------------------
# KonaKart upgrade database script for MS Sql Server
# From version 2.2.6.0 to version 3.0.1.0
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.6.0, the upgrade
# scripts must be run sequentially.
# 

INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateCachedConfigurations','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getKonakartPropertyValue','', getdate());

-- Run Initial Search on Customer Panel
delete from configuration where configuration_key = 'CUST_PANEL_RUN_INITIAL_SEARCH';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Run Initial Customer Search', 'CUST_PANEL_RUN_INITIAL_SEARCH', 'true', 'Set to true to always run the initial Customer Search', '21', '12', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Clear button clears results on Customer Panel
delete from configuration where configuration_key = 'CUST_PANEL_CLEAR_REMOVES_RESULTS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Clear button on Customer Panel removes results', 'CUST_PANEL_CLEAR_REMOVES_RESULTS', 'false', 'Set to true to clear both the search criteria AND the results when the clear button is clicked', '21', '13', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

--Oracle -- For Oracle Only - Increase size of Auditing column
--Oracle ALTER TABLE kk_audit ADD tempcol CLOB;
--Oracle UPDATE kk_audit SET tempcol = object_to_string;
--Oracle ALTER TABLE kk_audit DROP COLUMN object_to_string;
--Oracle ALTER TABLE kk_audit RENAME COLUMN tempcol to object_to_string;

--DB2 -- For DB2 Only - Increase size of Auditing Column
--DB2 ALTER TABLE kk_audit ALTER COLUMN object_to_string SET DATA TYPE VARCHAR(7000);

-- Add the ENABLE_ANALYTICS config variable
delete from configuration where configuration_key = 'ENABLE_ANALYTICS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Analytics', 'ENABLE_ANALYTICS', 'false', 'Enable analytics to have the analytics.code (in your Messages.properties file) inserted into the JSPs', '20', '3', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Google Data Feed
DROP TABLE kk_product_feed;
CREATE TABLE kk_product_feed (
  product_id int NOT NULL,
  language_id int NOT NULL,
  feed_type int NOT NULL,
  feed_key varchar(255) NOT NULL,
  last_updated datetime NOT NULL,
  PRIMARY KEY(product_id, language_id, feed_type)
);

-- Google Data Feed - Google Username config variable
delete from configuration where configuration_key = 'GOOGLE_DATA_ENABLED';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Google Data Enabled', 'GOOGLE_DATA_ENABLED', '', 'Set to true to enable Google Data updates when products are amended in KonaKart', '23', '1', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());
delete from configuration where configuration_key = 'GOOGLE_API_KEY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Google API Key', 'GOOGLE_API_KEY', '', 'Google API Key (obtain from Google) for populating Google Data with Product Information', '23', '2', getdate());
delete from configuration where configuration_key = 'GOOGLE_DATA_USERNAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Google Data Username', 'GOOGLE_DATA_USERNAME', '', 'Username (obtain from Google) for populating Google Data with Product Information', '23', '3', getdate());
delete from configuration where configuration_key = 'GOOGLE_DATA_PASSWORD';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Google Data Password', 'GOOGLE_DATA_PASSWORD', '', 'Password (obtain from Google) for populating Google Data with Product Information', '23', '4', 'password', getdate());
delete from configuration where configuration_key = 'GOOGLE_DATA_LOCATION';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Store Location', 'GOOGLE_DATA_LOCATION', 'Lake Buena Vista, FL 32830, USA', 'Store location (address) to be published to Google Data', '23', '5', getdate());

-- Panel for configuring Data Feeds
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_dataFeeds','Configure Data Feeds', getdate());

-- Panel for Publishing Products
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_publishProducts','Publish Products', getdate());

-- publishProducts API call
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'publishProducts','', getdate());

-- Solr 
delete from configuration where configuration_key = 'USE_SOLR_SEARCH';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Use Solr Search Server','USE_SOLR_SEARCH','false','Use Solr search server to search for products','24', '1', 'tep_cfg_select_option(array(''true'', ''false'') ', getdate());
delete from configuration where configuration_key = 'SOLR_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Base URL of Solr Search Server','SOLR_URL','http://localhost:8780/solr','Base URL of Solr Search Server','24', '2', getdate());

-- New Solr API calls
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addAllProductsToSearchEngine','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addProductToSearchEngine','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeAllProductsFromSearchEngine','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeProductFromSearchEngine','', getdate());

-- Configuration variable for enabling/disabling storage of credit card details
delete from configuration where configuration_key = 'STORE_CC_DETAILS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Store Credit Card Details', 'STORE_CC_DETAILS', 'false', 'Store credit card details', 9, 4, 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

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
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_solr_search','Solr Search Engine', getdate());

-- Panel for Controling products in Solr
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_solr_control','Solr Search Engine Control', getdate());

-- KonaKart Application Base URL
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Store Base URL', 'KK_BASE_URL', 'http://localhost:8780/konakart/', 'KonaKart Base URL', '1', '25', getdate());









exit;

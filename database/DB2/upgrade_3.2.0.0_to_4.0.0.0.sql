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
-- From version 3.2.0.0 to version 4.0.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 3.2.0.0, the upgrade
-- scripts must be run sequentially.
-- 

ALTER table zones add custom1 varchar(128);
ALTER table zones add custom2 varchar(128);
ALTER table zones add custom3 varchar(128);

-- Configuration for product select panels in admin app
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_TEMPLATE';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Product Select Template' , 'ADMIN_APP_PROD_SEL_TEMPLATE', '$name', 'Sets the template for which attributes to view when selecting a product ($name, $sku, $id, $model, $manufacturer, $custom1 ... $custom5', 21, 25, current timestamp);
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_NUM_PRODS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Product Select Default Num Prods', 'ADMIN_APP_PROD_SEL_NUM_PRODS', '0', 'Sets the default number of products displayed in the product select dialogs when opened', 21, 26, current timestamp);
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Product Select Max Num Prods', 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS', '100', 'Sets the maximum number of products displayed in the product select dialogs after a search', 21, 27, current timestamp);

-- Add date available attribute to products quantity
ALTER TABLE products_quantity add products_date_available TIMESTAMP;

-- API calls for setting product quantity and product availability
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'setProductQuantity','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'setProductAvailability','', current timestamp);

-- Extra attributes for product object
ALTER TABLE products add max_num_downloads int default -1 not null;
ALTER TABLE products add max_download_days int default -1 not null;
ALTER TABLE products add stock_reorder_level int default -1 not null;

-- Cookie table to save cookie information
DROP TABLE kk_cookie;
CREATE TABLE kk_cookie (
  customer_uuid VARCHAR(128) NOT NULL,
  attribute_id VARCHAR(64) NOT NULL,
  attribute_value VARCHAR(256),
  date_added TIMESTAMP NOT NULL,
  last_read TIMESTAMP,
  last_modified TIMESTAMP,
  PRIMARY KEY(customer_uuid, attribute_id)
);

-- Add tracking number to orders table
ALTER TABLE orders add tracking_number varchar(128);

-- Update description of role to panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields, order number, tracking number' where panel_id=17;

-- Extra attribute for product object
ALTER TABLE products add can_order_when_not_in_stock int default -1 not null;

-- Add invisible attribute to categories table
ALTER TABLE categories add categories_invisible INTEGER DEFAULT 0 NOT NULL;

-- API calls for getting product quantity and product availability
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductQuantity','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductAvailability','', current timestamp);

-- Add a new panel for inserting product quantities
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_productQuantity','Product Quantity', current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 87, 1,1,1,current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 87, 1,1,1,current timestamp);

-- API calls for XML import/export
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertTagGroupToTags','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getTagGroupToTags','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'importCustomer','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductNotificationsForCustomer','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductOptionsPerName','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getAllProductOptionValues','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductOptionValuesPerName','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertProductsOptionsValuesToProductsOptions','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getProductOptionValueToProductOptions','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getAllConfigurations','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getAllConfigurationGroups','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'updateConfiguration','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'updateConfigurationGroup','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getConfigurationGroupsByTitle','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getConfigurationByKey','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertConfiguration','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertConfigurationGroup','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertIpnHistory','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'importAudit','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getCategoriesPerTagGroup','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'addCategoriesToTagGroups','', current timestamp);

-- Add a new panel for inserting product available dates
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_productAvailableDate','Product Available Date', current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 88, 1,1,1,current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 88, 1,1,1,current timestamp);

-- Extra attributes for order product and basket objects
ALTER TABLE orders_products add products_state int DEFAULT 0;
ALTER TABLE orders_products add products_sku varchar(255);
ALTER TABLE customers_basket add products_sku varchar(255);

-- Add customer_id to sessions table - previously the customer_id was stored in the value column.  We also make value nullable.
-- For various reasons, mainly DB2 limitations, we drop the sessions table and recreate it
DROP TABLE sessions;
CREATE TABLE sessions (
  sesskey VARCHAR(32) NOT NULL,
  expiry INTEGER NOT NULL,
  customer_id INTEGER ,
  value VARCHAR(256) ,
  store_id VARCHAR(64) ,
  custom1 VARCHAR(128) ,
  custom2 VARCHAR(128) ,
  custom3 VARCHAR(128) ,
  custom4 VARCHAR(128) ,
  custom5 VARCHAR(128) ,
  PRIMARY KEY(sesskey)
);
CREATE INDEX i_st_1ae788109da01 ON sessions (store_id);

-- Determine whether to show dialog to send mail after a group change
delete from configuration where configuration_key = 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Allow Cust Group Change eMail', 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL', 'true', 'When this is set, a popup window appears when the group of a customer is changed to allow you to send an eMail', 21, 28, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Admin App session related API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'addCustomDataToSession','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getCustomDataFromSession','', current timestamp);

-- New Batch jobs
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'com.konakartadmin.bl.AdminOrderBatchMgr.productAvailabilityNotificationBatch','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'com.konakartadmin.bl.AdminOrderBatchMgr.unpaidOrderNotificationBatch','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'com.konakartadmin.bl.AdminCustomerBatchMgr.removeExpiredCustomersBatch','', current timestamp);













exit;

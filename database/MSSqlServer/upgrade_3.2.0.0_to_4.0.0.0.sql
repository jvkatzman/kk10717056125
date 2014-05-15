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
-- KonaKart upgrade database script for MS Sql Server
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
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Template' , 'ADMIN_APP_PROD_SEL_TEMPLATE', '$name', 'Sets the template for which attributes to view when selecting a product ($name, $sku, $id, $model, $manufacturer, $custom1 ... $custom5', '21', '25', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_NUM_PRODS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Default Num Prods', 'ADMIN_APP_PROD_SEL_NUM_PRODS', '0', 'Sets the default number of products displayed in the product select dialogs when opened', '21', '26', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Max Num Prods', 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS', '100', 'Sets the maximum number of products displayed in the product select dialogs after a search', '21', '27', getdate());

-- Add date available attribute to products quantity
ALTER TABLE products_quantity add products_date_available datetime;

-- API calls for setting product quantity and product availability
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'setProductQuantity','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'setProductAvailability','', getdate());

-- Extra attributes for product object
ALTER TABLE products add max_num_downloads int default -1 not null;
ALTER TABLE products add max_download_days int default -1 not null;
ALTER TABLE products add stock_reorder_level int default -1 not null;

-- Cookie table to save cookie information
DROP TABLE kk_cookie;
CREATE TABLE kk_cookie (
  customer_uuid varchar(128) NOT NULL,
  attribute_id varchar(64) NOT NULL,
  attribute_value varchar(256),
  date_added datetime NOT NULL,
  last_read datetime,
  last_modified datetime,
  PRIMARY KEY(customer_uuid, attribute_id)
);

-- Add tracking number to orders table
ALTER TABLE orders add tracking_number varchar(128);

-- Update description of role to panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields, order number, tracking number' where panel_id=17;

-- Extra attribute for product object
ALTER TABLE products add can_order_when_not_in_stock int default -1 not null;

-- Add invisible attribute to categories table
ALTER TABLE categories add categories_invisible smallint DEFAULT 0 NOT NULL;

-- API calls for getting product quantity and product availability
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductQuantity','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductAvailability','', getdate());

-- Add a new panel for inserting product quantities
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_productQuantity','Product Quantity', getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 87, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 87, 1,1,1,getdate());

-- API calls for XML import/export
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertTagGroupToTags','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getTagGroupToTags','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'importCustomer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductNotificationsForCustomer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductOptionsPerName','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllProductOptionValues','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductOptionValuesPerName','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductsOptionsValuesToProductsOptions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductOptionValueToProductOptions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllConfigurations','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllConfigurationGroups','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateConfiguration','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateConfigurationGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getConfigurationGroupsByTitle','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getConfigurationByKey','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertConfiguration','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertConfigurationGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertIpnHistory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'importAudit','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCategoriesPerTagGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCategoriesToTagGroups','', getdate());

-- Add a new panel for inserting product available dates
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_productAvailableDate','Product Available Date', getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 88, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 88, 1,1,1,getdate());

-- Extra attributes for order product and basket objects
ALTER TABLE orders_products add products_state int default '0';
ALTER TABLE orders_products add products_sku varchar(255);
ALTER TABLE customers_basket add products_sku varchar(255);

-- Add customer_id to sessions table - previously the customer_id was stored in the value column.  We also make value nullable.
-- For various reasons, mainly DB2 limitations, we drop the sessions table and recreate it
DROP TABLE sessions;
CREATE TABLE sessions (
  sesskey varchar(32) NOT NULL,
  expiry int NOT NULL,
  customer_id int NULL,
  value varchar(256) NULL,
  store_id varchar(64) NULL,
  custom1 varchar(128) NULL,
  custom2 varchar(128) NULL,
  custom3 varchar(128) NULL,
  custom4 varchar(128) NULL,
  custom5 varchar(128) NULL,
  PRIMARY KEY(sesskey)
);
CREATE INDEX i_stsessions ON sessions (store_id);

-- Determine whether to show dialog to send mail after a group change
delete from configuration where configuration_key = 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Allow Cust Group Change eMail', 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL', 'true', 'When this is set, a popup window appears when the group of a customer is changed to allow you to send an eMail', '21', '28', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Admin App session related API calls
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCustomDataToSession','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomDataFromSession','', getdate());

-- New Batch jobs
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'com.konakartadmin.bl.AdminOrderBatchMgr.productAvailabilityNotificationBatch','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'com.konakartadmin.bl.AdminOrderBatchMgr.unpaidOrderNotificationBatch','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'com.konakartadmin.bl.AdminCustomerBatchMgr.removeExpiredCustomersBatch','', getdate());













exit;

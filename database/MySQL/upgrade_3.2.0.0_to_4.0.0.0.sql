#----------------------------------------------------------------
# KonaKart upgrade script from version 3.2.0.0 to version 4.0.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# Add Custom fields for zones table
alter table zones add column custom1 varchar(128);
alter table zones add column custom2 varchar(128);
alter table zones add column custom3 varchar(128);

# Configuration for product select panels in admin app
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_TEMPLATE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Template' , 'ADMIN_APP_PROD_SEL_TEMPLATE', '$name', 'Sets the template for which attributes to view when selecting a product ($name, $sku, $id, $model, $manufacturer, $custom1 ... $custom5', '21', '25', now());
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_NUM_PRODS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Default Num Prods', 'ADMIN_APP_PROD_SEL_NUM_PRODS', '0', 'Sets the default number of products displayed in the product select dialogs when opened', '21', '26', now());
delete from configuration where configuration_key = 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Product Select Max Num Prods', 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS', '100', 'Sets the maximum number of products displayed in the product select dialogs after a search', '21', '27', now());

# Add date available attribute to products quantity
ALTER TABLE products_quantity add column products_date_available datetime;

# Just for MySQL
delete from kk_api_call where api_call_id = 221;

# API calls for setting product quantity and product availability
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (220, 'setProductQuantity','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (221, 'setProductAvailability','', now());

# Extra attributes for product object
ALTER TABLE products add column max_num_downloads int default -1 not null;
ALTER TABLE products add column max_download_days int default -1 not null;
ALTER TABLE products add column stock_reorder_level int default -1 not null;

# Cookie table to save cookie information
DROP TABLE IF EXISTS kk_cookie;
CREATE TABLE kk_cookie (
  customer_uuid varchar(128) NOT NULL,
  attribute_id varchar(64) NOT NULL,
  attribute_value varchar(256),
  date_added datetime NOT NULL,
  last_read datetime,
  last_modified datetime,
  PRIMARY KEY (customer_uuid, attribute_id)
);

# Add tracking number to orders table
ALTER TABLE orders add column tracking_number varchar(128);

# Update description of role to panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields, order number, tracking number' where panel_id=17;

# Extra attribute for product object
ALTER TABLE products add column can_order_when_not_in_stock int default -1 not null;

# Add invisible attribute to categories table
ALTER TABLE categories add categories_invisible int(1) DEFAULT 0 NOT NULL;

# API calls for getting product quantity and product availability
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (222, 'getProductQuantity','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (223, 'getProductAvailability','', now());

# Add a new panel for inserting product quantities
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (87, 'kk_panel_productQuantity','Product Quantity', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 87, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 87, 1,1,1,now());

# API calls for XML import/export
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (224, 'insertTagGroupToTags','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (225, 'getTagGroupToTags','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (226, 'importCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (227, 'getProductNotificationsForCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (228, 'getProductOptionsPerName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (229, 'getAllProductOptionValues','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (230, 'getProductOptionValuesPerName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (231, 'insertProductsOptionsValuesToProductsOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (232, 'getProductOptionValueToProductOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (233, 'getAllConfigurations','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (234, 'getAllConfigurationGroups','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (235, 'updateConfiguration','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (236, 'updateConfigurationGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (237, 'getConfigurationGroupsByTitle','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (238, 'getConfigurationByKey','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (239, 'insertConfiguration','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (240, 'insertConfigurationGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (241, 'insertIpnHistory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (242, 'importAudit','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (243, 'getCategoriesPerTagGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (244, 'addCategoriesToTagGroups','', now());

# Add a new panel for inserting product available dates
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (88, 'kk_panel_productAvailableDate','Product Available Date', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 88, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 88, 1,1,1,now());

# Extra attributes for order product and basket objects
ALTER TABLE orders_products add column products_state int default '0';
ALTER TABLE orders_products add column products_sku varchar(255);
ALTER TABLE customers_basket add column products_sku varchar(255);

# Add customer_id to sessions table - previously the customer_id was stored in the value column.  We also make value nullable.
# For various reasons, mainly DB2 limitations, we drop the sessions table and recreate it
DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  sesskey varchar(32) NOT NULL,
  expiry int(11) unsigned NOT NULL,
  customer_id int NULL,
  value varchar(256) NULL,
  store_id varchar(64) NULL,
  custom1 varchar(128) NULL,
  custom2 varchar(128) NULL,
  custom3 varchar(128) NULL,
  custom4 varchar(128) NULL,
  custom5 varchar(128) NULL,
  PRIMARY KEY (sesskey)
);
alter table sessions add key idx_store_id (store_id);

# Determine whether to show dialog to send mail after a group change
delete from configuration where configuration_key = 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Allow Cust Group Change eMail', 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL', 'true', 'When this is set, a popup window appears when the group of a customer is changed to allow you to send an eMail', '21', '28', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());

# Admin App session related API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (245, 'addCustomDataToSession','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (246, 'getCustomDataFromSession','', now());

# New Batch jobs
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (247, 'com.konakartadmin.bl.AdminOrderBatchMgr.productAvailabilityNotificationBatch','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (248, 'com.konakartadmin.bl.AdminOrderBatchMgr.unpaidOrderNotificationBatch','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (249, 'com.konakartadmin.bl.AdminCustomerBatchMgr.removeExpiredCustomersBatch','', now());

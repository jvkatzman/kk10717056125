#----------------------------------------------------------------
# KonaKart upgrade script from version 3.0.1.0 to version 3.2.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#
# API call for inserting a configuration group
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (215, 'insertConfigurationGroup','', now());

# Column for storing store_id on all tables
alter table address_book add column store_id varchar(64);
alter table address_book add key idx_store_id (store_id);

alter table address_format add column store_id varchar(64);
alter table address_format add key idx_store_id (store_id);

alter table banners add column store_id varchar(64);
alter table banners add key idx_store_id (store_id);

alter table banners_history add column store_id varchar(64);
alter table banners_history add key idx_store_id (store_id);

alter table categories add column store_id varchar(64);
alter table categories add key idx_store_id (store_id);

alter table categories_description add column store_id varchar(64);
alter table categories_description add key idx_store_id (store_id);

alter table configuration add column store_id varchar(64);
alter table configuration add key idx_store_id (store_id);

alter table configuration_group add column store_id varchar(64);
alter table configuration_group add key idx_store_id (store_id);

alter table counter add column store_id varchar(64);
alter table counter add key idx_store_id (store_id);

alter table counter_history add column store_id varchar(64);
alter table counter_history add key idx_store_id (store_id);

alter table countries add column store_id varchar(64);
alter table countries add key idx_store_id (store_id);

alter table coupon add column store_id varchar(64);
alter table coupon add key idx_store_id (store_id);

alter table currencies add column store_id varchar(64);
alter table currencies add key idx_store_id (store_id);

alter table customers add column store_id varchar(64);
alter table customers add key idx_store_id (store_id);

alter table customers_basket add column store_id varchar(64);
alter table customers_basket add key idx_store_id (store_id);

alter table customers_basket_attributes add column store_id varchar(64);
alter table customers_basket_attributes add key idx_store_id (store_id);

alter table customers_info add column store_id varchar(64);
alter table customers_info add key idx_store_id (store_id);

alter table geo_zones add column store_id varchar(64);
alter table geo_zones add key idx_store_id (store_id);

alter table ipn_history add column store_id varchar(64);
alter table ipn_history add key idx_store_id (store_id);

alter table kk_audit add column store_id varchar(64);
alter table kk_audit add key idx_store_id (store_id);

alter table kk_category_to_tag_group add column store_id varchar(64);
alter table kk_category_to_tag_group add key idx_store_id (store_id);

alter table kk_customer_group add column store_id varchar(64);
alter table kk_customer_group add key idx_store_id (store_id);

alter table kk_customers_to_role add column store_id varchar(64);
alter table kk_customers_to_role add key idx_store_id (store_id);

alter table kk_digital_download add column store_id varchar(64);
alter table kk_digital_download add key idx_store_id (store_id);

alter table kk_product_feed add column store_id varchar(64);
alter table kk_product_feed add key idx_store_id (store_id);

alter table kk_role_to_api_call add column store_id varchar(64);
alter table kk_role_to_api_call add key idx_store_id (store_id);

alter table kk_role_to_panel add column store_id varchar(64);
alter table kk_role_to_panel add key idx_store_id (store_id);

alter table kk_tag add column store_id varchar(64);
alter table kk_tag add key idx_store_id (store_id);

alter table kk_tag_group add column store_id varchar(64);
alter table kk_tag_group add key idx_store_id (store_id);

alter table kk_tag_group_to_tag add column store_id varchar(64);
alter table kk_tag_group_to_tag add key idx_store_id (store_id);

alter table kk_tag_to_product add column store_id varchar(64);
alter table kk_tag_to_product add key idx_store_id (store_id);

alter table languages add column store_id varchar(64);
alter table languages add key idx_store_id (store_id);

alter table manufacturers add column store_id varchar(64);
alter table manufacturers add key idx_store_id (store_id);

alter table manufacturers_info add column store_id varchar(64);
alter table manufacturers_info add key idx_store_id (store_id);

alter table newsletters add column store_id varchar(64);
alter table newsletters add key idx_store_id (store_id);

alter table orders add column store_id varchar(64);
alter table orders add key idx_store_id (store_id);

alter table orders_products add column store_id varchar(64);
alter table orders_products add key idx_store_id (store_id);

alter table orders_products_attributes add column store_id varchar(64);
alter table orders_products_attributes add key idx_store_id (store_id);

alter table orders_products_download add column store_id varchar(64);
alter table orders_products_download add key idx_store_id (store_id);

alter table orders_returns add column store_id varchar(64);
alter table orders_returns add key idx_store_id (store_id);

alter table orders_status add column store_id varchar(64);
alter table orders_status add key idx_store_id (store_id);

alter table orders_status_history add column store_id varchar(64);
alter table orders_status_history add key idx_store_id (store_id);

alter table orders_total add column store_id varchar(64);
alter table orders_total add key idx_store_id (store_id);

alter table products add column store_id varchar(64);
alter table products add key idx_store_id (store_id);

alter table products_attributes add column store_id varchar(64);
alter table products_attributes add key idx_store_id (store_id);

alter table products_attributes_download add column store_id varchar(64);
alter table products_attributes_download add key idx_store_id (store_id);

alter table products_description add column store_id varchar(64);
alter table products_description add key idx_store_id (store_id);

alter table products_notifications add column store_id varchar(64);
alter table products_notifications add key idx_store_id (store_id);

alter table products_options add column store_id varchar(64);
alter table products_options add key idx_store_id (store_id);

alter table products_options_values add column store_id varchar(64);
alter table products_options_values add key idx_store_id (store_id);

alter table products_options_values_to_products_options add column store_id varchar(64);
alter table products_options_values_to_products_options add key idx_store_id (store_id);

alter table products_quantity add column store_id varchar(64);
alter table products_quantity add key idx_store_id (store_id);

alter table products_to_categories add column store_id varchar(64);
alter table products_to_categories add key idx_store_id (store_id);

alter table products_to_products add column store_id varchar(64);
alter table products_to_products add key idx_store_id (store_id);

alter table promotion add column store_id varchar(64);
alter table promotion add key idx_store_id (store_id);

alter table promotion_to_category add column store_id varchar(64);
alter table promotion_to_category add key idx_store_id (store_id);

alter table promotion_to_coupon add column store_id varchar(64);
alter table promotion_to_coupon add key idx_store_id (store_id);

alter table promotion_to_cust_group add column store_id varchar(64);
alter table promotion_to_cust_group add key idx_store_id (store_id);

alter table promotion_to_customer add column store_id varchar(64);
alter table promotion_to_customer add key idx_store_id (store_id);

alter table promotion_to_manufacturer add column store_id varchar(64);
alter table promotion_to_manufacturer add key idx_store_id (store_id);

alter table promotion_to_product add column store_id varchar(64);
alter table promotion_to_product add key idx_store_id (store_id);

alter table returns_to_ord_prods add column store_id varchar(64);
alter table returns_to_ord_prods add key idx_store_id (store_id);

alter table reviews add column store_id varchar(64);
alter table reviews add key idx_store_id (store_id);

alter table reviews_description add column store_id varchar(64);
alter table reviews_description add key idx_store_id (store_id);

alter table sessions add column store_id varchar(64);
alter table sessions add key idx_store_id (store_id);

alter table specials add column store_id varchar(64);
alter table specials add key idx_store_id (store_id);

alter table tax_class add column store_id varchar(64);
alter table tax_class add key idx_store_id (store_id);

alter table tax_rates add column store_id varchar(64);
alter table tax_rates add key idx_store_id (store_id);

#alter table utility add column store_id varchar(64);
#alter table utility add key idx_store_id (store_id);

alter table whos_online add column store_id varchar(64);
alter table whos_online add key idx_store_id (store_id);

alter table zones add column store_id varchar(64);
alter table zones add key idx_store_id (store_id);

alter table zones_to_geo_zones add column store_id varchar(64);
alter table zones_to_geo_zones add key idx_store_id (store_id);

# kk_store table for holding store instance information for multi-store
DROP TABLE IF EXISTS kk_store;
CREATE TABLE kk_store (
  store_id varchar(64) NOT NULL,
  store_name varchar(64) NOT NULL,
  store_desc varchar(128) NOT NULL,
  store_enabled int(1) NOT NULL,
  store_under_maint int(1) NOT NULL,
  store_deleted int(1) NOT NULL,
  store_template int(1) NOT NULL,
  store_admin_email varchar(96),
  store_css_filename varchar(128),
  store_logo_filename varchar(128),
  store_url varchar(128),
  store_home varchar(64),
  store_max_products int NOT NULL DEFAULT '-1',
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  date_added datetime,
  last_updated datetime,
  PRIMARY KEY (store_id)
);

INSERT INTO kk_store (store_id, store_name, store_desc, store_enabled, store_under_maint, store_deleted, store_template, store_admin_email, store_logo_filename, store_css_filename, store_home, date_added) VALUES ('store1','store1','Store Number One', 1,0,0,0, 'admin@konakart.com', 'logo.png', 'style.css', 'derby', now());

# MultiStore Template StoreId
delete from configuration where configuration_key = 'MULTISTORE_TEMPLATE_STORE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Multi-Store Template Store', 'MULTISTORE_TEMPLATE_STORE', 'store1', 'This is the storeId of the template store used when creating new stores in a multi-store installation', '25', '5', now());

# MultiStore Admin Role
delete from configuration where configuration_key = 'MULTISTORE_ADMIN_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Admin Role', 'MULTISTORE_ADMIN_ROLE_IDX', '5', 'Defines the Role given to Admin users of new stores', '25', '6', 'Roles', now());

# MultiStore Super User Role
delete from configuration where configuration_key = 'MULTISTORE_SUPER_USER_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Super User Role', 'MULTISTORE_SUPER_USER_ROLE_IDX', '1', 'Defines the Role given to Super User user of new stores', '25', '6', 'Roles', now());

# Filenames for new store sql
delete from configuration where configuration_key = 'KK_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('KonaKart new store creation SQL','KK_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_new_store.sql','Filename containing the KonaKart new store creation SQL commands','25', '10', now());
delete from configuration where configuration_key = 'USER_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('User new store creation SQL','USER_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_user_new_store.sql','Filename containing the user defined new store creation SQL commands - these are executed after the KonaKart cloning commands','25', '11', now());

# Table for wish list
DROP TABLE IF EXISTS kk_wishlist;
CREATE TABLE kk_wishlist (
  kk_wishlist_id int NOT NULL auto_increment,
  store_id varchar(64),
  customers_id int NOT NULL,
  name varchar(128),
  description varchar(255),
  public_or_private int NOT NULL,
  date_added datetime NOT NULL,
  customers_firstname varchar(32),
  customers_lastname varchar(32),
  customers_dob datetime,
  customers_city varchar(32),
  customers_state varchar(32),
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  PRIMARY KEY (kk_wishlist_id)
);

# Table for wish list items
DROP TABLE IF EXISTS kk_wishlist_item;
CREATE TABLE kk_wishlist_item (
  kk_wishlist_item_id int NOT NULL auto_increment,
  store_id varchar(64),
  kk_wishlist_id int NOT NULL,
  products_id varchar(255) NOT NULL,
  priority int,
  date_added datetime NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  PRIMARY KEY (kk_wishlist_item_id)
);

# Enable / Disable wish list functionality from application
delete from configuration where configuration_key = 'ENABLE_WISHLIST';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Wish List functionality', 'ENABLE_WISHLIST', 'false', 'When set to true, wish list functionality is enabled in the application', '1', '24', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());

# Add column to orders table for order number
ALTER TABLE orders add column orders_number varchar(128);

# Orders Panel Show Order Number or Order Id
delete from configuration where configuration_key = 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Display Order Number', 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM', '', 'When this is set, the order number is displayed in the orders panel rather than the order id', '21', '24', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());

# Panels for Managing Stores in a Multi-Store Environment
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added) VALUES (1, 83, 1,1,1,1, 'Set to allow admin of all stores', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (84, 'kk_panel_editStore','Edit a Store in a Mall', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (85, 'kk_panel_insertStore','Insert a Store in a Mall', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (86, 'kk_panel_multistoreConfig','Multi-Store Configuration', now());

# API calls for Multi-Store Store Maintenance
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (216, 'getMallStores','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (217, 'insertMallStore','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (218, 'deleteMallStore','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (219, 'updateMallStore','', now());

# Add language code to products_description
ALTER TABLE products_description add column language_code char(2);

update products_description set language_code = 'en' where language_id = 1;
update products_description set language_code = 'de' where language_id = 2;
update products_description set language_code = 'es' where language_id = 3;

# Admin Store Integration Class
delete from configuration where configuration_key = 'ADMIN_STORE_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Store Integration Class', 'ADMIN_STORE_INTEGRATION_CLASS','com.konakartadmin.bl.AdminStoreIntegrationMgr','The Store Integration Implementation Class, to allow custom store maintenance function', '25', '7', now());

# Add super_user and 5 custom fields to kk_role
ALTER TABLE kk_role add column super_user int(1);
ALTER TABLE kk_role add column custom1 varchar(128);
ALTER TABLE kk_role add column custom2 varchar(128);
ALTER TABLE kk_role add column custom3 varchar(128);
ALTER TABLE kk_role add column custom4 varchar(128);
ALTER TABLE kk_role add column custom5 varchar(128);
update kk_role set super_user = 1 where name = 'Super User';

# API call for forcing registration of admin users even if already registered
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (221, 'forceRegisterCustomer','', now());

# Reports re-located for MultiStore
UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/webapps/birtviewer/reports/stores/store1/' where configuration_key = 'REPORTS_DEFN_PATH';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/frameset?__report=reports/stores/store1/' where configuration_key = 'REPORTS_URL';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/run?__report=reports/stores/store1/OrdersInLast30DaysChart.rptdesign&storeId=store1' where configuration_key = 'REPORTS_STATUS_PAGE_URL';

# Add the custom1 privilege to enable/disable the reading and editing of custom fields and order number on the Edit Order Panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields and order number' where panel_id=17;

# KonaKart Home Directory
delete from configuration where configuration_key = 'INSTALLATION_HOME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('KonaKart Installation Home', 'INSTALLATION_HOME','C:/Program Files/KonaKart/','The home directory of this KonaKart Installation', '1', '26', now());



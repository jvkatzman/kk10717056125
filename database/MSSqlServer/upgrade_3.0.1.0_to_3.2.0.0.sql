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
-- From version 3.0.1.0 to version 3.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 3.0.1.0, the upgrade
-- scripts must be run sequentially.
-- 

INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertConfigurationGroup','', getdate());

-- Column for storing store_id on all tables
ALTER table address_book add store_id varchar(64);
CREATE INDEX i_staddress_book ON address_book (store_id);

ALTER table address_format add store_id varchar(64);
CREATE INDEX i_staddress_format ON address_format (store_id);

ALTER table banners add store_id varchar(64);
CREATE INDEX i_stbanners ON banners (store_id);

ALTER table banners_history add store_id varchar(64);
CREATE INDEX i_stbanners_history ON banners_history (store_id);

ALTER table categories add store_id varchar(64);
CREATE INDEX i_stcategories ON categories (store_id);

ALTER table categories_description add store_id varchar(64);
CREATE INDEX i_stcategories_description ON categories_description (store_id);

ALTER table configuration add store_id varchar(64);
CREATE INDEX i_stconfiguration ON configuration (store_id);

ALTER table configuration_group add store_id varchar(64);
CREATE INDEX i_stconfiguration_group ON configuration_group (store_id);

ALTER table counter add store_id varchar(64);
CREATE INDEX i_stcounter ON counter (store_id);

ALTER table counter_history add store_id varchar(64);
CREATE INDEX i_stcounter_history ON counter_history (store_id);

ALTER table countries add store_id varchar(64);
CREATE INDEX i_stcountries ON countries (store_id);

ALTER table coupon add store_id varchar(64);
CREATE INDEX i_stcoupon ON coupon (store_id);

ALTER table currencies add store_id varchar(64);
CREATE INDEX i_stcurrencies ON currencies (store_id);

ALTER table customers add store_id varchar(64);
CREATE INDEX i_stcustomers ON customers (store_id);

ALTER table customers_basket add store_id varchar(64);
CREATE INDEX i_stcustomers_basket ON customers_basket (store_id);

ALTER table customers_basket_attributes add store_id varchar(64);
CREATE INDEX i_stcustomers_basket_attribute ON customers_basket_attributes (store_id);

ALTER table customers_info add store_id varchar(64);
CREATE INDEX i_stcustomers_info ON customers_info (store_id);

ALTER table geo_zones add store_id varchar(64);
CREATE INDEX i_stgeo_zones ON geo_zones (store_id);

ALTER table ipn_history add store_id varchar(64);
CREATE INDEX i_stipn_history ON ipn_history (store_id);

ALTER table kk_audit add store_id varchar(64);
CREATE INDEX i_stkk_audit ON kk_audit (store_id);

ALTER table kk_category_to_tag_group add store_id varchar(64);
CREATE INDEX i_stkk_category_to_tag_group ON kk_category_to_tag_group (store_id);

ALTER table kk_customer_group add store_id varchar(64);
CREATE INDEX i_stkk_customer_group ON kk_customer_group (store_id);

ALTER table kk_customers_to_role add store_id varchar(64);
CREATE INDEX i_stkk_customers_to_role ON kk_customers_to_role (store_id);

ALTER table kk_digital_download add store_id varchar(64);
CREATE INDEX i_stkk_digital_download ON kk_digital_download (store_id);

ALTER table kk_product_feed add store_id varchar(64);
CREATE INDEX i_stkk_product_feed ON kk_product_feed (store_id);

ALTER table kk_role_to_api_call add store_id varchar(64);
CREATE INDEX i_stkk_role_to_api_call ON kk_role_to_api_call (store_id);

ALTER table kk_role_to_panel add store_id varchar(64);
CREATE INDEX i_stkk_role_to_panel ON kk_role_to_panel (store_id);

ALTER table kk_tag add store_id varchar(64);
CREATE INDEX i_stkk_tag ON kk_tag (store_id);

ALTER table kk_tag_group add store_id varchar(64);
CREATE INDEX i_stkk_tag_group ON kk_tag_group (store_id);

ALTER table kk_tag_group_to_tag add store_id varchar(64);
CREATE INDEX i_stkk_tag_group_to_tag ON kk_tag_group_to_tag (store_id);

ALTER table kk_tag_to_product add store_id varchar(64);
CREATE INDEX i_stkk_tag_to_product ON kk_tag_to_product (store_id);

ALTER table languages add store_id varchar(64);
CREATE INDEX i_stlanguages ON languages (store_id);

ALTER table manufacturers add store_id varchar(64);
CREATE INDEX i_stmanufacturers ON manufacturers (store_id);

ALTER table manufacturers_info add store_id varchar(64);
CREATE INDEX i_stmanufacturers_info ON manufacturers_info (store_id);

ALTER table newsletters add store_id varchar(64);
CREATE INDEX i_stnewsletters ON newsletters (store_id);

ALTER table orders add store_id varchar(64);
CREATE INDEX i_storders ON orders (store_id);

ALTER table orders_products add store_id varchar(64);
CREATE INDEX i_storders_products ON orders_products (store_id);

ALTER table orders_products_attributes add store_id varchar(64);
CREATE INDEX i_storders_products_attributes ON orders_products_attributes (store_id);

ALTER table orders_products_download add store_id varchar(64);
CREATE INDEX i_storders_products_download ON orders_products_download (store_id);

ALTER table orders_returns add store_id varchar(64);
CREATE INDEX i_storders_returns ON orders_returns (store_id);

ALTER table orders_status add store_id varchar(64);
CREATE INDEX i_storders_status ON orders_status (store_id);

ALTER table orders_status_history add store_id varchar(64);
CREATE INDEX i_storders_status_history ON orders_status_history (store_id);

ALTER table orders_total add store_id varchar(64);
CREATE INDEX i_storders_total ON orders_total (store_id);

ALTER table products add store_id varchar(64);
CREATE INDEX i_stproducts ON products (store_id);

ALTER table products_attributes add store_id varchar(64);
CREATE INDEX i_stproducts_attributes ON products_attributes (store_id);

ALTER table products_attributes_download add store_id varchar(64);
CREATE INDEX i_stproducts_attributes_downlo ON products_attributes_download (store_id);

ALTER table products_description add store_id varchar(64);
CREATE INDEX i_stproducts_description ON products_description (store_id);

ALTER table products_notifications add store_id varchar(64);
CREATE INDEX i_stproducts_notifications ON products_notifications (store_id);

ALTER table products_options add store_id varchar(64);
CREATE INDEX i_stproducts_options ON products_options (store_id);

ALTER table products_options_values add store_id varchar(64);
CREATE INDEX i_stproducts_options_values ON products_options_values (store_id);

ALTER table products_options_values_to_products_options add store_id varchar(64);
CREATE INDEX i_stproducts_options_values_to ON products_options_values_to_products_options (store_id);

ALTER table products_quantity add store_id varchar(64);
CREATE INDEX i_stproducts_quantity ON products_quantity (store_id);

ALTER table products_to_categories add store_id varchar(64);
CREATE INDEX i_stproducts_to_categories ON products_to_categories (store_id);

ALTER table products_to_products add store_id varchar(64);
CREATE INDEX i_stproducts_to_products ON products_to_products (store_id);

ALTER table promotion add store_id varchar(64);
CREATE INDEX i_stpromotion ON promotion (store_id);

ALTER table promotion_to_category add store_id varchar(64);
CREATE INDEX i_stpromotion_to_category ON promotion_to_category (store_id);

ALTER table promotion_to_coupon add store_id varchar(64);
CREATE INDEX i_stpromotion_to_coupon ON promotion_to_coupon (store_id);

ALTER table promotion_to_cust_group add store_id varchar(64);
CREATE INDEX i_stpromotion_to_cust_group ON promotion_to_cust_group (store_id);

ALTER table promotion_to_customer add store_id varchar(64);
CREATE INDEX i_stpromotion_to_customer ON promotion_to_customer (store_id);

ALTER table promotion_to_manufacturer add store_id varchar(64);
CREATE INDEX i_stpromotion_to_manufacturer ON promotion_to_manufacturer (store_id);

ALTER table promotion_to_product add store_id varchar(64);
CREATE INDEX i_stpromotion_to_product ON promotion_to_product (store_id);

ALTER table returns_to_ord_prods add store_id varchar(64);
CREATE INDEX i_streturns_to_ord_prods ON returns_to_ord_prods (store_id);

ALTER table reviews add store_id varchar(64);
CREATE INDEX i_streviews ON reviews (store_id);

ALTER table reviews_description add store_id varchar(64);
CREATE INDEX i_streviews_description ON reviews_description (store_id);

ALTER table sessions add store_id varchar(64);
CREATE INDEX i_stsessions ON sessions (store_id);

ALTER table specials add store_id varchar(64);
CREATE INDEX i_stspecials ON specials (store_id);

ALTER table tax_class add store_id varchar(64);
CREATE INDEX i_sttax_class ON tax_class (store_id);

ALTER table tax_rates add store_id varchar(64);
CREATE INDEX i_sttax_rates ON tax_rates (store_id);

--alter table utility add column store_id varchar(64);
--alter table utility add key idx_store_id (store_id);

ALTER table whos_online add store_id varchar(64);
CREATE INDEX i_stwhos_online ON whos_online (store_id);

ALTER table zones add store_id varchar(64);
CREATE INDEX i_stzones ON zones (store_id);

ALTER table zones_to_geo_zones add store_id varchar(64);
CREATE INDEX i_stzones_to_geo_zones ON zones_to_geo_zones (store_id);

-- kk_store table for holding store instance information for multi-store
DROP TABLE kk_store;
CREATE TABLE kk_store (
  store_id varchar(64) NOT NULL,
  store_name varchar(64) NOT NULL,
  store_desc varchar(128) NOT NULL,
  store_enabled int NOT NULL,
  store_under_maint int NOT NULL,
  store_deleted int NOT NULL,
  store_template int NOT NULL,
  store_admin_email varchar(96),
  store_css_filename varchar(128),
  store_logo_filename varchar(128),
  store_url varchar(128),
  store_home varchar(64),
  store_max_products int DEFAULT -1 NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  date_added datetime,
  last_updated datetime,
  PRIMARY KEY(store_id)
);

INSERT INTO kk_store (store_id, store_name, store_desc, store_enabled, store_under_maint, store_deleted, store_template, store_admin_email, store_logo_filename, store_css_filename, store_home, date_added) VALUES ('store1','store1','Store Number One', 1,0,0,0, 'admin@konakart.com', 'logo.png', 'style.css', 'derby', getdate());

-- MultiStore Template StoreId
delete from configuration where configuration_key = 'MULTISTORE_TEMPLATE_STORE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Multi-Store Template Store', 'MULTISTORE_TEMPLATE_STORE', 'store1', 'This is the storeId of the template store used when creating new stores in a multi-store installation', '25', '5', getdate());

-- MultiStore Admin Role
delete from configuration where configuration_key = 'MULTISTORE_ADMIN_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Admin Role', 'MULTISTORE_ADMIN_ROLE_IDX', '5', 'Defines the Role given to Admin users of new stores', '25', '6', 'Roles', getdate());

-- MultiStore Super User Role
delete from configuration where configuration_key = 'MULTISTORE_SUPER_USER_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Super User Role', 'MULTISTORE_SUPER_USER_ROLE_IDX', '1', 'Defines the Role given to Super User user of new stores', '25', '6', 'Roles', getdate());

-- Filenames for new store sql
delete from configuration where configuration_key = 'KK_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('KonaKart new store creation SQL','KK_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_new_store.sql','Filename containing the KonaKart new store creation SQL commands','25', '10', getdate());
delete from configuration where configuration_key = 'USER_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('User new store creation SQL','USER_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_user_new_store.sql','Filename containing the user defined new store creation SQL commands - these are executed after the KonaKart cloning commands','25', '11', getdate());

-- Table for wish list
DROP TABLE kk_wishlist;
CREATE TABLE kk_wishlist (
  kk_wishlist_id int NOT NULL identity(1,1),
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
  PRIMARY KEY(kk_wishlist_id)
);

-- Table for wish list items
DROP TABLE kk_wishlist_item;
CREATE TABLE kk_wishlist_item (
  kk_wishlist_item_id int NOT NULL identity(1,1),
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
  PRIMARY KEY(kk_wishlist_item_id)
);

-- Enable / Disable wish list functionality from application
delete from configuration where configuration_key = 'ENABLE_WISHLIST';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Wish List functionality', 'ENABLE_WISHLIST', 'false', 'When set to true, wish list functionality is enabled in the application', '1', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Add column to orders table for order number
ALTER TABLE orders add orders_number varchar(128);

-- Orders Panel Show Order Number or Order Id
delete from configuration where configuration_key = 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Display Order Number', 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM', '', 'When this is set, the order number is displayed in the orders panel rather than the order id', '21', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Panels for Managing Stores in a Multi-Store Environment
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added) VALUES (1, 83, 1,1,1,1, 'Set to allow admin of all stores', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_editStore','Edit a Store in a Mall', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_insertStore','Insert a Store in a Mall', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_multistoreConfig','Multi-Store Configuration', getdate());

-- API calls for Multi-Store Store Maintenance
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getMallStores','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertMallStore','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteMallStore','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateMallStore','', getdate());

-- Add language code to products_description
ALTER TABLE products_description add language_code char(2);

update products_description set language_code = 'en' where language_id = 1;
update products_description set language_code = 'de' where language_id = 2;
update products_description set language_code = 'es' where language_id = 3;

-- Admin Store Integration Class
delete from configuration where configuration_key = 'ADMIN_STORE_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Store Integration Class', 'ADMIN_STORE_INTEGRATION_CLASS','com.konakartadmin.bl.AdminStoreIntegrationMgr','The Store Integration Implementation Class, to allow custom store maintenance function', '25', '7', getdate());

-- Add super_user and 5 custom fields to kk_role
ALTER TABLE kk_role add super_user smallint;
ALTER TABLE kk_role add custom1 varchar(128);
ALTER TABLE kk_role add custom2 varchar(128);
ALTER TABLE kk_role add custom3 varchar(128);
ALTER TABLE kk_role add custom4 varchar(128);
ALTER TABLE kk_role add custom5 varchar(128);
update kk_role set super_user = 1 where name = 'Super User';

-- API call for forcing registration of admin users even if already registered
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'forceRegisterCustomer','', getdate());

-- Reports re-located for MultiStore
UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/webapps/birtviewer/reports/stores/store1/' where configuration_key = 'REPORTS_DEFN_PATH';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/frameset?__report=reports/stores/store1/' where configuration_key = 'REPORTS_URL';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/run?__report=reports/stores/store1/OrdersInLast30DaysChart.rptdesign\&storeId=store1' where configuration_key = 'REPORTS_STATUS_PAGE_URL';

-- Add the custom1 privilege to enable/disable the reading and editing of custom fields and order number on the Edit Order Panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields and order number' where panel_id=17;

-- KonaKart Home Directory
delete from configuration where configuration_key = 'INSTALLATION_HOME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('KonaKart Installation Home', 'INSTALLATION_HOME','C:/Program Files/KonaKart/','The home directory of this KonaKart Installation', '1', '26', getdate());


exit;

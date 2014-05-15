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
-- From version 3.0.1.0 to version 3.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 3.0.1.0, the upgrade
-- scripts must be run sequentially.
-- 

set echo on
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertConfigurationGroup','', current timestamp);

-- Column for storing store_id on all tables
ALTER table address_book add store_id varchar(64);
CREATE INDEX i_st_ce2c90a44e2d3 ON address_book (store_id);

ALTER table address_format add store_id varchar(64);
CREATE INDEX i_st_b934af097bd19 ON address_format (store_id);

ALTER table banners add store_id varchar(64);
CREATE INDEX i_st_d0b165d3da2e_ ON banners (store_id);

ALTER table banners_history add store_id varchar(64);
CREATE INDEX i_st_e5cc24af5ed10 ON banners_history (store_id);

ALTER table categories add store_id varchar(64);
CREATE INDEX i_st_727041564dd58 ON categories (store_id);

ALTER table categories_description add store_id varchar(64);
CREATE INDEX i_st_ba9939845d7f5 ON categories_description (store_id);

ALTER table configuration add store_id varchar(64);
CREATE INDEX i_st_c9f557d8573ac ON configuration (store_id);

ALTER table configuration_group add store_id varchar(64);
CREATE INDEX i_st_c5b88f9839871 ON configuration_group (store_id);

ALTER table counter add store_id varchar(64);
CREATE INDEX i_st_d0b1d3f53965_ ON counter (store_id);

ALTER table counter_history add store_id varchar(64);
CREATE INDEX i_st_c4896bdc929da ON counter_history (store_id);

ALTER table countries add store_id varchar(64);
CREATE INDEX i_st_377c476a6302e ON countries (store_id);

ALTER table coupon add store_id varchar(64);
CREATE INDEX i_st_652f6e86e79_c ON coupon (store_id);

ALTER table currencies add store_id varchar(64);
CREATE INDEX i_st_72705adb72fb2 ON currencies (store_id);

ALTER table customers add store_id varchar(64);
CREATE INDEX i_st_377c4b1a3685e ON customers (store_id);

ALTER table customers_basket add store_id varchar(64);
CREATE INDEX i_st_ad910311c2a1a ON customers_basket (store_id);

ALTER table customers_basket_attribute add store_id varchar(64);
CREATE INDEX i_st_e988e8a78e95d ON customers_basket_attribute (store_id);

ALTER table customers_info add store_id varchar(64);
CREATE INDEX i_st_975087a4922d9 ON customers_info (store_id);

ALTER table geo_zones add store_id varchar(64);
CREATE INDEX i_st_377c92f4d1fd7 ON geo_zones (store_id);

ALTER table ipn_history add store_id varchar(64);
CREATE INDEX i_st_c09b83295fef0 ON ipn_history (store_id);

ALTER table kk_audit add store_id varchar(64);
CREATE INDEX i_st_1ae73a4c85e51 ON kk_audit (store_id);

ALTER table kk_category_to_tag_group add store_id varchar(64);
CREATE INDEX i_st_81a7f11b10741 ON kk_category_to_tag_group (store_id);

ALTER table kk_customer_group add store_id varchar(64);
CREATE INDEX i_st_502a449ee1bb8 ON kk_customer_group (store_id);

ALTER table kk_customers_to_role add store_id varchar(64);
CREATE INDEX i_st_7d8afcec6822d ON kk_customers_to_role (store_id);

ALTER table kk_digital_download add store_id varchar(64);
CREATE INDEX i_st_f65dd12eafb1d ON kk_digital_download (store_id);

ALTER table kk_product_feed add store_id varchar(64);
CREATE INDEX i_st_8ea6503df3724 ON kk_product_feed (store_id);

ALTER table kk_role_to_api_call add store_id varchar(64);
CREATE INDEX i_st_662e42296d8dd ON kk_role_to_api_call (store_id);

ALTER table kk_role_to_panel add store_id varchar(64);
CREATE INDEX i_st_8f9075d70f10a ON kk_role_to_panel (store_id);

ALTER table kk_tag add store_id varchar(64);
CREATE INDEX i_st_653093d5056_k ON kk_tag (store_id);

ALTER table kk_tag_group add store_id varchar(64);
CREATE INDEX i_st_d555747f372c1 ON kk_tag_group (store_id);

ALTER table kk_tag_group_to_tag add store_id varchar(64);
CREATE INDEX i_st_104b101ee92dd ON kk_tag_group_to_tag (store_id);

ALTER table kk_tag_to_product add store_id varchar(64);
CREATE INDEX i_st_319feeb16818d ON kk_tag_to_product (store_id);

ALTER table languages add store_id varchar(64);
CREATE INDEX i_st_377cf6ca7d37b ON languages (store_id);

ALTER table manufacturers add store_id varchar(64);
CREATE INDEX i_st_a79d46cbb5bb0 ON manufacturers (store_id);

ALTER table manufacturers_info add store_id varchar(64);
CREATE INDEX i_st_160827a094b13 ON manufacturers_info (store_id);

ALTER table newsletters add store_id varchar(64);
CREATE INDEX i_st_c0b4f3f286753 ON newsletters (store_id);

ALTER table orders add store_id varchar(64);
CREATE INDEX i_st_65313131eb4_o ON orders (store_id);

ALTER table orders_products add store_id varchar(64);
CREATE INDEX i_st_b83369b4358d1 ON orders_products (store_id);

ALTER table orders_products_attributes add store_id varchar(64);
CREATE INDEX i_st_71ef5930e3470 ON orders_products_attributes (store_id);

ALTER table orders_products_download add store_id varchar(64);
CREATE INDEX i_st_40c0476bcaeec ON orders_products_download (store_id);

ALTER table orders_returns add store_id varchar(64);
CREATE INDEX i_st_1518d4a8dabbd ON orders_returns (store_id);

ALTER table orders_status add store_id varchar(64);
CREATE INDEX i_st_e19be769fa772 ON orders_status (store_id);

ALTER table orders_status_history add store_id varchar(64);
CREATE INDEX i_st_bdbf4e4395486 ON orders_status_history (store_id);

ALTER table orders_total add store_id varchar(64);
CREATE INDEX i_st_d84a8ae42e705 ON orders_total (store_id);

ALTER table products add store_id varchar(64);
CREATE INDEX i_st_1ae76e2a2f877 ON products (store_id);

ALTER table products_attributes add store_id varchar(64);
CREATE INDEX i_st_390f139aa7407 ON products_attributes (store_id);

ALTER table products_attributes_downlo add store_id varchar(64);
CREATE INDEX i_st_10342b00c51c1 ON products_attributes_downlo (store_id);

ALTER table products_description add store_id varchar(64);
CREATE INDEX i_st_5aff5ecf5b342 ON products_description (store_id);

ALTER table products_notifications add store_id varchar(64);
CREATE INDEX i_st_6d3a37d0fa913 ON products_notifications (store_id);

ALTER table products_options add store_id varchar(64);
CREATE INDEX i_st_c7728fd5b236a ON products_options (store_id);

ALTER table products_options_values add store_id varchar(64);
CREATE INDEX i_st_f445bd0d2878f ON products_options_values (store_id);

ALTER table products_options_values_to add store_id varchar(64);
CREATE INDEX i_st_b1cfd41e7e430 ON products_options_values_to (store_id);

ALTER table products_quantity add store_id varchar(64);
CREATE INDEX i_st_b5c48aa1267d0 ON products_quantity (store_id);

ALTER table products_to_categories add store_id varchar(64);
CREATE INDEX i_st_914190186b0cb ON products_to_categories (store_id);

ALTER table products_to_products add store_id varchar(64);
CREATE INDEX i_st_5b57fb3fcc2e6 ON products_to_products (store_id);

ALTER table promotion add store_id varchar(64);
CREATE INDEX i_st_377d53384bb74 ON promotion (store_id);

ALTER table promotion_to_category add store_id varchar(64);
CREATE INDEX i_st_bd57fc9bf6947 ON promotion_to_category (store_id);

ALTER table promotion_to_coupon add store_id varchar(64);
CREATE INDEX i_st_d4eb64d86b3d3 ON promotion_to_coupon (store_id);

ALTER table promotion_to_cust_group add store_id varchar(64);
CREATE INDEX i_st_7349ad038a82a ON promotion_to_cust_group (store_id);

ALTER table promotion_to_customer add store_id varchar(64);
CREATE INDEX i_st_bd57fca1f8dfd ON promotion_to_customer (store_id);

ALTER table promotion_to_manufacturer add store_id varchar(64);
CREATE INDEX i_st_72fef51299910 ON promotion_to_manufacturer (store_id);

ALTER table promotion_to_product add store_id varchar(64);
CREATE INDEX i_st_7257ffe9c2258 ON promotion_to_product (store_id);

ALTER table returns_to_ord_prods add store_id varchar(64);
CREATE INDEX i_st_3a4997bc2fb02 ON returns_to_ord_prods (store_id);

ALTER table reviews add store_id varchar(64);
CREATE INDEX i_st_d0b63f5a4f8a_ ON reviews (store_id);

ALTER table reviews_description add store_id varchar(64);
CREATE INDEX i_st_acfcbefb041a9 ON reviews_description (store_id);

ALTER table sessions add store_id varchar(64);
CREATE INDEX i_st_1ae788109da01 ON sessions (store_id);

ALTER table specials add store_id varchar(64);
CREATE INDEX i_st_1ae78b3d943fb ON specials (store_id);

ALTER table tax_class add store_id varchar(64);
CREATE INDEX i_st_377d9ab399455 ON tax_class (store_id);

ALTER table tax_rates add store_id varchar(64);
CREATE INDEX i_st_377d9ab3a9e0b ON tax_rates (store_id);

--alter table utility add column store_id varchar(64);
--alter table utility add key idx_store_id (store_id);

ALTER table whos_online add store_id varchar(64);
CREATE INDEX i_st_c0e660ffcd215 ON whos_online (store_id);

ALTER table zones add store_id varchar(64);
CREATE INDEX i_st_3110dd6d14_zo ON zones (store_id);

ALTER table zones_to_geo_zones add store_id varchar(64);
CREATE INDEX i_st_7533c0361a37a ON zones_to_geo_zones (store_id);

-- kk_store table for holding store instance information for multi-store
DROP TABLE kk_store;
CREATE TABLE kk_store (
  store_id VARCHAR(64) NOT NULL,
  store_name VARCHAR(64) NOT NULL,
  store_desc VARCHAR(128) NOT NULL,
  store_enabled INTEGER NOT NULL,
  store_under_maint INTEGER NOT NULL,
  store_deleted INTEGER NOT NULL,
  store_template INTEGER NOT NULL,
  store_admin_email VARCHAR(96),
  store_css_filename VARCHAR(128),
  store_logo_filename VARCHAR(128),
  store_url VARCHAR(128),
  store_home VARCHAR(64),
  store_max_products INTEGER DEFAULT -1 NOT NULL,
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  date_added TIMESTAMP,
  last_updated TIMESTAMP,
  PRIMARY KEY(store_id)
);

INSERT INTO kk_store (store_id, store_name, store_desc, store_enabled, store_under_maint, store_deleted, store_template, store_admin_email, store_logo_filename, store_css_filename, store_home, date_added) VALUES ('store1','store1','Store Number One', 1,0,0,0, 'admin@konakart.com', 'logo.png', 'style.css', 'derby', current timestamp);

-- MultiStore Template StoreId
delete from configuration where configuration_key = 'MULTISTORE_TEMPLATE_STORE';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Multi-Store Template Store', 'MULTISTORE_TEMPLATE_STORE', 'store1', 'This is the storeId of the template store used when creating new stores in a multi-store installation', 25, 5, current timestamp);

-- MultiStore Admin Role
delete from configuration where configuration_key = 'MULTISTORE_ADMIN_ROLE_IDX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Multi-Store Admin Role', 'MULTISTORE_ADMIN_ROLE_IDX', '5', 'Defines the Role given to Admin users of new stores', 25, 6, 'Roles', current timestamp);

-- MultiStore Super User Role
delete from configuration where configuration_key = 'MULTISTORE_SUPER_USER_ROLE_IDX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Multi-Store Super User Role', 'MULTISTORE_SUPER_USER_ROLE_IDX', '1', 'Defines the Role given to Super User user of new stores', 25, 6, 'Roles', current timestamp);

-- Filenames for new store sql
delete from configuration where configuration_key = 'KK_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'KonaKart new store creation SQL','KK_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_new_store.sql','Filename containing the KonaKart new store creation SQL commands',25, 10, current timestamp);
delete from configuration where configuration_key = 'USER_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'User new store creation SQL','USER_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_user_new_store.sql','Filename containing the user defined new store creation SQL commands - these are executed after the KonaKart cloning commands',25, 11, current timestamp);

-- Table for wish list
DROP TABLE kk_wishlist;
CREATE TABLE kk_wishlist (
  kk_wishlist_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  customers_id INTEGER NOT NULL,
  name VARCHAR(128),
  description VARCHAR(255),
  public_or_private INTEGER NOT NULL,
  date_added TIMESTAMP NOT NULL,
  customers_firstname VARCHAR(32),
  customers_lastname VARCHAR(32),
  customers_dob TIMESTAMP,
  customers_city VARCHAR(32),
  customers_state VARCHAR(32),
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  PRIMARY KEY(kk_wishlist_id)
);
DROP SEQUENCE kk_wishlist_SEQ;
CREATE SEQUENCE kk_wishlist_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Table for wish list items
DROP TABLE kk_wishlist_item;
CREATE TABLE kk_wishlist_item (
  kk_wishlist_item_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  kk_wishlist_id INTEGER NOT NULL,
  products_id VARCHAR(255) NOT NULL,
  priority int,
  date_added TIMESTAMP NOT NULL,
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  PRIMARY KEY(kk_wishlist_item_id)
);
DROP SEQUENCE kk_wishlist_item_SEQ;
CREATE SEQUENCE kk_wishlist_item_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Enable / Disable wish list functionality from application
delete from configuration where configuration_key = 'ENABLE_WISHLIST';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Enable Wish List functionality', 'ENABLE_WISHLIST', 'false', 'When set to true, wish list functionality is enabled in the application', 1, 24, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Add column to orders table for order number
ALTER TABLE orders add orders_number varchar(128);

-- Orders Panel Show Order Number or Order Id
delete from configuration where configuration_key = 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (nextval for configuration_seq, 'Display Order Number', 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM', '', 'When this is set, the order number is displayed in the orders panel rather than the order id', 21, 24, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp);

-- Panels for Managing Stores in a Multi-Store Environment
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added) VALUES (1, 83, 1,1,1,1, 'Set to allow admin of all stores', current timestamp);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_editStore','Edit a Store in a Mall', current timestamp);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_insertStore','Insert a Store in a Mall', current timestamp);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_multistoreConfig','Multi-Store Configuration', current timestamp);

-- API calls for Multi-Store Store Maintenance
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'getMallStores','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'insertMallStore','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'deleteMallStore','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'updateMallStore','', current timestamp);

-- Add language code to products_description
ALTER TABLE products_description add language_code char(2);

update products_description set language_code = 'en' where language_id = 1;
update products_description set language_code = 'de' where language_id = 2;
update products_description set language_code = 'es' where language_id = 3;

-- Admin Store Integration Class
delete from configuration where configuration_key = 'ADMIN_STORE_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Admin Store Integration Class', 'ADMIN_STORE_INTEGRATION_CLASS','com.konakartadmin.bl.AdminStoreIntegrationMgr','The Store Integration Implementation Class, to allow custom store maintenance function', 25, 7, current timestamp);

-- Add super_user and 5 custom fields to kk_role
ALTER TABLE kk_role add super_user INTEGER;
ALTER TABLE kk_role add custom1 varchar(128);
ALTER TABLE kk_role add custom2 varchar(128);
ALTER TABLE kk_role add custom3 varchar(128);
ALTER TABLE kk_role add custom4 varchar(128);
ALTER TABLE kk_role add custom5 varchar(128);
update kk_role set super_user = 1 where name = 'Super User';

-- API call for forcing registration of admin users even if already registered
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq,  'forceRegisterCustomer','', current timestamp);

-- Reports re-located for MultiStore
UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/webapps/birtviewer/reports/stores/store1/' where configuration_key = 'REPORTS_DEFN_PATH';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/frameset?__report=reports/stores/store1/' where configuration_key = 'REPORTS_URL';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/run?__report=reports/stores/store1/OrdersInLast30DaysChart.rptdesign\&storeId=store1' where configuration_key = 'REPORTS_STATUS_PAGE_URL';

-- Add the custom1 privilege to enable/disable the reading and editing of custom fields and order number on the Edit Order Panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields and order number' where panel_id=17;

-- KonaKart Home Directory
delete from configuration where configuration_key = 'INSTALLATION_HOME';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'KonaKart Installation Home', 'INSTALLATION_HOME','C:/Program Files/KonaKart/','The home directory of this KonaKart Installation', 1, 26, current timestamp);


exit;

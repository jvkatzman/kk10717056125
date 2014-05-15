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
-- KonaKart upgrade database script for PostgreSQL
-- From version 3.0.1.0 to version 3.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 3.0.1.0, the upgrade
-- scripts must be run sequentially.
-- 
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertConfigurationGroup','', now());

-- Column for storing store_id on all tables
alter table address_book add column store_id varchar(64);
CREATE INDEX idxaddress_book_store_id ON address_book (store_id);

alter table address_format add column store_id varchar(64);
CREATE INDEX idxaddress_format_store_id ON address_format (store_id);

alter table banners add column store_id varchar(64);
CREATE INDEX idxbanners_store_id ON banners (store_id);

alter table banners_history add column store_id varchar(64);
CREATE INDEX idxbanners_history_store_id ON banners_history (store_id);

alter table categories add column store_id varchar(64);
CREATE INDEX idxcategories_store_id ON categories (store_id);

alter table categories_description add column store_id varchar(64);
CREATE INDEX idxcategories_description_store_id ON categories_description (store_id);

alter table configuration add column store_id varchar(64);
CREATE INDEX idxconfiguration_store_id ON configuration (store_id);

alter table configuration_group add column store_id varchar(64);
CREATE INDEX idxconfiguration_group_store_id ON configuration_group (store_id);

alter table counter add column store_id varchar(64);
CREATE INDEX idxcounter_store_id ON counter (store_id);

alter table counter_history add column store_id varchar(64);
CREATE INDEX idxcounter_history_store_id ON counter_history (store_id);

alter table countries add column store_id varchar(64);
CREATE INDEX idxcountries_store_id ON countries (store_id);

alter table coupon add column store_id varchar(64);
CREATE INDEX idxcoupon_store_id ON coupon (store_id);

alter table currencies add column store_id varchar(64);
CREATE INDEX idxcurrencies_store_id ON currencies (store_id);

alter table customers add column store_id varchar(64);
CREATE INDEX idxcustomers_store_id ON customers (store_id);

alter table customers_basket add column store_id varchar(64);
CREATE INDEX idxcustomers_basket_store_id ON customers_basket (store_id);

alter table customers_basket_attributes add column store_id varchar(64);
CREATE INDEX idxcustomers_basket_attributes_store_id ON customers_basket_attributes (store_id);

alter table customers_info add column store_id varchar(64);
CREATE INDEX idxcustomers_info_store_id ON customers_info (store_id);

alter table geo_zones add column store_id varchar(64);
CREATE INDEX idxgeo_zones_store_id ON geo_zones (store_id);

alter table ipn_history add column store_id varchar(64);
CREATE INDEX idxipn_history_store_id ON ipn_history (store_id);

alter table kk_audit add column store_id varchar(64);
CREATE INDEX idxkk_audit_store_id ON kk_audit (store_id);

alter table kk_category_to_tag_group add column store_id varchar(64);
CREATE INDEX idxkk_category_to_tag_group_store_id ON kk_category_to_tag_group (store_id);

alter table kk_customer_group add column store_id varchar(64);
CREATE INDEX idxkk_customer_group_store_id ON kk_customer_group (store_id);

alter table kk_customers_to_role add column store_id varchar(64);
CREATE INDEX idxkk_customers_to_role_store_id ON kk_customers_to_role (store_id);

alter table kk_digital_download add column store_id varchar(64);
CREATE INDEX idxkk_digital_download_store_id ON kk_digital_download (store_id);

alter table kk_product_feed add column store_id varchar(64);
CREATE INDEX idxkk_product_feed_store_id ON kk_product_feed (store_id);

alter table kk_role_to_api_call add column store_id varchar(64);
CREATE INDEX idxkk_role_to_api_call_store_id ON kk_role_to_api_call (store_id);

alter table kk_role_to_panel add column store_id varchar(64);
CREATE INDEX idxkk_role_to_panel_store_id ON kk_role_to_panel (store_id);

alter table kk_tag add column store_id varchar(64);
CREATE INDEX idxkk_tag_store_id ON kk_tag (store_id);

alter table kk_tag_group add column store_id varchar(64);
CREATE INDEX idxkk_tag_group_store_id ON kk_tag_group (store_id);

alter table kk_tag_group_to_tag add column store_id varchar(64);
CREATE INDEX idxkk_tag_group_to_tag_store_id ON kk_tag_group_to_tag (store_id);

alter table kk_tag_to_product add column store_id varchar(64);
CREATE INDEX idxkk_tag_to_product_store_id ON kk_tag_to_product (store_id);

alter table languages add column store_id varchar(64);
CREATE INDEX idxlanguages_store_id ON languages (store_id);

alter table manufacturers add column store_id varchar(64);
CREATE INDEX idxmanufacturers_store_id ON manufacturers (store_id);

alter table manufacturers_info add column store_id varchar(64);
CREATE INDEX idxmanufacturers_info_store_id ON manufacturers_info (store_id);

alter table newsletters add column store_id varchar(64);
CREATE INDEX idxnewsletters_store_id ON newsletters (store_id);

alter table orders add column store_id varchar(64);
CREATE INDEX idxorders_store_id ON orders (store_id);

alter table orders_products add column store_id varchar(64);
CREATE INDEX idxorders_products_store_id ON orders_products (store_id);

alter table orders_products_attributes add column store_id varchar(64);
CREATE INDEX idxorders_products_attributes_store_id ON orders_products_attributes (store_id);

alter table orders_products_download add column store_id varchar(64);
CREATE INDEX idxorders_products_download_store_id ON orders_products_download (store_id);

alter table orders_returns add column store_id varchar(64);
CREATE INDEX idxorders_returns_store_id ON orders_returns (store_id);

alter table orders_status add column store_id varchar(64);
CREATE INDEX idxorders_status_store_id ON orders_status (store_id);

alter table orders_status_history add column store_id varchar(64);
CREATE INDEX idxorders_status_history_store_id ON orders_status_history (store_id);

alter table orders_total add column store_id varchar(64);
CREATE INDEX idxorders_total_store_id ON orders_total (store_id);

alter table products add column store_id varchar(64);
CREATE INDEX idxproducts_store_id ON products (store_id);

alter table products_attributes add column store_id varchar(64);
CREATE INDEX idxproducts_attributes_store_id ON products_attributes (store_id);

alter table products_attributes_download add column store_id varchar(64);
CREATE INDEX idxproducts_attributes_download_store_id ON products_attributes_download (store_id);

alter table products_description add column store_id varchar(64);
CREATE INDEX idxproducts_description_store_id ON products_description (store_id);

alter table products_notifications add column store_id varchar(64);
CREATE INDEX idxproducts_notifications_store_id ON products_notifications (store_id);

alter table products_options add column store_id varchar(64);
CREATE INDEX idxproducts_options_store_id ON products_options (store_id);

alter table products_options_values add column store_id varchar(64);
CREATE INDEX idxproducts_options_values_store_id ON products_options_values (store_id);

alter table products_options_values_to_products_options add column store_id varchar(64);
CREATE INDEX idxproducts_options_values_to_products_options_store_id ON products_options_values_to_products_options (store_id);

alter table products_quantity add column store_id varchar(64);
CREATE INDEX idxproducts_quantity_store_id ON products_quantity (store_id);

alter table products_to_categories add column store_id varchar(64);
CREATE INDEX idxproducts_to_categories_store_id ON products_to_categories (store_id);

alter table products_to_products add column store_id varchar(64);
CREATE INDEX idxproducts_to_products_store_id ON products_to_products (store_id);

alter table promotion add column store_id varchar(64);
CREATE INDEX idxpromotion_store_id ON promotion (store_id);

alter table promotion_to_category add column store_id varchar(64);
CREATE INDEX idxpromotion_to_category_store_id ON promotion_to_category (store_id);

alter table promotion_to_coupon add column store_id varchar(64);
CREATE INDEX idxpromotion_to_coupon_store_id ON promotion_to_coupon (store_id);

alter table promotion_to_cust_group add column store_id varchar(64);
CREATE INDEX idxpromotion_to_cust_group_store_id ON promotion_to_cust_group (store_id);

alter table promotion_to_customer add column store_id varchar(64);
CREATE INDEX idxpromotion_to_customer_store_id ON promotion_to_customer (store_id);

alter table promotion_to_manufacturer add column store_id varchar(64);
CREATE INDEX idxpromotion_to_manufacturer_store_id ON promotion_to_manufacturer (store_id);

alter table promotion_to_product add column store_id varchar(64);
CREATE INDEX idxpromotion_to_product_store_id ON promotion_to_product (store_id);

alter table returns_to_ord_prods add column store_id varchar(64);
CREATE INDEX idxreturns_to_ord_prods_store_id ON returns_to_ord_prods (store_id);

alter table reviews add column store_id varchar(64);
CREATE INDEX idxreviews_store_id ON reviews (store_id);

alter table reviews_description add column store_id varchar(64);
CREATE INDEX idxreviews_description_store_id ON reviews_description (store_id);

alter table sessions add column store_id varchar(64);
CREATE INDEX idxsessions_store_id ON sessions (store_id);

alter table specials add column store_id varchar(64);
CREATE INDEX idxspecials_store_id ON specials (store_id);

alter table tax_class add column store_id varchar(64);
CREATE INDEX idxtax_class_store_id ON tax_class (store_id);

alter table tax_rates add column store_id varchar(64);
CREATE INDEX idxtax_rates_store_id ON tax_rates (store_id);

--alter table utility add column store_id varchar(64);
--alter table utility add key idx_store_id (store_id);

alter table whos_online add column store_id varchar(64);
CREATE INDEX idxwhos_online_store_id ON whos_online (store_id);

alter table zones add column store_id varchar(64);
CREATE INDEX idxzones_store_id ON zones (store_id);

alter table zones_to_geo_zones add column store_id varchar(64);
CREATE INDEX idxzones_to_geo_zones_store_id ON zones_to_geo_zones (store_id);

-- kk_store table for holding store instance information for multi-store
DROP TABLE IF EXISTS kk_store;
CREATE TABLE kk_store (
  store_id varchar(64) NOT NULL,
  store_name varchar(64) NOT NULL,
  store_desc varchar(128) NOT NULL,
  store_enabled integer NOT NULL,
  store_under_maint integer NOT NULL,
  store_deleted integer NOT NULL,
  store_template integer NOT NULL,
  store_admin_email varchar(96),
  store_css_filename varchar(128),
  store_logo_filename varchar(128),
  store_url varchar(128),
  store_home varchar(64),
  store_max_products integer NOT NULL DEFAULT '-1',
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  date_added timestamp,
  last_updated timestamp,
  PRIMARY KEY (store_id)
);

INSERT INTO kk_store (store_id, store_name, store_desc, store_enabled, store_under_maint, store_deleted, store_template, store_admin_email, store_logo_filename, store_css_filename, store_home, date_added) VALUES ('store1','store1','Store Number One', 1,0,0,0, 'admin@konakart.com', 'logo.png', 'style.css', 'derby', now());

-- MultiStore Template StoreId
delete from configuration where configuration_key = 'MULTISTORE_TEMPLATE_STORE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Multi-Store Template Store', 'MULTISTORE_TEMPLATE_STORE', 'store1', 'This is the storeId of the template store used when creating new stores in a multi-store installation', '25', '5', now());

-- MultiStore Admin Role
delete from configuration where configuration_key = 'MULTISTORE_ADMIN_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Admin Role', 'MULTISTORE_ADMIN_ROLE_IDX', '5', 'Defines the Role given to Admin users of new stores', '25', '6', 'Roles', now());

-- MultiStore Super User Role
delete from configuration where configuration_key = 'MULTISTORE_SUPER_USER_ROLE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Multi-Store Super User Role', 'MULTISTORE_SUPER_USER_ROLE_IDX', '1', 'Defines the Role given to Super User user of new stores', '25', '6', 'Roles', now());

-- Filenames for new store sql
delete from configuration where configuration_key = 'KK_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('KonaKart new store creation SQL','KK_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_new_store.sql','Filename containing the KonaKart new store creation SQL commands','25', '10', now());
delete from configuration where configuration_key = 'USER_NEW_STORE_SQL_FILENAME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('User new store creation SQL','USER_NEW_STORE_SQL_FILENAME','C:/Program Files/KonaKart/database/MySQL/konakart_user_new_store.sql','Filename containing the user defined new store creation SQL commands - these are executed after the KonaKart cloning commands','25', '11', now());

-- Table for wish list
DROP TABLE IF EXISTS kk_wishlist;
CREATE TABLE kk_wishlist (
  kk_wishlist_id SERIAL,
  store_id varchar(64),
  customers_id integer NOT NULL,
  name varchar(128),
  description varchar(255),
  public_or_private integer NOT NULL,
  date_added timestamp NOT NULL,
  customers_firstname varchar(32),
  customers_lastname varchar(32),
  customers_dob timestamp,
  customers_city varchar(32),
  customers_state varchar(32),
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  PRIMARY KEY (kk_wishlist_id)
);

-- Table for wish list items
DROP TABLE IF EXISTS kk_wishlist_item;
CREATE TABLE kk_wishlist_item (
  kk_wishlist_item_id SERIAL,
  store_id varchar(64),
  kk_wishlist_id integer NOT NULL,
  products_id varchar(255) NOT NULL,
  priority integer,
  date_added timestamp NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  PRIMARY KEY (kk_wishlist_item_id)
);

-- Enable / Disable wish list functionality from application
delete from configuration where configuration_key = 'ENABLE_WISHLIST';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Wish List functionality', 'ENABLE_WISHLIST', 'false', 'When set to true, wish list functionality is enabled in the application', '1', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', now());

-- Add column to orders table for order number
ALTER TABLE orders add column orders_number varchar(128);

-- Orders Panel Show Order Number or Order Id
delete from configuration where configuration_key = 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Display Order Number', 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM', '', 'When this is set, the order number is displayed in the orders panel rather than the order id', '21', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', now());

-- Panels for Managing Stores in a Multi-Store Environment
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added) VALUES (1, 83, 1,1,1,1, 'Set to allow admin of all stores', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (DEFAULT, 'kk_panel_editStore','Edit a Store in a Mall', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (DEFAULT, 'kk_panel_insertStore','Insert a Store in a Mall', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (DEFAULT, 'kk_panel_multistoreConfig','Multi-Store Configuration', now());

-- API calls for Multi-Store Store Maintenance
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getMallStores','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertMallStore','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteMallStore','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateMallStore','', now());

-- Add language code to products_description
ALTER TABLE products_description add column language_code char(2);

update products_description set language_code = 'en' where language_id = 1;
update products_description set language_code = 'de' where language_id = 2;
update products_description set language_code = 'es' where language_id = 3;

-- Admin Store Integration Class
delete from configuration where configuration_key = 'ADMIN_STORE_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Store Integration Class', 'ADMIN_STORE_INTEGRATION_CLASS','com.konakartadmin.bl.AdminStoreIntegrationMgr','The Store Integration Implementation Class, to allow custom store maintenance function', '25', '7', now());

-- Add super_user and 5 custom fields to kk_role
ALTER TABLE kk_role add column super_user integer;
ALTER TABLE kk_role add column custom1 varchar(128);
ALTER TABLE kk_role add column custom2 varchar(128);
ALTER TABLE kk_role add column custom3 varchar(128);
ALTER TABLE kk_role add column custom4 varchar(128);
ALTER TABLE kk_role add column custom5 varchar(128);
update kk_role set super_user = 1 where name = 'Super User';

-- API call for forcing registration of admin users even if already registered
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'forceRegisterCustomer','', now());

-- Reports re-located for MultiStore
UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/webapps/birtviewer/reports/stores/store1/' where configuration_key = 'REPORTS_DEFN_PATH';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/frameset?__report=reports/stores/store1/' where configuration_key = 'REPORTS_URL';
UPDATE configuration set configuration_value = 'http://localhost:8780/birtviewer/run?__report=reports/stores/store1/OrdersInLast30DaysChart.rptdesign&storeId=store1' where configuration_key = 'REPORTS_STATUS_PAGE_URL';

-- Add the custom1 privilege to enable/disable the reading and editing of custom fields and order number on the Edit Order Panel
UPDATE kk_role_to_panel set custom2=0, custom2_desc='Set to allow read and edit of custom fields and order number' where panel_id=17;

-- KonaKart Home Directory
delete from configuration where configuration_key = 'INSTALLATION_HOME';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('KonaKart Installation Home', 'INSTALLATION_HOME','C:/Program Files/KonaKart/','The home directory of this KonaKart Installation', '1', '26', now());



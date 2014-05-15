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
-- From version 4.0.0.0 to version 4.1.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 4.0.0.0, the upgrade
-- scripts must be run sequentially.
-- 
DROP TABLE IF EXISTS kk_product_to_stores;
CREATE TABLE kk_product_to_stores (
  store_id varchar(64) NOT NULL,
  products_id integer NOT NULL,
  price_id integer NOT NULL DEFAULT '-1',
  PRIMARY KEY (store_id, products_id)
);

-- New Multi-Store Shared Products APIs
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProductsToStores','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductsToStores','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeProductsToStores','', now());

-- New Categories to Tag Groups API
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCategoriesToTagGroups','', now());

-- Modifications for gift registry support
alter table customers_basket add column kk_wishlist_id int;
alter table orders_products add column kk_wishlist_id int;
alter table customers_basket add column kk_wishlist_item_id int;
alter table orders_products add column kk_wishlist_item_id int;

alter table kk_wishlist add column customers1_firstname varchar(32);
alter table kk_wishlist add column customers1_lastname varchar(32);
alter table kk_wishlist add column link_url varchar(255);
alter table kk_wishlist add column list_type int;
alter table kk_wishlist add column address_id int;
alter table kk_wishlist add column event_date timestamp;

alter table kk_wishlist_item add column quantity_desired int;
alter table kk_wishlist_item add column quantity_bought int;
alter table kk_wishlist_item add column comments varchar(255);

-- Enable / Disable gift registry functionality from application
delete from configuration where configuration_key = 'ENABLE_GIFT_REGISTRY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Gift Registry functionality', 'ENABLE_GIFT_REGISTRY', 'false', 'When set to true, gift registry functionality is enabled in the application', '1', '26', 'tep_cfg_select_option(array(''true'', ''false''), ', now());

-- Maximum number of gift registries displayed in a search
delete from configuration where configuration_key = 'MAX_DISPLAY_GIFT_REGISTRIES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Gift Registry Search', 'MAX_DISPLAY_GIFT_REGISTRIES', '6', 'Maximum number of gift registries to display', '3', '24', 'integer(0,null)', now());

-- New Insert Order API
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertOrder','', now());


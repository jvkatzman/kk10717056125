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
-- From version 2.2.0.2 to version 2.2.0.3
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.2, the upgrade
-- scripts must be run sequentially.
-- 
DROP TABLE IF EXISTS products_to_products;
CREATE TABLE products_to_products (
  products_to_products_id SERIAL,
  id_from integer NOT NULL,
  id_to integer NOT NULL,
  relation_type integer DEFAULT '0' NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  PRIMARY KEY (products_to_products_id)
);

-- Max number of items to display for merchandising
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Up Sell Products', 'MAX_DISPLAY_UP_SELL', '6', 'Maximum number of products to display in the ''Top of Range'' box', '3', '20', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Cross Sell Products', 'MAX_DISPLAY_CROSS_SELL', '6', 'Maximum number of products to display in the ''Similar Products'' box', '3', '21', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Accessories', 'MAX_DISPLAY_ACCESSORIES', '6', 'Maximum number of products to display in the ''Accessories'' box', '3', '22', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Dependent Products', 'MAX_DISPLAY_DEPENDENT_PRODUCTS', '6', 'Maximum number of products to display in the ''Warranties'' box', '3', '23', 'integer(0,null)', now());

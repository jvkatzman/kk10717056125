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
-- From version 5.0.0.0 to version 5.1.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.0.0.0, the upgrade
-- scripts must be run sequentially.
-- 

UPDATE configuration SET configuration_value='8783' WHERE configuration_key = 'SSL_PORT_NUMBER' AND configuration_value = '8443';
UPDATE configuration SET configuration_value='https://localhost:8783/konakart/AdminLoginSubmit.do' WHERE configuration_key = 'ADMIN_APP_LOGIN_BASE_URL' AND configuration_value = 'https://localhost:8443/konakart/AdminLoginSubmit.do';

-- Add attribute to determine whether to use basket price or product price
ALTER TABLE customers_basket ADD use_basket_price int DEFAULT 0;

-- Allow usage of basket price
DELETE FROM configuration where configuration_key = 'ALLOW_BASKET_PRICE';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Allow using the basket price', 'ALLOW_BASKET_PRICE', 'false', 'Allows you to define the price in the basket object when adding a product to the basket', 18, 8, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add attribute to set the default behavior of the admin app when changing order status
ALTER TABLE orders_status ADD notify_customer int DEFAULT 0;

-- Add special price expiry date
ALTER TABLE specials ADD starts_date TIMESTAMP DEFAULT NULL;

-- Add a new key to the external product prices
-- Whilst this is easy to do with some databases it isn't with others hence this portable approach
-- Create a temporary table for saving any existing data
DROP TABLE kk_product_prices_tmp;
CREATE TABLE kk_product_prices_tmp (
  store_id VARCHAR(64),
  catalog_id VARCHAR(32) NOT NULL,
  products_id INTEGER NOT NULL,
  products_attributes_id INTEGER NOT NULL,
  tier_price_id INTEGER DEFAULT 0 NOT NULL,
  products_price_0 decimal(15,4),
  products_price_1 decimal(15,4),
  products_price_2 decimal(15,4),
  products_price_3 decimal(15,4)
);

-- Copy the existing data to the temporary table for safe keeping
INSERT INTO kk_product_prices_tmp (store_id, catalog_id, products_id, products_attributes_id, tier_price_id, products_price_0, products_price_1, products_price_2, products_price_3) SELECT store_id, catalog_id, products_id, products_attributes_id, 0, products_price_0, products_price_1, products_price_2, products_price_3 FROM kk_product_prices;

-- Now Re-create Product Price Table with a new key
DROP TABLE kk_product_prices;
CREATE TABLE kk_product_prices (
  store_id VARCHAR(64),
  catalog_id VARCHAR(32) NOT NULL,
  products_id INTEGER NOT NULL,
  products_attributes_id INTEGER NOT NULL,
  tier_price_id INTEGER DEFAULT 0 NOT NULL,
  products_price_0 decimal(15,4),
  products_price_1 decimal(15,4),
  products_price_2 decimal(15,4),
  products_price_3 decimal(15,4),
  PRIMARY KEY(catalog_id, products_id, products_attributes_id, tier_price_id)
);

-- Load the data saved in the temporary table
INSERT INTO kk_product_prices SELECT * FROM kk_product_prices_tmp;

-- Finally remove the temporary table
DROP TABLE kk_product_prices_tmp;

-- Add a tier price table
DROP TABLE kk_tier_price;
CREATE TABLE kk_tier_price (
  kk_tier_price_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  products_id INTEGER NOT NULL,
  products_quantity INTEGER NOT NULL,
  tier_price decimal(15,4),
  tier_price_1 decimal(15,4),
  tier_price_2 decimal(15,4),
  tier_price_3 decimal(15,4),
  use_percentage_discount int,
  custom1 VARCHAR(128),
  date_added TIMESTAMP NOT NULL,
  last_modified TIMESTAMP,
  PRIMARY KEY(kk_tier_price_id)
);
DROP SEQUENCE kk_tier_price_SEQ;
CREATE SEQUENCE kk_tier_price_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Add discount attribute to Orders Products table
ALTER TABLE orders_products ADD discount_percent decimal(15,4);

-- To correct a problem where sometimes the wrong database scripts were defined when not using MySQL
UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/database/DB2/konakart_new_store_cs.sql' where configuration_key = 'KK_NEW_STORE_SQL_FILENAME' and configuration_value = 'C:/Program Files/KonaKart/database/MySQL/konakart_new_store_cs.sql';
--MSSSQL UPDATE configuration set configuration_value = 'C:/Program Files/KonaKart/database/MSSqlServer/konakart_new_store_cs.sql' where configuration_key = 'KK_NEW_STORE_SQL_FILENAME' and configuration_value = 'C:/Program Files/KonaKart/database/MySQL/konakart_new_store_cs.sql';

-- Set the rule for calculating tax
DELETE FROM configuration where configuration_key = 'TAX_QUANTITY_RULE';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Tax Quantity Rule', 'TAX_QUANTITY_RULE', '1', 'Tax calculated on total=1\nTax calculated per item and then rounded=2', 9, 13, 'integer(1,2), ', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Set the number of decimal places for currency in the admin app
DELETE FROM configuration where configuration_key = 'ADMIN_CURRENCY_DECIMAL_PLACES';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'No of decimal places for currency', 'ADMIN_CURRENCY_DECIMAL_PLACES', '2', 'No of decimal places allowed for entering prices in the admin app', 1, 27, 'integer(0,9), ', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add extra street address to various tables
ALTER TABLE address_book ADD entry_street_address_1 varchar(64);
ALTER TABLE orders ADD customers_street_address_1 varchar(64);
ALTER TABLE orders ADD delivery_street_address_1 varchar(64);
ALTER TABLE orders ADD billing_street_address_1 varchar(64);

-- Config variable to decide whether to show 2nd street address
DELETE FROM configuration where configuration_key = 'ACCOUNT_STREET_ADDRESS_1';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Street Address 1', 'ACCOUNT_STREET_ADDRESS_1', 'false', 'Display 2nd street address in the customers account', 5, 4, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Config variable to define min length of 2nd street address
DELETE FROM configuration where configuration_key = 'ENTRY_STREET_ADDRESS1_MIN_LENGTH';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Street Address 1', 'ENTRY_STREET_ADDRESS1_MIN_LENGTH', '5', 'Minimum length of street address 1', 2, 5, 'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Addition of custom fields to products_attributes
ALTER TABLE products_attributes ADD custom1 varchar(128);
ALTER TABLE products_attributes ADD custom2 varchar(128);

-- Addition of custom fields to products_options
ALTER TABLE products_options ADD custom1 varchar(128);
ALTER TABLE products_options ADD custom2 varchar(128);

-- Addition of custom fields to products_options_values
ALTER TABLE products_options_values ADD custom1 varchar(128);
ALTER TABLE products_options_values ADD custom2 varchar(128);

-- Config variable to issue warning for matching SKUs in Admin App
DELETE FROM configuration where configuration_key = 'ADMIN_APP_WARN_OF_DUPLICATE_SKUS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Warn of Duplicate SKUs', 'ADMIN_APP_WARN_OF_DUPLICATE_SKUS', 'false', 'Issue warning in Admin App of duplicate SKUs', 21, 32, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Move the Rich Text Editor Configuration Variable to the Admn App Configuration Panel
UPDATE configuration set configuration_group_id = 21, sort_order = 32 where configuration_key = 'RICH_TEXT_EDITOR' and configuration_group_id = 9;

exit;

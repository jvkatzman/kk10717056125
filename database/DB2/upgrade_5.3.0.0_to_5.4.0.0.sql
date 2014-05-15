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
-- From version 5.3.0.0 to version 5.4.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.3.0.0, the upgrade
-- scripts must be run sequentially.
-- 

DELETE FROM configuration where configuration_key = 'RICH_TEXT_EDITOR';

-- Extend the size of the products_name field
ALTER TABLE products_description ALTER COLUMN products_name SET DATA TYPE VARCHAR(256);

-- For the New Google Shopping Interface
DELETE FROM configuration WHERE configuration_key = 'GOOGLE_DATA_ACCOUNT_ID';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Google Shopping Account Id', 'GOOGLE_DATA_ACCOUNT_ID', '', 'Account Id (obtain from Google) for populating Google Shopping with Product Information', 23, 3,  current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Move the two Google Base configs to the end
UPDATE configuration set sort_order = 100 where configuration_key = 'GOOGLE_API_KEY';
UPDATE configuration set sort_order = 101 where configuration_key = 'GOOGLE_DATA_LOCATION';

-- For defining the height of the Custom Panels
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_CUSTOM_PANEL_HEIGHT';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Custom Panel Height', 'ADMIN_APP_CUSTOM_PANEL_HEIGHT', '500px', 'Custom Panel Height eg. 100% or 700px etc', 22, 20,  current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

--Add tax code to tax_class table and order_product
ALTER TABLE tax_class ADD tax_code VARCHAR(64);
ALTER TABLE orders_products ADD tax_code VARCHAR(64);

--Add lifecycle_id to order table
ALTER TABLE orders ADD lifecycle_id VARCHAR(128);

-- Add custom fields to product to stores
ALTER TABLE kk_product_to_stores ADD custom1 varchar(128);
ALTER TABLE kk_product_to_stores ADD custom2 varchar(128);
ALTER TABLE kk_product_to_stores ADD custom3 varchar(128);

-- Add custom privileges for the Customer and CustomerForOrder panels - default to allow access to Reviews button
UPDATE kk_role_to_panel SET custom4=0, custom4_desc='If set reviews button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customers');
UPDATE kk_role_to_panel SET custom4=0, custom4_desc='If set reviews button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerForOrder');
-- Virtual CustomerForOrder 2 Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_customerForOrder_2', 'Customer For Order 2', current timestamp);

-- Add Panel access to all roles that can access the CustomerForOrders panel - default to not allow access to invisible customers
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, 0, 'Set to Access Invisible Customers', current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customerForOrder' and p2.code='kk_panel_customerForOrder_2';

-- Add custom privileges for the Customer2 and CustomerForOrder2 panels - default to allow access to Reviews button
UPDATE kk_role_to_panel SET custom2_desc='If set reviews button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customers_2');
UPDATE kk_role_to_panel SET custom2_desc='If set reviews button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerForOrder_2');

-- Add custom privileges for the Customer and CustomerForOrder panels - default to allow access to Login button
UPDATE kk_role_to_panel SET custom4_desc='If set login button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customers');
UPDATE kk_role_to_panel SET custom4_desc='If set login button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerForOrder');

-- Add custom privileges for the Customer and CustomerForOrder panels - default to allow access to Addresses button
UPDATE kk_role_to_panel SET custom5_desc='If set addresses button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customers');
UPDATE kk_role_to_panel SET custom5_desc='If set addresses button is hidden' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerForOrder');

-- Add custom privilege description for the CustomerOrders panel - default to allow access to Packing List and Invoice buttons
-- Do not update the privilege setting just in case it is already being used
UPDATE kk_role_to_panel SET custom1_desc='If set packing list button not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerOrders');
UPDATE kk_role_to_panel SET custom2_desc='If set invoice button not shown'      WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_customerOrders');

-- Add custom privileges for the Promotions panel - default to allow access to Coupons and Gift Certificates buttons
UPDATE kk_role_to_panel SET custom1_desc='If set coupons button not shown'           WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_promotions');
UPDATE kk_role_to_panel SET custom2_desc='If set gift certificates button not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_promotions');

-- Add custom privileges for the Products panel - default to allow access to Reviews and Addresses buttons
UPDATE kk_role_to_panel SET custom1_desc='If set reviews button not shown'   WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_products');
UPDATE kk_role_to_panel SET custom2_desc='If set addresses button not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_products');

-- For defining the number of suggested search terms to show
DELETE FROM configuration WHERE configuration_key = 'MAX_NUM_SUGGESTED_SEARCH_ITEMS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Suggested Search Items','MAX_NUM_SUGGESTED_SEARCH_ITEMS','10','Max number of suggested search items to display',3, 3,'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Table for bookable products
DROP TABLE kk_bookable_prod;
CREATE TABLE kk_bookable_prod (
  products_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  max_num_bookings INTEGER DEFAULT -1,
  bookings_made INTEGER DEFAULT 0,
  monday VARCHAR(128),
  tuesday VARCHAR(128),
  wednesday VARCHAR(128),
  thursday VARCHAR(128),
  friday VARCHAR(128),
  saturday VARCHAR(128),
  sunday VARCHAR(128),
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  PRIMARY KEY(products_id)
   );

-- Table for bookings
DROP TABLE kk_booking;
CREATE TABLE kk_booking (
  booking_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  products_id INTEGER NOT NULL,
  quantity INTEGER DEFAULT 0,
  customers_id INTEGER DEFAULT 0,
  orders_id INTEGER DEFAULT 0,
  orders_products_id INTEGER DEFAULT 0,
  firstname VARCHAR(32),
  lastname VARCHAR(32),
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  date_added TIMESTAMP,
  PRIMARY KEY(booking_id)
   );
DROP SEQUENCE kk_booking_SEQ;
CREATE SEQUENCE kk_booking_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;


exit;

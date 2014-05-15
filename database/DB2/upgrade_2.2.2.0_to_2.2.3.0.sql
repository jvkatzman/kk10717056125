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
-- From version 2.2.2.0 to version 2.2.3.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.2.0, the upgrade
-- scripts must be run sequentially.
-- 

ALTER TABLE kk_customer_group add custom1 varchar(128);
ALTER TABLE kk_customer_group add custom2 varchar(128);
ALTER TABLE kk_customer_group add custom3 varchar(128);
ALTER TABLE kk_customer_group add custom4 varchar(128);
ALTER TABLE kk_customer_group add custom5 varchar(128);

-- Addition of price_id to customer group

ALTER TABLE kk_customer_group add price_id int DEFAULT 0;

-- Addition of new price fields to product and order product

ALTER TABLE products add products_price_1 decimal(15,4);
ALTER TABLE products add products_price_2 decimal(15,4);
ALTER TABLE products add products_price_3 decimal(15,4);

ALTER TABLE orders_products add products_price_0 decimal(15,4);
ALTER TABLE orders_products add products_price_1 decimal(15,4);
ALTER TABLE orders_products add products_price_2 decimal(15,4);
ALTER TABLE orders_products add products_price_3 decimal(15,4);

ALTER TABLE products_attributes add options_values_price_1 decimal(15,4);
ALTER TABLE products_attributes add options_values_price_2 decimal(15,4);
ALTER TABLE products_attributes add options_values_price_3 decimal(15,4);

-- Add a new customer group panel
set echo on
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_custGroups','Customer Groups', current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 63, 1,1,1,current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 63, 1,1,1,current timestamp);

-- Address format template for address in admin app
delete from configuration where configuration_key = 'ADMIN_APP_ADDRESS_FORMAT';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Address Format for Admin App', 'ADMIN_APP_ADDRESS_FORMAT', '$streets,$city,$postcode', 'How the address is formatted in the customers panel', 21, 0, current timestamp);

-- Add a new configuration panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_adminAppConfig','Configure Admin App', current timestamp);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 64, 1,1,1,current timestamp);

-- Config variables for Admin customer login
delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_BASE_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Base URL for logging into the App', 'ADMIN_APP_LOGIN_BASE_URL', 'https://localhost:8443/konakart/AdminLoginSubmit.do', 'Base URL for logging into the App from the Admin App', 21, 1, current timestamp);

delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_WINDOW_FEATURES';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'Window features', 'ADMIN_APP_LOGIN_WINDOW_FEATURES', 'resizable=yes,scrollbars=yes,status=yes,toolbar=yes,location=yes', 'Comma separated features for the application window opened by the login feature of the admin app', 21, 2, current timestamp);

exit;

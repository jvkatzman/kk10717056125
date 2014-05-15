# (c) 2006 DS Data Systems UK Ltd, All rights reserved.
# 
# DS Data Systems and KonaKart and their respective logos, are
# trademarks of DS Data Systems UK Ltd. All rights reserved.
# 
# The information in this document below this text is free software; you can redistribute
# it and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# -----------------------------------------------------------
# KonaKart upgrade database script for MS Sql Server
# From version 2.2.2.0 to version 2.2.3.0
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.2.0, the upgrade
# scripts must be run sequentially.
# 

ALTER TABLE kk_customer_group add custom1 varchar(128);
ALTER TABLE kk_customer_group add custom2 varchar(128);
ALTER TABLE kk_customer_group add custom3 varchar(128);
ALTER TABLE kk_customer_group add custom4 varchar(128);
ALTER TABLE kk_customer_group add custom5 varchar(128);

-- Addition of price_id to customer group

ALTER TABLE kk_customer_group add price_id int default '0';

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
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custGroups','Customer Groups', getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 63, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 63, 1,1,1,getdate());

-- Address format template for address in admin app
delete from configuration where configuration_key = 'ADMIN_APP_ADDRESS_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Address Format for Admin App', 'ADMIN_APP_ADDRESS_FORMAT', '$streets,$city,$postcode', 'How the address is formatted in the customers panel', '21', '0', getdate());

-- Add a new configuration panel
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_adminAppConfig','Configure Admin App', getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 64, 1,1,1,getdate());

-- Config variables for Admin customer login
delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_BASE_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Base URL for logging into the App', 'ADMIN_APP_LOGIN_BASE_URL', 'https://localhost:8443/konakart/AdminLoginSubmit.do', 'Base URL for logging into the App from the Admin App', '21', '1', getdate());

delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_WINDOW_FEATURES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Window features', 'ADMIN_APP_LOGIN_WINDOW_FEATURES', 'resizable=yes,scrollbars=yes,status=yes,toolbar=yes,location=yes', 'Comma separated features for the application window opened by the login feature of the admin app', '21', '2', getdate());

exit;

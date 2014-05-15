#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.2.0 to version 2.2.3.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.2.0, the upgrade 
# scripts must be run sequentially


# Addition of custom fields to customer group

ALTER TABLE kk_customer_group add column custom1 varchar(128);
ALTER TABLE kk_customer_group add column custom2 varchar(128);
ALTER TABLE kk_customer_group add column custom3 varchar(128);
ALTER TABLE kk_customer_group add column custom4 varchar(128);
ALTER TABLE kk_customer_group add column custom5 varchar(128);

# Addition of price_id to customer group

ALTER TABLE kk_customer_group add column price_id int default '0';

# Addition of new price fields to product and order product

ALTER TABLE products add column products_price_1 decimal(15,4);
ALTER TABLE products add column products_price_2 decimal(15,4);
ALTER TABLE products add column products_price_3 decimal(15,4);

ALTER TABLE orders_products add column products_price_0 decimal(15,4);
ALTER TABLE orders_products add column products_price_1 decimal(15,4);
ALTER TABLE orders_products add column products_price_2 decimal(15,4);
ALTER TABLE orders_products add column products_price_3 decimal(15,4);

ALTER TABLE products_attributes add column options_values_price_1 decimal(15,4);
ALTER TABLE products_attributes add column options_values_price_2 decimal(15,4);
ALTER TABLE products_attributes add column options_values_price_3 decimal(15,4);

# Add a new customer group panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (63, 'kk_panel_custGroups','Customer Groups', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 63, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 63, 1,1,1,now());

# Address format template for address in admin app
delete from configuration where configuration_key = 'ADMIN_APP_ADDRESS_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Address Format for Admin App', 'ADMIN_APP_ADDRESS_FORMAT', '$streets,$city,$postcode', 'How the address is formatted in the customers panel', '21', '0', now());

# Add a new configuration panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (64, 'kk_panel_adminAppConfig','Configure Admin App', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 64, 1,1,1,now());

# Config variables for Admin customer login
delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_BASE_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Base URL for logging into the App', 'ADMIN_APP_LOGIN_BASE_URL', 'https://localhost:8443/konakart/AdminLoginSubmit.do', 'Base URL for logging into the App from the Admin App', '21', '1', now());

delete from configuration where configuration_key = 'ADMIN_APP_LOGIN_WINDOW_FEATURES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Window features', 'ADMIN_APP_LOGIN_WINDOW_FEATURES', 'resizable=yes,scrollbars=yes,status=yes,toolbar=yes,location=yes', 'Comma separated features for the application window opened by the login feature of the admin app', '21', '2', now());


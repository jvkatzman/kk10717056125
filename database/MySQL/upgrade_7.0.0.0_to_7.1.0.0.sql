#----------------------------------------------------------------
# KonaKart upgrade script from version 7.0.0.0 to version 7.1.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade scripts
# must be run sequentially
#

# Set database version information
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '7.1.0.0 U', now());
UPDATE kk_config SET kk_config_value='7.1.0.0 MySQL', date_added=now() WHERE kk_config_key='VERSION';

# Add extra attributes to Order for multi-vendor mode
ALTER TABLE orders ADD COLUMN store_name VARCHAR(64);
ALTER TABLE orders ADD COLUMN parent_id int DEFAULT 0;

# Configuration variable to enable multi-vendor mode
DELETE FROM configuration WHERE configuration_key = 'MULTI_VENDOR_MODE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT 'Enable multi-vendor mode','MULTI_VENDOR_MODE','false','Set to true to enable multi-vendor mode. KK Engine must be in shared products mode.','1', '35', 'choice(\'true\', \'false\')', now(), '1', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# Addr addr store id to address table
ALTER TABLE address_book ADD COLUMN addr_store_id varchar(64);

# New Velocity Templates Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_velocityTemplates','Maintain Velocity Templates', now());

# Add access to the Velocity Templates Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_velocityTemplates';

# New copyFile API
INSERT INTO kk_api_call (name, description, date_added) VALUES ('copyFile', '', now());

# Config variable for formatting store addresses in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_STORE_ADDR_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, return_by_api, store_id) SELECT 'Addr Format for Store Addr', 'ADMIN_APP_STORE_ADDR_FORMAT', '$street $street1 $suburb $city $state $country', 'How the address is formatted in the store address panel', '21', '1', now(), '0', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# Address Panel for stores
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_store_address', 'Store Addresses', now());

# Add Address Panel access to all roles that can access the Customer panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_store_address';

# Configuration variable to force login for storefront app
DELETE FROM configuration WHERE configuration_key = 'APP_FORCE_LOOGIN';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT 'Storefront force login','APP_FORCE_LOOGIN','false','Set to true to force customers to login in order to be able to use the storefront application.','1', '38', 'choice(\'true\', \'false\')', now(), '1', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';


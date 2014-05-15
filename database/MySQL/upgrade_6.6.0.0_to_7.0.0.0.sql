#----------------------------------------------------------------
# KonaKart upgrade script from version 6.6.0.0 to version 7.0.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade scripts
# must be run sequentially
#

# Set database version information
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '7.0.0.0 U', now());
UPDATE kk_config SET kk_config_value='7.0.0.0 MySQL', date_added=now() WHERE kk_config_key='VERSION';

# Align configuration parameters between store1 and store2 - not always present
UPDATE configuration SET configuration_group_id=12 WHERE configuration_key='EMAIL_FROM' AND store_id='store2';
UPDATE configuration SET configuration_group_id=12 WHERE configuration_key='SEND_EXTRA_EMAILS_TO' AND store_id='store2';
UPDATE configuration SET configuration_group_id=21 WHERE configuration_key='ADMIN_CURRENCY_DECIMAL_PLACES' AND store_id='store2';

UPDATE configuration SET configuration_title='Enable Reward Points' WHERE configuration_key='ENABLE_REWARD_POINTS' AND store_id='store2';
UPDATE configuration SET configuration_title='Street Address 1' WHERE configuration_key='ENTRY_STREET_ADDRESS1_MIN_LENGTH' AND store_id='store2';
UPDATE configuration SET configuration_title='KonaKart cache refresh check interval' WHERE configuration_key='CLIENT_CONFIG_CACHE_CHECK_SECS' AND store_id='store2';
UPDATE configuration SET configuration_title='Store-Front base' WHERE configuration_key='STORE_FRONT_BASE' AND store_id='store2';
UPDATE configuration SET configuration_title='Store-Front image base' WHERE configuration_key='STORE_FRONT_IMG_BASE' AND store_id='store2';
UPDATE configuration SET configuration_title='Store-Front script base' WHERE configuration_key='STORE_FRONT_SCRIPT_BASE' AND store_id='store2';
UPDATE configuration SET configuration_title='Store-Front style sheet base' WHERE configuration_key='STORE_FRONT_STYLE_BASE' AND store_id='store2';
UPDATE configuration SET configuration_title='Mobile Store-Front script base' WHERE configuration_key='STORE_FRONT_SCRIPT_BASE_M' AND store_id='store2';
UPDATE configuration SET configuration_title='Mobile Store-Front style sheet base' WHERE configuration_key='STORE_FRONT_STYLE_BASE_M' AND store_id='store2';
UPDATE configuration SET configuration_title='Template Panel Default Num Templates' WHERE configuration_key='ADMIN_APP_TMPL_SEL_NUM_TMPLS' AND store_id='store2';
UPDATE configuration SET configuration_title='Template Panel Max Num Templates' WHERE configuration_key='ADMIN_APP_TMPL_SEL_MAX_NUM_TMPLS' AND store_id='store2';

UPDATE configuration SET sort_order=100 WHERE configuration_key='GOOGLE_API_KEY' AND store_id='store2';
UPDATE configuration SET sort_order=6 WHERE configuration_key='EMAIL_FROM' AND store_id='store2';
UPDATE configuration SET sort_order=101 WHERE configuration_key='GOOGLE_DATA_LOCATION' AND store_id='store2';
UPDATE configuration SET sort_order=6 WHERE configuration_key='MULTISTORE_ADMIN_ROLE_IDX' AND store_id='store2';
UPDATE configuration SET sort_order=6 WHERE configuration_key='MULTISTORE_SUPER_USER_ROLE_IDX' AND store_id='store2';
UPDATE configuration SET sort_order=6 WHERE configuration_key='SEND_EXTRA_EMAILS_TO' AND store_id='store2';
UPDATE configuration SET sort_order=40 WHERE configuration_key='ADMIN_CURRENCY_DECIMAL_PLACES' AND store_id='store2';

UPDATE configuration SET set_function='tep_cfg_select_option(array(\'true\', \'false\'), ' WHERE configuration_key='DD_DOWNLOAD_AS_ATTACHMENT' AND store_id='store2';
UPDATE configuration SET set_function='choice(\'true\', \'false\')' WHERE configuration_key='ENABLE_PDF_INVOICE_DOWNLOAD' AND store_id='store2';
UPDATE configuration SET set_function='choice(\'true\', \'false\')' WHERE configuration_key='DISPLAY_GIFT_CERT_ENTRY' AND store_id='store2';
UPDATE configuration SET set_function='choice(\'true\', \'false\')' WHERE configuration_key='USE_MSG_CAT_FOR_COUNTRY_NAMES' AND store_id='store2';
UPDATE configuration SET set_function='FileUpload' WHERE configuration_key='USER_NEW_STORE_SQL_FILENAME' AND store_id='store2';

# New DB table for allowing a product to be associated with multiple custom attribute templates
DROP TABLE IF EXISTS kk_product_to_templates;
CREATE TABLE kk_product_to_templates (
  store_id varchar(64),
  products_id int NOT NULL,
  cust_attr_tmpl_id int NOT NULL,
  sort_order int NOT NULL DEFAULT '0',
  PRIMARY KEY (products_id ,cust_attr_tmpl_id)
);

# Populate new table
insert into kk_product_to_templates (products_id, cust_attr_tmpl_id, store_id) select products_id, cust_attr_tmpl_id, store_id from products where cust_attr_tmpl_id > -1;

# Sitemap file location 
DELETE FROM configuration WHERE configuration_key = 'SITEMAP_FILE_DIRECTORY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Sitemap file Directory', 'SITEMAP_FILE_DIRECTORY', 'C:/Program Files/KonaKart/batchlogs/', 'The location where KonaKart will write sitemap files', '30', '1', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# Sitemap Config panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_sitemap', 'SitemapConfiguration', now());

# Add access to the Sitemap Config Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_sitemap';

# Insert a Configuration for the Importer File Path
DELETE FROM configuration WHERE configuration_key = 'IMPORT_FILES_PATH';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Import files path','IMPORT_FILES_PATH','C:/Program Files/KonaKart/data/','The import data files location',29,50,now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# Importer Log file location 
DELETE FROM configuration WHERE configuration_key = 'IMPORTER_LOG_FILE_DIRECTORY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Importer Log file Directory', 'IMPORTER_LOG_FILE_DIRECTORY', 'C:/Program Files/KonaKart/importerlogs/', 'The location where KonaKart will write importer log files', 29, 60, now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# Add some Configuration Groups
INSERT INTO configuration_group VALUES (26, 'Reward Points', 'Reward Points Configuration', 26, 1, null);
INSERT INTO configuration_group VALUES (27, 'PDF Configuration', 'PDF Configuration', 27, 1, null);
INSERT INTO configuration_group VALUES (28, 'Velocity Templates', 'Velocity Templates Configuration', 28, 1, null);
INSERT INTO configuration_group VALUES (29, 'Importer Config', 'Importer Configuration', 29, 1, null);
INSERT INTO configuration_group VALUES (30, 'Sitemap', 'Sitemap Configuration', 30, 1, null);

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_importer','Importer', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_importerConfig','Importer Configuration', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_resetDatabase','Reset Database', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_viewImporterLogs','View Importer Jobs', now());

# Add access to the Importer Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_importer';

# Add access to the View Importer Config Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_importerConfig';

# Add access to the Reset Database Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_resetDatabase';

# Add access to the View Importer Logs Panel to all roles that can access the Configuration panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_viewImporterLogs';

# Add custom privileges for the Importer panel - default to allow access to the Custom Importer1 button - custom 1 hides it
UPDATE kk_role_to_panel SET custom1=0, custom1_desc='If set Custom1 button is not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_importer');
# Add custom privileges for the Importer panel - default to allow access to the Custom Importer2 button - custom 2 hides it
UPDATE kk_role_to_panel SET custom2=0, custom2_desc='If set Custom2 button is not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_importer');
# Add custom privileges for the Importer panel - default to allow access to the Custom Importer3 button - custom 3 hides it
UPDATE kk_role_to_panel SET custom3=0, custom3_desc='If set Custom3 button is not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_importer');
# Add custom privileges for the Importer panel - default to allow access to the Upload button - custom 4 hides it
UPDATE kk_role_to_panel SET custom4=0, custom4_desc='If set Upload button is not shown' WHERE panel_id IN (SELECT panel_id FROM kk_panel where code='kk_panel_importer');


#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.7.0.0 to version 5.7.5.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# Configuration variable to define how to format the URLs for SEO
DELETE FROM configuration WHERE configuration_key = 'SEO_URL_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'How to format the URLs for SEO', 'SEO_URL_FORMAT', '2', 'Decide the format of the URLs for SEO', '1', '30', 'option(0=OFF,1=SEO Parameters,2=SEO Directory Structure)', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Configuration variables for defining-store front base paths
DELETE FROM configuration WHERE configuration_key = 'STORE_FRONT_BASE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Store-Front base','STORE_FRONT_BASE','/konakart','Base directory used in JSPs for store-front application','4', '12', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'STORE_FRONT_IMG_BASE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Store-Front image base','STORE_FRONT_IMG_BASE','/konakart/images','Image base used in JSPs for store-front application','4', '13', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'STORE_FRONT_SCRIPT_BASE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Store-Front script base','STORE_FRONT_SCRIPT_BASE','/konakart/script','Script base used in JSPs for store-front application','4', '14', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'STORE_FRONT_STYLE_BASE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Store-Front style sheet base','STORE_FRONT_STYLE_BASE','/konakart/styles','Style sheet base used in JSPs for store-front application','4', '15', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# New doesProductExist Admin API
INSERT INTO kk_api_call (name, description, date_added) VALUES ('doesProductExist','', now());

# Extend the size of the categories_name field 
ALTER TABLE categories_description MODIFY categories_name VARCHAR(256);
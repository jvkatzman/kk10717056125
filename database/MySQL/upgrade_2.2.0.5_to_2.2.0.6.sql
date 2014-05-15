#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.5 to version 2.2.0.6
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially

# Extend the size of the products_model column
ALTER TABLE products MODIFY products_model VARCHAR(64);

# Add an extra field to the ipn_history table
ALTER TABLE ipn_history add customers_id int;

# For the case where SSL communication requires a different URL
delete from configuration where configuration_key = 'SSL_BASE_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Base URL for SSL pages','SSL_BASE_URL','','Base URL used for SSL pages (i.e. https://myhost:8443). This overrides the SSL port number config.','16', '40', now());



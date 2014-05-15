#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.8 to version 2.2.1.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially


# Add the API Call Data
update kk_api_call set name='insertDigitalDownload' where api_call_id=177;

# KonaKart Mail Properties file location
delete from configuration where configuration_key = 'KONAKART_MAIL_PROPERTIES_FILE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('KonaKart mail properties filename', 'KONAKART_MAIL_PROPERTIES_FILE', 'C:/Program Files/KonaKart/conf/konakart_mail.properties', 'Location of the KonaKart mail properties file', '12', '8', now());

# Log file location 
delete from configuration where configuration_key = 'KONAKART_LOG_FILE_DIRECTORY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('KonaKart Log file Directory', 'KONAKART_LOG_FILE_DIRECTORY', 'C:/Program Files/KonaKart/logs', 'The location where KonaKart will write diagnostic log files', '20', '2', now());

# Extend the size of the country_name columns to match countries table
ALTER TABLE orders MODIFY customers_country VARCHAR(64);
ALTER TABLE orders MODIFY billing_country VARCHAR(64);
ALTER TABLE orders MODIFY delivery_country VARCHAR(64);

# Extend the size of the products_model column to match products table
ALTER TABLE orders_products MODIFY products_model VARCHAR(64);

# No longer use KK_IF function for MySQL - allowing KonaKart to work with earlier versions of MySQL
DROP FUNCTION IF EXISTS KK_IF;


#----------------------------------------------------------------
# KonaKart upgrade script from version 6.3.0.0 to version 6.4.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade scripts
# must be run sequentially
#

# Set database version information
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '6.4.0.0 U', now());
UPDATE kk_config SET kk_config_value='6.4.0.0 MySQL', date_added=now() WHERE kk_config_key='VERSION';

# Set some defaults by configuration_group
UPDATE configuration set return_by_api = 1 where configuration_group_id in (26);

# Return the STOCK_REORDER_LEVEL configuration variable
UPDATE configuration set return_by_api = 1 where configuration_key in ('STOCK_REORDER_LEVEL');

# Admin API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('editProductWithOptions','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertProductWithOptions','', now());

# Save payment module sub-code information with the order
ALTER TABLE orders ADD COLUMN payment_module_subcode varchar(64);

# Add number of reviews to product table
ALTER TABLE products ADD number_reviews int DEFAULT '0';

# Change the email address for John Doe
UPDATE customers SET customers_email_address = 'doe@konakart.com' where customers_email_address = 'root@localhost';
UPDATE customers SET customers_email_address = 'store2-doe@konakart.com' where customers_email_address = 'store2-root@localhost';

# Change previous occurrences of root@localhost should they still exist
UPDATE configuration SET configuration_value = 'admin@konakart.com' where configuration_value = 'root@localhost' and configuration_key = 'STORE_OWNER_EMAIL_ADDRESS';
UPDATE configuration SET configuration_value = 'admin@konakart.com' where configuration_value = 'KonaKart <root@localhost>' and configuration_key = 'EMAIL_FROM';

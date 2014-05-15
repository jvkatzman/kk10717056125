#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.8.0.0 to version 6.0.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# Add new attributes to ipn_history table
ALTER TABLE ipn_history ADD COLUMN transaction_type varchar(128);
ALTER TABLE ipn_history ADD COLUMN transaction_amount decimal(15,4);
ALTER TABLE ipn_history ADD COLUMN custom1 varchar(128);
ALTER TABLE ipn_history ADD COLUMN custom2 varchar(128);
ALTER TABLE ipn_history ADD COLUMN custom3 varchar(128);
ALTER TABLE ipn_history ADD COLUMN custom4 varchar(128);
ALTER TABLE ipn_history ADD COLUMN custom1Dec decimal(15,4);
ALTER TABLE ipn_history ADD COLUMN custom2Dec decimal(15,4);

# Extend the size of the product option and option value fields 
ALTER TABLE products_options MODIFY products_options_name VARCHAR(64);
ALTER TABLE orders_products_attributes MODIFY products_options VARCHAR(64);
ALTER TABLE orders_products_attributes MODIFY products_options_values VARCHAR(64);

# Add a new product option type
ALTER TABLE products_options ADD COLUMN option_type int DEFAULT '0' NOT NULL;
ALTER TABLE customers_basket_attributes ADD COLUMN attr_type int DEFAULT '0' NOT NULL;
ALTER TABLE customers_basket_attributes ADD COLUMN attr_quantity int DEFAULT '0';
ALTER TABLE customers_basket_attributes ADD COLUMN customers_basket_id int DEFAULT '0' NOT NULL;
ALTER TABLE orders_products_attributes ADD COLUMN attr_type int DEFAULT '0' NOT NULL;
ALTER TABLE orders_products_attributes ADD COLUMN attr_quantity int DEFAULT '0';

# No longer used
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_DATE_TEMPLATE';


#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.2 to version 2.2.0.3
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially

# Product relationships for merchandising
DROP TABLE IF EXISTS products_to_products;
CREATE TABLE products_to_products (
  products_to_products_id int NOT NULL auto_increment,
  id_from int NOT NULL,
  id_to int NOT NULL,
  relation_type int DEFAULT '0' NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  PRIMARY KEY (products_to_products_id)
);

# Max number of items to display for merchandising
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Up Sell Products', 'MAX_DISPLAY_UP_SELL', '6', 'Maximum number of products to display in the \'Top of Range\' box', '3', '20', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Cross Sell Products', 'MAX_DISPLAY_CROSS_SELL', '6', 'Maximum number of products to display in the \'Similar Products\' box', '3', '21', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Accessories', 'MAX_DISPLAY_ACCESSORIES', '6', 'Maximum number of products to display in the \'Accessories\' box', '3', '22', 'integer(0,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Dependent Products', 'MAX_DISPLAY_DEPENDENT_PRODUCTS', '6', 'Maximum number of products to display in the \'Warranties\' box', '3', '23', 'integer(0,null)', now());

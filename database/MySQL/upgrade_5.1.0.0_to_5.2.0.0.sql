#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.1.0.0 to version 5.2.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# Add extra columns to the Zones table
ALTER TABLE zones ADD COLUMN zone_invisible int DEFAULT 0 NOT NULL;
ALTER TABLE zones ADD COLUMN zone_search varchar(64);
ALTER TABLE zones ADD KEY idx_zone_search (zone_search);

# New API call for checking Data Integrity
INSERT INTO kk_api_call (name, description, date_added) VALUES ('checkDataIntegrity','', now());

# Addition of custom fields to digital_downloads
ALTER TABLE kk_digital_download_1 ADD COLUMN custom1 varchar(128);
ALTER TABLE kk_digital_download_1 ADD COLUMN custom2 varchar(128);
ALTER TABLE kk_digital_download_1 ADD COLUMN custom3 varchar(128);

# Add an attribute to the orders table 
ALTER TABLE orders ADD COLUMN shipping_service_code varchar(128);

# Add custom field descriptions for Shipping Command on Order panels
UPDATE kk_role_to_panel SET custom3=0, custom3_desc='If set Export For Shipping button not shown' WHERE panel_id in (select panel_id from kk_panel WHERE code='kk_panel_customerOrders');
UPDATE kk_role_to_panel SET custom3=0, custom3_desc='If set Export For Shipping button not shown' WHERE panel_id in (select panel_id from kk_panel WHERE code='kk_panel_orders');

UPDATE kk_role_to_panel SET custom4=0, custom4_desc='If set Export button not shown' WHERE panel_id in (select panel_id from kk_panel WHERE code='kk_panel_customerOrders');
UPDATE kk_role_to_panel SET custom4=0, custom4_desc='If set Export button not shown' WHERE panel_id in (select panel_id from kk_panel WHERE code='kk_panel_orders');

# Config variable to define the location of the Shipping Orders
DELETE FROM configuration where configuration_key = 'EXPORT_ORDERS_BASE_DIRECTORY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Exported Orders Directory', 'EXPORT_ORDERS_BASE_DIRECTORY', 'C:/Program Files/KonaKart/orders', 'Defines the root directory where the Orders are exported to', '7', '7', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# New exportOrder API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('exportOrder','', now());

# Add description field to category
ALTER TABLE categories_description ADD COLUMN description text;

# Move the Admin Currency Decimal Place Configuration Variable to the Admn App Configuration Panel
UPDATE configuration set configuration_group_id = 21, sort_order = 40 where configuration_key = 'ADMIN_CURRENCY_DECIMAL_PLACES' and configuration_group_id = 1;

# Move the Admin Date Template Configuration Variable to the Admn App Configuration Panel
UPDATE configuration set configuration_group_id = 21, sort_order = 35 where configuration_key = 'ADMIN_APP_DATE_TEMPLATE' and configuration_group_id = 1;

# Move the Email From and Send Extra Emails Configuration Variable to the Email Configuration Panel
UPDATE configuration set configuration_group_id = 12, sort_order = 6 where configuration_key = 'EMAIL_FROM' and configuration_group_id = 1;
UPDATE configuration set configuration_group_id = 12, sort_order = 6 where configuration_key = 'SEND_EXTRA_EMAILS_TO' and configuration_group_id = 1;

# Config variable to define whether to allow wish lists for non logged in users
DELETE FROM configuration where configuration_key = 'ALLOW_WISHLIST_WHEN_NOT_LOGGED_IN';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Allow Wish List when not logged in', 'ALLOW_WISHLIST_WHEN_NOT_LOGGED_IN', 'false', 'Allow wish list functionality to be available for customers that have not logged in', '1', '25', 'choice(\'true\', \'false\')', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Config variable to define the Address that Orders are shipped from
DELETE FROM configuration where configuration_key = 'SHIP_FROM_STREET_ADDRESS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Ship From Street Address', 'SHIP_FROM_STREET_ADDRESS', '', 'Ship From Street Address - used by some of the Shipping Modules', '7', '2', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Config variable to define the City that Orders are shipped from
DELETE FROM configuration where configuration_key = 'SHIP_FROM_CITY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Ship From City', 'SHIP_FROM_CITY', '', 'Ship From City - used by some of the Shipping Modules', '7', '2', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Add weight attribute to Orders Products table
ALTER TABLE orders_products ADD COLUMN weight decimal(10,2);

# Config variable to define the Product Types that are not shown in the droplist on the Edit Product Panel
DELETE FROM configuration where configuration_key = 'HIDDEN_PRODUCT_TYPES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Hidden Product Types', 'HIDDEN_PRODUCT_TYPES', '', 'The Product Types that are not shown in the droplist on the Edit Product Panel', '21', '27', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Product Quantity Table for different catalog ids
DROP TABLE IF EXISTS kk_catalog_quantity;
CREATE TABLE kk_catalog_quantity (
  store_id varchar(64),
  catalog_id varchar(32) NOT NULL,
  products_id int NOT NULL,
  products_options varchar(128) NOT NULL,
  products_quantity int NOT NULL,
  products_date_available datetime,
  PRIMARY KEY (catalog_id,products_id, products_options)
);

# Add new column to promotions table
ALTER TABLE promotion ADD COLUMN max_use int NOT NULL DEFAULT '-1';

# Tracks the number of times a promotion has been used
DROP TABLE IF EXISTS promotion_to_customer_use;
CREATE TABLE promotion_to_customer_use (
  store_id varchar(64),
  promotion_id int NOT NULL,
  customers_id int NOT NULL,
  times_used int NOT NULL DEFAULT '0',
  PRIMARY KEY (promotion_id,customers_id)
);

# Page links
DELETE FROM configuration where configuration_key = 'MAX_DISPLAY_PAGE_LINKS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Search Result Page Links', 'MAX_DISPLAY_PAGE_LINKS', '5', 'Maximum number of links used for page-sets - must be odd number', '3', '3', 'integer(3,null)', now());

# Define the default state for reviews when written by a customer
DELETE FROM configuration where configuration_key = 'DEFAULT_REVIEW_STATE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Default state for reviews', 'DEFAULT_REVIEW_STATE', '0', 'Allows you to make reviews visible only after approval if initial state is set to 1', '18', '10', 'integer(0,null)', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Add state attribute to reviews table
ALTER TABLE reviews ADD state int DEFAULT 0 NOT NULL;

# Reviews Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_reviews', 'Maintain Product Reviews', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_prod_reviews', 'Product Reviews for Product', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_cust_reviews', 'Product Reviews for Customer', now());

# Add Reviews Panel access to all roles that can access the Product panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_reviews';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prod_reviews';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_cust_reviews';

# getReviews API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getReviews','', now());

# For storing all messages in the database
DROP TABLE IF EXISTS kk_msg;
CREATE TABLE kk_msg (
  msg_key varchar(100) NOT NULL,
  msg_locale varchar(10) NOT NULL,
  msg_type int NOT NULL,
  msg_value text,
  PRIMARY KEY (msg_key,msg_type,msg_locale)
);

# Add locale to languages table
ALTER TABLE languages ADD COLUMN locale varchar(10);
UPDATE languages SET locale = code;
UPDATE languages SET locale = 'en_GB' where code = 'en';
UPDATE languages SET locale = 'de_DE' where code = 'de';
UPDATE languages SET locale = 'es_ES' where code = 'es';
UPDATE languages SET locale = 'pt_BR' where code = 'pt';

# Messages Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_messages', 'Maintain Application Messages', now());

# Add Messages Panel access to all roles that can access the Languages panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_languages' and p2.code='kk_panel_messages';

# Config variable to define the Messsage Types allowed in the System
DELETE FROM configuration where configuration_key = 'MESSAGE_TYPES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Message Types', 'MESSAGE_TYPES', 'Application,AdminApp,AdminAppHelp', 'Used to populate the Message Types droplist in the Messages section', '21', '41', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Config variable to define whether we use files (the default) or the database for storing system messages
DELETE FROM configuration where configuration_key = 'USE_DB_FOR_MESSAGES';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Use D/B For Messages', 'USE_DB_FOR_MESSAGES', 'false', 'If true use the Database for the system messsages, if false use file-based messages', '21', '40', 'choice(\'true\', \'false\')', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# New Messages APIs
INSERT INTO kk_api_call (name, description, date_added) VALUES ('searchMsg','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getMsgValue','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteMsg','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertMsg','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateMsg','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('importMsgs','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('exportMsgs','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getLanguageById','', now());

# Add indexes on product table
ALTER TABLE products ADD KEY idx_manu_id (manufacturers_id);

# Add new attribute to address_book table
ALTER TABLE address_book ADD manufacturers_id int DEFAULT 0 NOT NULL;

# Address Panel
#INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_address', 'All Addresses', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_prod_address', 'Product Addresses', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_manu_address', 'Manufacturer Addresses', now());
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_cust_address', 'Customer Addresses', now());

# Add Address Panel access to all roles that can access the Customer panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_address';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_prod_address';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_manu_address';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_cust_address';

# Table to connect products to addresses
DROP TABLE IF EXISTS kk_addr_to_product;
CREATE TABLE kk_addr_to_product (
  store_id varchar(64),
  address_book_id int NOT NULL,
  products_id int NOT NULL,
  relation_type int NOT NULL DEFAULT 0,
  PRIMARY KEY (address_book_id,products_id)
);

# Configuration for address select panels in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_ADDR_SEL_NUM_ADDRS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Address Select Default Num Addrs', 'ADMIN_APP_ADDR_SEL_NUM_ADDRS', '50', 'Sets the default number of addresses displayed in the address select dialogs when opened', '21', '50', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_ADDR_SEL_MAX_NUM_ADDRS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Address Select Max Num Addrs', 'ADMIN_APP_ADDR_SEL_MAX_NUM_ADDRS', '100', 'Sets the maximum number of addresses displayed in the address select dialogs after a search', '21', '51', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_SELECT_PROD_ADDR_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Addr Format for Prod Addr Sel', 'ADMIN_APP_SELECT_PROD_ADDR_FORMAT', '$company $street $street1 $suburb $city $state $country', 'How the address is formatted in the product select address panel', '21', '0', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_PROD_ADDR_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Addr Format for Prod Addr', 'ADMIN_APP_PROD_ADDR_FORMAT', '$company $street $street1 $suburb $city $state $country', 'How the address is formatted in the product address panel', '21', '0', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_CUST_ADDR_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Addr Format for Cust Addr', 'ADMIN_APP_CUST_ADDR_FORMAT', '$street $street1 $suburb $city $state $country', 'How the address is formatted in the customer address panel', '21', '0', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_MANU_ADDR_FORMAT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Addr Format for Manu Addr', 'ADMIN_APP_MANU_ADDR_FORMAT', '$street $street1 $suburb $city $state $country', 'How the address is formatted in the manufacturer address panel', '21', '0', now(), store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

# New address related API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('addAddressesToProduct','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('removeAddressFromProduct','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getProductCountPerAddress','', now());

# New Manufacturer API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getManufacturers','', now());

#MSSQL -- For MS SQL Server - Use nvarchar(max) for products_description
#MSSQL ALTER TABLE products_description ALTER COLUMN products_description nvarchar(max);

# New Product Option API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getProductOptions','', now());

# Configuration for manufacturer panels in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_MANU_SEL_NUM_MANUS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Manufacturer Panel Default Num Manus', 'ADMIN_APP_MANU_SEL_NUM_MANUS', '50', 'Sets the default number of manufacturers displayed in the manufacturer panels and dialogs when opened', '21', '52', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_MANU_SEL_MAX_NUM_MANUS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Manufacturer Panel Max Num Manus', 'ADMIN_APP_MANU_SEL_MAX_NUM_MANUS', '100', 'Sets the maximum number of manufacturers displayed in the manufacturer panels and dialogs after a search', '21', '53', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

# Configuration for product option panel in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_PROD_OPT_SEL_NUM_PROD_OPTS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Prod Option Panel Default Num Prod Opts', 'ADMIN_APP_PROD_OPT_SEL_NUM_PROD_OPTS', '50', 'Sets the default number of product options displayed in the prod option panel when opened', '21', '54', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_PROD_OPT_SEL_MAX_NUM_PROD_OPTS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Prod Option Panel Max Num Prod Opts', 'ADMIN_APP_PROD_OPT_SEL_MAX_NUM_PROD_OPTS', '100', 'Sets the maximum number of product options displayed in the prod option panel after a search', '21', '55', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';


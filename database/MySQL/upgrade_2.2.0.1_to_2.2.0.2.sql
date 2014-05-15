#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.1 to version 2.2.0.2
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially

# SSL
delete from configuration where configuration_key = 'ENABLE_SSL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enables SSL if set to true', 'ENABLE_SSL', 'false', 'Enables SSL if set to true to make the site secure', '16', '10', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());
delete from configuration where configuration_key = 'STANDARD_PORT_NUMBER';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Port number for standard (non SSL) pages','STANDARD_PORT_NUMBER','8780','Port number used to access standard non SSL pages','16', '20' ,'integer(0,null)', now());
delete from configuration where configuration_key = 'SSL_PORT_NUMBER';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Port number for SSL pages','SSL_PORT_NUMBER','8443','Port number used to access SSL pages','16', '30' ,'integer(0,null)', now());

# Location for report definitions, and BIRT viewer home
delete from configuration where configuration_key = 'REPORTS_DEFN_PATH';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('Report definitions base path','REPORTS_DEFN_PATH','C:/Program Files/KonaKart/webapps/birt-viewer/reports/','The reports definition location','17', '1', now());
delete from configuration where configuration_key = 'REPORTS_EXTENSION';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('Report file extension','REPORTS_EXTENSION','.rptdesign','The report file extension - identifies report files','17', '2', now());
delete from configuration where configuration_key = 'REPORTS_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('Report viewer URL','REPORTS_URL','http://localhost:8780/birt-viewer/frameset?__report=reports/','The report viewer base URL','17', '3', now());
delete from configuration where configuration_key = 'REPORTS_STATUS_PAGE_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('Status Page Report URL','REPORTS_STATUS_PAGE_URL','http://localhost:8780/birt-viewer/run?__report=reports/OrdersInLast30DaysChart.rptdesign','The URL for the report on the status page','17', '4', now());

# Stock Reorder Email
delete from configuration where configuration_key = 'STOCK_REORDER_EMAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('E-Mail address for low stock alert', 'STOCK_REORDER_EMAIL', 'reorder_mgr@konakart.com', 'The e-mail address used to send an alert email when the stock level of a product falls below the reorder level', '9', '6', now());

# Allow user to insert coupon code
delete from configuration where configuration_key = 'DISPLAY_COUPON_ENTRY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Display Coupon Entry Field', 'DISPLAY_COUPON_ENTRY', 'false', 'During checkout the customer will be allowed to enter a coupon if set to true', '1', '22', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());


# Promotions
DROP TABLE IF EXISTS promotion;
CREATE TABLE promotion (
   promotion_id int NOT NULL auto_increment,
   order_total_code varchar(32) NOT NULL,
   description varchar(128),
   name varchar(64),
   active int(1) NOT NULL DEFAULT '0',
   cumulative int(1) NOT NULL DEFAULT '0',
   requires_coupon int(1) NOT NULL DEFAULT '0',
   start_date datetime,
   end_date datetime,
   manufacturer_rule int,
   product_rule int,
   customer_rule int,
   category_rule int,
   custom1 varchar(128),
   custom2 varchar(128),
   custom3 varchar(128),
   custom4 varchar(128),
   custom5 varchar(128),
   custom6 varchar(128),
   custom7 varchar(128),
   custom8 varchar(128),
   custom9 varchar(128),
   custom10 varchar(128),
   date_added datetime NOT NULL,
   last_modified datetime,
   PRIMARY KEY (promotion_id)
);

DROP TABLE IF EXISTS promotion_to_manufacturer;
CREATE TABLE promotion_to_manufacturer (
  promotion_id int NOT NULL,
  manufacturers_id int NOT NULL,
  PRIMARY KEY (promotion_id,manufacturers_id)
);

DROP TABLE IF EXISTS promotion_to_product;
CREATE TABLE promotion_to_product (
  promotion_id int NOT NULL,
  products_id int NOT NULL,
  products_options_id int NOT NULL DEFAULT '0',
  products_options_values_id int NOT NULL DEFAULT '0',
  PRIMARY KEY (promotion_id,products_id,products_options_id,products_options_values_id)
);

DROP TABLE IF EXISTS promotion_to_category;
CREATE TABLE promotion_to_category (
  promotion_id int NOT NULL,
  categories_id int NOT NULL,
  PRIMARY KEY (promotion_id,categories_id)
);

DROP TABLE IF EXISTS promotion_to_customer;
CREATE TABLE promotion_to_customer (
  promotion_id int NOT NULL,
  customers_id int NOT NULL,
  max_use int NOT NULL DEFAULT '-1',
  times_used int NOT NULL DEFAULT '0',
  custom1 varchar(128),
  custom2 varchar(128),
  PRIMARY KEY (promotion_id,customers_id)
);

DROP TABLE IF EXISTS coupon;
CREATE TABLE coupon (
   coupon_id int NOT NULL auto_increment,
   coupon_code varchar(64) NOT NULL,
   name varchar(64),
   description varchar(128),
   max_use int NOT NULL DEFAULT '1',
   times_used int NOT NULL DEFAULT '0',
   custom1 varchar(128),
   custom2 varchar(128),
   custom3 varchar(128),
   custom4 varchar(128),
   custom5 varchar(128),
   date_added datetime NOT NULL,
   last_modified datetime,
   PRIMARY KEY (coupon_id)
);

DROP TABLE IF EXISTS promotion_to_coupon;
CREATE TABLE promotion_to_coupon (
  promotion_id int NOT NULL,
  coupon_id int NOT NULL,
  PRIMARY KEY (promotion_id,coupon_id)
);

# Add promotion related fields to orders table
ALTER TABLE orders add column promotion_ids varchar(64);
ALTER TABLE orders add column coupon_ids varchar(64);


# Utility Table
DROP TABLE IF EXISTS utility;
CREATE TABLE utility (
	id int NOT NULL,
	PRIMARY KEY (id)
);

delete from utility;
INSERT INTO utility (id) VALUES (1);
INSERT INTO utility (id) VALUES (2);
INSERT INTO utility (id) VALUES (3);
INSERT INTO utility (id) VALUES (4);
INSERT INTO utility (id) VALUES (5);
INSERT INTO utility (id) VALUES (6);
INSERT INTO utility (id) VALUES (7);
INSERT INTO utility (id) VALUES (8);
INSERT INTO utility (id) VALUES (9);
INSERT INTO utility (id) VALUES (10);
INSERT INTO utility (id) VALUES (11);
INSERT INTO utility (id) VALUES (12);
INSERT INTO utility (id) VALUES (13);
INSERT INTO utility (id) VALUES (14);
INSERT INTO utility (id) VALUES (15);
INSERT INTO utility (id) VALUES (16);
INSERT INTO utility (id) VALUES (17);
INSERT INTO utility (id) VALUES (18);
INSERT INTO utility (id) VALUES (19);
INSERT INTO utility (id) VALUES (20);
INSERT INTO utility (id) VALUES (21);
INSERT INTO utility (id) VALUES (22);
INSERT INTO utility (id) VALUES (23);
INSERT INTO utility (id) VALUES (24);
INSERT INTO utility (id) VALUES (25);
INSERT INTO utility (id) VALUES (26);
INSERT INTO utility (id) VALUES (27);
INSERT INTO utility (id) VALUES (28);
INSERT INTO utility (id) VALUES (29);
INSERT INTO utility (id) VALUES (30);
INSERT INTO utility (id) VALUES (31);


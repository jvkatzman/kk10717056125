# (c) 2006 DS Data Systems UK Ltd, All rights reserved.
# 
# DS Data Systems and KonaKart and their respective logos, are
# trademarks of DS Data Systems UK Ltd. All rights reserved.
# 
# The information in this document below this text is free software; you can redistribute
# it and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# -----------------------------------------------------------
# KonaKart upgrade database script for MS Sql Server
# From version 2.2.0.6 to version 2.2.0.7
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.0.6, the upgrade
# scripts must be run sequentially.
# 

delete from configuration where configuration_key = 'READ_AUDIT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Auditing for Reads', 'READ_AUDIT', '0', 'Enable / Disable auditing for reads', '18', '1','tep_cfg_pull_down_audit_list(', getdate());
delete from configuration where configuration_key = 'EDIT_AUDIT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Auditing for Edits', 'EDIT_AUDIT', '0', 'Enable / Disable auditing for edits', '18', '2','tep_cfg_pull_down_audit_list(', getdate());
delete from configuration where configuration_key = 'INSERT_AUDIT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Auditing for Inserts', 'INSERT_AUDIT', '0', 'Enable / Disable auditing for inserts', '18', '3','tep_cfg_pull_down_audit_list(', getdate());
delete from configuration where configuration_key = 'DELETE_AUDIT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Auditing for Deletes', 'DELETE_AUDIT', '0', 'Enable / Disable auditing for deletes', '18', '4','tep_cfg_pull_down_audit_list(', getdate());

-- Audit table
DROP TABLE kk_audit;
CREATE TABLE kk_audit (
  audit_id int NOT NULL identity(1,1),
  customers_id int NOT NULL,
  audit_action int NOT NULL,
  api_method_name varchar(128) NOT NULL,
  object_id int,
  object_to_string text,
  date_added datetime NOT NULL,
  PRIMARY KEY(audit_id)
);

-- Add extra fields to the customers table
ALTER TABLE customers add customers_type int;
ALTER TABLE customers add customers_enabled int DEFAULT '1';

-- Role table
DROP TABLE kk_role;
CREATE TABLE kk_role (
  role_id int NOT NULL identity(1,1),
  name varchar(128) NOT NULL,
  description varchar(255),
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(role_id)
);

-- Customers_to_role table
DROP TABLE kk_customers_to_role;
CREATE TABLE kk_customers_to_role (
  role_id int DEFAULT 0 NOT NULL,
  customers_id int DEFAULT 0 NOT NULL,
  date_added datetime,
  PRIMARY KEY(role_id, customers_id)
);

-- Panel table
DROP TABLE kk_panel;
CREATE TABLE kk_panel (
  panel_id int NOT NULL identity(1,1),
  code varchar(128) NOT NULL,
  description varchar(255),
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(panel_id)
);

-- Role to Panel table
DROP TABLE kk_role_to_panel;
CREATE TABLE kk_role_to_panel (
  role_id int DEFAULT 0 NOT NULL,
  panel_id int DEFAULT 0 NOT NULL,
  can_edit int DEFAULT 0,
  can_insert int DEFAULT 0,
  can_delete int DEFAULT 0,
  custom1 int DEFAULT 0,
  custom1_desc varchar(128),
  custom2 int DEFAULT 0,
  custom2_desc varchar(128),
  custom3 int DEFAULT 0,
  custom3_desc varchar(128),
  custom4 int DEFAULT 0,
  custom4_desc varchar(128),
  custom5 int DEFAULT 0,
  custom5_desc varchar(128),
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(role_id, panel_id)
);

-- Default super-administrator user = "admin@konakart.com" password = "princess"
delete from customers where customers_email_address = 'admin@konakart.com' and customers_telephone='019081';
delete from address_book where entry_street_address='1 Way Street' and entry_postcode='PostCode1';
INSERT INTO address_book (customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id, entry_zone_id) VALUES (-1, 'm', 'ACME Inc.', 'Andy', 'Admin', '1 Way Street', '', 'PostCode1', 'NeverNever', '', 223, 12);
INSERT INTO customers (customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type) VALUES ('m', 'Andy', 'Admin', '1977-01-01 00:00:00', 'admin@konakart.com', -1, '019081', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1);
INSERT INTO customers_info select customers_id , getdate(), 0, getdate(), getdate(), 0 from customers where customers_email_address = 'admin@konakart.com' and customers_telephone='019081';
UPDATE address_book set customers_id = (select customers_id from customers where customers_email_address = 'admin@konakart.com' and customers_telephone='019081') where customers_id=-1;
UPDATE customers set customers_default_address_id = (select address_book_id from address_book where entry_street_address='1 Way Street' and entry_postcode='PostCode1') where customers_default_address_id=-1;

-- Default catalog maintainer user = "cat@konakart.com" password = "princess"
delete from customers where customers_email_address = 'cat@konakart.com' and customers_telephone='019082';
delete from address_book where entry_street_address='2 Way Street' and entry_postcode='PostCode2';
INSERT INTO address_book (customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id, entry_zone_id) VALUES (-1, 'm', 'ACME Inc.', 'Caty', 'Catalog', '2 Way Street', '', 'PostCode2', 'NeverNever', '', 223, 12);
INSERT INTO customers (customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type) VALUES ('m', 'Caty', 'Catalog', '1977-01-01 00:00:00', 'cat@konakart.com', -1, '019082', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1);
INSERT INTO customers_info select customers_id , getdate(), 0, getdate(), getdate(), 0 from customers where customers_email_address = 'cat@konakart.com' and customers_telephone='019082';
UPDATE address_book set customers_id = (select customers_id from customers where customers_email_address = 'cat@konakart.com' and customers_telephone='019082') where customers_id=-1;
UPDATE customers set customers_default_address_id = (select address_book_id from address_book where entry_street_address='2 Way Street' and entry_postcode='PostCode2') where customers_default_address_id=-1;


-- Default order maintainer user = "order@konakart.com" password = "princess"
delete from customers where customers_email_address = 'order@konakart.com' and customers_telephone='019083';
delete from address_book where entry_street_address='3 Way Street' and entry_postcode='PostCode3';
INSERT INTO address_book (customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id, entry_zone_id) VALUES (-1, 'm', 'ACME Inc.', 'Olly', 'Order', '3 Way Street', '', 'PostCode3', 'NeverNever', '', 223, 12);
INSERT INTO customers (customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type) VALUES ('m', 'Olly', 'Order', '1977-01-01 00:00:00', 'order@konakart.com', -1, '019083', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1);
INSERT INTO customers_info select customers_id , getdate(), 0, getdate(), getdate(), 0 from customers where customers_email_address = 'order@konakart.com' and customers_telephone='019083';
UPDATE address_book set customers_id = (select customers_id from customers where customers_email_address = 'order@konakart.com' and customers_telephone='019083') where customers_id=-1;
UPDATE customers set customers_default_address_id = (select address_book_id from address_book where entry_street_address='3 Way Street' and entry_postcode='PostCode3') where customers_default_address_id=-1;

-- Panels
delete from kk_panel;
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_addressFormats','Address Formats', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_audit','Audit', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_auditConfig','AuditConfig', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_cache','Cache', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_categories','Categories', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_configFiles','Configuration Files', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_digitalDownloadConfig','Digital Downloads', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_countries','Countries', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_coupons','Coupons', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_couponsFromProm','Coupons For Promotions', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_currencies','Currencies', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_customerDetails','Customer Details', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_customerOrders','Customer Orders', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_customers','Customers', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_deleteSessions','Delete Expired Sessions', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_editCustomer','Edit Customer', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_editOrderPanel','Edit Order', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_editProduct','Edit Product', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_emailOptions','Email Options', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_geoZones','Geo-Zones', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_httpHttps','HTTP / HTTPS', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_images','Images', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_insertCustomer','Insert Customer', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_ipnhistory','Payment Gateway Callbacks', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_ipnhistoryFromOrders','Payment Status For Order', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_languages','Languages', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_logging','Logging', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_roleToPanels','Maintain Roles', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_manufacturers','Manufacturers', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_maximumValues','Maximum Values', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_minimumValues','Minimum Values', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_userToRoles','Map Users to Roles', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_orders','Orders', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_orderStatuses','Order Statuses', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_orderTotalModules','Order Total', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_paymentModules','Payment', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_prodsFromCat','Products for Categories', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_prodsFromManu','Products for Manufacturer', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_productOptions','Product Options', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_products','Products', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_promotions','Promotions', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_promRules','Promotion Rules', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_refreshCache','Refresh Config Cache', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_reports','Reports', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_reportsConfig','Reports Configuration', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_returns','Product Returns', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_returnsFromOrders','Product Returns For Order', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_rss','Latest News', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_shippingModules','Shipping', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_shippingPacking','Shipping / Packing', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_status','Status', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_stockAndOrders','Stock and Orders', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_storeConfiguration','My Store', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_subZones','Sub-Zones', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_taxAreaMapping','Tax Area Mapping', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_taxAreas','Tax Areas', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_taxAreaToZoneMapping','Tax Area to Zone Mapping', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_taxClasses','Tax Classes', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_taxRates','Tax Rates', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_zones','Zones', getdate());

-- Roles
delete from kk_role;
INSERT INTO kk_role ( name, description, date_added) VALUES ( 'Super User','Permission to do everything', getdate());
INSERT INTO kk_role ( name, description, date_added) VALUES ( 'Catalog Maintenance','Permission to maintain the catalog of products', getdate());
INSERT INTO kk_role ( name, description, date_added) VALUES ( 'Order Maintenance','Permission to maintain the orders', getdate());
INSERT INTO kk_role ( name, description, date_added) VALUES ( 'Customer Maintenance','Permission to maintain the customers', getdate());

-- Associate roles to panels
delete from kk_role_to_panel;

-- Super User Role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 1, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 2, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 3, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 4, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 5, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 6, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 7, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 8, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 9, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 10, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 11, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 12, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 13, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, custom1, custom1_desc, custom2, custom2_desc) VALUES (1, 14, 1,1,1,getdate(), 0, 'If set email is disabled', 0, 'If set cannot reset password');
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 15, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 16, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 17, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 18, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 19, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 20, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 21, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 22, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 23, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 24, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 25, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 26, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 27, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 28, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 29, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 30, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 31, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 32, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 33, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 34, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 35, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 36, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 37, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 38, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 39, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 40, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 41, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 42, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 43, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, custom1, custom1_desc) VALUES (1, 44, 1,1,1,getdate(), 0, 'If set reports cannot be run');
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 45, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 46, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 47, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 48, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 49, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 50, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 51, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 52, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 53, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 54, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 55, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 56, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 57, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 58, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 59, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 60, 1,1,1,getdate());

-- Catalog maintenance Role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 5, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 9, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 10, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 18, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 29, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 37, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 38, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 39, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 40, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 41, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 42, 1,1,1,getdate());

-- Order Maintenance Role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 17, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 24, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 25, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 33, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 46, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 47, 1,1,1,getdate());

-- Customer Maintenance Role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 13, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, custom1, custom1_desc, custom2, custom2_desc) VALUES (4, 14, 1,1,1,getdate(), 0, 'If set email is disabled', 0, 'If set cannot reset password');
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 16, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 23, 1,1,1,getdate());

-- Associate customers to roles
delete from kk_customers_to_role;

-- Super User
INSERT INTO kk_customers_to_role (role_id, customers_id, date_added) select 1, customers_id, getdate() from customers where customers_email_address = 'admin@konakart.com' and customers_telephone='019081';

-- Catalog maintainer
INSERT INTO kk_customers_to_role (role_id, customers_id, date_added) select 2, customers_id, getdate() from customers where customers_email_address = 'cat@konakart.com' and customers_telephone='019082';

-- Order \& Customer Manager
INSERT INTO kk_customers_to_role (role_id, customers_id, date_added) select 3, customers_id, getdate() from customers where customers_email_address = 'order@konakart.com' and customers_telephone='019083';
INSERT INTO kk_customers_to_role (role_id, customers_id, date_added) select 4, customers_id, getdate() from customers where customers_email_address = 'order@konakart.com' and customers_telephone='019083';

-- Digital Download table
DROP TABLE kk_digital_download;
CREATE TABLE kk_digital_download(
  products_id int DEFAULT 0 NOT NULL,
  customers_id int DEFAULT 0 NOT NULL,
  max_downloads int DEFAULT -1,
  times_downloaded int DEFAULT 0,
  expiration_date datetime,
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(products_id, customers_id)
);

-- Add extra fields to the products table
ALTER TABLE products add products_type int DEFAULT '0';
ALTER TABLE products add products_file_path varchar(255);
ALTER TABLE products add products_content_type varchar(128);

-- Add extra field to the orders_products
ALTER TABLE orders_products add products_type int DEFAULT '0';

-- Configuration variables for digital downloads
delete from configuration where configuration_key = 'DD_BASE_PATH';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Digital Download Base Path', 'DD_BASE_PATH', '', 'Base path for digital download files', 19, 0, getdate());
delete from configuration where configuration_key = 'DD_MAX_DOWNLOADS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES  ('Max Number of Downloads', 'DD_MAX_DOWNLOADS', '-1', 'Maximum number of downloads allowed from link. -1 for unlimited number.', 19, 1, getdate());
delete from configuration where configuration_key = 'DD_MAX_DOWNLOAD_DAYS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES  ('Number of days link is valid', 'DD_MAX_DOWNLOAD_DAYS', '-1', 'The download link remains valid for this number of days. -1 for unlimited number of days', 19, 2, getdate());
delete from configuration where configuration_key = 'DD_DELETE_ON_EXPIRATION';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Delete record on expiration', 'DD_DELETE_ON_EXPIRATION', 'true', 'When the download link expires, delete the database table record', 19, 3, 'tep_cfg_select_option(array(''true'', ''false''), ',getdate());
delete from configuration where configuration_key = 'DD_DOWNLOAD_AS_ATTACHMENT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Download as an attachment', 'DD_DOWNLOAD_AS_ATTACHMENT', 'true', 'Download the file as an attachment rather than viewing in the browser', 19, 4, 'tep_cfg_select_option(array(''true'', ''false''), ',getdate());

-- Add a new order status
delete from orders_status where orders_status_id = 7;
INSERT INTO orders_status(orders_status_id, language_id, orders_status_name) VALUES (7,1,'Partially Delivered');
INSERT INTO orders_status(orders_status_id, language_id, orders_status_name) VALUES (7,2,'Teilweise geliefert');
INSERT INTO orders_status(orders_status_id, language_id, orders_status_name) VALUES (7,3,'Entregado parcialmente');

-- Configuration variable for enabling/disabling access to Invisible Products in the Admin App
delete from configuration where configuration_key = 'SHOW_INVISIBLE_PRODUCTS_IN_ADM';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Show Invisible Products', 'SHOW_INVISIBLE_PRODUCTS_IN_ADM', 'true', 'Show invisible products in the Admin App', 9, 4, 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Add a primary key to the counter table
DROP TABLE counter;
CREATE TABLE counter (
  counter_id int NOT NULL identity(1,1),
  startdate char(8),
  counter int,
  PRIMARY KEY(counter_id)
);


-- Logging configuration
INSERT INTO configuration_group VALUES ( 'Logging', 'Logging configuration options', '20', '1');
delete from configuration where configuration_key = 'ADMIN_APP_LOGGING_LEVEL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Admin App logging level', 'ADMIN_APP_LOGGING_LEVEL', '4', 'Set the logging level for the KonaKart Admin App', '20', '1', 'option(0=OFF,1=SEVERE,2=ERROR,4=WARNING,6=INFO,8=DEBUG)', getdate());

-- Detailed eMail configurations
delete from configuration where configuration_key = 'SEND_ORDER_CONF_EMAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Send Order Confirmation E-Mails', 'SEND_ORDER_CONF_EMAIL', 'true', 'Send out an e-mail when an order is saved or state changes', '12', '8', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());
delete from configuration where configuration_key = 'SEND_STOCK_REORDER_EMAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Send Stock Reorder E-Mails', 'SEND_STOCK_REORDER_EMAIL', 'true', 'Send out an e-mail when the stock level of a product falls below a certain value', '12', '9', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());
delete from configuration where configuration_key = 'SEND_WELCOME_EMAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Send Welcome E-Mails', 'SEND_WELCOME_EMAIL', 'true', 'Send out a welcome e-mail when a customer registers to use the cart', '12', '10', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());
delete from configuration where configuration_key = 'SEND_NEW_PASSWORD_EMAIL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Send New Password E-Mails', 'SEND_NEW_PASSWORD_EMAIL', 'true', 'Send out an e-mail containing a new password when requested by a customer', '12', '11', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate());

-- Add extra image fields to product 
ALTER TABLE products add products_image2 varchar(64);
ALTER TABLE products add products_image3 varchar(64);
ALTER TABLE products add products_image4 varchar(64);

-- Add field for comparison data to products_description
ALTER TABLE products_description add products_comparison text;

-- Initial configuration for the Order Total Shipping Module
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Allow Free Shipping', 'MODULE_ORDER_TOTAL_SHIPPING_FREE_SHIPPING', 'false', 'Do you want to allow free shipping?', '6', '3','tep_cfg_select_option(array(''true'', ''false''), ', getdate());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, date_added) VALUES ('Free Shipping For Orders Over', 'MODULE_ORDER_TOTAL_SHIPPING_FREE_SHIPPING_OVER', '50', 'Provide free shipping for orders over the set amount.', '6', '4', 'currencies->format',getdate());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Provide Free Shipping For Orders Made', 'MODULE_ORDER_TOTAL_SHIPPING_DESTINATION', 'national', 'Provide free shipping for orders sent to the set destination.', '6', '5', 'tep_cfg_select_option(array(''national'', ''international'', ''both''), ', getdate());

  

exit;

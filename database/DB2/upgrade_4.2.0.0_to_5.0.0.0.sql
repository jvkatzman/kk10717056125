-- (c) 2006 DS Data Systems UK Ltd, All rights reserved.
-- 
-- DS Data Systems and KonaKart and their respective logos, are
-- trademarks of DS Data Systems UK Ltd. All rights reserved.
-- 
-- The information in this document below this text is free software; you can redistribute
-- it and/or modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
-- 
-- This software is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
-- 
-- -----------------------------------------------------------
-- KonaKart upgrade database script for DB2
-- From version 4.2.0.0 to version 5.0.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 4.2.0.0, the upgrade
-- scripts must be run sequentially.
-- 

delete from configuration where configuration_key = 'MODULE_PAYMENT_COD_ORDER_STATUS_ID';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, use_function, date_added, store_id) SELECT nextval for configuration_seq, 'Set Order Status', 'MODULE_PAYMENT_COD_ORDER_STATUS_ID', '0', 'Set the status of orders made with this payment module to this value.', 6, 0, 'tep_get_order_status_name', 'tep_cfg_pull_down_order_statuses(', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Maximum number of gift registry items displayed - to remove duplicates that can occur in store2
delete from configuration where configuration_key = 'MAX_DISPLAY_GIFT_REGISTRY_ITEMS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Gift Registry Items', 'MAX_DISPLAY_GIFT_REGISTRY_ITEMS', '20', 'Maximum number of gift registry items to display', 3, 25, 'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Reward points table
DROP TABLE kk_reward_points;
CREATE TABLE kk_reward_points (
  kk_reward_points_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  code VARCHAR(64),
  description VARCHAR(256),
  customers_id INTEGER DEFAULT 0 NOT NULL,
  initial_points INTEGER DEFAULT 0 NOT NULL,
  remaining_points INTEGER DEFAULT 0 NOT NULL,
  expired INTEGER DEFAULT 0 NOT NULL,
  tx_type INTEGER DEFAULT 0 NOT NULL,
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(kk_reward_points_id)
);
DROP SEQUENCE kk_reward_points_SEQ;
CREATE SEQUENCE kk_reward_points_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Reserved points table
DROP TABLE kk_reserved_points;
CREATE TABLE kk_reserved_points (
  kk_reserved_points_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  customers_id INTEGER DEFAULT 0 NOT NULL,
  reward_points_id INTEGER DEFAULT 0 NOT NULL,
  reservation_id INTEGER DEFAULT 0 NOT NULL,
  reserved_points INTEGER DEFAULT 0 NOT NULL,
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(kk_reserved_points_id)
);
DROP SEQUENCE kk_reserved_points_SEQ;
CREATE SEQUENCE kk_reserved_points_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

--Extra order attributes for reward points
ALTER TABLE orders add points_used int DEFAULT 0;
ALTER TABLE orders add points_awarded int DEFAULT 0;
ALTER TABLE orders add points_reservation_id int DEFAULT -1;

-- Allow user to insert reward points
DELETE FROM configuration where configuration_key = 'ENABLE_REWARD_POINTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Enable Reward Points', 'ENABLE_REWARD_POINTS', 'false', 'During checkout the customer will be allowed to enter reward points if set to true', 26, 1, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add the "Partially Deliverd" order status that may be missing in a multi-store environment
INSERT INTO orders_status (orders_status_id, language_id, orders_status_name, store_id) SELECT 7, language_id, 'Partially Delivered', store_id FROM orders_status WHERE orders_status_id = (SELECT min(orders_status_id) FROM orders_status) and language_id not in (SELECT language_id from orders_status where orders_status_id = 7);

-- Set the Cancelled Order Status for German, if present
UPDATE orders_status set orders_status_name = 'Teilweise geliefert' where orders_status_name = 'Partially Delivered' and language_id in (SELECT languages_id FROM languages WHERE code = 'de');
-- Set the Cancelled Order Status for Spanish, if present
UPDATE orders_status set orders_status_name = 'Entregado parcialmente' where orders_status_name = 'Partially Delivered' and language_id in (SELECT languages_id FROM languages WHERE code = 'es');
-- Set the Cancelled Order Status for Portuguese, if present
UPDATE orders_status set orders_status_name = 'Parcialmente entregue' where orders_status_name = 'Partially Delivered' and language_id in (SELECT languages_id FROM languages WHERE code = 'pt');

-- Add the new "Cancelled" order status
INSERT INTO orders_status (orders_status_id, language_id, orders_status_name, store_id) SELECT orders_status_id+1, language_id, 'Cancelled', store_id FROM orders_status WHERE orders_status_id = (SELECT max(orders_status_id) FROM orders_status);

-- Set the Cancelled Order Status for German, if present
UPDATE orders_status set orders_status_name = 'Abgesagt' where orders_status_name = 'Cancelled' and language_id in (SELECT languages_id FROM languages WHERE code = 'de');
-- Set the Cancelled Order Status for Spanish, if present
UPDATE orders_status set orders_status_name = 'Cancelado' where orders_status_name = 'Cancelled' and language_id in (SELECT languages_id FROM languages WHERE code = 'es');
-- Set the Cancelled Order Status for Portuguese, if present
UPDATE orders_status set orders_status_name = 'Cancelado' where orders_status_name = 'Cancelled' and language_id in (SELECT languages_id FROM languages WHERE code = 'pt');

-- Maximum number of reward point transactions displayed
delete from configuration where configuration_key = 'MAX_DISPLAY_REWARD_POINTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Reward Point Transactions', 'MAX_DISPLAY_REWARD_POINTS', '20', 'Maximum number of reward point transactions to display', 3, 26, 'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
-- Number of reward point awarded for registering
delete from configuration where configuration_key = 'REGISTRATION_REWARD_POINTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Reward Points for registering', 'REGISTRATION_REWARD_POINTS', '0', 'Reward points received for registration', 26, 2, 'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
-- Number of reward point awarded for writing a review
delete from configuration where configuration_key = 'REVIEW_REWARD_POINTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Reward Points for writing a review', 'REVIEW_REWARD_POINTS', '0', 'Reward points received for writing a review', 26, 3, 'integer(0,null)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Panel for Configuring Reward Points
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq,  'kk_panel_reward_points','Reward Points Configuration', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 92, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_promotions';

-- Reward Point API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getRewardPoints','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'deletePoints','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'importDigitalDownload','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'pointsAvailable','', current timestamp);

-- Add locale to customer and order
ALTER TABLE customers add customers_locale varchar(16);
ALTER TABLE orders add customers_locale varchar(16);

-- To enable/disable the new Rich Text Product Description Editor
delete from configuration where configuration_key = 'RICH_TEXT_EDITOR';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Use Rich Text Editor', 'RICH_TEXT_EDITOR', 'true', 'If true the Rich Text Editor is used for product descriptions, otherwise the Plain Text Editor is used', 9, 12, 'tep_cfg_select_option(array(''true'', ''false''), ', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

--MSSQL -- Increase the range of values allowed in quantity columns in MS SQL Server
--MSSQL ALTER TABLE products ALTER COLUMN products_quantity int;
--MSSQL ALTER TABLE customers_basket ALTER COLUMN customers_basket_quantity int;
--MSSQL ALTER TABLE orders_products ALTER COLUMN products_quantity int;

-- To allow the definition of the 1st Day of the Week on the Calendar Widget
delete from configuration where configuration_key = '1ST_DAY_OF_WEEK';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, '1st Day of the Week', '1ST_DAY_OF_WEEK', '0', 'Define the first day of the week for the calendars in the Admin App.', 21, 35, 'option(0=date.day.long.Sunday,1=date.day.long.Monday,2=date.day.long.Tuesday,3=date.day.long.Wednesday,4=date.day.long.Thursday,5=date.day.long.Friday,6=date.day.long.Saturday)', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Allow user to insert gift certificate code
DELETE FROM configuration where configuration_key = 'DISPLAY_GIFT_CERT_ENTRY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Display Gift Cert Entry Field', 'DISPLAY_GIFT_CERT_ENTRY', 'false', 'During checkout the customer will be allowed to enter a git certificate if set to true', 1, 22, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Configure the customer communications panel to show or not show a drop list of templates
UPDATE kk_role_to_panel set custom1=0, custom1_desc='If set, template names can be entered in a text box' where panel_id=62;
-- Configure the customer communications panel to show or not show a file upload button
UPDATE kk_role_to_panel set custom2=0, custom2_desc='If set, a file upload button is not displayed' where panel_id=62;

-- PDF Creation API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getPdf','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getFileContentsAsByteArray','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getLanguageIdForLocale','', current timestamp);

-- PDF Config panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_pdfConfig', 'PDF Configuration', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 93, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_reportsConfig';

-- PDF Configuration Parameters
DELETE FROM configuration where configuration_key = 'PDF_BASE_DIRECTORY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'PDF Directory', 'PDF_BASE_DIRECTORY', 'C:/Program Files/KonaKart/pdf', 'Defines the root directory for the location of the PDF documents that are created', 27, 5, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration where configuration_key = 'ENABLE_PDF_INVOICE_DOWNLOAD';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Enable PDF Invoice Download', 'ENABLE_PDF_INVOICE_DOWNLOAD', 'false', 'When set to true, invoices in PDF format can be downloaded from the application', 27, 10, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
 
-- Add column for Invoice filename 
ALTER TABLE orders add invoice_filename varchar(255);

-- Velocity Template Configuration Parameters
DELETE FROM configuration where configuration_key = 'TEMPLATE_BASE_DIRECTORY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Templates Directory', 'TEMPLATE_BASE_DIRECTORY', 'C:/Program Files/KonaKart/templates', 'Defines the root directory where the velocity templates are stored', 28, 10, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Velocity Template Config panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_templates', 'Template Configuration', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 94, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_reportsConfig';

-- Add extra column to returns table
ALTER TABLE orders_returns add orders_number varchar(128);

-- Config variable to automatically enable products when quantity > 0
DELETE FROM configuration where configuration_key = 'STOCK_ENABLE_PRODUCT';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Automatically Enable Product', 'STOCK_ENABLE_PRODUCT', 'false', 'Automatically enable a product if quantity is set to a positive number', 9, 4, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Configure the edit customer panel to allow editing of external customers only
UPDATE kk_role_to_panel set custom1=0, custom1_desc='Set to allow editing of external customer fields only' where panel_id in (select panel_id from kk_panel where code='kk_panel_editCustomer');

-- Configure the edit config files panel to control the upload of new files 
UPDATE kk_role_to_panel set custom1=0, custom1_desc='Set to allow upload of configuration files' where panel_id in (select panel_id from kk_panel where code='kk_panel_configFiles');

-- New Batch job for Creating Invoices
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'com.konakartadmin.bl.AdminOrderBatchMgr.createInvoicesBatch','', current timestamp);

-- Add new FileUpload configuration command
UPDATE configuration set set_function='FileUpload' where configuration_key = 'KONAKART_MAIL_PROPERTIES_FILE';
UPDATE configuration set set_function='FileUpload' where configuration_key = 'KK_NEW_STORE_SQL_FILENAME';
UPDATE configuration set set_function='FileUpload' where configuration_key = 'USER_NEW_STORE_SQL_FILENAME';

-- Added just as an example of using the FileUpload get_function in a module configuration parameter
DELETE FROM configuration where configuration_key = 'MODULE_PAYMENT_COD_MISC_CONFIG_FILE';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, use_function, date_added, store_id) SELECT nextval for configuration_seq, 'Miscellaneous Config File', 'MODULE_PAYMENT_COD_MISC_CONFIG_FILE', 'C:/Temp/cod_misc.properties', 'Miscellaneous Configuration File (just an example - not actually used).', 6, 6, 'FileUpload', '', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add index to customers table
CREATE INDEX i_cu_377c4b1a3685e ON customers (customers_email_address);

-- Addition of more custom fields to product object
ALTER TABLE products add custom6 varchar(128);
ALTER TABLE products add custom7 varchar(128);
ALTER TABLE products add custom8 varchar(128);
ALTER TABLE products add custom9 varchar(128);
ALTER TABLE products add custom10 varchar(128);
ALTER TABLE products add custom1Int int;
ALTER TABLE products add custom2Int int;
ALTER TABLE products add custom1Dec decimal(15,4);
ALTER TABLE products add custom2Dec decimal(15,4);
ALTER TABLE products add products_date_expiry TIMESTAMP;

-- Config variable to determine whether to show internal customer ids
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOMERS_DISPLAY_ID';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Display Customer Ids', 'ADMIN_APP_CUSTOMERS_DISPLAY_ID', 'true', 'When this is set, the customer id is displayed in the edit customer panel', 21, 29, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Extra attributes for product object
ALTER TABLE products add payment_schedule_id int default -1 not null;

-- Payment Schedule
DROP TABLE kk_payment_schedule;
CREATE TABLE kk_payment_schedule (
  kk_payment_schedule_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  name VARCHAR(64),
  description VARCHAR(256),
  length INTEGER DEFAULT 0 NOT NULL,
  unit INTEGER DEFAULT 0 NOT NULL,
  day_of_month INTEGER DEFAULT 0 NOT NULL,
  occurrences INTEGER DEFAULT 0 NOT NULL,
  trial_occurrences INTEGER DEFAULT 0 NOT NULL,
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(kk_payment_schedule_id)
);
DROP SEQUENCE kk_payment_schedule_SEQ;
CREATE SEQUENCE kk_payment_schedule_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Subscription
DROP TABLE kk_subscription;
CREATE TABLE kk_subscription (
  kk_subscription_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  orders_id INTEGER DEFAULT 0 NOT NULL,
  orders_number VARCHAR(128),
  customers_id INTEGER DEFAULT 0 NOT NULL,
  products_id INTEGER DEFAULT 0 NOT NULL,
  payment_schedule_id INTEGER DEFAULT 0 NOT NULL,
  products_sku VARCHAR(255),
  subscription_code VARCHAR(128),
  start_date TIMESTAMP,
  amount decimal(15,4) NOT NULL,
  trial_amount decimal(15,4),
  active INTEGER DEFAULT 0 NOT NULL,
  problem INTEGER DEFAULT 0 NOT NULL,
  problem_description VARCHAR(255),
  last_billing_date TIMESTAMP,
  next_billing_date TIMESTAMP,
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  custom4 VARCHAR(128),
  custom5 VARCHAR(128),
  date_added TIMESTAMP NOT NULL,
  last_modified TIMESTAMP,
  PRIMARY KEY(kk_subscription_id)
);
DROP SEQUENCE kk_subscription_SEQ;
CREATE SEQUENCE kk_subscription_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Payment Schedule Panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_payment_schedule', 'Payment Schedule', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 95, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_editProduct';

-- Subscription Panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_subscription', 'Subscription', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 96, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_editOrderPanel';

-- Subscription From Orders Panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_subscriptionFromOrders', 'Subscription From Orders', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 97, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_editOrderPanel';

-- Subscription from Customers Panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_subscriptionFromCustomers', 'Subscription From Customers', current timestamp);

-- Add Configure Reward Points to super admin role
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 98, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_editOrderPanel';

-- Extra attributes for ipn_history object
ALTER TABLE ipn_history add kk_subscription_id int default -1 not null;

-- Config variable to determine whether to show button for subscriptions panel
delete from configuration where configuration_key = 'ADMIN_APP_DISPLAY_SUBSCRIPTIONS_BUTTON';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Display Subscriptions Button', 'ADMIN_APP_DISPLAY_SUBSCRIPTIONS_BUTTON', 'false', 'When this is set, a Subscriptions button is displayed in the Customers and Orders panels', 21, 30, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Allow the same product to be entered into the basket more than once without updating the quantity of the existing one
DELETE FROM configuration where configuration_key = 'ALLOW_MULTIPLE_BASKET_ENTRIES';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Allow multiple basket entries', 'ALLOW_MULTIPLE_BASKET_ENTRIES', 'false', 'When set, allow the same product to be entered into the basket more than once without updating the quantity of the existing one', 9, 11, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Addition of extra telephone and eMail attributes
ALTER table customers add customers_telephone_1 varchar(32);
ALTER table address_book add entry_telephone varchar(32);
ALTER table address_book add entry_telephone_1 varchar(32);
ALTER table address_book add entry_email_address varchar(96);
ALTER table orders add customers_telephone_1 varchar(32);
ALTER table orders add delivery_telephone varchar(32);
ALTER table orders add delivery_telephone_1 varchar(32);
ALTER table orders add delivery_email_address varchar(96);
ALTER table orders add billing_telephone varchar(32);
ALTER table orders add billing_telephone_1 varchar(32);
ALTER table orders add billing_email_address varchar(96);

-- Make address format fields bigger
ALTER TABLE address_format ALTER COLUMN address_format SET DATA TYPE VARCHAR(256);
ALTER TABLE address_format ALTER COLUMN address_summary SET DATA TYPE VARCHAR(256);

-- Make product image fields bigger
ALTER TABLE products ALTER COLUMN products_image SET DATA TYPE VARCHAR(256);
ALTER TABLE products ALTER COLUMN products_image2 SET DATA TYPE VARCHAR(256);
ALTER TABLE products ALTER COLUMN products_image3 SET DATA TYPE VARCHAR(256);
ALTER TABLE products ALTER COLUMN products_image4 SET DATA TYPE VARCHAR(256);

exit;

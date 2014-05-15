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
-- KonaKart upgrade database script for MS Sql Server
-- From version 4.1.0.0 to version 4.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 4.1.0.0, the upgrade
-- scripts must be run sequentially.
-- 

ALTER TABLE products add index_attachment int default 0 not null;

-- API call for forcing registration of admin users even if already registered - delete and re-insert (it may or may not be present)
delete from kk_role_to_api_call where api_call_id in (select api_call_id from kk_api_call where name='forceRegisterCustomer');
delete from kk_api_call where name = 'forceRegisterCustomer';
INSERT INTO kk_api_call (name, description, date_added) VALUES ('forceRegisterCustomer','', getdate());

-- Maximum number of gift registry items displayed
delete from configuration where configuration_key = 'MAX_DISPLAY_GIFT_REGISTRY_ITEMS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Gift Registry Items', 'MAX_DISPLAY_GIFT_REGISTRY_ITEMS', '20', 'Maximum number of gift registry items to display', '3', '25', 'integer(0,null)', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- WishList APIs for the Admin App... used by the XML_IO utility
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getWishLists','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertWishList','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteWishList','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertWishListItem','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteWishListItem','', getdate());

-- Tables for CustomerTags
DROP TABLE kk_customer_tag;
CREATE TABLE kk_customer_tag (
  kk_customer_tag_id int NOT NULL identity(1,1),
  store_id varchar(64),
  name varchar(64) NOT NULL,
  description varchar(255) NOT NULL,
  validation varchar(128),
  tag_type integer DEFAULT 0 NOT NULL,
  max_ints integer DEFAULT 1,
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  custom4 varchar(128),
  custom5 varchar(128),
  date_added datetime NOT NULL,
  PRIMARY KEY(kk_customer_tag_id)
   );
CREATE INDEX idx_name_kk_customer_tag ON kk_customer_tag (name);
CREATE INDEX idx_store_id_kk_customer_tag ON kk_customer_tag (store_id);

DROP TABLE kk_customers_to_tag;
CREATE TABLE kk_customers_to_tag (
  kk_customer_tag_id int DEFAULT 0 NOT NULL,
  customers_id int DEFAULT 0 NOT NULL,
  store_id varchar(64),
  name varchar(64) NOT NULL,
  tag_value varchar(255),
  date_added datetime NOT NULL,
  PRIMARY KEY(kk_customer_tag_id, customers_id)
);
CREATE INDEX idx_name_kk_customers_to_tag ON kk_customers_to_tag (name);
CREATE INDEX idx_stor_kk_customers_to_tag ON kk_customers_to_tag (store_id);

-- AdminApp CustomerTag API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertCustomerTag','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getCustomerTag','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteCustomerTag','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateCustomerTag','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getCustomerTags','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteCustomerTagForCustomer','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getCustomerTagForCustomer','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getCustomerTagForName','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getCustomerTagsForCustomer','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertCustomerTagForCustomer','', getdate());
    
-- Admin Engine Address API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getAddressById','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getAddresses','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertAddress','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateAddress','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteAddress','', getdate());

-- Add a new panel for managing customer tags
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custTags','Customer Tags', getdate());

-- Allow all roles which can currently access kk_panel_editCustomer access the new kk_panel_custTags
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 89, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_editCustomer';

-- Email Integration Class
delete from configuration where configuration_key = 'EMAIL_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Email Integration Class', 'EMAIL_INTEGRATION_CLASS', 'com.konakart.bl.EmailIntegrationMgr', 'The Email Integration Implementation Class to enable you to change the toAddress of the mail', '12', '16', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Tables for Expressions
DROP TABLE kk_expression;
CREATE TABLE kk_expression (
  kk_expression_id int NOT NULL identity(1,1),
  store_id varchar(64),
  name varchar(64) NOT NULL,
  description varchar(255),
  num_variables integer DEFAULT 0 NOT NULL,
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  date_added datetime NOT NULL,
  PRIMARY KEY(kk_expression_id)
   );
CREATE INDEX idx_name_kk_expression ON kk_expression (name);
CREATE INDEX idx_store_id_kk_expression ON kk_expression (store_id);

DROP TABLE kk_expression_variable;
CREATE TABLE kk_expression_variable (
  kk_expression_variable_id int NOT NULL identity(1,1),
  kk_customer_tag_id int DEFAULT 0 NOT NULL,
  kk_expression_id int DEFAULT 0 NOT NULL,
  store_id varchar(64),
  tag_type integer DEFAULT 0 NOT NULL,
  tag_value varchar(255) NOT NULL,
  operator integer DEFAULT 0 NOT NULL,
  tag_order integer DEFAULT 0 NOT NULL,
  tag_and_or integer DEFAULT 0 NOT NULL,
  group_order integer DEFAULT 0 NOT NULL,
  group_and_or integer DEFAULT 0 NOT NULL,
  date_added datetime NOT NULL,
  PRIMARY KEY(kk_expression_variable_id)
   );
CREATE INDEX idx_exp_kk_express_to_tag ON kk_expression_variable (kk_expression_id);
CREATE INDEX idx_stor_kk_express_to_tag ON kk_expression_variable (store_id);

-- AdminApp Expression API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertExpression','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateExpression','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteExpression','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpression','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpressions','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpressionVariable','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpressionVariablesForExpression','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpressionForName','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertExpressionVariables','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateExpressionVariable','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteExpressionVariable','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteExpressionVariablesForExpression','', getdate());

-- Add new kk_panel_expressions panel for managing expressions
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_expressions','Expressions', getdate());

-- Allow all roles which can currently access kk_panel_promotions access the new kk_panel_expressions
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 90, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_promotions';

-- Add new kk_panel_variablesFromExp panel for managing expressions
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_variablesFromExp','Expression Variables', getdate());

-- Allow all roles which can currently access kk_panel_promotions access the new kk_panel_variablesFromExp
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, 91, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p where rtp.panel_id=p.panel_id and p.code='kk_panel_promotions';

-- Connect the promotion to expressions
DROP TABLE kk_promotion_to_expression;
CREATE TABLE kk_promotion_to_expression (
  promotion_id int NOT NULL,
  kk_expression_id int NOT NULL,
  store_id varchar(64),
  PRIMARY KEY(promotion_id,kk_expression_id)
);
CREATE INDEX idx_store_id ON kk_promotion_to_expression (store_id);

-- AdminApp Promotion - Expression API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('addExpressionsToPromotion','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getExpressionsPerPromotion','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('removeExpressionsFromPromotion','', getdate());

--Customer tag examples
delete from kk_customer_tag where name ='PRODUCTS_VIEWED';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'PRODUCTS_VIEWED', 'Recently viewed product id', '((:[0-9]*)*:|)', 2, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='CATEGORIES_VIEWED';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'CATEGORIES_VIEWED', 'Recently viewed category id', '((:[0-9]*)*:|)', 2, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='MANUFACTURERS_VIEWED';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'MANUFACTURERS_VIEWED', 'Recently viewed manufacturer id', '((:[0-9]*)*:|)', 2, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='PRODUCTS_IN_CART';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'PRODUCTS_IN_CART', 'Id of a product in the cart', '((:[0-9]*)*:|)', 2, 50, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='PRODUCTS_IN_WISHLIST';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'PRODUCTS_IN_WISHLIST', 'Id of a product in the Wish List', '((:[0-9]*)*:|)', 2, 50, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='SEARCH_STRING';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added, store_id) SELECT 'SEARCH_STRING', 'Product Search String', 0, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='COUNTRY_CODE';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added, store_id) SELECT 'COUNTRY_CODE', 'Country code of customer', 0, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='CART_TOTAL';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added, store_id) SELECT 'CART_TOTAL', 'Cart total', 3, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='WISHLIST_TOTAL';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added, store_id) SELECT 'WISHLIST_TOTAL', 'Wish List total', 3, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='BIRTH_DATE';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added, store_id) SELECT 'BIRTH_DATE', 'Date of Birth', 4, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';
delete from kk_customer_tag where name ='IS_MALE';
INSERT INTO kk_customer_tag (name, description, validation, tag_type, max_ints, date_added, store_id) SELECT 'IS_MALE', 'Customer is Male', 'true|false', 5, 5, getdate(), store_id FROM countries where countries_iso_code_2 = 'US';

-- Enable / Disable customer tag functionality from application
delete from configuration where configuration_key = 'ENABLE_CUSTOMER_TAGS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Enable Customer Tag functionality', 'ENABLE_CUSTOMER_TAGS', 'false', 'When set to true, the application sets customer tags. All tag functionality is disabled when false.', '5', '6', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Enable / Disable customer cart tag functionality from application
delete from configuration where configuration_key = 'ENABLE_CUSTOMER_CART_TAGS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Enable Customer Cart Tag functionality', 'ENABLE_CUSTOMER_CART_TAGS', 'false', 'When set to true, the application sets customer cart tags', '5', '7', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Enable / Disable customer wishlist tag functionality from application
delete from configuration where configuration_key = 'ENABLE_CUSTOMER_WISHLIST_TAGS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Enable Customer WishList Tag functionality', 'ENABLE_CUSTOMER_WISHLIST_TAGS', 'false', 'When set to true, the application sets customer wish list tags', '5', '8', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Config variables to determine whether to show internal ids
delete from configuration where configuration_key = 'ADMIN_APP_PRODUCTS_DISPLAY_ID';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Display Product Ids', 'ADMIN_APP_PRODUCTS_DISPLAY_ID', 'true', 'When this is set, the product id is displayed in the products panel', '21', '29', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

delete from configuration where configuration_key = 'ADMIN_APP_MANUFACTURERS_DISPLAY_ID';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Display Manufacturer Ids', 'ADMIN_APP_MANUFACTURERS_DISPLAY_ID', 'true', 'When this is set, the manufacturer id is displayed in the manufacturers panel', '21', '30', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

delete from configuration where configuration_key = 'ADMIN_APP_CATEGORIES_DISPLAY_ID';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Display Category Ids', 'ADMIN_APP_CATEGORIES_DISPLAY_ID', 'true', 'When this is set, the category id is displayed in the categories panel', '21', '31', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Evaluate Expression Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('evaluateExpression','', getdate());

-- Add these config variables to stores where they are currently absent
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Display Order Number', 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM', '', 'When this is set, the order number is displayed in the orders panel rather than the order id', '21', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM kk_store where store_id not in (SELECT ks.store_id from configuration c2, kk_store ks where c2.configuration_key = 'ADMIN_APP_ORDERS_DISPLAY_ORDER_NUM' and ks.store_id = c2.store_id) and store_id != 'store1';

INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT 'Allow Cust Group Change eMail', 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL', 'true', 'When this is set, a popup window appears when the group of a customer is changed to allow you to send an eMail', '21', '28', 'tep_cfg_select_option(array(''true'', ''false''), ', getdate(), store_id FROM kk_store where store_id not in (SELECT ks.store_id from configuration c2, kk_store ks where c2.configuration_key = 'ADMIN_APP_ALLOW_GROUP_CHANGE_MAIL' and ks.store_id = c2.store_id) and store_id != 'store1';

INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Product Select Template', 'ADMIN_APP_PROD_SEL_TEMPLATE', '$name', 'Sets the template for which attributes to view when selecting a product ($name, $sku, $id, $model, $manufacturer, $custom1 ... $custom5', '21', '25', getdate(), store_id FROM kk_store where store_id not in (SELECT ks.store_id from configuration c2, kk_store ks where c2.configuration_key = 'ADMIN_APP_PROD_SEL_TEMPLATE' and ks.store_id = c2.store_id) and store_id != 'store1';

INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Product Select Default Num Prods', 'ADMIN_APP_PROD_SEL_NUM_PRODS', '0', 'Sets the default number of products displayed in the product select dialogs when opened', '21', '26', getdate(), store_id FROM kk_store where store_id not in (SELECT ks.store_id from configuration c2, kk_store ks where c2.configuration_key = 'ADMIN_APP_PROD_SEL_NUM_PRODS' and ks.store_id = c2.store_id) and store_id != 'store1';

INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Product Select Max Num Prods', 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS', '100', 'Sets the maximum number of products displayed in the product select dialogs after a search', '21', '27', getdate(), store_id FROM kk_store where store_id not in (SELECT ks.store_id from configuration c2, kk_store ks where c2.configuration_key = 'ADMIN_APP_PROD_SEL_MAX_NUM_PRODS' and ks.store_id = c2.store_id) and store_id != 'store1';

-- Product Price Table
DROP TABLE kk_product_prices;
CREATE TABLE kk_product_prices (
  store_id varchar(64),
  catalog_id varchar(32) NOT NULL,
  products_id int NOT NULL,
  products_attributes_id int NOT NULL,
  products_price_0 decimal(15,4),
  products_price_1 decimal(15,4),
  products_price_2 decimal(15,4),
  products_price_3 decimal(15,4),
  PRIMARY KEY(catalog_id,products_id, products_attributes_id)
);

-- Extra attribute for product object
ALTER TABLE products add rating decimal(15,4);

-- Update image names

update products set products_image = 'dvd/replacement_killers.jpg'          where products_image = 'dvd/replacement_killers.gif';
update products set products_image = 'dvd/blade_runner.jpg'                 where products_image = 'dvd/blade_runner.gif';
update products set products_image = 'dvd/the_matrix.jpg'                   where products_image = 'dvd/the_matrix.gif';
update products set products_image = 'dvd/youve_got_mail.jpg'               where products_image = 'dvd/youve_got_mail.gif';
update products set products_image = 'dvd/a_bugs_life.jpg'                  where products_image = 'dvd/a_bugs_life.gif';
update products set products_image = 'dvd/under_siege.jpg'                  where products_image = 'dvd/under_siege.gif';
update products set products_image = 'dvd/under_siege2.jpg'                 where products_image = 'dvd/under_siege2.gif';
update products set products_image = 'dvd/fire_down_below.jpg'              where products_image = 'dvd/fire_down_below.gif';
update products set products_image = 'dvd/die_hard_3.jpg'                   where products_image = 'dvd/die_hard_3.gif';
update products set products_image = 'dvd/lethal_weapon.jpg'                where products_image = 'dvd/lethal_weapon.gif';
update products set products_image = 'dvd/red_corner.jpg'                   where products_image = 'dvd/red_corner.gif';
update products set products_image = 'dvd/frantic.jpg'                      where products_image = 'dvd/frantic.gif';
update products set products_image = 'dvd/courage_under_fire.jpg'           where products_image = 'dvd/courage_under_fire.gif';
update products set products_image = 'dvd/speed.jpg'                        where products_image = 'dvd/speed.gif';
update products set products_image = 'dvd/speed2.jpg'                       where products_image = 'dvd/speed_2.gif';
update products set products_image = 'dvd/theres_something_about_mary.jpg'  where products_image = 'dvd/theres_something_about_mary.gif';
update products set products_image = 'dvd/beloved.jpg'                      where products_image = 'dvd/beloved.gif';

update products set products_image = 'sierra/swat3.jpg'                     where products_image = 'sierra/swat_3.gif';

update products set products_image = 'gt_interactive/unreal_tournament.jpg' where products_image = 'gt_interactive/unreal_tournament.gif';
update products set products_image = 'gt_interactive/wheel_of_time.jpg'     where products_image = 'gt_interactive/wheel_of_time.gif';
update products set products_image = 'gt_interactive/disciples.jpg'         where products_image = 'gt_interactive/disciples.gif';

update products set products_image = 'hewlett_packard/lj1100xi.jpg'         where products_image = 'hewlett_packard/lj1100xi.gif';

update products set products_image = 'matrox/mg400-32mb.jpg'                where products_image = 'matrox/mg400-32mb.gif';
update products set products_image = 'matrox/mg200mms.jpg'                  where products_image = 'matrox/mg200mms.gif';

update products set products_image = 'microsoft/bundle.jpg'                 where products_image = 'microsoft/bundle.gif';
update products set products_image = 'microsoft/imexplorer.jpg'             where products_image = 'microsoft/imexplorer.gif';
update products set products_image = 'microsoft/intkeyboardps2.jpg'         where products_image = 'microsoft/intkeyboardps2.gif';
update products set products_image = 'microsoft/msimpro.jpg'                where products_image = 'microsoft/msimpro.gif';

-- Add index to products_attributes table
CREATE INDEX i_prproducts_attributes ON products_attributes (products_id);

----------- 26-Nov-2009

-- New Digital Download table
DROP TABLE kk_digital_download_1;
CREATE TABLE kk_digital_download_1 (
  kk_digital_download_id int NOT NULL identity(1,1),
  store_id varchar(64),
  products_id int DEFAULT 0 NOT NULL,
  customers_id int DEFAULT 0 NOT NULL,
  products_file_path varchar(255),
  max_downloads int DEFAULT -1,
  times_downloaded int DEFAULT 0,
  expiration_date datetime,
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(kk_digital_download_id)
);
CREATE INDEX i_prodid_kk_digdown_1 ON kk_digital_download_1 (products_id);
CREATE INDEX i_custid_kk_digdown_1 ON kk_digital_download_1 (customers_id);
CREATE INDEX i_storid_kk_digdown_1 ON kk_digital_download_1 (store_id);

-- Move records over from kk_digital_download to the new kk_digital_download_1 table
INSERT INTO kk_digital_download_1 (store_id, products_id, customers_id, max_downloads, times_downloaded,expiration_date, date_added, last_modified) SELECT store_id, products_id, customers_id, max_downloads, times_downloaded,expiration_date, date_added, last_modified from kk_digital_download;

-- Now we can remove the kk_digital_download table
DROP TABLE kk_digital_download;

-- Add column to promotion_to_product table
ALTER TABLE promotion_to_product add relation_type int default '0';

-- GiftCertificate APIs for the Admin App
INSERT INTO kk_api_call (name, description, date_added) VALUES ('addGiftCertificatesToPromotion','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getGiftCertificatesPerPromotion','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('removeGiftCertificatesFromPromotion','', getdate());

-- Table to store secret key used in payment gateways
DROP TABLE kk_secret_key;
CREATE TABLE kk_secret_key (
  kk_secret_key_id int NOT NULL identity(1,1),
  secret_key varchar(255) NOT NULL,
  orders_id integer NOT NULL,
  date_added datetime NOT NULL,
  PRIMARY KEY(kk_secret_key_id)
   );
CREATE INDEX idx_secret_key_kk_secret_key ON kk_secret_key (secret_key);

-- Digital Download Admin API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('searchDigitalDownloads','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('importDigitalDownload','', getdate());

exit;

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
-- From version 5.2.0.0 to version 5.3.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.2.0.0, the upgrade
-- scripts must be run sequentially.
-- 

DROP TABLE kk_cust_attr;
CREATE TABLE kk_cust_attr (
  kk_cust_attr_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  name VARCHAR(64) NOT NULL,
  msg_cat_key VARCHAR(128),
  attr_type integer DEFAULT -1,
  template VARCHAR(128),
  validation VARCHAR(512),
  set_function VARCHAR(512),
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(kk_cust_attr_id)
   );
DROP SEQUENCE kk_cust_attr_SEQ;
CREATE SEQUENCE kk_cust_attr_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

DROP TABLE kk_cust_attr_tmpl;
CREATE TABLE kk_cust_attr_tmpl (
  kk_cust_attr_tmpl_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255),
  custom1 VARCHAR(128),
  custom2 VARCHAR(128),
  custom3 VARCHAR(128),
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(kk_cust_attr_tmpl_id)
   );
DROP SEQUENCE kk_cust_attr_tmpl_SEQ;
CREATE SEQUENCE kk_cust_attr_tmpl_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

DROP TABLE kk_tmpl_to_cust_attr;
CREATE TABLE kk_tmpl_to_cust_attr (
  kk_cust_attr_tmpl_id INTEGER DEFAULT 0 NOT NULL,
  kk_cust_attr_id INTEGER DEFAULT 0 NOT NULL,
  store_id VARCHAR(64),
  sort_order INTEGER DEFAULT 0 NOT NULL,
  PRIMARY KEY(kk_cust_attr_tmpl_id, kk_cust_attr_id)
);

-- Custom product attribute panels
set echo on
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_prodAttrTemplates', 'Product Custom Attribute Templates', current timestamp);
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_prodAttrDescs', 'Product Custom Attributes', current timestamp);

-- Add Panel access to all roles that can access the Product maintenance panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prodAttrTemplates';
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prodAttrDescs';

-- New Product Custom Attribute APIs
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'deleteProdAttrDesc','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'deleteProdAttrTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getProdAttrDesc','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getProdAttrTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getProdAttrDescs','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getProdAttrDescsForTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getProdAttrTemplates','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'insertProdAttrDesc','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'insertProdAttrTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'updateProdAttrDesc','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'updateProdAttrTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'removeProdAttrDescsFromTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'addProdAttrDescsToTemplate','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'getTemplateCountPerProdAttrDesc','', current timestamp);

-- Configuration for select product custom attr panels in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_PROD_ATTR_SEL_NUM_PROD_ATTRS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Prod Custom Attr Panel Default Num Attrs', 'ADMIN_APP_PROD_ATTR_SEL_NUM_PROD_ATTRS', '50', 'Sets the default number of product attributes displayed in the product attribute dialogs when opened', 21, 56, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_PROD_ATTR_SEL_MAX_NUM_PROD_ATTRS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Prod Custom Attr Panel Max Num Attrs', 'ADMIN_APP_PROD_ATTR_SEL_MAX_NUM_PROD_ATTRS', '100', 'Sets the maximum number of product attributes displayed in the product attribute dialogs after a search', 21, 57, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Configuration for select template panels in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_TMPL_SEL_NUM_TMPLS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Template Panel Default Num Templates', 'ADMIN_APP_TMPL_SEL_NUM_TMPLS', '50', 'Sets the default number of templates displayed in the select template dialogs when opened', 21, 58, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_TMPL_SEL_MAX_NUM_TMPLS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT nextval for configuration_seq, 'Template Panel Max Num Templates', 'ADMIN_APP_TMPL_SEL_MAX_NUM_TMPLS', '100', 'Sets the maximum number of templatess displayed in the select template dialogs after a search', 21, 59, current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add template / custom attribute attributes to product
ALTER TABLE products ADD cust_attr_tmpl_id int DEFAULT -1;
ALTER TABLE products ADD custom_attrs VARCHAR(4000);


-- Configuration variable for defining the way searches are done - for Oracle CLOB support etc
DELETE FROM configuration WHERE configuration_key = 'FETCH_PRODUCT_DESCRIPTIONS_SEPARATELY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order,  set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Fetch Descriptions Separately', 'FETCH_PRODUCT_DESCRIPTIONS_SEPARATELY', 'false', 'Fetch Product Descriptions Separately', 9, 30, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Customer tags for preferences
DELETE FROM kk_customer_tag WHERE name ='PROD_PAGE_SIZE';
INSERT INTO kk_customer_tag (kk_customer_tag_id, name, description, tag_type, max_ints, date_added) VALUES (nextval for kk_customer_tag_seq,'PROD_PAGE_SIZE', 'The page size for product lists', 1, 0, current timestamp);
DELETE FROM kk_customer_tag WHERE name ='ORDER_PAGE_SIZE';
INSERT INTO kk_customer_tag (kk_customer_tag_id, name, description, tag_type, max_ints, date_added) VALUES (nextval for kk_customer_tag_seq,'ORDER_PAGE_SIZE', 'The page size for order lists', 1, 0, current timestamp);
DELETE FROM kk_customer_tag WHERE name ='REVIEW_PAGE_SIZE';
INSERT INTO kk_customer_tag (kk_customer_tag_id, name, description, tag_type, max_ints, date_added) VALUES (nextval for kk_customer_tag_seq,'REVIEW_PAGE_SIZE', 'The page size for review lists', 1, 0, current timestamp);

-- Add a Message Catalog Key to the countries table to allow country names in multiple languages - default the value of this to the ISO-3 value
ALTER TABLE countries ADD msgCatKey VARCHAR(32);
UPDATE countries set msgCatKey = CONCAT('CTRY.',countries_iso_code_3);

-- Configuration variable for defining whether to look up country names in the message catalog or not
DELETE FROM configuration WHERE configuration_key = 'USE_MSG_CAT_FOR_COUNTRY_NAMES';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order,  set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Use Country Names in Msg Cat', 'USE_MSG_CAT_FOR_COUNTRY_NAMES', 'false', 'Use the Country Names in the Message Catalogues', 1, 29, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Demo data for Custom product attributes
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, msg_cat_key, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'radio', 'label.size', 0, 'choice(''label.small'',''label.medium'',''label.large'')', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, msg_cat_key, attr_type, validation, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'true-false', 'label.true.false', 4, 'true|false', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, msg_cat_key, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'dropList', 'label.size', 0, 'option(s=label.small,m=label.medium,l=label.large)', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'integer-1-to-10', 1, 'integer(1,10)', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'any-int', 1, 'integer(null,null)', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'decimal-1.5-to-2.3', 2, 'double(1.5,2.3)', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, set_function, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'string-length-4', 0, 'string(4,4)', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, template, validation, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'date-dd/MM/yyyy', 3, 'dd/MM/yyyy', '^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((1[6-9]|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((1[6-9]|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((1[6-9]|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$', current timestamp, L.store_id from (select distinct store_id from languages) L;
INSERT INTO kk_cust_attr (kk_cust_attr_id, name, attr_type, custom1, custom2, custom3, date_added, store_id) SELECT nextval for kk_cust_attr_SEQ, 'any-string-use-custom', 0, 'c1', 'c2', 'c3', current timestamp, L.store_id from (select distinct store_id from languages) L;

-- Table for storing customer statistics data
DROP TABLE kk_cust_stats;
CREATE TABLE kk_cust_stats (
  cust_stats_id INTEGER NOT NULL,
  store_id VARCHAR(64),
  customers_id INTEGER DEFAULT 0,
  event_type INTEGER DEFAULT 0,
  data1Str VARCHAR(128),
  data2Str VARCHAR(128),
  data1Int int,
  data2Int int,
  data1Dec decimal(15,4),
  data2Dec decimal(15,4),
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(cust_stats_id)
   );
DROP SEQUENCE kk_cust_stats_SEQ;
CREATE SEQUENCE kk_cust_stats_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Enable / Disable customer event functionality from application
DELETE FROM configuration WHERE configuration_key = 'ENABLE_CUSTOMER_EVENTS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, store_id) SELECT nextval for configuration_seq, 'Enable Customer Event functionality', 'ENABLE_CUSTOMER_EVENTS', 'false', 'When set to true, the application inserts customer events. All event functionality is disabled when false.', 5, 9, 'choice(''true'', ''false'')', current timestamp, store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Visibility of Customers - Customers are visible by default
ALTER TABLE customers ADD invisible INTEGER NOT NULL DEFAULT 0;

-- Virtual Customer 2 Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (nextval for kk_panel_seq, 'kk_panel_customers_2', 'Customers 2', current timestamp);

-- Add Panel access to all roles that can access the Customer panel - default to not allow access to invisible customers
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, 0, 'Set to Access Invisible Customers', current timestamp, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_customers_2';

-- New Admin Payment Module API
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'callPaymentModule','', current timestamp);

exit;

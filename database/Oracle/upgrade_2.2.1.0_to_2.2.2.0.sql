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
-- KonaKart upgrade database script for Oracle
-- From version 2.2.1.0 to version 2.2.2.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.1.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
UPDATE configuration set configuration_value = 'false', configuration_description='This allows checkout without registration only when one page checkout is enabled' where configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';


-- Add a new panel
set echo on
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_communications','Customer Communications', sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 62, 1,1,1,sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 62, 1,1,1,sysdate);

-- New API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'sendTemplateEmailToCustomers1','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductNotification','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProductNotification','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomerForEmail','', sysdate);

-- Number of concurrent eMail sending threads to use for sending out the newsletter
delete from configuration where configuration_key = 'EMAIL_THREADS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'Number of email sender threads', 'EMAIL_THREADS', '5', 'Number of concurrent threads used to send newsletter eMails', '12', '15', sysdate);

-- Addition of custom fields to orders_products and customers_basket

ALTER TABLE orders_products add custom1 varchar(128);
ALTER TABLE orders_products add custom2 varchar(128);
ALTER TABLE orders_products add custom3 varchar(128);
ALTER TABLE orders_products add custom4 varchar(128);
ALTER TABLE orders_products add custom5 varchar(128);

ALTER TABLE customers_basket add custom1 varchar(128);
ALTER TABLE customers_basket add custom2 varchar(128);
ALTER TABLE customers_basket add custom3 varchar(128);
ALTER TABLE customers_basket add custom4 varchar(128);
ALTER TABLE customers_basket add custom5 varchar(128);

-- Customer group
DROP TABLE kk_customer_group CASCADE CONSTRAINTS;
CREATE TABLE kk_customer_group (
  customer_group_id NUMBER(10,0) DEFAULT 0 NOT NULL,
  language_id NUMBER(10,0) DEFAULT 1 NOT NULL,
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(128),
  date_added TIMESTAMP,
  last_modified TIMESTAMP,
  PRIMARY KEY(customer_group_id, language_id)
);

ALTER TABLE customers add customers_group_id int default '-1';
ALTER TABLE promotion add customer_group_rule int default '0';

DROP TABLE promotion_to_cust_group CASCADE CONSTRAINTS;
CREATE TABLE promotion_to_cust_group (
  promotion_id NUMBER(10,0) NOT NULL,
  customers_group_id NUMBER(10,0) NOT NULL,
  PRIMARY KEY(promotion_id,customers_group_id)
);

INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeCustomerGroupsFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addCustomerGroupsToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomerGroupsPerPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCustomerGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateCustomerGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCustomerGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomerGroups','', sysdate);



exit;

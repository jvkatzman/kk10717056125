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
-- KonaKart upgrade database script for PostgreSQL
-- From version 2.2.1.0 to version 2.2.2.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.1.0, the upgrade
-- scripts must be run sequentially.
-- 
UPDATE configuration set configuration_value = 'false', configuration_description='This allows checkout without registration only when one page checkout is enabled' where configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';


-- Add a new panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (DEFAULT, 'kk_panel_communications','Customer Communications', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 62, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 62, 1,1,1,now());

-- New API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'sendTemplateEmailToCustomers1','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductNotification','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProductNotification','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerForEmail','', now());

-- Number of concurrent eMail sending threads to use for sending out the newsletter
delete from configuration where configuration_key = 'EMAIL_THREADS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Number of email sender threads', 'EMAIL_THREADS', '5', 'Number of concurrent threads used to send newsletter eMails', '12', '15', now());

-- Addition of custom fields to orders_products and customers_basket

ALTER TABLE orders_products add column custom1 varchar(128);
ALTER TABLE orders_products add column custom2 varchar(128);
ALTER TABLE orders_products add column custom3 varchar(128);
ALTER TABLE orders_products add column custom4 varchar(128);
ALTER TABLE orders_products add column custom5 varchar(128);

ALTER TABLE customers_basket add column custom1 varchar(128);
ALTER TABLE customers_basket add column custom2 varchar(128);
ALTER TABLE customers_basket add column custom3 varchar(128);
ALTER TABLE customers_basket add column custom4 varchar(128);
ALTER TABLE customers_basket add column custom5 varchar(128);

-- Customer group
DROP TABLE IF EXISTS kk_customer_group;
CREATE TABLE kk_customer_group (
   customer_group_id integer DEFAULT '0' NOT NULL,
   language_id integer DEFAULT '1' NOT NULL,
   name varchar(64) NOT NULL,
   description varchar(128),
   date_added timestamp,
   last_modified timestamp,
   PRIMARY KEY (customer_group_id, language_id)
);

ALTER TABLE customers add column customers_group_id int default '-1';
ALTER TABLE promotion add column customer_group_rule int default '0';

DROP TABLE IF EXISTS promotion_to_cust_group;
CREATE TABLE promotion_to_cust_group (
  promotion_id integer NOT NULL,
  customers_group_id integer NOT NULL,
  PRIMARY KEY (promotion_id,customers_group_id)
);

INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeCustomerGroupsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCustomerGroupsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerGroupsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerGroups','', now());




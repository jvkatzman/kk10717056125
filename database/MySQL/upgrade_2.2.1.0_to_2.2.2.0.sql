#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.1.0 to version 2.2.2.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.1.0, the upgrade 
# scripts must be run sequentially

# Do not allow checkout without registration by default
UPDATE configuration set configuration_value = 'false', configuration_description='This allows checkout without registration only when one page checkout is enabled' where configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';


# Add a new panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (62, 'kk_panel_communications','Customer Communications', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 62, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 62, 1,1,1,now());

# New API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (178, 'sendTemplateEmailToCustomers1','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (179, 'insertProductNotification','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (180, 'deleteProductNotification','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (181, 'getCustomerForEmail','', now());

# Number of concurrent eMail sending threads to use for sending out the newsletter
delete from configuration where configuration_key = 'EMAIL_THREADS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Number of email sender threads', 'EMAIL_THREADS', '5', 'Number of concurrent threads used to send newsletter eMails', '12', '15', now());

# Addition of custom fields to orders_products and customers_basket

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

# Customer group
DROP TABLE IF EXISTS kk_customer_group;
CREATE TABLE kk_customer_group (
   customer_group_id int DEFAULT '0' NOT NULL,
   language_id int DEFAULT '1' NOT NULL,
   name varchar(64) NOT NULL,
   description varchar(128),
   date_added datetime,
   last_modified datetime,
   PRIMARY KEY (customer_group_id, language_id)
);

ALTER TABLE customers add column customers_group_id int default '-1';
ALTER TABLE promotion add column customer_group_rule int default '0';

DROP TABLE IF EXISTS promotion_to_cust_group;
CREATE TABLE promotion_to_cust_group (
  promotion_id int NOT NULL,
  customers_group_id int NOT NULL,
  PRIMARY KEY (promotion_id,customers_group_id)
);

INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (182, 'removeCustomerGroupsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (183, 'addCustomerGroupsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (184, 'getCustomerGroupsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (185, 'insertCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (186, 'updateCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (187, 'deleteCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (188, 'getCustomerGroups','', now());




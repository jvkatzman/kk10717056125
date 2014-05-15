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
# From version 2.2.5.0 to version 2.2.6.0
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.5.0, the upgrade
# scripts must be run sequentially.
# 

ALTER TABLE products_to_products add products_options varchar(128);
ALTER TABLE products_to_products add products_quantity int;

-- New API calls
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getBundleProductDetails','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'customSecure','', getdate());

-- Tags

DROP TABLE kk_tag_group;
CREATE TABLE kk_tag_group (
  tag_group_id int DEFAULT 0 NOT NULL,
  language_id int DEFAULT 1 NOT NULL,
  name varchar(128) NOT NULL,
  description varchar(255),
  PRIMARY KEY(tag_group_id, language_id)
);

DROP TABLE kk_tag;
CREATE TABLE kk_tag (
  tag_id int DEFAULT 0 NOT NULL,
  language_id int DEFAULT 1 NOT NULL,
  name varchar(128) NOT NULL,
  sort_order int DEFAULT 0,
  PRIMARY KEY(tag_id, language_id)
);

DROP TABLE kk_category_to_tag_group;
CREATE TABLE kk_category_to_tag_group (
  categories_id int NOT NULL,
  tag_group_id int NOT NULL,
  PRIMARY KEY(categories_id,tag_group_id)
);

DROP TABLE kk_tag_group_to_tag;
CREATE TABLE kk_tag_group_to_tag (
  tag_group_id int NOT NULL,
  tag_id int NOT NULL,
  PRIMARY KEY(tag_group_id,tag_id)
);

DROP TABLE kk_tag_to_product;
CREATE TABLE kk_tag_to_product (
  tag_id int NOT NULL,
  products_id int NOT NULL,
  date_added datetime NOT NULL,
  PRIMARY KEY(tag_id,products_id)
);

-- Panels for maintaining Tags
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_tagGroups','Maintain Tag Groups', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_tags','Maintain Tags', getdate());

-- Tag API calls
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getTags','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getTagGroups','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertTag','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertTags','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertGroups','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateTag','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateTagGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteTag','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteTagGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getTagGroupsPerCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addTagGroupsToCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeTagGroupsFromCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getTagsPerProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addTagsToProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeTagsFromProduct','', getdate());

-- Save shipping and payment module information with the order
ALTER TABLE orders add shipping_module_code varchar(64);
ALTER TABLE orders add payment_module_code varchar(64);

-- Returns Panel Custom Command Definitions
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_LABEL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Returns Custom Button Label', 'ADMIN_APP_RETURNS_CUSTOM_LABEL', '', 'When this is set, a custom button appears on the returns panels with this label', '21', '22', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Returns Custom Button URL', 'ADMIN_APP_RETURNS_CUSTOM_URL', 'http://www.konakart.com/', 'The URL that is launched when the Returns Custom button is clicked', '21', '23', getdate());

-- Add the custom3 privilege to enable/disable custom option on the 'Returns' and 'Returns from Orders' panel
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=46;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=47;

-- Panels for viewing customer from orders panel
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_customerForOrder','Customer For Order', getdate());

-- Add the custom privileges to the CustomerForOrder panel to make it the same as the Customer panel
UPDATE kk_role_to_panel set custom1=0, custom1_desc='If set email is disabled' where panel_id=67;
UPDATE kk_role_to_panel set custom2=0, custom2_desc='If set cannot reset password' where panel_id=67;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set customer search droplists are disabled' where panel_id=67;

-- Custom Panels
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom1','Custom1', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom2','Custom2', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom3','Custom3', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom4','Custom4', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom5','Custom5', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom6','Custom6', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom7','Custom7', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom8','Custom8', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom9','Custom9', getdate());
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_custom10','Custom10', getdate());

-- Custom Panel URLs
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL1_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom1 panel', 'ADMIN_APP_CUSTOM_PANEL1_URL', 'http://www.konakart.com/?', 'The URL for Custom1 panel', '22', '0', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL2_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom2 panel', 'ADMIN_APP_CUSTOM_PANEL2_URL', 'http://www.konakart.com/?', 'The URL for Custom2 panel', '22', '1', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL3_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom3 panel', 'ADMIN_APP_CUSTOM_PANEL3_URL', 'http://www.konakart.com/?', 'The URL for Custom3 panel', '22', '2', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL4_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom4 panel', 'ADMIN_APP_CUSTOM_PANEL4_URL', 'http://www.konakart.com/?', 'The URL for Custom4 panel', '22', '3', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL5_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom5 panel', 'ADMIN_APP_CUSTOM_PANEL5_URL', 'http://www.konakart.com/?', 'The URL for Custom5 panel', '22', '4', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL6_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom6 panel', 'ADMIN_APP_CUSTOM_PANEL6_URL', 'http://www.konakart.com/?', 'The URL for Custom6 panel', '22', '5', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL7_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom7 panel', 'ADMIN_APP_CUSTOM_PANEL7_URL', 'http://www.konakart.com/?', 'The URL for Custom7 panel', '22', '6', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL8_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom8 panel', 'ADMIN_APP_CUSTOM_PANEL8_URL', 'http://www.konakart.com/?', 'The URL for Custom8 panel', '22', '7', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL9_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom9 panel', 'ADMIN_APP_CUSTOM_PANEL9_URL', 'http://www.konakart.com/?', 'The URL for Custom9 panel', '22', '8', getdate());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL10_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom10 panel', 'ADMIN_APP_CUSTOM_PANEL10_URL', 'http://www.konakart.com/?', 'The URL for Custom10 panel', '22', '9', getdate());

-- Panel for configuring custom panels
INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_customConfig','Configure Custom Panels', getdate());



exit;

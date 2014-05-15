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
-- From version 2.2.5.0 to version 2.2.6.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.5.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
ALTER TABLE products_to_products add products_options varchar(128);
ALTER TABLE products_to_products add products_quantity int;

-- New API calls
set echo on
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getBundleProductDetails','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'customSecure','', sysdate);

-- Tags

DROP TABLE kk_tag_group CASCADE CONSTRAINTS;
CREATE TABLE kk_tag_group (
  tag_group_id NUMBER(10,0) DEFAULT 0 NOT NULL,
  language_id NUMBER(10,0) DEFAULT 1 NOT NULL,
  name VARCHAR2(128) NOT NULL,
  description VARCHAR2(255),
  PRIMARY KEY(tag_group_id, language_id)
);

DROP TABLE kk_tag CASCADE CONSTRAINTS;
CREATE TABLE kk_tag (
  tag_id NUMBER(10,0) DEFAULT 0 NOT NULL,
  language_id NUMBER(10,0) DEFAULT 1 NOT NULL,
  name VARCHAR2(128) NOT NULL,
  sort_order NUMBER(10,0) DEFAULT 0,
  PRIMARY KEY(tag_id, language_id)
);

DROP TABLE kk_category_to_tag_group CASCADE CONSTRAINTS;
CREATE TABLE kk_category_to_tag_group (
  categories_id NUMBER(10,0) NOT NULL,
  tag_group_id NUMBER(10,0) NOT NULL,
  PRIMARY KEY(categories_id,tag_group_id)
);

DROP TABLE kk_tag_group_to_tag CASCADE CONSTRAINTS;
CREATE TABLE kk_tag_group_to_tag (
  tag_group_id NUMBER(10,0) NOT NULL,
  tag_id NUMBER(10,0) NOT NULL,
  PRIMARY KEY(tag_group_id,tag_id)
);

DROP TABLE kk_tag_to_product CASCADE CONSTRAINTS;
CREATE TABLE kk_tag_to_product (
  tag_id NUMBER(10,0) NOT NULL,
  products_id NUMBER(10,0) NOT NULL,
  date_added TIMESTAMP NOT NULL,
  PRIMARY KEY(tag_id,products_id)
);

-- Panels for maintaining Tags
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_tagGroups','Maintain Tag Groups', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_tags','Maintain Tags', sysdate);

-- Tag API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getTags','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getTagGroups','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertTag','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertTags','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertGroups','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateTag','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateTagGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteTag','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteTagGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getTagGroupsPerCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addTagGroupsToCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeTagGroupsFromCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getTagsPerProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addTagsToProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeTagsFromProduct','', sysdate);

-- Save shipping and payment module information with the order
ALTER TABLE orders add shipping_module_code varchar(64);
ALTER TABLE orders add payment_module_code varchar(64);

-- Returns Panel Custom Command Definitions
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_LABEL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'Returns Custom Button Label', 'ADMIN_APP_RETURNS_CUSTOM_LABEL', '', 'When this is set, a custom button appears on the returns panels with this label', '21', '22', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'Returns Custom Button URL', 'ADMIN_APP_RETURNS_CUSTOM_URL', 'http://www.konakart.com/', 'The URL that is launched when the Returns Custom button is clicked', '21', '23', sysdate);

-- Add the custom3 privilege to enable/disable custom option on the 'Returns' and 'Returns from Orders' panel
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=46;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=47;

-- Panels for viewing customer from orders panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_customerForOrder','Customer For Order', sysdate);

-- Add the custom privileges to the CustomerForOrder panel to make it the same as the Customer panel
UPDATE kk_role_to_panel set custom1=0, custom1_desc='If set email is disabled' where panel_id=67;
UPDATE kk_role_to_panel set custom2=0, custom2_desc='If set cannot reset password' where panel_id=67;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set customer search droplists are disabled' where panel_id=67;

-- Custom Panels
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom1','Custom1', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom2','Custom2', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom3','Custom3', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom4','Custom4', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom5','Custom5', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom6','Custom6', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom7','Custom7', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom8','Custom8', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom9','Custom9', sysdate);
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_custom10','Custom10', sysdate);

-- Custom Panel URLs
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL1_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom1 panel', 'ADMIN_APP_CUSTOM_PANEL1_URL', 'http://www.konakart.com/?', 'The URL for Custom1 panel', '22', '0', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL2_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom2 panel', 'ADMIN_APP_CUSTOM_PANEL2_URL', 'http://www.konakart.com/?', 'The URL for Custom2 panel', '22', '1', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL3_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom3 panel', 'ADMIN_APP_CUSTOM_PANEL3_URL', 'http://www.konakart.com/?', 'The URL for Custom3 panel', '22', '2', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL4_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom4 panel', 'ADMIN_APP_CUSTOM_PANEL4_URL', 'http://www.konakart.com/?', 'The URL for Custom4 panel', '22', '3', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL5_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom5 panel', 'ADMIN_APP_CUSTOM_PANEL5_URL', 'http://www.konakart.com/?', 'The URL for Custom5 panel', '22', '4', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL6_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom6 panel', 'ADMIN_APP_CUSTOM_PANEL6_URL', 'http://www.konakart.com/?', 'The URL for Custom6 panel', '22', '5', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL7_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom7 panel', 'ADMIN_APP_CUSTOM_PANEL7_URL', 'http://www.konakart.com/?', 'The URL for Custom7 panel', '22', '6', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL8_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom8 panel', 'ADMIN_APP_CUSTOM_PANEL8_URL', 'http://www.konakart.com/?', 'The URL for Custom8 panel', '22', '7', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL9_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom9 panel', 'ADMIN_APP_CUSTOM_PANEL9_URL', 'http://www.konakart.com/?', 'The URL for Custom9 panel', '22', '8', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL10_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'URL for Custom10 panel', 'ADMIN_APP_CUSTOM_PANEL10_URL', 'http://www.konakart.com/?', 'The URL for Custom10 panel', '22', '9', sysdate);

-- Panel for configuring custom panels
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_customConfig','Configure Custom Panels', sysdate);



exit;

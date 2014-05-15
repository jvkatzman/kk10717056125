#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.5.0 to version 2.2.6.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.5.0, the upgrade 
# scripts must be run sequentially

# Add attributes for supporting bundles
ALTER TABLE products_to_products add column products_options varchar(128);
ALTER TABLE products_to_products add column products_quantity int;

# New API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (190, 'getBundleProductDetails','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (191, 'customSecure','', now());

# Tags

DROP TABLE IF EXISTS kk_tag_group;
CREATE TABLE kk_tag_group (
   tag_group_id int DEFAULT '0' NOT NULL,
   language_id int DEFAULT '1' NOT NULL,
   name varchar(128) NOT NULL,
   description varchar(255),
   PRIMARY KEY (tag_group_id, language_id)
);

DROP TABLE IF EXISTS kk_tag;
CREATE TABLE kk_tag (
   tag_id int DEFAULT '0' NOT NULL,
   language_id int DEFAULT '1' NOT NULL,
   name varchar(128) NOT NULL,
   sort_order int default '0',
   PRIMARY KEY (tag_id, language_id)
);

DROP TABLE IF EXISTS kk_category_to_tag_group;
CREATE TABLE kk_category_to_tag_group (
  categories_id int NOT NULL,
  tag_group_id int NOT NULL,
  PRIMARY KEY (categories_id,tag_group_id)
);

DROP TABLE IF EXISTS kk_tag_group_to_tag;
CREATE TABLE kk_tag_group_to_tag (
  tag_group_id int NOT NULL,
  tag_id int NOT NULL,
  PRIMARY KEY (tag_group_id,tag_id)
);

DROP TABLE IF EXISTS kk_tag_to_product;
CREATE TABLE kk_tag_to_product (
  tag_id int NOT NULL,
  products_id int NOT NULL,
  date_added datetime NOT NULL,
  PRIMARY KEY (tag_id,products_id)
);

# Panels for maintaining Tags
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (65, 'kk_panel_tagGroups','Maintain Tag Groups', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (66, 'kk_panel_tags','Maintain Tags', now());

# Tag API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (192, 'getTags','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (193, 'getTagGroups','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (194, 'insertTag','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (195, 'insertTags','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (196, 'insertGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (197, 'insertGroups','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (198, 'updateTag','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (199, 'updateTagGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (200, 'deleteTag','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (201, 'deleteTagGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (202, 'getTagGroupsPerCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (203, 'addTagGroupsToCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (204, 'removeTagGroupsFromCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (205, 'getTagsPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (206, 'addTagsToProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (207, 'removeTagsFromProduct','', now());

# Save shipping and payment module information with the order
ALTER TABLE orders add column shipping_module_code varchar(64);
ALTER TABLE orders add column payment_module_code varchar(64);

# Returns Panel Custom Command Definitions
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_LABEL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Returns Custom Button Label', 'ADMIN_APP_RETURNS_CUSTOM_LABEL', '', 'When this is set, a custom button appears on the returns panels with this label', '21', '22', now());
delete from configuration where configuration_key = 'ADMIN_APP_RETURNS_CUSTOM_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Returns Custom Button URL', 'ADMIN_APP_RETURNS_CUSTOM_URL', 'http://www.konakart.com/', 'The URL that is launched when the Returns Custom button is clicked', '21', '23', now());

# Add the custom3 privilege to enable/disable custom option on the 'Returns' and 'Returns from Orders' panel
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=46;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set custom returns button is disabled' where panel_id=47;

# Panels for viewing customer from orders panel
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (67, 'kk_panel_customerForOrder','Customer For Order', now());

# Add the custom privileges to the CustomerForOrder panel to make it the same as the Customer panel
UPDATE kk_role_to_panel set custom1=0, custom1_desc='If set email is disabled' where panel_id=67;
UPDATE kk_role_to_panel set custom2=0, custom2_desc='If set cannot reset password' where panel_id=67;
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set customer search droplists are disabled' where panel_id=67;

# Custom Panels
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (68, 'kk_panel_custom1','Custom1', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (69, 'kk_panel_custom2','Custom2', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (70, 'kk_panel_custom3','Custom3', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (71, 'kk_panel_custom4','Custom4', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (72, 'kk_panel_custom5','Custom5', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (73, 'kk_panel_custom6','Custom6', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (74, 'kk_panel_custom7','Custom7', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (75, 'kk_panel_custom8','Custom8', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (76, 'kk_panel_custom9','Custom9', now());
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (77, 'kk_panel_custom10','Custom10', now());

# Custom Panel URLs
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL1_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom1 panel', 'ADMIN_APP_CUSTOM_PANEL1_URL', 'http://www.konakart.com/?', 'The URL for Custom1 panel', '22', '0', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL2_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom2 panel', 'ADMIN_APP_CUSTOM_PANEL2_URL', 'http://www.konakart.com/?', 'The URL for Custom2 panel', '22', '1', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL3_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom3 panel', 'ADMIN_APP_CUSTOM_PANEL3_URL', 'http://www.konakart.com/?', 'The URL for Custom3 panel', '22', '2', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL4_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom4 panel', 'ADMIN_APP_CUSTOM_PANEL4_URL', 'http://www.konakart.com/?', 'The URL for Custom4 panel', '22', '3', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL5_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom5 panel', 'ADMIN_APP_CUSTOM_PANEL5_URL', 'http://www.konakart.com/?', 'The URL for Custom5 panel', '22', '4', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL6_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom6 panel', 'ADMIN_APP_CUSTOM_PANEL6_URL', 'http://www.konakart.com/?', 'The URL for Custom6 panel', '22', '5', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL7_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom7 panel', 'ADMIN_APP_CUSTOM_PANEL7_URL', 'http://www.konakart.com/?', 'The URL for Custom7 panel', '22', '6', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL8_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom8 panel', 'ADMIN_APP_CUSTOM_PANEL8_URL', 'http://www.konakart.com/?', 'The URL for Custom8 panel', '22', '7', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL9_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom9 panel', 'ADMIN_APP_CUSTOM_PANEL9_URL', 'http://www.konakart.com/?', 'The URL for Custom9 panel', '22', '8', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUSTOM_PANEL10_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('URL for Custom10 panel', 'ADMIN_APP_CUSTOM_PANEL10_URL', 'http://www.konakart.com/?', 'The URL for Custom10 panel', '22', '9', now());

# Panel for configuring custom panels
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (78, 'kk_panel_customConfig','Configure Custom Panels', now());




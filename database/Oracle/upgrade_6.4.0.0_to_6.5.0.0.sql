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
-- From version 6.4.0.0 to version 6.5.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.4.0.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;

set echo on
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (kk_config_seq.nextval, 'HISTORY', '6.5.0.0 U', sysdate);
UPDATE kk_config SET kk_config_value='6.5.0.0 Oracle', date_added=sysdate WHERE kk_config_key='VERSION';

-- Update image names of demo products if still present
-- Probably remove these because this is done below in a different way with the new images system:
--UPDATE products SET products_image='hewlett_packard/hp5510e.jpg' WHERE products_model='HPLJ1100XI' AND products_image='hewlett_packard/lj1100xi.jpg';
--UPDATE products SET products_image='dvd/hgames.jpg' WHERE products_model='DVD-RPMK' AND products_image='dvd/replacement_killers.jpg';
--UPDATE products SET products_image='dvd/titanic.jpg' WHERE products_model='DVD-CUFI' AND products_image='dvd/courage_under_fire.jpg';
--UPDATE products SET products_image='dvd/darkknight.jpg' WHERE products_model='DVD-BELOVED' AND products_image='dvd/beloved.jpg';
--UPDATE products SET products_image='dvd/harrypotter.jpg' WHERE products_model='DVD-FDBL' AND products_image='dvd/fire_down_below.jpg';

-- Update product names of demo products if still present
UPDATE products_description SET products_name='HP Photosmart 5510 e' WHERE products_name='Hewlett Packard LaserJet 1100Xi' AND products_id=27;
UPDATE products_description SET products_name='The Hunger Games' WHERE products_name='The Replacement Killers' AND products_id=4;
UPDATE products_description SET products_name='Titanic' WHERE products_name='Courage Under Fire' AND products_id=16;
UPDATE products_description SET products_name='The Dark Knight' WHERE products_name='Beloved' AND products_id=20;
UPDATE products_description SET products_name='Harry Potter - The Goblet of Fire' WHERE products_name='Fire Down Below' AND products_id=11;

-- For new Struts2 storefront

-- Maximum number of special price products to cache in client engine
DELETE FROM configuration WHERE configuration_key = 'MAX_DISPLAY_SPECIALS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, return_by_api, date_added, store_id) SELECT configuration_seq.nextval, 'Special Price Products', 'MAX_DISPLAY_SPECIALS', '9', 'Maximum number of special price products to cache', '3', '5', 'integer(0,null)', '1', sysdate, store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'STOCK_WARN_LEVEL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, return_by_api, date_added, store_id) SELECT configuration_seq.nextval, 'Stock warn level', 'STOCK_WARN_LEVEL', '5', 'Warn customer when stock reaches this level', '9', '5', 'integer(null,null)', '1', sysdate, store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

-- Modify some configuration variables
UPDATE configuration SET configuration_value = '10', configuration_description = 'Maximum number of latest products to cache' WHERE configuration_key = 'MAX_DISPLAY_NEW_PRODUCTS';
UPDATE configuration SET configuration_value = '15' WHERE configuration_key = 'MAX_DISPLAY_MANUFACTURERS_IN_A_LIST';
UPDATE configuration SET configuration_title='KonaKart cache refresh check interval', configuration_description = 'Interval in seconds for checking to see whether to refresh the KonaKart caches' WHERE configuration_key = 'CLIENT_CONFIG_CACHE_CHECK_SECS';
UPDATE configuration SET configuration_description='This allows checkout without registration' WHERE configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';

-- Add number of reviews to Something about mary
UPDATE products SET number_reviews = 1 WHERE products_id = 19 AND products_model = 'DVD-TSAB';

-- Delete some config variables
DELETE FROM configuration WHERE configuration_key = 'MAX_RANDOM_SELECT_NEW';
DELETE FROM configuration WHERE configuration_key = 'MAX_RANDOM_SELECT_SPECIALS';
DELETE FROM configuration WHERE configuration_key = 'MAX_RANDOM_SELECT_REVIEWS';
DELETE FROM configuration WHERE configuration_key = 'MAX_DISPLAY_PRODUCTS_IN_ORDER_HISTORY_BOX';
DELETE FROM configuration WHERE configuration_key = 'MAX_DISPLAY_CATEGORIES_PER_ROW';
DELETE FROM configuration WHERE configuration_key = 'HEADING_IMAGE_WIDTH';
DELETE FROM configuration WHERE configuration_key = 'HEADING_IMAGE_HEIGHT';
DELETE FROM configuration WHERE configuration_key = 'SUBCATEGORY_IMAGE_WIDTH';
DELETE FROM configuration WHERE configuration_key = 'SUBCATEGORY_IMAGE_HEIGHT';
DELETE FROM configuration WHERE configuration_key = 'ENTRY_DOB_MIN_LENGTH';
DELETE FROM configuration WHERE configuration_key = 'ENTRY_EMAIL_ADDRESS_MIN_LENGTH';
DELETE FROM configuration WHERE configuration_key = 'MAX_DISPLAY_BESTSELLERS';
DELETE FROM configuration WHERE configuration_key = 'CLIENT_CACHE_UPDATE_SECS';
DELETE FROM configuration WHERE configuration_key = 'ONE_PAGE_CHECKOUT';
DELETE FROM configuration WHERE configuration_key = 'SMALL_IMAGE_WIDTH';
DELETE FROM configuration WHERE configuration_key = 'SMALL_IMAGE_HEIGHT';
DELETE FROM configuration WHERE configuration_key = 'MAX_DISPLAY_MANUFACTURER_NAME_LEN';

-- Zone update
UPDATE zones SET zone_code='NL', zone_name='Newfoundland and Labrador' where zone_code='NF' and zone_name='Newfoundland' and zone_country_id in (select countries_id from countries WHERE countries_name='Canada');

-- Solr faceted search
DELETE FROM configuration WHERE configuration_key = 'SOLR_DYNAMIC_FACETS';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Use Solr dynamic facets','SOLR_DYNAMIC_FACETS','false','When true, the displayed facets are valid for only the products returned by the search rather than for all the available products.','24', '6', 'choice(''true'', ''false'')', sysdate, '1', store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
DELETE FROM configuration WHERE configuration_key = 'PRICE_FACETS_SLIDER';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Use Slider for price filter','PRICE_FACETS_SLIDER','true','When false, price facets are displayed instead of a slider for filtering a result set by price.','1', '31', 'choice(''true'', ''false'')', sysdate, '1', store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- Add index to coupon table
CREATE INDEX i_co_coupon ON coupon (coupon_code);

-- Panel for Licensing
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_license','Licensing', sysdate);

-- Add access to the Licensing Panel to all roles that can access the Configuration panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_license';

-- Google Data Feed - Google Product Link
DELETE FROM configuration WHERE configuration_key = 'GOOGLE_PRODUCT_LINK';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Google Product Link', 'GOOGLE_PRODUCT_LINK', 'SelectProd.action?prodId=', 'Added to the KonaKart base URL to form a link to a product that is sent to Google.  The ProductId is appended at the end.', '23', '105', sysdate, '0', store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

-- ConfigData API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'insertConfigData','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateConfigData','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'removeConfigData','', sysdate);

-- Image APIs
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'scaleImage','', sysdate);

-- Add extra fields to products table
ALTER TABLE products ADD product_image_dir varchar(64);
ALTER TABLE products ADD product_depth int DEFAULT 0 NOT NULL;
ALTER TABLE products ADD product_width int DEFAULT 0 NOT NULL;
ALTER TABLE products ADD product_length int DEFAULT 0 NOT NULL;
ALTER TABLE products MODIFY products_weight DECIMAL(15,2) DEFAULT 0.00;


-- The following section of product image UPDATES is only relevant when upgrading a system that still has the sample products in it
UPDATE products SET products_image = '/prod/9/5/9/9/95992CDB-33D0-46BE-A6EF-4C973B3221B5_1_big.jpg', product_image_dir = '/prod/9/5/9/9/', product_uuid = '95992CDB-33D0-46BE-A6EF-4C973B3221B5' WHERE products_image = 'matrox/mg200mms.jpg';
UPDATE products SET products_image = '/prod/7/8/5/7/7857D709-61C6-44C1-A5D4-52E463CBEAA9_1_big.jpg', product_image_dir = '/prod/7/8/5/7/', product_uuid = '7857D709-61C6-44C1-A5D4-52E463CBEAA9' WHERE products_image = 'matrox/mg400-32mb.jpg';
UPDATE products SET products_image = '/prod/1/8/5/3/18536902-5B5C-4FF2-859B-A927EE8F38AF_1_big.jpg', product_image_dir = '/prod/1/8/5/3/', product_uuid = '18536902-5B5C-4FF2-859B-A927EE8F38AF' WHERE products_image = 'microsoft/msimpro.jpg';
UPDATE products SET products_image = '/prod/9/3/E/E/93EE9E10-709E-4517-9041-D07C577AFBC9_1_big.jpg', product_image_dir = '/prod/9/3/E/E/', product_uuid = '93EE9E10-709E-4517-9041-D07C577AFBC9' WHERE products_image = 'dvd/replacement_killers.jpg';
UPDATE products SET products_image = '/prod/8/3/7/7/8377214C-C4A5-41C5-93A5-3A580132C55A_1_big.jpg', product_image_dir = '/prod/8/3/7/7/', product_uuid = '8377214C-C4A5-41C5-93A5-3A580132C55A' WHERE products_image = 'dvd/blade_runner.jpg';
UPDATE products SET products_image = '/prod/9/5/2/1/95214187-5DF3-403B-BFEF-16DECA237BF6_1_big.jpg', product_image_dir = '/prod/9/5/2/1/', product_uuid = '95214187-5DF3-403B-BFEF-16DECA237BF6' WHERE products_image = 'dvd/the_matrix.jpg';
UPDATE products SET products_image = '/prod/9/2/9/3/92937B41-BC5C-4CB8-92E3-4380A933F6E2_1_big.jpg', product_image_dir = '/prod/9/2/9/3/', product_uuid = '92937B41-BC5C-4CB8-92E3-4380A933F6E2' WHERE products_image = 'dvd/youve_got_mail.jpg';
UPDATE products SET products_image = '/prod/0/6/D/A/06DAD86E-0FA8-4B42-9184-CE1B3F3CE4A6_1_big.jpg', product_image_dir = '/prod/0/6/D/A/', product_uuid = '06DAD86E-0FA8-4B42-9184-CE1B3F3CE4A6' WHERE products_image = 'dvd/a_bugs_life.jpg';
UPDATE products SET products_image = '/prod/A/E/C/2/AEC246F9-F629-4657-B563-15B10F644CC8_1_big.jpg', product_image_dir = '/prod/A/E/C/2/', product_uuid = 'AEC246F9-F629-4657-B563-15B10F644CC8' WHERE products_image = 'dvd/under_siege.jpg';
UPDATE products SET products_image = '/prod/9/6/3/9/9639041E-710D-472A-B87C-85E59C435D82_1_big.jpg', product_image_dir = '/prod/9/6/3/9/', product_uuid = '9639041E-710D-472A-B87C-85E59C435D82' WHERE products_image = 'dvd/under_siege2.jpg';
UPDATE products SET products_image = '/prod/3/F/D/D/3FDD11D0-C6F2-45D0-B906-7DDFDA015594_1_big.jpg', product_image_dir = '/prod/3/F/D/D/', product_uuid = '3FDD11D0-C6F2-45D0-B906-7DDFDA015594' WHERE products_image = 'dvd/fire_down_below.jpg';
UPDATE products SET products_image = '/prod/F/7/E/6/F7E61CE3-5778-4790-A705-EE2D9980E979_1_big.jpg', product_image_dir = '/prod/F/7/E/6/', product_uuid = 'F7E61CE3-5778-4790-A705-EE2D9980E979' WHERE products_image = 'dvd/die_hard_3.jpg';
UPDATE products SET products_image = '/prod/6/7/7/E/677E32E4-1DB2-44AD-A5BF-3CE389A25D3F_1_big.jpg', product_image_dir = '/prod/6/7/7/E/', product_uuid = '677E32E4-1DB2-44AD-A5BF-3CE389A25D3F' WHERE products_image = 'dvd/lethal_weapon.jpg';
UPDATE products SET products_image = '/prod/F/3/1/8/F3186F6D-20DB-49A8-84F8-3F98BE3BA076_1_big.jpg', product_image_dir = '/prod/F/3/1/8/', product_uuid = 'F3186F6D-20DB-49A8-84F8-3F98BE3BA076' WHERE products_image = 'dvd/red_corner.jpg';
UPDATE products SET products_image = '/prod/E/6/A/B/E6AB1135-5B32-4FD1-BF28-12C5CD256CD9_1_big.jpg', product_image_dir = '/prod/E/6/A/B/', product_uuid = 'E6AB1135-5B32-4FD1-BF28-12C5CD256CD9' WHERE products_image = 'dvd/frantic.jpg';
UPDATE products SET products_image = '/prod/2/1/E/0/21E0683C-62A7-4282-A36F-E0D6BC9AE8A2_1_big.jpg', product_image_dir = '/prod/2/1/E/0/', product_uuid = '21E0683C-62A7-4282-A36F-E0D6BC9AE8A2' WHERE products_image = 'dvd/courage_under_fire.jpg';
UPDATE products SET products_image = '/prod/8/C/7/A/8C7A57B8-A6B5-48A5-A965-87A7D728F1BE_1_big.jpg', product_image_dir = '/prod/8/C/7/A/', product_uuid = '8C7A57B8-A6B5-48A5-A965-87A7D728F1BE' WHERE products_image = 'dvd/speed.jpg';
UPDATE products SET products_image = '/prod/C/5/1/A/C51A6C94-27CC-4159-89CF-D8EEFDBB2928_1_big.jpg', product_image_dir = '/prod/C/5/1/A/', product_uuid = 'C51A6C94-27CC-4159-89CF-D8EEFDBB2928' WHERE products_image = 'dvd/speed2.jpg';
UPDATE products SET products_image = '/prod/C/1/9/2/C1929825-BD7C-4FE3-8AE8-DFEA73A230F0_1_big.jpg', product_image_dir = '/prod/C/1/9/2/', product_uuid = 'C1929825-BD7C-4FE3-8AE8-DFEA73A230F0' WHERE products_image = 'dvd/theres_something_about_mary.jpg';
UPDATE products SET products_image = '/prod/6/8/9/6/68965D51-F873-4D1B-8A37-92A340E5B913_1_big.jpg', product_image_dir = '/prod/6/8/9/6/', product_uuid = '68965D51-F873-4D1B-8A37-92A340E5B913' WHERE products_image = 'dvd/beloved.jpg';
UPDATE products SET products_image = '/prod/C/4/9/4/C4941395-021B-4C97-B46C-A4491AD3D620_1_big.jpg', product_image_dir = '/prod/C/4/9/4/', product_uuid = 'C4941395-021B-4C97-B46C-A4491AD3D620' WHERE products_image = 'sierra/swat3.jpg';
UPDATE products SET products_image = '/prod/5/7/D/3/57D32457-0C8A-4387-9680-1B4861AE6178_1_big.jpg', product_image_dir = '/prod/5/7/D/3/', product_uuid = '57D32457-0C8A-4387-9680-1B4861AE6178' WHERE products_image = 'gt_interactive/unreal_tournament.jpg';
UPDATE products SET products_image = '/prod/F/9/8/F/F98FF9EA-110B-4096-AD22-1423E0E78C36_1_big.jpg', product_image_dir = '/prod/F/9/8/F/', product_uuid = 'F98FF9EA-110B-4096-AD22-1423E0E78C36' WHERE products_image = 'gt_interactive/wheel_of_time.jpg';
UPDATE products SET products_image = '/prod/3/8/3/B/383B8D87-B3EA-4AAF-B0AB-9614C17463F3_1_big.jpg', product_image_dir = '/prod/3/8/3/B/', product_uuid = '383B8D87-B3EA-4AAF-B0AB-9614C17463F3' WHERE products_image = 'gt_interactive/disciples.jpg';
UPDATE products SET products_image = '/prod/0/0/1/F/001F1EAA-2910-440E-BB8D-C714E0E859B4_1_big.jpg', product_image_dir = '/prod/0/0/1/F/', product_uuid = '001F1EAA-2910-440E-BB8D-C714E0E859B4' WHERE products_image = 'microsoft/intkeyboardps2.jpg';
UPDATE products SET products_image = '/prod/F/E/F/2/FEF2DB86-728E-4C6A-A3FA-4F4B099D28E6_1_big.jpg', product_image_dir = '/prod/F/E/F/2/', product_uuid = 'FEF2DB86-728E-4C6A-A3FA-4F4B099D28E6' WHERE products_image = 'microsoft/imexplorer.jpg';
UPDATE products SET products_image = '/prod/5/1/B/7/51B73EC2-0845-4837-B125-EC8041C0EA76_1_big.jpg', product_image_dir = '/prod/5/1/B/7/', product_uuid = '51B73EC2-0845-4837-B125-EC8041C0EA76' WHERE products_image = 'hewlett_packard/lj1100xi.jpg';
UPDATE products SET products_image = '/prod/E/3/8/4/E384D77F-69C0-4DA9-97DE-32F042B437DB_1_big.jpg', product_image_dir = '/prod/E/3/8/4/', product_uuid = 'E384D77F-69C0-4DA9-97DE-32F042B437DB' WHERE products_image = 'microsoft/bundle.jpg';
UPDATE products SET products_image = '/prod/E/D/7/0/ED709A75-1C44-4983-ADB5-B42E963452C3_1_big.jpg', product_image_dir = '/prod/E/D/7/0/', product_uuid = 'ED709A75-1C44-4983-ADB5-B42E963452C3' WHERE products_image = 'gifts/giftcert.jpg';

-- Reset Login base URL for new storefront - but only if it's still set to the original value
UPDATE configuration SET configuration_value='https://localhost:8783/konakart/AdminLoginSubmit.action' WHERE configuration_key='ADMIN_APP_LOGIN_BASE_URL' and configuration_value='https://localhost:8443/konakart/AdminLoginSubmit.do';

exit;

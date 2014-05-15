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
-- From version 7.0.0.0 to version 7.1.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 7.0.0.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;

set echo on
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (kk_config_seq.nextval, 'HISTORY', '7.1.0.0 U', sysdate);
UPDATE kk_config SET kk_config_value='7.1.0.0 Oracle', date_added=sysdate WHERE kk_config_key='VERSION';

-- Add extra attributes to Order for multi-vendor mode
ALTER TABLE orders ADD store_name VARCHAR(64);
ALTER TABLE orders ADD parent_id int DEFAULT 0;

-- Configuration variable to enable multi-vendor mode
DELETE FROM configuration WHERE configuration_key = 'MULTI_VENDOR_MODE';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Enable multi-vendor mode','MULTI_VENDOR_MODE','false','Set to true to enable multi-vendor mode. KK Engine must be in shared products mode.','1', '35', 'choice(''true'', ''false'')', sysdate, '1', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

-- Addr addr store id to address table
ALTER TABLE address_book ADD addr_store_id varchar(64);

-- New Velocity Templates Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_velocityTemplates','Maintain Velocity Templates', sysdate);

-- Add access to the Velocity Templates Panel to all roles that can access the Configuration panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_storeConfiguration' and p2.code='kk_panel_velocityTemplates';

-- New copyFile API
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'copyFile', '', sysdate);

-- Config variable for formatting store addresses in admin app
DELETE FROM configuration WHERE configuration_key = 'ADMIN_APP_STORE_ADDR_FORMAT';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Addr Format for Store Addr', 'ADMIN_APP_STORE_ADDR_FORMAT', '$street $street1 $suburb $city $state $country', 'How the address is formatted in the store address panel', '21', '1', sysdate, '0', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

-- Address Panel for stores
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_store_address', 'Store Addresses', sysdate);

-- Add Address Panel access to all roles that can access the Customer panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_store_address';

-- Configuration variable to force login for storefront app
DELETE FROM configuration WHERE configuration_key = 'APP_FORCE_LOOGIN';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added, return_by_api, store_id) SELECT configuration_seq.nextval, 'Storefront force login','APP_FORCE_LOOGIN','false','Set to true to force customers to login in order to be able to use the storefront application.','1', '38', 'choice(''true'', ''false'')', sysdate, '1', store_id FROM configuration WHERE configuration_key = 'STORE_COUNTRY';

exit;

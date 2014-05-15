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
-- From version 2.2.3.0 to version 2.2.4.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.3.0, the upgrade
-- scripts must be run sequentially.
-- 
delete from kk_api_call where api_call_id = 182;
delete from kk_api_call where api_call_id = 183;
delete from kk_api_call where api_call_id = 184;
delete from kk_api_call where api_call_id = 185;
delete from kk_api_call where api_call_id = 186;
delete from kk_api_call where api_call_id = 187;
delete from kk_api_call where api_call_id = 188;

INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeCustomerGroupsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCustomerGroupsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerGroupsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerGroups','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editOrder','', now());

-- Login integration class
delete from configuration where configuration_key = 'LOGIN_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Login Integration Class', 'LOGIN_INTEGRATION_CLASS','com.konakart.bl.LoginIntegrationMgr','The Login Integration Implementation Class, to allow custom credential checking', '18', '6', now());
delete from configuration where configuration_key = 'ADMIN_LOGIN_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Login Integration Class', 'ADMIN_LOGIN_INTEGRATION_CLASS','com.konakartadmin.bl.AdminLoginIntegrationMgr','The Login Integration Implementation Class, to allow custom credential checking for the Admin App', '18', '7', now());

-- Add two custom privileges to the Orders screen for restricting access to PackingList and Invoice buttons
update kk_role_to_panel set custom1=0, custom1_desc='If set packing list button not shown', custom2=0, custom2_desc='If set invoice button not shown' where role_id=1 and panel_id=33;
update kk_role_to_panel set custom1=0, custom1_desc='If set packing list button not shown', custom2=0, custom2_desc='If set invoice button not shown' where role_id=3 and panel_id=33;

-- Config variables for Admin search definitions
delete from configuration where configuration_key = 'ADMIN_APP_ADD_WILDCARD_BEFORE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Add wildcard search before text', 'ADMIN_APP_ADD_WILDCARD_BEFORE', 'true', 'When set to true, a wildcard search character is added before the specified text', '21', '10', 'tep_cfg_select_option(array(''true'', ''false''), ', now());
delete from configuration where configuration_key = 'ADMIN_APP_ADD_WILDCARD_AFTER';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Add wildcard search after text', 'ADMIN_APP_ADD_WILDCARD_AFTER', 'true', 'When set to true, a wildcard search character is added after the specified text', '21', '11', 'tep_cfg_select_option(array(''true'', ''false''), ', now());


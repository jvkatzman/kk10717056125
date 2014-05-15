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
-- From version 2.2.4.0 to version 2.2.5.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.4.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
delete from configuration where configuration_key = 'ADMIN_APP_CUST_CUSTOM_LABEL';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'Customer Custom Button Label', 'ADMIN_APP_CUST_CUSTOM_LABEL', '', 'When this is set, a custom button appears on the customer panel with this label', '21', '20', sysdate);
delete from configuration where configuration_key = 'ADMIN_APP_CUST_CUSTOM_URL';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (configuration_seq.nextval, 'Customer Custom Button URL', 'ADMIN_APP_CUST_CUSTOM_URL', 'http://www.konakart.com', 'The URL that is launched when the Customer Custom button is clicked', '21', '21', sysdate);

-- Default Customer Panel Search Definition
delete from configuration where configuration_key = 'ADMIN_APP_DEFAULT_CUST_CHOICE_IDX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (configuration_seq.nextval, 'Default Customer Choice', 'ADMIN_APP_DEFAULT_CUST_CHOICE_IDX', 0, 'Sets the default customer choice droplist on the Customer Panel', '21', '22', 'CustomerChoices', sysdate);

-- Default Customer Group Search Definition
delete from configuration where configuration_key = 'ADMIN_APP_DEFAULT_CUST_GROUP_IDX';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (configuration_seq.nextval, 'Default Customer Group', 'ADMIN_APP_DEFAULT_CUST_GROUP_IDX', 0, 'Sets the default customer group droplist on the Customer Panel', '21', '22', 'CustomerGroups', sysdate);

-- Add the custom3 privilege to enable/disable the customer search options on the Customer panel
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set customer search droplists are disabled' where panel_id=14;

-- Set customer type to 0 (customer) for all customers with null customer types
UPDATE customers set customers_type=0 where customers_type is null;

exit;

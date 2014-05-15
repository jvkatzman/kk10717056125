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
-- From version 2.2.0.3 to version 2.2.0.4
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.3, the upgrade
-- scripts must be run sequentially.
-- 
delete from configuration where configuration_key = 'ONE_PAGE_CHECKOUT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enables One Page Checkout', 'ONE_PAGE_CHECKOUT', 'true', 'When set to true, it enables the one page checkout functionality rather than 3 separate pages', '1', '23', 'tep_cfg_select_option(array(''true'', ''false''), ', now());
delete from configuration where configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enables Checkout Without Registration', 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION', 'true', 'When set to true, and one page checkout is enabled, it allows customers to checkout without registering', '1', '24', 'tep_cfg_select_option(array(''true'', ''false''), ', now());



-- Order Integration Mgr
delete from configuration where configuration_key = 'ORDER_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Order Integration Class', 'ORDER_INTEGRATION_CLASS','com.konakart.bl.OrderIntegrationMgr','The Order Integration Implementation Class, to trigger off events when an order is saved or modified', '9', '8', now());
delete from configuration where configuration_key = 'ADMIN_ORDER_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Order Integration Class', 'ADMIN_ORDER_INTEGRATION_CLASS','com.konakartadmin.bl.AdminOrderIntegrationMgr','The Order Integration Implementation Class, to trigger off events when an order is modified from the Admin App', '9', '9', now());



-- Create a kk_if function for compatibility with mySQL
DROP FUNCTION IF EXISTS "kk_if"(integer, anyelement, anyelement);
CREATE FUNCTION "kk_if"(integer, anyelement, anyelement) RETURNS anyelement AS 'SELECT CASE WHEN $1>0 THEN $2 ELSE $3 END;' LANGUAGE 'sql';

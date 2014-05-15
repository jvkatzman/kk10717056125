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
-- KonaKart upgrade database script for MS Sql Server
-- From version 5.5.0.0 to version 5.6.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.5.0.0, the upgrade
-- scripts must be run sequentially.
-- 

DELETE FROM kk_role_to_panel WHERE panel_id in (SELECT panel_id from kk_panel WHERE code='kk_panel_otherModules');
DELETE FROM kk_panel WHERE code = 'kk_panel_otherModules';
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_otherModules', 'Other Modules Configuration', getdate());
-- Add access to the Other Modules Panel to all roles that can access the Other Modules panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_paymentModules' and p2.code='kk_panel_otherModules';

-- For defining the list of Other modules installed
DELETE FROM configuration WHERE configuration_key = 'MODULE_OTHERS_INSTALLED';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Installed Other Modules','MODULE_OTHERS_INSTALLED','','List of Other modules separated by a semi-colon.  Automatically updated.  No need to edit.','6', '0', getdate(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';
exit;

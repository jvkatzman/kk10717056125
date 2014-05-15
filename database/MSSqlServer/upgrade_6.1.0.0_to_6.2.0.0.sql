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
-- From version 6.1.0.0 to version 6.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.1.0.0, the upgrade
-- scripts must be run sequentially.
-- 

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_viewLogs', 'View Logs', getdate());
-- Add access to the View Logs Panel to all roles that can access the Configuration Files panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 0, 0, 'Set to hide the View button', getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_configFiles' and p2.code='kk_panel_viewLogs';

-- Add last login date tag
DELETE FROM kk_customer_tag WHERE name ='LOGIN_DATE';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added) VALUES ('LOGIN_DATE', 'Time of Last Login', 6, 5, getdate());

-- Allow null values for entry_firtsname and entry_lastname on addresses (useful for Manufacturer addresses particularly)
ALTER TABLE address_book ALTER COLUMN entry_firstname VARCHAR(32) NULL;
ALTER TABLE address_book ALTER COLUMN entry_lastname VARCHAR(32) NULL;

-- Table for KonaKart Config Values
DROP TABLE kk_config;
CREATE TABLE kk_config (
  kk_config_id int NOT NULL identity(1,1),
  kk_config_key varchar(16),
  kk_config_value varchar(256),
  date_added datetime,
  PRIMARY KEY(kk_config_id)
);

INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '6.2.0.0 U', getdate());
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('VERSION', '6.2.0.0 SQLServer', getdate());

-- New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getConfigData','', getdate());

-- Customer from Reviews Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_customerForReview', 'Customer From Reviews', getdate());

-- Add access to the Customer from Reviews Panel to all roles that can access the Customers panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_customerForReview';

-- Add "Updated By Customer Id" to the Orders Status History table to record who updated the order
ALTER TABLE orders_status_history ADD updated_by_id int DEFAULT 0;

-- New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateOrder','', getdate());

exit;

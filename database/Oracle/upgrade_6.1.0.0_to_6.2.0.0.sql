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
-- From version 6.1.0.0 to version 6.2.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.1.0.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;

set echo on
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_viewLogs', 'View Logs', sysdate);
-- Add access to the View Logs Panel to all roles that can access the Configuration Files panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 0, 0, 'Set to hide the View button', sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_configFiles' and p2.code='kk_panel_viewLogs';

-- Add last login date tag
DELETE FROM kk_customer_tag WHERE name ='LOGIN_DATE';
INSERT INTO kk_customer_tag (kk_customer_tag_id, name, description, tag_type, max_ints, date_added) VALUES (kk_customer_tag_seq.nextval,'LOGIN_DATE', 'Time of Last Login', 6, 5, sysdate);

-- Allow null values for entry_firtsname and entry_lastname on addresses (useful for Manufacturer addresses particularly)
ALTER TABLE address_book MODIFY entry_firstname VARCHAR(32) NULL;
ALTER TABLE address_book MODIFY entry_lastname VARCHAR(32) NULL;

-- Table for KonaKart Config Values
DROP TABLE kk_config CASCADE CONSTRAINTS;
CREATE TABLE kk_config (
  kk_config_id NUMBER(10,0) NOT NULL,
  kk_config_key VARCHAR2(16),
  kk_config_value VARCHAR2(256),
  date_added TIMESTAMP,
  PRIMARY KEY(kk_config_id)
);
DROP SEQUENCE kk_config_SEQ;
CREATE SEQUENCE kk_config_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (kk_config_seq.nextval, 'HISTORY', '6.2.0.0 U', sysdate);
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (kk_config_seq.nextval, 'VERSION', '6.2.0.0 Oracle', sysdate);

-- New Admin API call
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getConfigData','', sysdate);

-- Customer from Reviews Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_customerForReview', 'Customer From Reviews', sysdate);

-- Add access to the Customer from Reviews Panel to all roles that can access the Customers panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_customerForReview';

-- Add "Updated By Customer Id" to the Orders Status History table to record who updated the order
ALTER TABLE orders_status_history ADD updated_by_id int DEFAULT 0;

-- New Admin API call
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateOrder','', sysdate);

exit;

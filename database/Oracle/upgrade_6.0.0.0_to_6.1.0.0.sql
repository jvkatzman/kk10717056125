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
-- From version 6.0.0.0 to version 6.1.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.0.0.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;

ALTER TABLE products ADD product_uuid varchar(128) DEFAULT NULL;
ALTER TABLE products ADD source_last_modified TIMESTAMP DEFAULT NULL;
CREATE INDEX i_pr_products ON products (product_uuid);

-- New Admin API calls
set echo on
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'copyProductToStore','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getProductsToSynchronize','', sysdate);

-- Correct a small typo
UPDATE configuration set configuration_description = 'During checkout the customer will be allowed to enter a gift certificate if set to true' where configuration_description = 'During checkout the customer will be allowed to enter a git certificate if set to true';

-- New Synchronize Products Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_syncProducts', 'Synchronize Products', sysdate);
-- Add access to the Synchronize Products Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_syncProducts';

-- Add attribute to allow display only languages that are not used to define language variants for products etc
ALTER TABLE languages ADD display_only int DEFAULT 0;
UPDATE languages SET display_only = 0;

-- New Admin API call
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getLanguageForLocale','', sysdate);


exit;

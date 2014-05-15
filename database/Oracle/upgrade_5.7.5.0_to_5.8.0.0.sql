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
-- From version 5.7.5.0 to version 5.8.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.7.5.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;


-- Extend the size of the products_name field
ALTER TABLE orders_products MODIFY products_name VARCHAR(256);

-- Table to facilitate SSO
DROP TABLE kk_sso CASCADE CONSTRAINTS;
CREATE TABLE kk_sso (
  kk_sso_id NUMBER(10,0) NOT NULL,
  secret_key VARCHAR2(255) NOT NULL,
  customers_id NUMBER(10,0) DEFAULT 0,
  sesskey VARCHAR2(32),
  custom1 VARCHAR2(128),
  custom2 VARCHAR2(128),
  custom3 VARCHAR2(128),
  date_added TIMESTAMP,
  PRIMARY KEY(kk_sso_id)
);
CREATE INDEX i_kk_sso_1 ON kk_sso (secret_key);
DROP SEQUENCE kk_sso_SEQ;
CREATE SEQUENCE kk_sso_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Add sort order to the kk_category_to_tag_group table
ALTER TABLE kk_category_to_tag_group ADD sort_order int DEFAULT '0' NOT NULL;

-- Add facet number to the kk_cust_attr table
ALTER TABLE kk_cust_attr ADD facet_number int DEFAULT '0' NOT NULL;

-- Add facet number to the kk_tag_group table
ALTER TABLE kk_tag_group ADD facet_number int DEFAULT '0' NOT NULL;

-- Table for Miscellaneous Item Types
DROP TABLE kk_misc_item_type CASCADE CONSTRAINTS;
CREATE TABLE kk_misc_item_type (
  kk_misc_item_type_id NUMBER(10,0) NOT NULL,
  language_id NUMBER(10,0) NOT NULL,
  name VARCHAR2(128),
  description VARCHAR2(256),
  store_id VARCHAR2(64),
  date_added TIMESTAMP,
  PRIMARY KEY(kk_misc_item_type_id, language_id)
);

-- Table for Miscellaneous Item Type Associations
DROP TABLE kk_misc_item CASCADE CONSTRAINTS;
CREATE TABLE kk_misc_item (
  kk_misc_item_id NUMBER(10,0) NOT NULL,
  kk_obj_id NUMBER(10,0) NOT NULL,
  kk_obj_type_id NUMBER(10,0) NOT NULL,
  kk_misc_item_type_id NUMBER(10,0) NOT NULL,
  item_value VARCHAR2(512),
  custom1 VARCHAR2(128),
  custom2 VARCHAR2(128),
  custom3 VARCHAR2(128),
  store_id VARCHAR2(64),
  date_added TIMESTAMP,
  PRIMARY KEY(kk_misc_item_id)
);
DROP SEQUENCE kk_misc_item_SEQ;
CREATE SEQUENCE kk_misc_item_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- New Admin API call
set echo on
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getProductCountPerProdAttrDesc','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateProductsUsingProdAttrDesc','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateProductsUsingTemplates','', sysdate);

-- New Miscellaneous Item Types Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_miscItemTypes', 'Miscellaneous Item Types', sysdate);
-- Add access to the Miscellaneous Item Types Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItemTypes';

-- New Miscellaneous Items Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_miscItems', 'Miscellaneous Items', sysdate);
-- Add access to the Miscellaneous Items Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItems';

-- New Miscellaneous Items For Categories Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_cat_miscItems', 'Miscellaneous Category Items', sysdate);
-- Add access to the Miscellaneous Items for Categories Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_cat_miscItems';

-- New Miscellaneous Items For Products Panel
INSERT INTO  kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval, 'kk_panel_prod_miscItems', 'Miscellaneous Product Items', sysdate);
-- Add access to the Miscellaneous Items for Products Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, sysdate, store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prod_miscItems';

-- New Admin API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'insertMiscItemType','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateMiscItemType','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'deleteMiscItemType','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getMiscItemTypes','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'insertMiscItems','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'updateMiscItems','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'deleteMiscItem','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval, 'getMiscItems','', sysdate);

exit;

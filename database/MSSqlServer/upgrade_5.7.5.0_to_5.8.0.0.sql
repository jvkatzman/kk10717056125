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
-- From version 5.7.5.0 to version 5.8.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.7.5.0, the upgrade
-- scripts must be run sequentially.
-- 


-- Extend the size of the products_name field
ALTER TABLE orders_products ALTER COLUMN products_name VARCHAR(256);

-- Table to facilitate SSO
DROP TABLE kk_sso;
CREATE TABLE kk_sso (
  kk_sso_id int NOT NULL identity(1,1),
  secret_key varchar(255) NOT NULL,
  customers_id int DEFAULT 0,
  sesskey varchar(32),
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  date_added datetime,
  PRIMARY KEY(kk_sso_id)
);
CREATE INDEX i_kk_sso_1 ON kk_sso (secret_key);

-- Add sort order to the kk_category_to_tag_group table
ALTER TABLE kk_category_to_tag_group ADD sort_order int DEFAULT '0' NOT NULL;

-- Add facet number to the kk_cust_attr table
ALTER TABLE kk_cust_attr ADD facet_number int DEFAULT '0' NOT NULL;

-- Add facet number to the kk_tag_group table
ALTER TABLE kk_tag_group ADD facet_number int DEFAULT '0' NOT NULL;

-- Table for Miscellaneous Item Types
DROP TABLE kk_misc_item_type;
CREATE TABLE kk_misc_item_type (
  kk_misc_item_type_id int NOT NULL,
  language_id int NOT NULL,
  name varchar(128),
  description varchar(256),
  store_id varchar(64),
  date_added datetime,
  PRIMARY KEY(kk_misc_item_type_id, language_id)
);

-- Table for Miscellaneous Item Type Associations
DROP TABLE kk_misc_item;
CREATE TABLE kk_misc_item (
  kk_misc_item_id int NOT NULL identity(1,1),
  kk_obj_id int NOT NULL,
  kk_obj_type_id int NOT NULL,
  kk_misc_item_type_id int NOT NULL,
  item_value varchar(512),
  custom1 varchar(128),
  custom2 varchar(128),
  custom3 varchar(128),
  store_id varchar(64),
  date_added datetime,
  PRIMARY KEY(kk_misc_item_id)
);

-- New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getProductCountPerProdAttrDesc','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateProductsUsingProdAttrDesc','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateProductsUsingTemplates','', getdate());

-- New Miscellaneous Item Types Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_miscItemTypes', 'Miscellaneous Item Types', getdate());
-- Add access to the Miscellaneous Item Types Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItemTypes';

-- New Miscellaneous Items Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_miscItems', 'Miscellaneous Items', getdate());
-- Add access to the Miscellaneous Items Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItems';

-- New Miscellaneous Items For Categories Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_cat_miscItems', 'Miscellaneous Category Items', getdate());
-- Add access to the Miscellaneous Items for Categories Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_cat_miscItems';

-- New Miscellaneous Items For Products Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_prod_miscItems', 'Miscellaneous Product Items', getdate());
-- Add access to the Miscellaneous Items for Products Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prod_miscItems';

-- New Admin API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertMiscItemType','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateMiscItemType','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteMiscItemType','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getMiscItemTypes','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertMiscItems','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateMiscItems','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteMiscItem','', getdate());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getMiscItems','', getdate());

exit;

#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.7.5.0 to version 5.8.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

#PostgreSQL -- For PostgreSQL Only - Fix possible problems due to changes in PostgreSQL 9.1's treatment of escaped strings
#PostgreSQL UPDATE kk_cust_attr SET validation = E'^(((0[1-9]|[12]\\d|3[01])\\/(0[13578]|1[02])\\/((1[6-9]|[2-9]\\d)\\d{2}))|((0[1-9]|[12]\\d|30)\\/(0[13456789]|1[012])\\/((1[6-9]|[2-9]\\d)\\d{2}))|((0[1-9]|1\\d|2[0-8])\\/02\\/((1[6-9]|[2-9]\\d)\\d{2}))|(29\\/02\\/((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$' where template = 'dd/MM/yyyy' and validation like '^(((0[1-9]|[12]\\\\d|3%';

# Extend the size of the products_name field 
ALTER TABLE orders_products MODIFY products_name VARCHAR(256);

# Table to facilitate SSO
DROP TABLE IF EXISTS kk_sso;
CREATE TABLE kk_sso (
   kk_sso_id int NOT NULL auto_increment,
   secret_key varchar(255) NOT NULL,
   customers_id int DEFAULT 0, 
   sesskey varchar(32),
   custom1 varchar(128),
   custom2 varchar(128),
   custom3 varchar(128),
   date_added datetime,
   PRIMARY KEY (kk_sso_id),
   KEY i_kk_sso_1 (secret_key)
);

# Add sort order to the kk_category_to_tag_group table
ALTER TABLE kk_category_to_tag_group ADD COLUMN sort_order int DEFAULT '0' NOT NULL;

# Add facet number to the kk_cust_attr table
ALTER TABLE kk_cust_attr ADD COLUMN facet_number int DEFAULT '0' NOT NULL;

# Add facet number to the kk_tag_group table
ALTER TABLE kk_tag_group ADD COLUMN facet_number int DEFAULT '0' NOT NULL;

# Table for Miscellaneous Item Types
DROP TABLE IF EXISTS kk_misc_item_type;
CREATE TABLE kk_misc_item_type (
   kk_misc_item_type_id int NOT NULL,
   language_id int NOT NULL,
   name varchar(128),
   description varchar(256),
   store_id varchar(64),
   date_added datetime,
   PRIMARY KEY (kk_misc_item_type_id, language_id)
);

# Table for Miscellaneous Item Type Associations
DROP TABLE IF EXISTS kk_misc_item;
CREATE TABLE kk_misc_item (
   kk_misc_item_id int NOT NULL auto_increment,
   kk_obj_id int NOT NULL,
   kk_obj_type_id int NOT NULL,
   kk_misc_item_type_id int NOT NULL,
   item_value varchar(512),
   custom1 varchar(128),
   custom2 varchar(128),
   custom3 varchar(128),
   store_id varchar(64),
   date_added datetime,
   PRIMARY KEY (kk_misc_item_id)
);

# New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getProductCountPerProdAttrDesc','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateProductsUsingProdAttrDesc','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateProductsUsingTemplates','', now());

# New Miscellaneous Item Types Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_miscItemTypes', 'Miscellaneous Item Types', now());
# Add access to the Miscellaneous Item Types Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItemTypes';

# New Miscellaneous Items Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_miscItems', 'Miscellaneous Items', now());
# Add access to the Miscellaneous Items Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_miscItems';

# New Miscellaneous Items For Categories Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_cat_miscItems', 'Miscellaneous Category Items', now());
# Add access to the Miscellaneous Items for Categories Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_cat_miscItems';

# New Miscellaneous Items For Products Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_prod_miscItems', 'Miscellaneous Product Items', now());
# Add access to the Miscellaneous Items for Products Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_prod_miscItems';

# New Admin API calls
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertMiscItemType','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateMiscItemType','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteMiscItemType','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getMiscItemTypes','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('insertMiscItems','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateMiscItems','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('deleteMiscItem','', now());
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getMiscItems','', now());


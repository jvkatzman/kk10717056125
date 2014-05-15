#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.4.0.0 to version 5.5.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# New Bookings Panels
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForOrder', 'Bookings For Order', now());
# Add access to the Bookings Panel to all roles that can access the Orders panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_orders' and p2.code='kk_panel_bookingsForOrder';

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForProduct', 'Bookings For Product', now());
# Add access to the Bookings Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_bookingsForProduct';

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForCustomer', 'Bookings For Customer', now());
# Add access to the Bookings Panel to all roles that can access the Customers panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_bookingsForCustomer';

# Add active flag on countries table
ALTER TABLE countries ADD active int DEFAULT 1 NOT NULL;
UPDATE countries SET active = 1;

# store address ids in order table
ALTER TABLE orders ADD COLUMN billing_addr_id int default '-1';
ALTER TABLE orders ADD COLUMN delivery_addr_id int default '-1';
ALTER TABLE orders ADD COLUMN customer_addr_id int default '-1';

# Table for catalogs
DROP TABLE IF EXISTS kk_catalog;
CREATE TABLE kk_catalog (
   catalog_id int NOT NULL auto_increment,
   store_id varchar(64),
   cat_name varchar(32) NOT NULL,
   description varchar(255),
   use_cat_prices int,
   use_cat_quantities int,
   PRIMARY KEY (catalog_id)
   );
   
# New Product Catalog Definition Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_catalogs', 'Product Catalog Definitions', now());
# Add access to the Bookings Panel to all roles that can access the Products panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_catalogs';


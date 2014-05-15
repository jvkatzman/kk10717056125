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
-- From version 5.4.0.0 to version 5.5.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.4.0.0, the upgrade
-- scripts must be run sequentially.
-- 

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForOrder', 'Bookings For Order', getdate());
-- Add access to the Bookings Panel to all roles that can access the Orders panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_orders' and p2.code='kk_panel_bookingsForOrder';

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForProduct', 'Bookings For Product', getdate());
-- Add access to the Bookings Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_bookingsForProduct';

INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_bookingsForCustomer', 'Bookings For Customer', getdate());
-- Add access to the Bookings Panel to all roles that can access the Customers panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_bookingsForCustomer';

-- Add active flag on countries table
ALTER TABLE countries ADD active int DEFAULT 1 NOT NULL;
UPDATE countries SET active = 1;

-- store address ids in order table
ALTER TABLE orders ADD billing_addr_id int default '-1';
ALTER TABLE orders ADD delivery_addr_id int default '-1';
ALTER TABLE orders ADD customer_addr_id int default '-1';

-- Table for catalogs
DROP TABLE kk_catalog;
CREATE TABLE kk_catalog (
  catalog_id int NOT NULL identity(1,1),
  store_id varchar(64),
  cat_name varchar(32) NOT NULL,
  description varchar(255),
  use_cat_prices int,
  use_cat_quantities int,
  PRIMARY KEY(catalog_id)
   );

-- New Product Catalog Definition Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_catalogs', 'Product Catalog Definitions', getdate());
-- Add access to the Bookings Panel to all roles that can access the Products panel
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, getdate(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_products' and p2.code='kk_panel_catalogs';

exit;

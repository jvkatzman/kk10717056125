#----------------------------------------------------------------
# KonaKart upgrade script from version 6.1.0.0 to version 6.2.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# New View Logs Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_viewLogs', 'View Logs', now());
# Add access to the View Logs Panel to all roles that can access the Configuration Files panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, custom1, custom1_desc, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 0, 0, 'Set to hide the View button', now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_configFiles' and p2.code='kk_panel_viewLogs';

# Add last login date tag
DELETE FROM kk_customer_tag WHERE name ='LOGIN_DATE';
INSERT INTO kk_customer_tag (name, description, tag_type, max_ints, date_added) VALUES ('LOGIN_DATE', 'Time of Last Login', 6, 5, now());

# Allow null values for entry_firtsname and entry_lastname on addresses (useful for Manufacturer addresses particularly)
ALTER TABLE address_book MODIFY entry_firstname VARCHAR(32) NULL;
ALTER TABLE address_book MODIFY entry_lastname VARCHAR(32) NULL;
#DB2 -- For DB2 Only - Required after setting field to nullable
#DB2 call SYSPROC.ADMIN_CMD ('REORG TABLE address_book');

# Table for KonaKart Config Values
DROP TABLE IF EXISTS kk_config;
CREATE TABLE kk_config (
   kk_config_id int NOT NULL auto_increment,
   kk_config_key varchar(16),
   kk_config_value varchar(256),
   date_added datetime,
   PRIMARY KEY (kk_config_id)
);

INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '6.2.0.0 U', now());
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('VERSION', '6.2.0.0 MySQL', now());

# New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('getConfigData','', now());

# Customer from Reviews Panel
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_customerForReview', 'Customer From Reviews', now());

# Add access to the Customer from Reviews Panel to all roles that can access the Customers panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_customers' and p2.code='kk_panel_customerForReview';

# Add "Updated By Customer Id" to the Orders Status History table to record who updated the order
ALTER TABLE orders_status_history ADD COLUMN updated_by_id int DEFAULT 0;

# New Admin API call
INSERT INTO kk_api_call (name, description, date_added) VALUES ('updateOrder','', now());


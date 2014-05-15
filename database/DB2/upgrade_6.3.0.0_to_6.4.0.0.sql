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
-- KonaKart upgrade database script for DB2
-- From version 6.3.0.0 to version 6.4.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.3.0.0, the upgrade
-- scripts must be run sequentially.
-- 

set echo on
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (NEXTVAL FOR kk_config_seq, 'HISTORY', '6.4.0.0 U', current timestamp);
UPDATE kk_config SET kk_config_value='6.4.0.0 DB2', date_added=current timestamp WHERE kk_config_key='VERSION';

-- Set some defaults by configuration_group
UPDATE configuration set return_by_api = 1 where configuration_group_id in (26);

-- Return the STOCK_REORDER_LEVEL configuration variable
UPDATE configuration set return_by_api = 1 where configuration_key in ('STOCK_REORDER_LEVEL');

-- Admin API calls
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'editProductWithOptions','', current timestamp);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (nextval for kk_api_call_seq, 'insertProductWithOptions','', current timestamp);

-- Save payment module sub-code information with the order
ALTER TABLE orders ADD payment_module_subcode varchar(64);

-- Add number of reviews to product table
ALTER TABLE products ADD number_reviews int DEFAULT 0;

-- Change the email address for John Doe
UPDATE customers SET customers_email_address = 'doe@konakart.com' where customers_email_address = 'root@localhost';
UPDATE customers SET customers_email_address = 'store2-doe@konakart.com' where customers_email_address = 'store2-root@localhost';

-- Change previous occurrences of root@localhost should they still exist
UPDATE configuration SET configuration_value = 'admin@konakart.com' where configuration_value = 'root@localhost' and configuration_key = 'STORE_OWNER_EMAIL_ADDRESS';
UPDATE configuration SET configuration_value = 'admin@konakart.com' where configuration_value = 'KonaKart <root@localhost>' and configuration_key = 'EMAIL_FROM';
exit;

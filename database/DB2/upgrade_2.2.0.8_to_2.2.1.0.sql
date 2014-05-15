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
-- From version 2.2.0.8 to version 2.2.1.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.8, the upgrade
-- scripts must be run sequentially.
-- 

delete from configuration where configuration_key = 'KONAKART_MAIL_PROPERTIES_FILE';
set echo on
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'KonaKart mail properties filename', 'KONAKART_MAIL_PROPERTIES_FILE', 'C:/Program Files/KonaKart/conf/konakart_mail.properties', 'Location of the KonaKart mail properties file', 12, 8, current timestamp);

-- Log file location 
delete from configuration where configuration_key = 'KONAKART_LOG_FILE_DIRECTORY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES (nextval for configuration_seq, 'KonaKart Log file Directory', 'KONAKART_LOG_FILE_DIRECTORY', 'C:/Program Files/KonaKart/logs', 'The location where KonaKart will write diagnostic log files', 20, 2, current timestamp);

-- Extend the size of the country_name columns to match countries table
ALTER TABLE orders ALTER COLUMN customers_country SET DATA TYPE VARCHAR(64);
ALTER TABLE orders ALTER COLUMN billing_country SET DATA TYPE VARCHAR(64);
ALTER TABLE orders ALTER COLUMN delivery_country SET DATA TYPE VARCHAR(64);

-- Extend the size of the products_model column to match products table
ALTER TABLE orders_products ALTER COLUMN products_model SET DATA TYPE VARCHAR(64);


exit;

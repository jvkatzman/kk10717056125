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
-- From version 6.5.0.0 to version 6.5.1.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 6.5.0.0, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
-- Comment out the next 'Alter session' line if using 11gR1 or earlier
Alter session set deferred_segment_creation=false;

set echo on
INSERT INTO kk_config (kk_config_id, kk_config_key, kk_config_value, date_added) VALUES (kk_config_seq.nextval, 'HISTORY', '6.5.1.0 U', sysdate);
UPDATE kk_config SET kk_config_value='6.5.1.0 Oracle', date_added=sysdate WHERE kk_config_key='VERSION';

-- ===============================================================================
-- Reduce the size of some columns to make them more portable across all databases
-- Don't run this if there is a risk of data loss.
-- It's not essential to run these ALTER TABLE statements.
-- Data loss is possible if you have data in the specified columns that is
-- 256 characters in length as these are truncated to 255 characters.
-- As a pre-caution these ALTER TABLE commands are not executed by default
--
-- MySQL users:
-- If you're running MySQL prior to MySQL 5.6 it is advisable to execute these
-- ALTER TABLE statements to avoid problems if/when you migrate to MySQL 5.6.10 or
-- above.  The reason is that by default MySQL 5.6.10.1 with UTF8 encoding and
-- using innoDB tables will not support keys of VARCHAR(256) - but will accept
-- keys of VARCHAR(255) - hence this change.
-- ===============================================================================

-- Make address format fields 1 character smaller
-- ALTER TABLE address_format MODIFY address_format VARCHAR(255);
-- ALTER TABLE address_format MODIFY address_summary VARCHAR(255);

-- Make product image fields 1 character smaller
-- ALTER TABLE products MODIFY products_image VARCHAR(255);
-- ALTER TABLE products MODIFY products_image2 VARCHAR(255);
-- ALTER TABLE products MODIFY products_image3 VARCHAR(255);
-- ALTER TABLE products MODIFY products_image4 VARCHAR(255);

-- Reduce the size of the products_name by 1 character
-- ALTER TABLE products_description MODIFY products_name VARCHAR(255);

-- Reduce the size of the categories_name by 1 character
-- ALTER TABLE categories_description MODIFY categories_name VARCHAR(255);

-- Reduce the size of the products_name by 1 character
-- ALTER TABLE orders_products MODIFY products_name VARCHAR(255);
exit;

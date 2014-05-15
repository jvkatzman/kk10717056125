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
-- KonaKart upgrade database script for PostgreSQL database
-- From version 2.2.0.0 to version 2.2.0.1
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.0, the upgrade
-- scripts must be run sequentially.
-- 
ALTER TABLE customers add column custom1 varchar(128);
ALTER TABLE customers add column custom2 varchar(128);
ALTER TABLE customers add column custom3 varchar(128);
ALTER TABLE customers add column custom4 varchar(128);
ALTER TABLE customers add column custom5 varchar(128);

ALTER TABLE products add column custom1 varchar(128);
ALTER TABLE products add column custom2 varchar(128);
ALTER TABLE products add column custom3 varchar(128);
ALTER TABLE products add column custom4 varchar(128);
ALTER TABLE products add column custom5 varchar(128);

ALTER TABLE manufacturers add column custom1 varchar(128);
ALTER TABLE manufacturers add column custom2 varchar(128);
ALTER TABLE manufacturers add column custom3 varchar(128);
ALTER TABLE manufacturers add column custom4 varchar(128);
ALTER TABLE manufacturers add column custom5 varchar(128);

ALTER TABLE address_book add column custom1 varchar(128);
ALTER TABLE address_book add column custom2 varchar(128);
ALTER TABLE address_book add column custom3 varchar(128);
ALTER TABLE address_book add column custom4 varchar(128);
ALTER TABLE address_book add column custom5 varchar(128);

ALTER TABLE orders add column custom1 varchar(128);
ALTER TABLE orders add column custom2 varchar(128);
ALTER TABLE orders add column custom3 varchar(128);
ALTER TABLE orders add column custom4 varchar(128);
ALTER TABLE orders add column custom5 varchar(128);

ALTER TABLE reviews add column custom1 varchar(128);
ALTER TABLE reviews add column custom2 varchar(128);
ALTER TABLE reviews add column custom3 varchar(128);

ALTER TABLE categories add column custom1 varchar(128);
ALTER TABLE categories add column custom2 varchar(128);
ALTER TABLE categories add column custom3 varchar(128);

INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES                ('Client config cache refresh check interval','CLIENT_CONFIG_CACHE_CHECK_SECS','30','Interval in seconds for checking to see whether the client side cache of config variables needs updating','11', '9', 'integer(30,null)', now());
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES                ('Client config cache refresh flag','CLIENT_CONFIG_CACHE_CHECK_FLAG','false','Boolean to determine whether to refresh the client config variable cache','100', '1' , now());

UPDATE configuration set set_function='password' where configuration_key='SMTP_PASSWORD';


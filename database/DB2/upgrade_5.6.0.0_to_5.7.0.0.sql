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
-- From version 5.6.0.0 to version 5.7.0.0
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 5.6.0.0, the upgrade
-- scripts must be run sequentially.
-- 

ALTER TABLE orders_total ADD custom1 varchar(128);
ALTER TABLE orders_total ADD custom2 varchar(128);
ALTER TABLE orders_total ADD custom3 varchar(128);

-- Add creator field to order
ALTER TABLE orders ADD order_creator varchar(128);
exit;

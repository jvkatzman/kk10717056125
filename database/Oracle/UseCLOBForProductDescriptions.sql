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
-- Convert products_description field to a CLOB
-- Requires KonaKart v5.3.0.0 or above
-- -----------------------------------------------------------

set escape \

ALTER TABLE products_description ADD tempcol CLOB;
UPDATE products_description SET tempcol = products_description;
ALTER TABLE products_description DROP COLUMN products_description;
ALTER TABLE products_description RENAME COLUMN tempcol to products_description;

UPDATE configuration set configuration_value = 'true' WHERE configuration_key = 'FETCH_PRODUCT_DESCRIPTIONS_SEPARATELY';

exit;

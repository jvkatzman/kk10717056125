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
-- Convert custom_attrs field to a CLOB
-- Requires KonaKart v5.8.0.0 or above
-- -----------------------------------------------------------

set escape \

ALTER TABLE products ADD tempcol CLOB;
UPDATE products SET tempcol = custom_attrs;
ALTER TABLE products DROP COLUMN custom_attrs;
ALTER TABLE products RENAME COLUMN tempcol to custom_attrs;

exit;

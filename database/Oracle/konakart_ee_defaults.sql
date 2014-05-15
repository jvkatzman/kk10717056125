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
-- KonaKart demo database script for Oracle
-- Created: Thu Sep 12 06:01:42 BST 2013
-- -----------------------------------------------------------
-- 
set escape \
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'DISPLAY_GIFT_CERT_ENTRY';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_WISHLIST';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ALLOW_WISHLIST_WHEN_NOT_LOGGED_IN';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_GIFT_REGISTRY';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_CART_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_WISHLIST_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_PDF_INVOICE_DOWNLOAD';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_REWARD_POINTS';

exit;

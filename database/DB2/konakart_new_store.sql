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
-- KonaKart demo database script for DB2
-- Created: Thu Sep 12 06:01:47 BST 2013
-- -----------------------------------------------------------
-- 

DELETE FROM address_book where store_id = 'TARGET_STOREID';
DELETE FROM address_format where store_id = 'TARGET_STOREID';
DELETE FROM banners where store_id = 'TARGET_STOREID';
DELETE FROM banners_history where store_id = 'TARGET_STOREID';
DELETE FROM categories where store_id = 'TARGET_STOREID';
DELETE FROM categories_description where store_id = 'TARGET_STOREID';
DELETE FROM configuration where store_id = 'TARGET_STOREID';
DELETE FROM counter where store_id = 'TARGET_STOREID';
DELETE FROM counter_history where store_id = 'TARGET_STOREID';
DELETE FROM countries where store_id = 'TARGET_STOREID';
DELETE FROM currencies where store_id = 'TARGET_STOREID';
DELETE FROM customers where store_id = 'TARGET_STOREID';
DELETE FROM customers_basket where store_id = 'TARGET_STOREID';
DELETE FROM customers_basket_attribute where store_id = 'TARGET_STOREID';
DELETE FROM customers_info where store_id = 'TARGET_STOREID';
DELETE FROM languages where store_id = 'TARGET_STOREID';
DELETE FROM manufacturers where store_id = 'TARGET_STOREID';
DELETE FROM manufacturers_info where store_id = 'TARGET_STOREID';
DELETE FROM newsletters where store_id = 'TARGET_STOREID';
DELETE FROM orders where store_id = 'TARGET_STOREID';
DELETE FROM orders_products where store_id = 'TARGET_STOREID';
DELETE FROM orders_status where store_id = 'TARGET_STOREID';
DELETE FROM orders_status_history where store_id = 'TARGET_STOREID';
DELETE FROM orders_products_attributes where store_id = 'TARGET_STOREID';
DELETE FROM orders_products_download where store_id = 'TARGET_STOREID';
DELETE FROM orders_total where store_id = 'TARGET_STOREID';
DELETE FROM products where store_id = 'TARGET_STOREID';
DELETE FROM products_attributes where store_id = 'TARGET_STOREID';
DELETE FROM products_attributes_downlo where store_id = 'TARGET_STOREID';
DELETE FROM products_description where store_id = 'TARGET_STOREID';
DELETE FROM products_notifications where store_id = 'TARGET_STOREID';
DELETE FROM products_options where store_id = 'TARGET_STOREID';
DELETE FROM products_options_values where store_id = 'TARGET_STOREID';
DELETE FROM products_options_values_to where store_id = 'TARGET_STOREID';
DELETE FROM products_to_categories where store_id = 'TARGET_STOREID';
DELETE FROM reviews where store_id = 'TARGET_STOREID';
DELETE FROM reviews_description where store_id = 'TARGET_STOREID';
DELETE FROM specials where store_id = 'TARGET_STOREID';
DELETE FROM tax_class where store_id = 'TARGET_STOREID';
DELETE FROM tax_rates where store_id = 'TARGET_STOREID';
DELETE FROM geo_zones where store_id = 'TARGET_STOREID';
DELETE FROM whos_online where store_id = 'TARGET_STOREID';
DELETE FROM zones where store_id = 'TARGET_STOREID';
DELETE FROM zones_to_geo_zones where store_id = 'TARGET_STOREID';

DELETE FROM ipn_history where store_id = 'TARGET_STOREID';
DELETE FROM promotion where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_manufacturer where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_product where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_category where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_customer where store_id = 'TARGET_STOREID';
DELETE FROM coupon where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_coupon where store_id = 'TARGET_STOREID';
DELETE FROM products_to_products where store_id = 'TARGET_STOREID';
DELETE FROM products_quantity where store_id = 'TARGET_STOREID';
DELETE FROM orders_returns where store_id = 'TARGET_STOREID';
DELETE FROM returns_to_ord_prods where store_id = 'TARGET_STOREID';
DELETE FROM kk_audit where store_id = 'TARGET_STOREID';
DELETE FROM kk_customers_to_role where store_id = 'TARGET_STOREID';
DELETE FROM kk_role_to_panel where store_id = 'TARGET_STOREID';
DELETE FROM kk_digital_download_1 where store_id = 'TARGET_STOREID';
DELETE FROM counter where store_id = 'TARGET_STOREID';
DELETE FROM kk_role_to_api_call where store_id = 'TARGET_STOREID';
DELETE FROM kk_customer_group where store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_cust_group where store_id = 'TARGET_STOREID';

DELETE FROM kk_category_to_tag_group where store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_to_product where store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_group_to_tag where store_id = 'TARGET_STOREID';
DELETE FROM kk_tag where store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_group where store_id = 'TARGET_STOREID';
DELETE FROM kk_product_to_stores where store_id = 'TARGET_STOREID';

DELETE FROM kk_product_feed where store_id = 'TARGET_STOREID';
DELETE FROM kk_wishlist where store_id = 'TARGET_STOREID';
DELETE FROM kk_wishlist_item where store_id = 'TARGET_STOREID';
DELETE FROM kk_subscription where store_id = 'TARGET_STOREID';
DELETE FROM kk_payment_schedule where store_id = 'TARGET_STOREID';

DELETE FROM kk_misc_item_type where store_id = 'TARGET_STOREID';
DELETE FROM kk_misc_item where store_id = 'TARGET_STOREID';

-----------------------------------------------------------------------------------
-- Now create enough data for the store to be able to start using angine APIs
-----------------------------------------------------------------------------------

Delete from languages where store_id = 'TARGET_STOREID';
set echo on
INSERT INTO languages (languages_id, name, code, locale, image, directory, sort_order, display_only, store_id) select nextval for languages_seq, name, code, locale, image, directory, sort_order, display_only, 'TARGET_STOREID' from languages where store_id='SOURCE_STOREID';

delete from configuration where store_id = 'TARGET_STOREID';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added, return_by_api, store_id) select nextval for configuration_seq, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, current timestamp, return_by_api, 'TARGET_STOREID' from configuration where store_id='SOURCE_STOREID';

delete from currencies where store_id = 'TARGET_STOREID';
INSERT INTO currencies (currencies_id, title, code, symbol_left, symbol_right, decimal_point, thousands_point, decimal_places, value, last_updated, store_id) select nextval for currencies_seq, title, code, symbol_left, symbol_right, decimal_point, thousands_point, decimal_places, value, current timestamp,  'TARGET_STOREID' from currencies where store_id='SOURCE_STOREID';

delete from address_format where store_id = 'TARGET_STOREID';
INSERT INTO address_format (address_format_id, address_format, address_summary, store_id) select nextval for address_format_seq, address_format, address_summary, 'TARGET_STOREID' from address_format where store_id='SOURCE_STOREID';

delete from geo_zones where store_id = 'TARGET_STOREID';
INSERT INTO geo_zones (geo_zone_id, geo_zone_name, geo_zone_description, last_modified, date_added, store_id) select nextval for geo_zones_seq, geo_zone_name, geo_zone_description, last_modified, date_added, 'TARGET_STOREID' from geo_zones where store_id='SOURCE_STOREID';

delete from countries where store_id = 'TARGET_STOREID';
INSERT INTO countries (countries_id, countries_name, countries_iso_code_2, countries_iso_code_3, address_format_id, store_id) VALUES (nextval for countries_seq,'United States', 'US', 'USA', -1, 'TARGET_STOREID');
update countries set address_format_id = (select min(address_format_id) from address_format where store_id = 'TARGET_STOREID') where address_format_id = -1 and store_id = 'TARGET_STOREID' ;

Delete from address_book where store_id = 'TARGET_STOREID';
INSERT INTO address_book (address_book_id, customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id, store_id) VALUES (nextval for address_book_seq, -1, 'm', 'ACME Inc.', 'TARGET_STOREID-admin', 'Admin', 'TARGET_STOREID Admin Street', 'Suburb', 'PostcodeX', 'City', '', 1, 'TARGET_STOREID');
INSERT INTO address_book (address_book_id, customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id, store_id) VALUES (nextval for address_book_seq, -2, 'm', 'ACME Inc.', 'TARGET_STOREID-super', 'Super', 'TARGET_STOREID Super Street', 'Suburb', 'PostcodeX', 'City', '', 1, 'TARGET_STOREID');

Delete from customers where store_id = 'TARGET_STOREID';
INSERT INTO customers (customers_id, customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type, store_id) VALUES (nextval for customers_seq, 'm', 'TARGET_STOREID-admin', 'Admin', to_date('1977-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'TARGET_STOREID-admin@konakart.com', -1, '019081', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1, 'TARGET_STOREID');
INSERT INTO customers (customers_id, customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type, store_id) VALUES (nextval for customers_seq, 'm', 'TARGET_STOREID-super', 'Super', to_date('1977-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'TARGET_STOREID-super@konakart.com', -2, '019081', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1, 'TARGET_STOREID');

Delete from customers_info where store_id = 'TARGET_STOREID';
INSERT INTO customers_info select customers_id , current timestamp, 0, current timestamp, current timestamp, 0, 'TARGET_STOREID' from customers where customers_email_address = 'TARGET_STOREID-admin@konakart.com' and store_id='TARGET_STOREID';
INSERT INTO customers_info select customers_id , current timestamp, 0, current timestamp, current timestamp, 0, 'TARGET_STOREID' from customers where customers_email_address = 'TARGET_STOREID-super@konakart.com' and store_id='TARGET_STOREID';

UPDATE address_book set customers_id = (select customers_id from customers where customers_email_address = 'TARGET_STOREID-admin@konakart.com' and store_id='TARGET_STOREID') where customers_id=-1 and store_id='TARGET_STOREID';
UPDATE address_book set customers_id = (select customers_id from customers where customers_email_address = 'TARGET_STOREID-super@konakart.com' and store_id='TARGET_STOREID') where customers_id=-2 and store_id='TARGET_STOREID';

UPDATE customers set customers_default_address_id = (select address_book_id from address_book where entry_street_address='TARGET_STOREID Admin Street' and entry_postcode='PostcodeX' and store_id='TARGET_STOREID') where customers_default_address_id=-1 and store_id='TARGET_STOREID';
UPDATE customers set customers_default_address_id = (select address_book_id from address_book where entry_street_address='TARGET_STOREID Super Street' and entry_postcode='PostcodeX' and store_id='TARGET_STOREID') where customers_default_address_id=-2 and store_id='TARGET_STOREID';

UPDATE address_book set entry_country_id = (select countries_id from countries where store_id='TARGET_STOREID') where store_id='TARGET_STOREID';



exit;

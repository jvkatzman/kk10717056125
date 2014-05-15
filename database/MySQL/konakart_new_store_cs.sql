#---------------------------------------------------------------------------------
# KonaKart new store creation SQL script for MySQL
#---------------------------------------------------------------------------------
#
# This is run by the Admin App when creating new stores
#
# This version is for Shared Customers
#

#---------------------------------------------------------------------------------
# Clear records (that shouldn't actually exist in fact) for new store
#---------------------------------------------------------------------------------

DELETE FROM address_book WHERE store_id = 'TARGET_STOREID';
DELETE FROM address_format WHERE store_id = 'TARGET_STOREID';
DELETE FROM banners WHERE store_id = 'TARGET_STOREID';
DELETE FROM banners_history WHERE store_id = 'TARGET_STOREID';
DELETE FROM categories WHERE store_id = 'TARGET_STOREID';
DELETE FROM categories_description WHERE store_id = 'TARGET_STOREID';
DELETE FROM configuration WHERE store_id = 'TARGET_STOREID';
DELETE FROM counter WHERE store_id = 'TARGET_STOREID';
DELETE FROM counter_history WHERE store_id = 'TARGET_STOREID';
DELETE FROM countries WHERE store_id = 'TARGET_STOREID';
DELETE FROM currencies WHERE store_id = 'TARGET_STOREID';
DELETE FROM customers WHERE store_id = 'TARGET_STOREID';
DELETE FROM customers_basket WHERE store_id = 'TARGET_STOREID';
DELETE FROM customers_basket_attributes WHERE store_id = 'TARGET_STOREID';
DELETE FROM customers_info WHERE store_id = 'TARGET_STOREID';
DELETE FROM languages WHERE store_id = 'TARGET_STOREID';
DELETE FROM manufacturers WHERE store_id = 'TARGET_STOREID';
DELETE FROM manufacturers_info WHERE store_id = 'TARGET_STOREID';
DELETE FROM newsletters WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_products WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_status WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_status_history WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_products_attributes WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_products_download WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_total WHERE store_id = 'TARGET_STOREID';
DELETE FROM products WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_attributes WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_attributes_download WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_description WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_notifications WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_options WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_options_values WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_options_values_to_products_options WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_to_categories WHERE store_id = 'TARGET_STOREID';
DELETE FROM reviews WHERE store_id = 'TARGET_STOREID';
DELETE FROM reviews_description WHERE store_id = 'TARGET_STOREID';
DELETE FROM specials WHERE store_id = 'TARGET_STOREID';
DELETE FROM tax_class WHERE store_id = 'TARGET_STOREID';
DELETE FROM tax_rates WHERE store_id = 'TARGET_STOREID';
DELETE FROM geo_zones WHERE store_id = 'TARGET_STOREID';
DELETE FROM whos_online WHERE store_id = 'TARGET_STOREID';
DELETE FROM zones WHERE store_id = 'TARGET_STOREID';
DELETE FROM zones_to_geo_zones WHERE store_id = 'TARGET_STOREID';

DELETE FROM ipn_history WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_manufacturer WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_product WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_category WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_customer WHERE store_id = 'TARGET_STOREID';
DELETE FROM coupon WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_coupon WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_to_products WHERE store_id = 'TARGET_STOREID';
DELETE FROM products_quantity WHERE store_id = 'TARGET_STOREID';
DELETE FROM orders_returns WHERE store_id = 'TARGET_STOREID';
DELETE FROM returns_to_ord_prods WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_audit WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_customers_to_role WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_role_to_panel WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_digital_download_1 WHERE store_id = 'TARGET_STOREID';
DELETE FROM counter WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_role_to_api_call WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_customer_group WHERE store_id = 'TARGET_STOREID';
DELETE FROM promotion_to_cust_group WHERE store_id = 'TARGET_STOREID';

DELETE FROM kk_category_to_tag_group WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_to_product WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_group_to_tag WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_tag WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_tag_group WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_product_to_stores WHERE store_id = 'TARGET_STOREID';

DELETE FROM kk_product_feed WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_wishlist WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_wishlist_item WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_subscription WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_payment_schedule WHERE store_id = 'TARGET_STOREID';

DELETE FROM kk_misc_item_type WHERE store_id = 'TARGET_STOREID';
DELETE FROM kk_misc_item WHERE store_id = 'TARGET_STOREID';

#---------------------------------------------------------------------------------
# Now create enough data for the store to be able to start using angine APIs
#---------------------------------------------------------------------------------

DELETE FROM languages WHERE store_id = 'TARGET_STOREID';
INSERT INTO languages (name, code, locale, image, directory, sort_order, display_only, store_id) select name, code, locale, image, directory, sort_order, display_only, 'TARGET_STOREID' from languages WHERE store_id='SOURCE_STOREID';

delete from configuration WHERE store_id = 'TARGET_STOREID';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, date_added, return_by_api, store_id) select configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, use_function, set_function, now(), return_by_api, 'TARGET_STOREID' from configuration WHERE store_id='SOURCE_STOREID';

DELETE FROM currencies WHERE store_id = 'TARGET_STOREID';
INSERT INTO currencies (title, code, symbol_left, symbol_right, decimal_point, thousands_point, decimal_places, value, last_updated, store_id) select title, code, symbol_left, symbol_right, decimal_point, thousands_point, decimal_places, value, now(),  'TARGET_STOREID' from currencies WHERE store_id='SOURCE_STOREID';

DELETE FROM address_book WHERE customers_id = (select customers_id from customers WHERE customers_email_address = 'TARGET_STOREID-admin@konakart.com');
INSERT INTO address_book (customers_id, entry_gender, entry_company, entry_firstname, entry_lastname, entry_street_address, entry_suburb, entry_postcode, entry_city, entry_state, entry_country_id) VALUES (-1, 'm', 'ACME Inc.', 'TARGET_STOREID', 'Admin', 'TARGET_STOREID Admin Street', 'Suburb', 'PostcodeX', 'City', '', 1);

DELETE FROM customers_info WHERE customers_Info_id = (select customers_id from customers WHERE customers_email_address = 'TARGET_STOREID-admin@konakart.com');

DELETE FROM customers WHERE customers_email_address = 'TARGET_STOREID-admin@konakart.com';
INSERT INTO customers (customers_gender, customers_firstname, customers_lastname,customers_dob, customers_email_address, customers_default_address_id, customers_telephone, customers_fax, customers_password, customers_newsletter, customers_type) VALUES ('m', 'TARGET_STOREID', 'Admin', '1977-01-01 00:00:00', 'TARGET_STOREID-admin@konakart.com', -1, '019081', '', 'f5147fc3f6eb46e234c01db939bdb581:08', '0', 1);

INSERT INTO customers_info select customers_id , now(), 0, now(), now(), 0, 'XXXX' from customers WHERE customers_email_address = 'TARGET_STOREID-admin@konakart.com';

UPDATE address_book set entry_country_id = (select countries_id from countries WHERE countries_iso_code_2='US') WHERE customers_id=-1 and entry_firstname='TARGET_STOREID';
UPDATE address_book set customers_id = (select customers_id from customers WHERE customers_email_address = 'TARGET_STOREID-admin@konakart.com') WHERE customers_id=-1 and entry_firstname='TARGET_STOREID';

UPDATE customers set customers_default_address_id = (select address_book_id from address_book WHERE entry_street_address='TARGET_STOREID Admin Street' and entry_postcode='PostcodeX') WHERE customers_default_address_id=-1 and customers_firstname='TARGET_STOREID';


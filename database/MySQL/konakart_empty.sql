# (c) 2006 DS Data Systems UK Ltd, All rights reserved.
# 
# DS Data Systems and KonaKart and their respective logos, are
# trademarks of DS Data Systems UK Ltd. All rights reserved.
# 
# The information in this document below this text is free software; you can redistribute
# it and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# -----------------------------------------------------------
# KonaKart database empty script for MySQL
# Created: Thu Sep 12 06:01:35 BST 2013
# -----------------------------------------------------------
# 

DELETE FROM address_book;
DELETE FROM address_format;
DELETE FROM banners;
DELETE FROM banners_history;
DELETE FROM categories;
DELETE FROM categories_description;
DELETE FROM configuration;
DELETE FROM configuration_group;
DELETE FROM counter;
DELETE FROM counter_history;
DELETE FROM countries;
DELETE FROM coupon;
DELETE FROM currencies;
DELETE FROM customers;
DELETE FROM customers_basket;
DELETE FROM customers_basket_attributes;
DELETE FROM customers_info;
DELETE FROM geo_zones;
DELETE FROM ipn_history;
DELETE FROM kk_addr_to_product;
DELETE FROM kk_api_call;
DELETE FROM kk_audit;
DELETE FROM kk_bookable_prod;
DELETE FROM kk_booking;
DELETE FROM kk_catalog;
DELETE FROM kk_catalog_quantity;
DELETE FROM kk_category_to_tag_group;
DELETE FROM kk_config;
DELETE FROM kk_cookie;
DELETE FROM kk_cust_attr;
DELETE FROM kk_cust_attr_tmpl;
DELETE FROM kk_cust_stats;
DELETE FROM kk_customer_group;
DELETE FROM kk_customer_tag;
DELETE FROM kk_customers_to_role;
DELETE FROM kk_customers_to_tag;
DELETE FROM kk_digital_download;
DELETE FROM kk_digital_download_1;
DELETE FROM kk_expression;
DELETE FROM kk_expression_variable;
DELETE FROM kk_misc_item;
DELETE FROM kk_misc_item_type;
DELETE FROM kk_msg;
DELETE FROM kk_panel;
DELETE FROM kk_payment_schedule;
DELETE FROM kk_product_feed;
DELETE FROM kk_product_prices;
DELETE FROM kk_product_to_stores;
DELETE FROM kk_product_to_templates;
DELETE FROM kk_promotion_to_expression;
DELETE FROM kk_reserved_points;
DELETE FROM kk_reward_points;
DELETE FROM kk_role;
DELETE FROM kk_role_to_api_call;
DELETE FROM kk_role_to_panel;
DELETE FROM kk_secret_key;
DELETE FROM kk_sso;
DELETE FROM kk_store;
DELETE FROM kk_subscription;
DELETE FROM kk_tag;
DELETE FROM kk_tag_group;
DELETE FROM kk_tag_group_to_tag;
DELETE FROM kk_tag_to_product;
DELETE FROM kk_tier_price;
DELETE FROM kk_tmpl_to_cust_attr;
DELETE FROM kk_wishlist;
DELETE FROM kk_wishlist_item;
DELETE FROM languages;
DELETE FROM manufacturers;
DELETE FROM manufacturers_info;
DELETE FROM newsletters;
DELETE FROM orders;
DELETE FROM orders_products;
DELETE FROM orders_products_attributes;
DELETE FROM orders_products_download;
DELETE FROM orders_returns;
DELETE FROM orders_status;
DELETE FROM orders_status_history;
DELETE FROM orders_total;
DELETE FROM products;
DELETE FROM products_attributes;
DELETE FROM products_attributes_download;
DELETE FROM products_description;
DELETE FROM products_notifications;
DELETE FROM products_options;
DELETE FROM products_options_values;
DELETE FROM products_options_values_to_products_options;
DELETE FROM products_quantity;
DELETE FROM products_to_categories;
DELETE FROM products_to_products;
DELETE FROM promotion;
DELETE FROM promotion_to_category;
DELETE FROM promotion_to_coupon;
DELETE FROM promotion_to_cust_group;
DELETE FROM promotion_to_customer;
DELETE FROM promotion_to_customer_use;
DELETE FROM promotion_to_manufacturer;
DELETE FROM promotion_to_product;
DELETE FROM returns_to_ord_prods;
DELETE FROM reviews;
DELETE FROM reviews_description;
DELETE FROM sessions;
DELETE FROM specials;
DELETE FROM tax_class;
DELETE FROM tax_rates;
DELETE FROM utility;
DELETE FROM whos_online;
DELETE FROM zones;
DELETE FROM zones_to_geo_zones;

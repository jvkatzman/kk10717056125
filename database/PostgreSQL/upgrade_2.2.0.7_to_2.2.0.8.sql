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
-- KonaKart upgrade database script for PostgreSQL
-- From version 2.2.0.7 to version 2.2.0.8
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.7, the upgrade
-- scripts must be run sequentially.
-- 
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (DEFAULT, 'kk_panel_changePassword','Change Password', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 61, 1,1,1,now());

-- API Call table
DROP TABLE IF EXISTS kk_api_call;
CREATE TABLE kk_api_call (
   api_call_id SERIAL,
   name varchar(128) NOT NULL,
   description varchar(255),
   date_added timestamp,
   last_modified timestamp,
   PRIMARY KEY (api_call_id)
);

-- Role to API Call table
DROP TABLE IF EXISTS kk_role_to_api_call;
CREATE TABLE kk_role_to_api_call (
   role_id integer DEFAULT '0' NOT NULL,
   api_call_id integer DEFAULT '0' NOT NULL,
   date_added timestamp,
   PRIMARY KEY (role_id, api_call_id)
);

-- Add the API Call Data
delete from kk_api_call;
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertOrderStatusNames','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'sendEmail','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrdersCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrdersLite','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrders','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrderForOrderId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrderForOrderIdAndLangId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrdersCreatedSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateOrderStatus','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getHtml','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomersCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomersCountWhoHaventPlacedAnOrderSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomersCountWhoHavePlacedAnOrderSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteOrder','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomers','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomersLite','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCustomerForId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'updateSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getConfigurationInfo','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getConfigurationsByGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'saveConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getModules','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'registerCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'resetCustomerPassword','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'changePassword','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'searchForProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCategoryTree','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteSingleCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'moveCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAllReviews','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getReviewsPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAllSpecials','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getSpecialsPerCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProductOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProductOptionValues','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProductOptionsPerId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProductOptionValuesPerId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductOption','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editProductOption','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductOptionValue','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editProductOptionValue','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getNextProductOptionId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getNextProductOptionValuesId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProductAttributesPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteProductAttributesPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductOptionValues','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertProductOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'checkSession','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'searchForIpnHistory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteExpiredSessions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getConfigFiles','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getReports','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'reloadReports','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getFileContents','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'saveFileContents','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteFile','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCategoriesToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCouponsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addPromotionsToCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCustomersToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addCustomersToPromotionPerOrdersMade','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addManufacturersToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addProductsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deletePromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCouponsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCoupons','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getCategoriesPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getManufacturersPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getProductsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPromotions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPromotionsCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPromotionsPerCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCouponForPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeCategoriesFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeCouponsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removePromotionsFromCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeCustomersFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeManufacturersFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeProductsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'readFromUrl','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getOrderReturns','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getSku','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getSkus','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'doesCustomerExistForEmail','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAuditData','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteAuditData','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getRolesPerSessionId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getRolesPerUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addRolesToUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeRolesFromUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removePanelsFromRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'removeApiCallsFromRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addPanelsToRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'addApiCallsToRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPanelsPerRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getApiCallsPerRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAllPanels','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAllApiCalls','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getAllRoles','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deletePanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'deleteApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'editApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'insertApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (DEFAULT, 'getHelpMsg','', now());

-- Variable for enabling / disabling API Call Security
delete from configuration where configuration_key = 'API_CALL_SECURITY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Security on API Calls', 'API_CALL_SECURITY', 'false', 'Do you want to enable security on API calls ?', '18', '5','tep_cfg_select_option(array(''true'', ''false''), ' , now());


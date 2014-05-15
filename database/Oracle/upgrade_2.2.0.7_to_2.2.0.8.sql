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
-- From version 2.2.0.7 to version 2.2.0.8
-- -----------------------------------------------------------
-- In order to upgrade from versions prior to 2.2.0.7, the upgrade
-- scripts must be run sequentially.
-- 
set escape \
set echo on
INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (kk_panel_seq.nextval,  'kk_panel_changePassword','Change Password', sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 61, 1,1,1,sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 61, 1,1,1,sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 61, 1,1,1,sysdate);
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 61, 1,1,1,sysdate);

-- API Call table
DROP TABLE kk_api_call CASCADE CONSTRAINTS;
CREATE TABLE kk_api_call (
  api_call_id NUMBER(10,0) NOT NULL,
  name VARCHAR2(128) NOT NULL,
  description VARCHAR2(255),
  date_added TIMESTAMP,
  last_modified TIMESTAMP,
  PRIMARY KEY(api_call_id)
);
DROP SEQUENCE kk_api_call_SEQ;
CREATE SEQUENCE kk_api_call_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;

-- Role to API Call table
DROP TABLE kk_role_to_api_call CASCADE CONSTRAINTS;
CREATE TABLE kk_role_to_api_call (
  role_id NUMBER(10,0) DEFAULT 0 NOT NULL,
  api_call_id NUMBER(10,0) DEFAULT 0 NOT NULL,
  date_added TIMESTAMP,
  PRIMARY KEY(role_id, api_call_id)
);

-- Add the API Call Data
delete from kk_api_call;
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCurrency','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCurrency','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateCurrency','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteOrderStatusName','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertOrderStatusName','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertOrderStatusNames','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateOrderStatusName','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCountry','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCountry','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateCountry','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteLanguage','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertLanguage','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateLanguage','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'sendEmail','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrdersCount','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrdersLite','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrders','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrderForOrderId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrderForOrderIdAndLangId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrdersCreatedSince','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateOrderStatus','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getHtml','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomersCount','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomersCountWhoHaventPlacedAnOrderSince','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomersCountWhoHavePlacedAnOrderSince','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateCustomer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCustomer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteOrder','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomers','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomersLite','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCustomerForId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteTaxRate','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertTaxRate','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateTaxRate','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteTaxClass','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertTaxClass','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateTaxClass','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteAddressFormat','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertAddressFormat','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateAddressFormat','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteGeoZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertGeoZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateGeoZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteSubZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertSubZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'updateSubZone','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getConfigurationInfo','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getConfigurationsByGroup','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'saveConfigs','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertConfigs','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeConfigs','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getModules','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'registerCustomer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'resetCustomerPassword','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'changePassword','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'searchForProducts','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCategoryTree','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteSingleCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'moveCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteManufacturer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editManufacturer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertManufacturer','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteReview','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editReview','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAllReviews','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getReview','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getReviewsPerProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertReview','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertSpecial','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getSpecial','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteSpecial','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editSpecial','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAllSpecials','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getSpecialsPerCategory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProductOptions','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProductOptionValues','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getProductOptionsPerId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getProductOptionValuesPerId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductOption','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editProductOption','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductOptionValue','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editProductOptionValue','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getNextProductOptionId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getNextProductOptionValuesId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getProductAttributesPerProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProductAttribute','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteProductAttributesPerProduct','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editProductAttribute','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductAttribute','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductOptionValues','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertProductOptions','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'checkSession','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'searchForIpnHistory','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteExpiredSessions','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getConfigFiles','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getReports','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'reloadReports','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getFileContents','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'saveFileContents','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteFile','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addCategoriesToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addCouponsToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addPromotionsToCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addCustomersToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addCustomersToPromotionPerOrdersMade','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addManufacturersToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addProductsToPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deletePromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCouponsPerPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCoupons','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getCategoriesPerPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getManufacturersPerPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getProductsPerPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPromotions','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPromotionsCount','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPromotionsPerCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCouponForPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeCategoriesFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeCouponsFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removePromotionsFromCoupon','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeCustomersFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeManufacturersFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeProductsFromPromotion','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getRelatedProducts','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeRelatedProducts','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addRelatedProducts','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'readFromUrl','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editOrderReturn','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertOrderReturn','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteOrderReturn','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getOrderReturns','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getSku','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getSkus','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'doesCustomerExistForEmail','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAuditData','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteAuditData','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getRolesPerSessionId','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getRolesPerUser','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addRolesToUser','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeRolesFromUser','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removePanelsFromRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'removeApiCallsFromRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addPanelsToRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'addApiCallsToRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPanelsPerRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getApiCallsPerRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAllPanels','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAllApiCalls','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getAllRoles','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deletePanel','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'deleteApiCall','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editPanel','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'editApiCall','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getPanel','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getApiCall','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getRole','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertPanel','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'insertApiCall','', sysdate);
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (kk_api_call_seq.nextval,  'getHelpMsg','', sysdate);

-- Variable for enabling / disabling API Call Security
delete from configuration where configuration_key = 'API_CALL_SECURITY';
INSERT INTO configuration (configuration_id, configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES (configuration_seq.nextval, 'Enable Security on API Calls', 'API_CALL_SECURITY', 'false', 'Do you want to enable security on API calls ?', '18', '5','tep_cfg_select_option(array(''true'', ''false''), ' , sysdate);

exit;

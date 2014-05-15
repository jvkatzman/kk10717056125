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
# KonaKart upgrade database script for MS Sql Server
# From version 2.2.0.7 to version 2.2.0.8
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.0.7, the upgrade
# scripts must be run sequentially.
# 

INSERT INTO kk_panel ( code, description, date_added) VALUES ( 'kk_panel_changePassword','Change Password', getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 61, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 61, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 61, 1,1,1,getdate());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 61, 1,1,1,getdate());

-- API Call table
DROP TABLE kk_api_call;
CREATE TABLE kk_api_call (
  api_call_id int NOT NULL identity(1,1),
  name varchar(128) NOT NULL,
  description varchar(255),
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(api_call_id)
);

-- Role to API Call table
DROP TABLE kk_role_to_api_call;
CREATE TABLE kk_role_to_api_call (
  role_id int DEFAULT 0 NOT NULL,
  api_call_id int DEFAULT 0 NOT NULL,
  date_added datetime,
  PRIMARY KEY(role_id, api_call_id)
);

-- Add the API Call Data
delete from kk_api_call;
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteCurrency','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertCurrency','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateCurrency','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteOrderStatusName','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertOrderStatusName','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertOrderStatusNames','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateOrderStatusName','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteCountry','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertCountry','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateCountry','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteLanguage','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertLanguage','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateLanguage','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'sendEmail','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrdersCount','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrdersLite','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrders','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrderForOrderId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrderForOrderIdAndLangId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrdersCreatedSince','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateOrderStatus','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getHtml','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomersCount','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomersCountWhoHaventPlacedAnOrderSince','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomersCountWhoHavePlacedAnOrderSince','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateCustomer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteCustomer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteOrder','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomers','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomersLite','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCustomerForId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteTaxRate','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertTaxRate','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateTaxRate','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteTaxClass','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertTaxClass','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateTaxClass','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteAddressFormat','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertAddressFormat','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateAddressFormat','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteGeoZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertGeoZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateGeoZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteSubZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertSubZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'updateSubZone','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getConfigurationInfo','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getConfigurationsByGroup','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'saveConfigs','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertConfigs','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeConfigs','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getModules','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'registerCustomer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'resetCustomerPassword','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'changePassword','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'searchForProducts','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteCategoryTree','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteSingleCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'moveCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteManufacturer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editManufacturer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertManufacturer','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteReview','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editReview','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllReviews','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getReview','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getReviewsPerProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertReview','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertSpecial','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getSpecial','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteSpecial','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editSpecial','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllSpecials','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getSpecialsPerCategory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteProductOptions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteProductOptionValues','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductOptionsPerId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductOptionValuesPerId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductOption','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editProductOption','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductOptionValue','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editProductOptionValue','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getNextProductOptionId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getNextProductOptionValuesId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductAttributesPerProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteProductAttribute','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteProductAttributesPerProduct','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editProductAttribute','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductAttribute','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductOptionValues','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertProductOptions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'checkSession','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'searchForIpnHistory','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteExpiredSessions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getConfigFiles','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getReports','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'reloadReports','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getFileContents','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'saveFileContents','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteFile','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCategoriesToPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCouponsToPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addPromotionsToCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCustomersToPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addCustomersToPromotionPerOrdersMade','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addManufacturersToPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addProductsToPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deletePromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCouponsPerPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCoupons','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getCategoriesPerPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getManufacturersPerPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getProductsPerPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPromotions','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPromotionsCount','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPromotionsPerCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertCouponForPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeCategoriesFromPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeCouponsFromPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removePromotionsFromCoupon','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeCustomersFromPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeManufacturersFromPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeProductsFromPromotion','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getRelatedProducts','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeRelatedProducts','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addRelatedProducts','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'readFromUrl','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editOrderReturn','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertOrderReturn','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteOrderReturn','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getOrderReturns','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getSku','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getSkus','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'doesCustomerExistForEmail','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAuditData','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteAuditData','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getRolesPerSessionId','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getRolesPerUser','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addRolesToUser','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeRolesFromUser','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removePanelsFromRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'removeApiCallsFromRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addPanelsToRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'addApiCallsToRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPanelsPerRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getApiCallsPerRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllPanels','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllApiCalls','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getAllRoles','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deletePanel','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'deleteApiCall','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editPanel','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'editApiCall','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getPanel','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getApiCall','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getRole','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertPanel','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'insertApiCall','', getdate());
INSERT INTO kk_api_call ( name, description, date_added) VALUES ( 'getHelpMsg','', getdate());

-- Variable for enabling / disabling API Call Security
delete from configuration where configuration_key = 'API_CALL_SECURITY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Security on API Calls', 'API_CALL_SECURITY', 'false', 'Do you want to enable security on API calls ?', '18', '5','tep_cfg_select_option(array(''true'', ''false''), ' , getdate());

exit;

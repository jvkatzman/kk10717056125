#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.7 to version 2.2.0.8
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially

INSERT INTO kk_panel (panel_id, code, description, date_added) VALUES (61, 'kk_panel_changePassword','Change Password', now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (1, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (2, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (3, 61, 1,1,1,now());
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added) VALUES (4, 61, 1,1,1,now());

# API Call table
DROP TABLE IF EXISTS kk_api_call;
CREATE TABLE kk_api_call (
   api_call_id int NOT NULL auto_increment,
   name varchar(128) NOT NULL,
   description varchar(255),
   date_added datetime,
   last_modified datetime,
   PRIMARY KEY (api_call_id)
);

# Role to API Call table
DROP TABLE IF EXISTS kk_role_to_api_call;
CREATE TABLE kk_role_to_api_call (
   role_id int DEFAULT '0' NOT NULL,
   api_call_id int DEFAULT '0' NOT NULL,
   date_added datetime,
   PRIMARY KEY (role_id, api_call_id)
);

# Add the API Call Data
delete from kk_api_call;
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (1, 'deleteCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (2, 'insertCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (3, 'updateCurrency','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (4, 'deleteOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (5, 'insertOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (6, 'insertOrderStatusNames','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (7, 'updateOrderStatusName','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (8, 'deleteCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (9, 'insertCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (10, 'updateCountry','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (11, 'deleteLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (12, 'insertLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (13, 'updateLanguage','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (14, 'sendEmail','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (15, 'getOrdersCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (16, 'getOrdersLite','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (17, 'getOrders','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (18, 'getOrderForOrderId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (19, 'getOrderForOrderIdAndLangId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (20, 'getOrdersCreatedSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (21, 'updateOrderStatus','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (22, 'getHtml','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (23, 'getCustomersCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (24, 'getCustomersCountWhoHaventPlacedAnOrderSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (25, 'getCustomersCountWhoHavePlacedAnOrderSince','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (26, 'updateCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (27, 'deleteCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (28, 'deleteOrder','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (29, 'getCustomers','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (30, 'getCustomersLite','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (31, 'getCustomerForId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (32, 'deleteTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (33, 'insertTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (34, 'updateTaxRate','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (35, 'deleteZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (36, 'insertZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (37, 'updateZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (38, 'deleteTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (39, 'insertTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (40, 'updateTaxClass','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (41, 'deleteAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (42, 'insertAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (43, 'updateAddressFormat','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (44, 'deleteGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (45, 'insertGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (46, 'updateGeoZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (47, 'deleteSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (48, 'insertSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (49, 'updateSubZone','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (50, 'getConfigurationInfo','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (51, 'getConfigurationsByGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (52, 'saveConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (53, 'insertConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (54, 'removeConfigs','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (55, 'getModules','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (56, 'registerCustomer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (57, 'resetCustomerPassword','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (58, 'changePassword','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (59, 'insertProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (60, 'editProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (61, 'getProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (62, 'searchForProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (63, 'deleteProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (64, 'deleteCategoryTree','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (65, 'deleteSingleCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (66, 'editCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (67, 'insertCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (68, 'moveCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (69, 'deleteManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (70, 'editManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (71, 'insertManufacturer','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (72, 'deleteReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (73, 'editReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (74, 'getAllReviews','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (75, 'getReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (76, 'getReviewsPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (77, 'insertReview','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (78, 'insertSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (79, 'getSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (80, 'deleteSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (81, 'editSpecial','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (82, 'getAllSpecials','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (83, 'getSpecialsPerCategory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (84, 'deleteProductOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (85, 'deleteProductOptionValues','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (86, 'getProductOptionsPerId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (87, 'getProductOptionValuesPerId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (88, 'insertProductOption','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (89, 'editProductOption','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (90, 'insertProductOptionValue','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (91, 'editProductOptionValue','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (92, 'getNextProductOptionId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (93, 'getNextProductOptionValuesId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (94, 'getProductAttributesPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (95, 'deleteProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (96, 'deleteProductAttributesPerProduct','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (97, 'editProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (98, 'insertProductAttribute','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (99, 'insertProductOptionValues','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (100, 'insertProductOptions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (101, 'checkSession','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (102, 'searchForIpnHistory','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (103, 'deleteExpiredSessions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (104, 'getConfigFiles','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (105, 'getReports','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (106, 'reloadReports','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (107, 'getFileContents','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (108, 'saveFileContents','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (109, 'deleteFile','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (110, 'addCategoriesToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (111, 'addCouponsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (112, 'addPromotionsToCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (113, 'addCustomersToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (114, 'addCustomersToPromotionPerOrdersMade','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (115, 'addManufacturersToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (116, 'addProductsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (117, 'deletePromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (118, 'deleteCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (119, 'editCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (120, 'editPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (121, 'getCouponsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (122, 'getCoupons','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (123, 'getCategoriesPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (124, 'getManufacturersPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (125, 'getProductsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (126, 'getPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (127, 'getPromotions','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (128, 'getPromotionsCount','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (129, 'getPromotionsPerCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (130, 'insertCouponForPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (131, 'insertCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (132, 'insertPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (133, 'removeCategoriesFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (134, 'removeCouponsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (135, 'removePromotionsFromCoupon','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (136, 'removeCustomersFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (137, 'removeManufacturersFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (138, 'removeProductsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (139, 'getRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (140, 'removeRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (141, 'addRelatedProducts','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (142, 'readFromUrl','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (143, 'editOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (144, 'insertOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (145, 'deleteOrderReturn','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (146, 'getOrderReturns','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (147, 'getSku','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (148, 'getSkus','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (149, 'doesCustomerExistForEmail','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (150, 'getAuditData','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (151, 'deleteAuditData','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (152, 'getRolesPerSessionId','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (153, 'getRolesPerUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (154, 'addRolesToUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (155, 'removeRolesFromUser','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (156, 'removePanelsFromRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (157, 'removeApiCallsFromRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (158, 'addPanelsToRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (159, 'addApiCallsToRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (160, 'getPanelsPerRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (161, 'getApiCallsPerRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (162, 'getAllPanels','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (163, 'getAllApiCalls','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (164, 'getAllRoles','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (165, 'editRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (166, 'insertRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (167, 'deleteRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (168, 'deletePanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (169, 'deleteApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (170, 'editPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (171, 'editApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (172, 'getPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (173, 'getApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (174, 'getRole','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (175, 'insertPanel','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (176, 'insertApiCall','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (177, 'getHelpMsg','', now());

# Variable for enabling / disabling API Call Security
delete from configuration where configuration_key = 'API_CALL_SECURITY';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enable Security on API Calls', 'API_CALL_SECURITY', 'false', 'Do you want to enable security on API calls ?', '18', '5','tep_cfg_select_option(array(\'true\', \'false\'), ' , now());


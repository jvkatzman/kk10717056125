#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.3.0 to version 2.2.4.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.3.0, the upgrade 
# scripts must be run sequentially


# New API calls
delete from kk_api_call where api_call_id = 182;
delete from kk_api_call where api_call_id = 183;
delete from kk_api_call where api_call_id = 184;
delete from kk_api_call where api_call_id = 185;
delete from kk_api_call where api_call_id = 186;
delete from kk_api_call where api_call_id = 187;
delete from kk_api_call where api_call_id = 188;

INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (182, 'removeCustomerGroupsFromPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (183, 'addCustomerGroupsToPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (184, 'getCustomerGroupsPerPromotion','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (185, 'insertCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (186, 'updateCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (187, 'deleteCustomerGroup','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (188, 'getCustomerGroups','', now());
INSERT INTO kk_api_call (api_call_id, name, description, date_added) VALUES (189, 'editOrder','', now());

# Login integration class
delete from configuration where configuration_key = 'LOGIN_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Login Integration Class', 'LOGIN_INTEGRATION_CLASS','com.konakart.bl.LoginIntegrationMgr','The Login Integration Implementation Class, to allow custom credential checking', '18', '6', now());
delete from configuration where configuration_key = 'ADMIN_LOGIN_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Login Integration Class', 'ADMIN_LOGIN_INTEGRATION_CLASS','com.konakartadmin.bl.AdminLoginIntegrationMgr','The Login Integration Implementation Class, to allow custom credential checking for the Admin App', '18', '7', now());

# Add two custom privileges to the Orders screen for restricting access to PackingList and Invoice buttons
update kk_role_to_panel set custom1=0, custom1_desc='If set packing list button not shown', custom2=0, custom2_desc='If set invoice button not shown' where role_id=1 and panel_id=33;
update kk_role_to_panel set custom1=0, custom1_desc='If set packing list button not shown', custom2=0, custom2_desc='If set invoice button not shown' where role_id=3 and panel_id=33;

# Config variables for Admin search definitions
delete from configuration where configuration_key = 'ADMIN_APP_ADD_WILDCARD_BEFORE';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Add wildcard search before text', 'ADMIN_APP_ADD_WILDCARD_BEFORE', 'true', 'When set to true, a wildcard search character is added before the specified text', '21', '10', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());
delete from configuration where configuration_key = 'ADMIN_APP_ADD_WILDCARD_AFTER';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Add wildcard search after text', 'ADMIN_APP_ADD_WILDCARD_AFTER', 'true', 'When set to true, a wildcard search character is added after the specified text', '21', '11', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());


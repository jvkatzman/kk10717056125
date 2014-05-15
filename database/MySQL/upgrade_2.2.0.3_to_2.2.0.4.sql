#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.0.3 to version 2.2.0.4
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.0.0, the upgrade 
# scripts must be run sequentially

# Single page checkout
delete from configuration where configuration_key = 'ONE_PAGE_CHECKOUT';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enables One Page Checkout', 'ONE_PAGE_CHECKOUT', 'true', 'When set to true, it enables the one page checkout functionality rather than 3 separate pages', '1', '23', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());
delete from configuration where configuration_key = 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Enables Checkout Without Registration', 'ALLOW_CHECKOUT_WITHOUT_REGISTRATION', 'true', 'When set to true, and one page checkout is enabled, it allows customers to checkout without registering', '1', '24', 'tep_cfg_select_option(array(\'true\', \'false\'), ', now());


# Create a KK_IF function which for MySQL is a wrapper around the IF function (but we can't use IF on all databases)
DROP FUNCTION IF EXISTS KK_IF;
CREATE FUNCTION KK_IF (test int, a decimal(15,4), b decimal(15,4)) RETURNS decimal(15,4) deterministic return IF(test, a, b);

# Order Integration Mgr
delete from configuration where configuration_key = 'ORDER_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Order Integration Class', 'ORDER_INTEGRATION_CLASS','com.konakart.bl.OrderIntegrationMgr','The Order Integration Implementation Class, to trigger off events when an order is saved or modified', '9', '8', now());
delete from configuration where configuration_key = 'ADMIN_ORDER_INTEGRATION_CLASS';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Admin Order Integration Class', 'ADMIN_ORDER_INTEGRATION_CLASS','com.konakartadmin.bl.AdminOrderIntegrationMgr','The Order Integration Implementation Class, to trigger off events when an order is modified from the Admin App', '9', '9', now());



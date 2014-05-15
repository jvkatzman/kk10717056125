#----------------------------------------------------------------
# KonaKart upgrade script from version 2.2.4.0 to version 2.2.5.0
#----------------------------------------------------------------
#
# In order to upgrade from versions prior to 2.2.4.0, the upgrade 
# scripts must be run sequentially

# Customer Panel Custom Command Definitions
delete from configuration where configuration_key = 'ADMIN_APP_CUST_CUSTOM_LABEL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Customer Custom Button Label', 'ADMIN_APP_CUST_CUSTOM_LABEL', '', 'When this is set, a custom button appears on the customer panel with this label', '21', '20', now());
delete from configuration where configuration_key = 'ADMIN_APP_CUST_CUSTOM_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Customer Custom Button URL', 'ADMIN_APP_CUST_CUSTOM_URL', 'http://www.konakart.com', 'The URL that is launched when the Customer Custom button is clicked', '21', '21', now());

# Default Customer Panel Search Definition
delete from configuration where configuration_key = 'ADMIN_APP_DEFAULT_CUST_CHOICE_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Default Customer Choice', 'ADMIN_APP_DEFAULT_CUST_CHOICE_IDX', 0, 'Sets the default customer choice droplist on the Customer Panel', '21', '22', 'CustomerChoices', now());

# Default Customer Group Search Definition
delete from configuration where configuration_key = 'ADMIN_APP_DEFAULT_CUST_GROUP_IDX';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) VALUES ('Default Customer Group', 'ADMIN_APP_DEFAULT_CUST_GROUP_IDX', 0, 'Sets the default customer group droplist on the Customer Panel', '21', '22', 'CustomerGroups', now());

# Add the custom3 privilege to enable/disable the customer search options on the Customer panel
UPDATE kk_role_to_panel set custom3=0, custom3_desc='If set customer search droplists are disabled' where panel_id=14;

# Set customer type to 0 (customer) for all customers with null customer types
UPDATE customers set customers_type=0 where customers_type is null;


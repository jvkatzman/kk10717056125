#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.5.0.0 to version 5.6.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# New Other Modules Panel
DELETE FROM kk_role_to_panel WHERE panel_id in (SELECT panel_id from kk_panel WHERE code='kk_panel_otherModules');
DELETE FROM kk_panel WHERE code = 'kk_panel_otherModules';
INSERT INTO kk_panel (code, description, date_added) VALUES ('kk_panel_otherModules', 'Other Modules Configuration', now());
# Add access to the Other Modules Panel to all roles that can access the Other Modules panel  
INSERT INTO kk_role_to_panel (role_id, panel_id, can_edit, can_insert, can_delete, date_added, store_id) SELECT role_id, p2.panel_id, 1, 1, 1, now(), store_id FROM kk_role_to_panel rtp, kk_panel p, kk_panel p2 where rtp.panel_id=p.panel_id and p.code='kk_panel_paymentModules' and p2.code='kk_panel_otherModules';

# For defining the list of Other modules installed
DELETE FROM configuration WHERE configuration_key = 'MODULE_OTHERS_INSTALLED';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added, store_id) SELECT 'Installed Other Modules','MODULE_OTHERS_INSTALLED','','List of Other modules separated by a semi-colon.  Automatically updated.  No need to edit.','6', '0', now(), store_id FROM configuration where configuration_key = 'STORE_COUNTRY';

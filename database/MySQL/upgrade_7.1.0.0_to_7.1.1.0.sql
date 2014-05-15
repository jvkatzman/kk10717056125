#----------------------------------------------------------------
# KonaKart upgrade script from version 7.1.0.0 to version 7.1.1.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade scripts
# must be run sequentially
#

# Set database version information
INSERT INTO kk_config (kk_config_key, kk_config_value, date_added) VALUES ('HISTORY', '7.1.1.0 U', now());
UPDATE kk_config SET kk_config_value='7.1.1.0 MySQL', date_added=now() WHERE kk_config_key='VERSION';



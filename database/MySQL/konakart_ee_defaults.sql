#----------------------------------------------------------------
# KonaKart EE Defaults script
#----------------------------------------------------------------
#
# Used to set EE defaults when installing the Enterprise version of KonaKart
#

# Enable some EE features
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'DISPLAY_GIFT_CERT_ENTRY';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_WISHLIST';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ALLOW_WISHLIST_WHEN_NOT_LOGGED_IN';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_GIFT_REGISTRY';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_CART_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_CUSTOMER_WISHLIST_TAGS';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_PDF_INVOICE_DOWNLOAD';
UPDATE configuration SET configuration_value='true' WHERE configuration_key = 'ENABLE_REWARD_POINTS';


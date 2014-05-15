#----------------------------------------------------------------
#----------------------------------------------------------------
# KonaKart upgrade script from version 5.6.0.0 to version 5.7.0.0
#----------------------------------------------------------------
#
# In order to upgrade from earlier versions the upgrade 
# scripts must be run sequentially
#

# Add custom fields to Order Total
ALTER TABLE orders_total ADD COLUMN custom1 varchar(128);
ALTER TABLE orders_total ADD COLUMN custom2 varchar(128);
ALTER TABLE orders_total ADD COLUMN custom3 varchar(128);

# Add creator field to order
ALTER TABLE orders ADD COLUMN order_creator varchar(128);

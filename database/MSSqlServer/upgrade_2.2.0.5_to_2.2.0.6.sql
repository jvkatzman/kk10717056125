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
# From version 2.2.0.5 to version 2.2.0.6
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.0.5, the upgrade
# scripts must be run sequentially.
# 

ALTER TABLE products ALTER COLUMN products_model VARCHAR(64);

-- Add an extra field to the ipn_history table
ALTER TABLE ipn_history add customers_id int;

-- For the case where SSL communication requires a different URL
delete from configuration where configuration_key = 'SSL_BASE_URL';
INSERT INTO configuration (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) VALUES ('Base URL for SSL pages','SSL_BASE_URL','','Base URL used for SSL pages (i.e. https://myhost:8443). This overrides the SSL port number config.','16', '40', getdate());


exit;

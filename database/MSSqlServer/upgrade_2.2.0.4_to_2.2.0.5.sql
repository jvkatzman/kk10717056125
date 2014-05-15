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
# From version 2.2.0.4 to version 2.2.0.5
# -----------------------------------------------------------
# In order to upgrade from versions prior to 2.2.0.4, the upgrade
# scripts must be run sequentially.
# 

DROP TABLE products_quantity;
CREATE TABLE products_quantity(
  products_id int NOT NULL,
  products_options varchar(128) NOT NULL,
  products_quantity int NOT NULL,
  products_sku varchar(255),
  PRIMARY KEY(products_id, products_options)
);

-- Add extra fields to orders_products_attributes table
ALTER TABLE orders_products_attributes add products_options_id int NOT NULL default '-1';
ALTER TABLE orders_products_attributes add products_options_values_id int NOT NULL default '-1';

-- Add extra fields to products table
ALTER TABLE products add products_invisible smallint NOT NULL DEFAULT '0';
ALTER TABLE products add products_sku varchar(255);

-- Tables for returns
DROP TABLE orders_returns;
CREATE TABLE orders_returns (
  orders_returns_id int NOT NULL identity(1,1),
  orders_id int NOT NULL,
  rma_code varchar(128),
  return_reason text,
  date_added datetime,
  last_modified datetime,
  PRIMARY KEY(orders_returns_id)
);

DROP TABLE returns_to_ord_prods;
CREATE TABLE returns_to_ord_prods (
  orders_returns_id int NOT NULL,
  orders_products_id int NOT NULL,
  quantity int NOT NULL,
  date_added datetime,
  PRIMARY KEY(orders_returns_id, orders_products_id)
);

#============================================================================================
# Additional Zones...  remove these if you don't need them to maximise performance

#Australia
INSERT INTO zones VALUES (13,'ACT','Australian Capitol Territory');
INSERT INTO zones VALUES (13,'NSW','New South Wales');
INSERT INTO zones VALUES (13,'NT','Northern Territory');
INSERT INTO zones VALUES (13,'QLD','Queensland');
INSERT INTO zones VALUES (13,'SA','South Australia');
INSERT INTO zones VALUES (13,'TAS','Tasmania');
INSERT INTO zones VALUES (13,'VIC','Victoria');
INSERT INTO zones VALUES (13,'WA','Western Australia');

#China
INSERT INTO zones VALUES (44,'AN','Anhui');
INSERT INTO zones VALUES (44,'BE','Beijing');
INSERT INTO zones VALUES (44,'CH','Chongqing');
INSERT INTO zones VALUES (44,'FU','Fujian');
INSERT INTO zones VALUES (44,'GA','Gansu');
INSERT INTO zones VALUES (44,'GU','Guangdong');
INSERT INTO zones VALUES (44,'GX','Guangxi');
INSERT INTO zones VALUES (44,'GZ','Guizhou');
INSERT INTO zones VALUES (44,'HA','Hainan');
INSERT INTO zones VALUES (44,'HB','Hebei');
INSERT INTO zones VALUES (44,'HL','Heilongjiang');
INSERT INTO zones VALUES (44,'HE','Henan');
INSERT INTO zones VALUES (44,'HK','Hong Kong');
INSERT INTO zones VALUES (44,'HU','Hubei');
INSERT INTO zones VALUES (44,'HN','Hunan');
INSERT INTO zones VALUES (44,'IM','Inner Mongolia');
INSERT INTO zones VALUES (44,'JI','Jiangsu');
INSERT INTO zones VALUES (44,'JX','Jiangxi');
INSERT INTO zones VALUES (44,'JL','Jilin');
INSERT INTO zones VALUES (44,'LI','Liaoning');
INSERT INTO zones VALUES (44,'MA','Macau');
INSERT INTO zones VALUES (44,'NI','Ningxia');
INSERT INTO zones VALUES (44,'SH','Shaanxi');
INSERT INTO zones VALUES (44,'SA','Shandong');
INSERT INTO zones VALUES (44,'SG','Shanghai');
INSERT INTO zones VALUES (44,'SX','Shanxi');
INSERT INTO zones VALUES (44,'SI','Sichuan');
INSERT INTO zones VALUES (44,'TI','Tianjin');
INSERT INTO zones VALUES (44,'XI','Xinjiang');
INSERT INTO zones VALUES (44,'YU','Yunnan');
INSERT INTO zones VALUES (44,'ZH','Zhejiang');

#India
INSERT INTO zones VALUES (99,'AN','Andaman and Nicobar Islands');
INSERT INTO zones VALUES (99,'AP','Andhra Pradesh');
INSERT INTO zones VALUES (99,'AR','Arunachal Pradesh');
INSERT INTO zones VALUES (99,'AS','Assam');
INSERT INTO zones VALUES (99,'BI','Bihar');
INSERT INTO zones VALUES (99,'CH','Chandigarh');
INSERT INTO zones VALUES (99,'DA','Dadra and Nagar Haveli');
INSERT INTO zones VALUES (99,'DM','Daman and Diu');
INSERT INTO zones VALUES (99,'DE','Delhi');
INSERT INTO zones VALUES (99,'GO','Goa');
INSERT INTO zones VALUES (99,'GU','Gujarat');
INSERT INTO zones VALUES (99,'HA','Haryana');
INSERT INTO zones VALUES (99,'HP','Himachal Pradesh');
INSERT INTO zones VALUES (99,'JA','Jammu and Kashmir');
INSERT INTO zones VALUES (99,'KA','Karnataka');
INSERT INTO zones VALUES (99,'KE','Kerala');
INSERT INTO zones VALUES (99,'LI','Lakshadweep Islands');
INSERT INTO zones VALUES (99,'MP','Madhya Pradesh');
INSERT INTO zones VALUES (99,'MA','Maharashtra');
INSERT INTO zones VALUES (99,'MN','Manipur');
INSERT INTO zones VALUES (99,'ME','Meghalaya');
INSERT INTO zones VALUES (99,'MI','Mizoram');
INSERT INTO zones VALUES (99,'NA','Nagaland');
INSERT INTO zones VALUES (99,'OR','Orissa');
INSERT INTO zones VALUES (99,'PO','Pondicherry');
INSERT INTO zones VALUES (99,'PU','Punjab');
INSERT INTO zones VALUES (99,'RA','Rajasthan');
INSERT INTO zones VALUES (99,'SI','Sikkim');
INSERT INTO zones VALUES (99,'TN','Tamil Nadu');
INSERT INTO zones VALUES (99,'TR','Tripura');
INSERT INTO zones VALUES (99,'UP','Uttar Pradesh');
INSERT INTO zones VALUES (99,'WB','West Bengal');

#Netherlands
INSERT INTO zones VALUES (150,'DR','Drenthe');
INSERT INTO zones VALUES (150,'FL','Flevoland');
INSERT INTO zones VALUES (150,'FR','Friesland');
INSERT INTO zones VALUES (150,'GE','Gelderland');
INSERT INTO zones VALUES (150,'GR','Groningen');
INSERT INTO zones VALUES (150,'LI','Limburg');
INSERT INTO zones VALUES (150,'NB','Noord Brabant');
INSERT INTO zones VALUES (150,'NH','Noord Holland');
INSERT INTO zones VALUES (150,'OV','Overijssel');
INSERT INTO zones VALUES (150,'UT','Utrecht');
INSERT INTO zones VALUES (150,'ZE','Zeeland');
INSERT INTO zones VALUES (150,'ZH','Zuid Holland');

#Greece
INSERT INTO zones VALUES (84,'AT','Attica');
INSERT INTO zones VALUES (84,'CN','Central Greece');
INSERT INTO zones VALUES (84,'CM','Central Macedonia');
INSERT INTO zones VALUES (84,'CR','Crete');
INSERT INTO zones VALUES (84,'EM','East Macedonia and Thrace');
INSERT INTO zones VALUES (84,'EP','Epirus');
INSERT INTO zones VALUES (84,'II','Ionian Islands');
INSERT INTO zones VALUES (84,'NA','North Aegean');
INSERT INTO zones VALUES (84,'PP','Peloponnesos');
INSERT INTO zones VALUES (84,'SA','South Aegean');
INSERT INTO zones VALUES (84,'TH','Thessaly');
INSERT INTO zones VALUES (84,'WG','West Greece');
INSERT INTO zones VALUES (84,'WM','West Macedonia');

#Turkey
INSERT INTO zones VALUES (215,'ADA','Adana');
INSERT INTO zones VALUES (215,'ADI','Adiyaman');
INSERT INTO zones VALUES (215,'AFY','Afyonkarahisar');
INSERT INTO zones VALUES (215,'AGR','Agri');
INSERT INTO zones VALUES (215,'AKS','Aksaray');
INSERT INTO zones VALUES (215,'AMA','Amasya');
INSERT INTO zones VALUES (215,'ANK','Ankara');
INSERT INTO zones VALUES (215,'ANT','Antalya');
INSERT INTO zones VALUES (215,'ARD','Ardahan');
INSERT INTO zones VALUES (215,'ART','Artvin');
INSERT INTO zones VALUES (215,'AYI','Aydin');
INSERT INTO zones VALUES (215,'BAL','Balikesir');
INSERT INTO zones VALUES (215,'BAR','Bartin');
INSERT INTO zones VALUES (215,'BAT','Batman');
INSERT INTO zones VALUES (215,'BAY','Bayburt');
INSERT INTO zones VALUES (215,'BIL','Bilecik');
INSERT INTO zones VALUES (215,'BIN','Bingol');
INSERT INTO zones VALUES (215,'BIT','Bitlis');
INSERT INTO zones VALUES (215,'BOL','Bolu');
INSERT INTO zones VALUES (215,'BRD','Burdur');
INSERT INTO zones VALUES (215,'BRS','Bursa');
INSERT INTO zones VALUES (215,'CKL','Canakkale');
INSERT INTO zones VALUES (215,'CKR','Cankiri');
INSERT INTO zones VALUES (215,'COR','Corum');
INSERT INTO zones VALUES (215,'DEN','Denizli');
INSERT INTO zones VALUES (215,'DIY','Diyarbakir');
INSERT INTO zones VALUES (215,'DUZ','Duzce');
INSERT INTO zones VALUES (215,'EDI','Edirne');
INSERT INTO zones VALUES (215,'ELA','Elazig');
INSERT INTO zones VALUES (215,'EZC','Erzincan');
INSERT INTO zones VALUES (215,'EZR','Erzurum');
INSERT INTO zones VALUES (215,'ESK','Eskisehir');
INSERT INTO zones VALUES (215,'GAZ','Gaziantep');
INSERT INTO zones VALUES (215,'GIR','Giresun');
INSERT INTO zones VALUES (215,'GMS','Gumushane');
INSERT INTO zones VALUES (215,'HKR','Hakkari');
INSERT INTO zones VALUES (215,'HTY','Hatay');
INSERT INTO zones VALUES (215,'IGD','Igdir');
INSERT INTO zones VALUES (215,'ISP','Isparta');
INSERT INTO zones VALUES (215,'IST','Istanbul');
INSERT INTO zones VALUES (215,'IZM','Izmir');
INSERT INTO zones VALUES (215,'KAH','Kahramanmaras');
INSERT INTO zones VALUES (215,'KRB','Karabuk');
INSERT INTO zones VALUES (215,'KRM','Karaman');
INSERT INTO zones VALUES (215,'KRS','Kars');
INSERT INTO zones VALUES (215,'KAS','Kastamonu');
INSERT INTO zones VALUES (215,'KAY','Kayseri');
INSERT INTO zones VALUES (215,'KLS','Kilis');
INSERT INTO zones VALUES (215,'KRK','Kirikkale');
INSERT INTO zones VALUES (215,'KLR','Kirklareli');
INSERT INTO zones VALUES (215,'KRH','Kirsehir');
INSERT INTO zones VALUES (215,'KOC','Kocaeli');
INSERT INTO zones VALUES (215,'KON','Konya');
INSERT INTO zones VALUES (215,'KUT','Kutahya');
INSERT INTO zones VALUES (215,'MAL','Malatya');
INSERT INTO zones VALUES (215,'MAN','Manisa');
INSERT INTO zones VALUES (215,'MAR','Mardin');
INSERT INTO zones VALUES (215,'MER','Mersin');
INSERT INTO zones VALUES (215,'MUG','Mugla');
INSERT INTO zones VALUES (215,'MUS','Mus');
INSERT INTO zones VALUES (215,'NEV','Nevsehir');
INSERT INTO zones VALUES (215,'NIG','Nigde');
INSERT INTO zones VALUES (215,'ORD','Ordu');
INSERT INTO zones VALUES (215,'OSM','Osmaniye');
INSERT INTO zones VALUES (215,'RIZ','Rize');
INSERT INTO zones VALUES (215,'SAK','Sakarya');
INSERT INTO zones VALUES (215,'SAM','Samsun');
INSERT INTO zones VALUES (215,'SAN','Sanliurfa');
INSERT INTO zones VALUES (215,'SII','Siirt');
INSERT INTO zones VALUES (215,'SIN','Sinop');
INSERT INTO zones VALUES (215,'SIR','Sirnak');
INSERT INTO zones VALUES (215,'SIV','Sivas');
INSERT INTO zones VALUES (215,'TEL','Tekirdag');
INSERT INTO zones VALUES (215,'TOK','Tokat');
INSERT INTO zones VALUES (215,'TRA','Trabzon');
INSERT INTO zones VALUES (215,'TUN','Tunceli');
INSERT INTO zones VALUES (215,'USK','Usak');
INSERT INTO zones VALUES (215,'VAN','Van');
INSERT INTO zones VALUES (215,'YAL','Yalova');
INSERT INTO zones VALUES (215,'YOZ','Yozgat');
INSERT INTO zones VALUES (215,'ZON','Zonguldak');

#United Kingdom
INSERT INTO zones VALUES (222, 'ABN', 'Aberdeen');
INSERT INTO zones VALUES (222, 'ABNS', 'Aberdeenshire');
INSERT INTO zones VALUES (222, 'ANG', 'Anglesey');
INSERT INTO zones VALUES (222, 'AGS', 'Angus');
INSERT INTO zones VALUES (222, 'ARY', 'Argyll and Bute');
INSERT INTO zones VALUES (222, 'BEDS', 'Bedfordshire');
INSERT INTO zones VALUES (222, 'BERKS', 'Berkshire');
INSERT INTO zones VALUES (222, 'BLA', 'Blaenau Gwent');
INSERT INTO zones VALUES (222, 'BRI', 'Bridgend');
INSERT INTO zones VALUES (222, 'BSTL', 'Bristol');
INSERT INTO zones VALUES (222, 'BUCKS', 'Buckinghamshire');
INSERT INTO zones VALUES (222, 'CAE', 'Caerphilly');
INSERT INTO zones VALUES (222, 'CAMBS', 'Cambridgeshire');
INSERT INTO zones VALUES (222, 'CDF', 'Cardiff');
INSERT INTO zones VALUES (222, 'CARM', 'Carmarthenshire');
INSERT INTO zones VALUES (222, 'CDGN', 'Ceredigion');
INSERT INTO zones VALUES (222, 'CHES', 'Cheshire');
INSERT INTO zones VALUES (222, 'CLACK', 'Clackmannanshire');
INSERT INTO zones VALUES (222, 'CON', 'Conwy');
INSERT INTO zones VALUES (222, 'CORN', 'Cornwall');
INSERT INTO zones VALUES (222, 'DNBG', 'Denbighshire');
INSERT INTO zones VALUES (222, 'DERBY', 'Derbyshire');
INSERT INTO zones VALUES (222, 'DVN', 'Devon');
INSERT INTO zones VALUES (222, 'DOR', 'Dorset');
INSERT INTO zones VALUES (222, 'DGL', 'Dumfries and Galloway');
INSERT INTO zones VALUES (222, 'DUND', 'Dundee');
INSERT INTO zones VALUES (222, 'DHM', 'Durham');
INSERT INTO zones VALUES (222, 'ARYE', 'East Ayrshire');
INSERT INTO zones VALUES (222, 'DUNBE', 'East Dunbartonshire');
INSERT INTO zones VALUES (222, 'LOTE', 'East Lothian');
INSERT INTO zones VALUES (222, 'RENE', 'East Renfrewshire');
INSERT INTO zones VALUES (222, 'ERYS', 'East Riding of Yorkshire');
INSERT INTO zones VALUES (222, 'SXE', 'East Sussex');
INSERT INTO zones VALUES (222, 'EDIN', 'Edinburgh');
INSERT INTO zones VALUES (222, 'ESX', 'Essex');
INSERT INTO zones VALUES (222, 'FALK', 'Falkirk');
INSERT INTO zones VALUES (222, 'FFE', 'Fife');
INSERT INTO zones VALUES (222, 'FLINT', 'Flintshire');
INSERT INTO zones VALUES (222, 'GLAS', 'Glasgow');
INSERT INTO zones VALUES (222, 'GLOS', 'Gloucestershire');
INSERT INTO zones VALUES (222, 'LDN', 'Greater London');
INSERT INTO zones VALUES (222, 'MCH', 'Greater Manchester');
INSERT INTO zones VALUES (222, 'GDD', 'Gwynedd');
INSERT INTO zones VALUES (222, 'HANTS', 'Hampshire');
INSERT INTO zones VALUES (222, 'HWR', 'Herefordshire');
INSERT INTO zones VALUES (222, 'HERTS', 'Hertfordshire');
INSERT INTO zones VALUES (222, 'HLD', 'Highlands');
INSERT INTO zones VALUES (222, 'IVER', 'Inverclyde');
INSERT INTO zones VALUES (222, 'IOW', 'Isle of Wight');
INSERT INTO zones VALUES (222, 'KNT', 'Kent');
INSERT INTO zones VALUES (222, 'LANCS', 'Lancashire');
INSERT INTO zones VALUES (222, 'LEICS', 'Leicestershire');
INSERT INTO zones VALUES (222, 'LINCS', 'Lincolnshire');
INSERT INTO zones VALUES (222, 'MSY', 'Merseyside');
INSERT INTO zones VALUES (222, 'MERT', 'Merthyr Tydfil');
INSERT INTO zones VALUES (222, 'MLOT', 'Midlothian');
INSERT INTO zones VALUES (222, 'MMOUTH', 'Monmouthshire');
INSERT INTO zones VALUES (222, 'MORAY', 'Moray');
INSERT INTO zones VALUES (222, 'NPRTAL', 'Neath Port Talbot');
INSERT INTO zones VALUES (222, 'NEWPT', 'Newport');
INSERT INTO zones VALUES (222, 'NOR', 'Norfolk');
INSERT INTO zones VALUES (222, 'ARYN', 'North Ayrshire');
INSERT INTO zones VALUES (222, 'LANN', 'North Lanarkshire');
INSERT INTO zones VALUES (222, 'YSN', 'North Yorkshire');
INSERT INTO zones VALUES (222, 'NHM', 'Northamptonshire');
INSERT INTO zones VALUES (222, 'NLD', 'Northumberland');
INSERT INTO zones VALUES (222, 'NOT', 'Nottinghamshire');
INSERT INTO zones VALUES (222, 'ORK', 'Orkney Islands');
INSERT INTO zones VALUES (222, 'OFE', 'Oxfordshire');
INSERT INTO zones VALUES (222, 'PEM', 'Pembrokeshire');
INSERT INTO zones VALUES (222, 'PERTH', 'Perth and Kinross');
INSERT INTO zones VALUES (222, 'PWS', 'Powys');
INSERT INTO zones VALUES (222, 'REN', 'Renfrewshire');
INSERT INTO zones VALUES (222, 'RHON', 'Rhondda Cynon Taff');
INSERT INTO zones VALUES (222, 'RUT', 'Rutland');
INSERT INTO zones VALUES (222, 'BOR', 'Scottish Borders');
INSERT INTO zones VALUES (222, 'SHET', 'Shetland Islands');
INSERT INTO zones VALUES (222, 'SPE', 'Shropshire');
INSERT INTO zones VALUES (222, 'SOM', 'Somerset');
INSERT INTO zones VALUES (222, 'ARYS', 'South Ayrshire');
INSERT INTO zones VALUES (222, 'LANS', 'South Lanarkshire');
INSERT INTO zones VALUES (222, 'YSS', 'South Yorkshire');
INSERT INTO zones VALUES (222, 'SFD', 'Staffordshire');
INSERT INTO zones VALUES (222, 'STIR', 'Stirling');
INSERT INTO zones VALUES (222, 'SFK', 'Suffolk');
INSERT INTO zones VALUES (222, 'SRY', 'Surrey');
INSERT INTO zones VALUES (222, 'SWAN', 'Swansea');
INSERT INTO zones VALUES (222, 'TORF', 'Torfaen');
INSERT INTO zones VALUES (222, 'TWR', 'Tyne and Wear');
INSERT INTO zones VALUES (222, 'VGLAM', 'Vale of Glamorgan');
INSERT INTO zones VALUES (222, 'WARKS', 'Warwickshire');
INSERT INTO zones VALUES (222, 'WDUN', 'West Dunbartonshire');
INSERT INTO zones VALUES (222, 'WLOT', 'West Lothian');
INSERT INTO zones VALUES (222, 'WMD', 'West Midlands');
INSERT INTO zones VALUES (222, 'SXW', 'West Sussex');
INSERT INTO zones VALUES (222, 'YSW', 'West Yorkshire');
INSERT INTO zones VALUES (222, 'WIL', 'Western Isles');
INSERT INTO zones VALUES (222, 'WLT', 'Wiltshire');
INSERT INTO zones VALUES (222, 'WORCS', 'Worcestershire');
INSERT INTO zones VALUES (222, 'WRX', 'Wrexham');

exit;

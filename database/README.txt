KonaKart Database Scripts
=========================

konakart_bootstrap_ms_sdb.sql      
konakart_bootstrap_ms_sdb_cs.sql

konakart_init_ms_sdb.sql
konakart_init_ms_sdb_cs.sql
konakart_init_ms_sdb_cs_ps.sql
konakart_init_ms_sdb_cs_ps_cats.sql
konakart_init_ms_sdb_ps.sql
konakart_init_ms_sdb_ps_cats.sql
-----------------------------------

These bootstrap and init files are used internally by the installer 
when creating "store2" in the various different modes of the Multi-Store 
version.

"ms"   = Multistore
"sdb"  = Single Database
"cs"   = Customers Shared
"ps"   = Products Shared
"cats" = Categories Shared


konakart_demo.sql                  
-----------------

This is probably the most important script of all.  It sets up a Community Edition 
store with the demonstration data.


konakart_empty.sql              
------------------

A script that can be run to empty KonaKart tables.  


konakart_new_store.sql             
konakart_new_store_cs.sql          
konakart_user_new_store.sql        
---------------------------

These are used in Multi-Store mode when creating new stores.   
The konakart_user_new_store.sql is designed for use by customers who
wish to run certain initialisation queries when a new store is 
created.    Configuration variables are used to reference these
particular scripts as they are called from the Admin Engine.


upgrade_n.n.n.n_to_m.m.m.m.sql     
------------------------------

These are the database upgrade scripts that must be executed in 
strict sequence order when upgrading from version n.n.n.n to version
m.m.m.m.



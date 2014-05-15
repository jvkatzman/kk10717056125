@echo off

rem 
rem Set the classpath
rem -----------------
rem

set PP_CLASSPATH=.;..\webapps\konakartadmin\WEB-INF\classes

set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-configuration-1.7.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-logging-1.1.1.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-lang-2.4.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-collections-3.2.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_torque-3.3.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_village-3.3.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_custom_utils.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_utils.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakart\WEB-INF\lib\konakart_app.jar

set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-beanutils-1.8.0.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-dbcp-1.4.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-pool-1.3.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-validator-1.3.1.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\log4j-1.2.12.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\mysql-connector-java-5.1.23-bin.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\ojdbc14.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\postgresql-9.1-901.jdbc4.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\db2jcc.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\db2jcc_license_cu.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jtds-1.2.5.jar

set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\google-api-client-1.1.1-alpha.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\xpp3-1.1.4c.jar

set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_solr.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_multistore.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_google_data.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_publishproducts.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_enterprise.jar

rem These ones below here for SOAP:

set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\xml-apis-2.0.2.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\xercesImpl-2.9.1.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\axis.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jaxrpc.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-discovery-0.2.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\saaj.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\wsdl4j-1.5.1.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\activation.jar
set PP_CLASSPATH=%PP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\mail.jar


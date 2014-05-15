@echo off

rem 
rem Set the classpath
rem -----------------
rem

set IMP_EXP_CLASSPATH=.;..\webapps\konakartadmin\WEB-INF\classes;
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-configuration-1.7.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-logging-1.1.1.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-lang-2.4.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-collections-3.2.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_torque-3.3.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_village-3.3.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_multistore.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_enterprise.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_google_data.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_publishproducts.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_solr.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakartadmin_custom.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_xml_io.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_custom_utils.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\konakart_utils.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-beanutils-1.8.0.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-dbcp-1.4.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-pool-1.3.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-validator-1.3.1.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\log4j-1.2.12.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\mysql-connector-java-5.1.23-bin.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\ojdbc14.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\postgresql-9.1-901.jdbc4.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\db2jcc.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\db2jcc_license_cu.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jtds-1.2.5.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jaxb-api.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jaxb-impl.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jaxrpc.jar

rem These ones below here for SOAP:

set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\xml-apis-2.0.2.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\xercesImpl-2.9.1.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\axis.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\jaxrpc.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\commons-discovery-0.2.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\saaj.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\wsdl4j-1.5.1.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\activation.jar
set IMP_EXP_CLASSPATH=%IMP_EXP_CLASSPATH%;..\webapps\konakartadmin\WEB-INF\lib\mail.jar


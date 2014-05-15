#!/bin/sh

# 
# Set the classpath
# -----------------
#

IMP_EXP_CLASSPATH=.:../webapps/konakartadmin/WEB-INF/classes
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-configuration-1.7.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-logging-1.1.1.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-lang-2.4.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-collections-3.2.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart_torque-3.3.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart_village-3.3.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_multistore.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_enterprise.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_google_data.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_publishproducts.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_custom.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakartadmin_solr.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart_custom_utils.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart_utils.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-beanutils-1.8.0.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-dbcp-1.4.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-pool-1.3.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-validator-1.3.1.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/log4j-1.2.12.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/mysql-connector-java-5.1.23-bin.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/ojdbc14.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/db2jcc.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/db2jcc_license_cu.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/jtds-1.2.5.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/konakart_xml_io.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/jaxb-api.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/jaxb-impl.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/jaxrpc.jar

# These ones below here for SOAP:

IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/xml-apis-2.0.2.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/xercesImpl-2.9.1.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/axis.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/jaxrpc.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/commons-discovery-0.2.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/saaj.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/wsdl4j-1.5.1.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/activation.jar
IMP_EXP_CLASSPATH=${IMP_EXP_CLASSPATH}:../webapps/konakartadmin/WEB-INF/lib/mail.jar

export IMP_EXP_CLASSPATH


#!/bin/sh

# 
# Set the classpath
# -----------------
#

# figure out where the home is - $0 may be a softlink
				
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
        	 
KK_WEBAPPS_HOME=`dirname "$PRG"`/../../webapps/

KKADMIN_CLASSPATH=.:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/classes
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-configuration-1.7.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-logging-1.1.1.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-lang-2.4.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-collections-3.2.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart_torque-3.3.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart_village-3.3.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_multistore.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_enterprise.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_google_data.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_publishproducts.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_custom.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakartadmin_solr.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart_custom_utils.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart_utils.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-beanutils-1.8.0.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-dbcp-1.4.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-pool-1.3.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-validator-1.3.1.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/log4j-1.2.12.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/mysql-connector-java-5.1.23-bin.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/ojdbc14.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/db2jcc.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/db2jcc_license_cu.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/jtds-1.2.5.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/konakart_xml_io.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/jaxb-api.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/jaxb-impl.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/jaxrpc.jar

# These ones below here for SOAP:

KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/xml-apis-2.0.2.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/xercesImpl-2.9.1.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/axis.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/jaxrpc.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/commons-discovery-0.2.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/saaj.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/wsdl4j-1.5.1.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/activation.jar
KKADMIN_CLASSPATH=${KKADMIN_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/mail.jar

export KKADMIN_CLASSPATH
export KK_WEBAPPS_HOME

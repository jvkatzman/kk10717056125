#!/bin/sh

. ./setClasspath.sh

echo "======================================================================================================"
echo "Publish KonaKart Products in Google"
echo "For usage information enter ./PublishProducts.sh ?"
echo "======================================================================================================"

${JAVA_HOME}/bin/java -cp ${PP_CLASSPATH} com.konakartadmin.bl.PublishProducts  $*




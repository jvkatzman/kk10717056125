#!/bin/sh

#
# Add arguments to pass to the utility on the command line
# 
# eg:   -f properties-file-name -k property-name de_DE -p new-value
#
#       Use the argument "-?" to get usage information on the utility.
#

. ../setClasspath.sh

echo "======================================================================================================"
echo "KonaKart Create Password Utility"
echo "======================================================================================================"

${JAVA_HOME}/bin/java -cp ${KKADMIN_CLASSPATH} com.konakartadmin.utils.CreatePassword $@


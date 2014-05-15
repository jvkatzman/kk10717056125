#!/bin/sh

#
# Add arguments to pass to the utility on the command line
# 
# eg:  -rn report-name  -on output-filename
#
#       Use the argument "-?" to get usage information on the utility.
#

. ../setReportsClasspath.sh

echo "======================================================================================================"
echo "KonaKart Run Report Utility"
echo "======================================================================================================"

${JAVA_HOME}/bin/java -cp ${KK_REPORTS_CLASSPATH} com.konakartadmin.utils.RunReport $@


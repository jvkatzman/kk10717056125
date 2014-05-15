#!/bin/sh

#
# Add arguments to pass to the utility on the command line
# 
# eg:   -i ../../logs/KonaKart.log -o KonaKart.html 
#
# NOTE: The arguments used here are just an example.  You can use this utility to analyse the log
# statements created in any KonaKart utility but first you must set the following log flag:
# log4j.logger.org.apache.torque.util.BasePeer = DEBUG
#
#       Use the argument "-?" to get usage information on the utility.
#

. ../setClasspath.sh

echo "======================================================================================================"
echo "Quick Analysis of the API calls in the specified file"
echo "======================================================================================================"

${JAVA_HOME}/bin/java -cp ${KKADMIN_CLASSPATH} com.konakartadmin.utils.ApiAnalysis $@


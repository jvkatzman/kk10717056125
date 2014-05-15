#!/bin/sh
# ===================
#  Shutdown KonaKart
# ===================
				
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
      	 
KK_TOMCAT_BIN=`dirname "$PRG"`

export CATALINA_HOME=${KK_TOMCAT_BIN}/..
export CATALINA_BASE=${KK_TOMCAT_BIN}/..

. ${KK_TOMCAT_BIN}/setJavaHome.sh						

${KK_TOMCAT_BIN}/shutdown.sh
        

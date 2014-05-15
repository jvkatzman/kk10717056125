#!/bin/sh
# ================
#  Start KonaKart
# ================

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

export CATALINA_OPTS="-Xmx512m -Xms256m -XX:PermSize=256m -XX:MaxPermSize=256m -server -Dsolr.solr.home=${CATALINA_HOME}/solr -Djava.awt.headless=true -Dactivemq.store.dir=${CATALINA_HOME}/mq"

# Logging debug options:    
# (Default is debug=false)
# for debugging log4j   add:  -Dlog4j.debug=true
# for debugging kklog4j add:  -Dkk.log4j.debug=true

# To allow changes to logging without restarting:
# (Default is WatchTimeSecs=120)
# to disable the watch thread on log files set -Dkk.log4j.WatchTimeSecs=-1
# to enable  the watch thread on log files set -Dkk.log4j.WatchTimeSecs=60   to check for changes every 60 seconds

. ${KK_TOMCAT_BIN}/setJavaHome.sh

if [ ! -x "${CATALINA_HOME}/temp" ]; then
	mkdir ${CATALINA_HOME}/temp
fi

# These JAVA_OPTS (or similar) can used when running the Java Message Queue Web Console (Enterprise Extensions)
# export JAVA_OPTS="-Dwebconsole.type=properties -Dwebconsole.jms.url=tcp://localhost:8791 -Dwebconsole.jmx.url=service:jmx:rmi:///jndi/rmi://localhost:1099/jmxrmi -Dwebconsole.jmx.user= -Dwebconsole.jmx.password="

${KK_TOMCAT_BIN}/startup.sh

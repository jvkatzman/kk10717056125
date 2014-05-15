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

KK_REPORTS_CLASSPATH=.:${KK_WEBAPPS_HOME}/birtviewer/WEB-INF/classes
KK_REPORTS_CLASSPATH=${KK_REPORTS_CLASSPATH}:${KK_WEBAPPS_HOME}/birtviewer/WEB-INF/lib/*
KK_REPORTS_CLASSPATH=${KK_REPORTS_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/classes
KK_REPORTS_CLASSPATH=${KK_REPORTS_CLASSPATH}:${KK_WEBAPPS_HOME}/konakartadmin/WEB-INF/lib/*

export KK_REPORTS_CLASSPATH

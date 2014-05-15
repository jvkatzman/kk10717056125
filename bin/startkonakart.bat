
rem ================
rem  Start KonaKart
rem ================

set KK_TOMCAT_BIN=%~dp0

set CATALINA_HOME=%KK_TOMCAT_BIN%/..
set CATALINA_BASE=%KK_TOMCAT_BIN%/..

set CATALINA_OPTS=-XX:PermSize=256m -XX:MaxPermSize=256m -Xmx800m -server -Dsolr.solr.home="%CATALINA_HOME%/solr" -Djava.awt.headless=true -Dactivemq.store.dir="%CATALINA_HOME%/mq" 

rem Logging debug options:    
rem (Default is debug=false)
rem for debugging log4j   add:  -Dlog4j.debug=true
rem for debugging kklog4j add:  -Dkk.log4j.debug=true

rem To allow changes to logging without restarting:
rem (Default is WatchTimeSecs=120)
rem to disable the watch thread on log files set  -Dkk.log4j.WatchTimeSecs=-1
rem to enable  the watch thread on log files set  -Dkk.log4j.WatchTimeSecs=60   to check for changes every 60 seconds

call "%KK_TOMCAT_BIN%/setJavaHome.bat"

if not exist "%CATALINA_HOME%/temp" mkdir %CATALINA_HOME%/temp

rem These JAVA_OPTS (or similar) can used when running the Java Message Queue Web Console 
rem set JAVA_OPTS=-Dwebconsole.type=properties -Dwebconsole.jms.url=tcp://localhost:8791 -Dwebconsole.jmx.url=service:jmx:rmi:///jndi/rmi://localhost:1099/jmxrmi -Dwebconsole.jmx.user= -Dwebconsole.jmx.password=

call "%KK_TOMCAT_BIN%/startup.bat"

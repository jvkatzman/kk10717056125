@echo off

rem 
rem Set the classpath
rem -----------------
rem

set KK_WEBAPPS_HOME=%~dp0\..\webapps

set KK_REPORTS_CLASSPATH=.;"%KK_WEBAPPS_HOME%\birtviewer\WEB-INF\classes"
set KK_REPORTS_CLASSPATH=%KK_REPORTS_CLASSPATH%;"%KK_WEBAPPS_HOME%\birtviewer\WEB-INF\lib\*"
set KK_REPORTS_CLASSPATH=%KK_REPORTS_CLASSPATH%;"%KK_WEBAPPS_HOME%\konakartadmin\WEB-INF\classes"
set KK_REPORTS_CLASSPATH=%KK_REPORTS_CLASSPATH%;"%KK_WEBAPPS_HOME%\konakartadmin\WEB-INF\lib\*"


rem ===================
rem  Shutdown KonaKart
rem ===================

set KK_TOMCAT_BIN=%~dp0

set CATALINA_HOME=%KK_TOMCAT_BIN%/..
set CATALINA_BASE=%KK_TOMCAT_BIN%/..

call "%KK_TOMCAT_BIN%/setJavaHome.bat"
								
call "%KK_TOMCAT_BIN%/shutdown.bat"
        

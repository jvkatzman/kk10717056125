@echo off

rem
rem Add arguments to pass to the utility on the command line
rem 
rem eg:   -i ..\..\logs\KonaKart.log -o KonaKart.html 
rem
rem NOTE: The arguments used here are just an example.  You can use this utility to analyse the log
rem statements created in any KonaKart utility but first you must set the following log flag:
rem log4j.logger.org.apache.torque.util.BasePeer = DEBUG
rem
rem       Use the argument "-?" to get usage information on the utility.
rem

call ..\setClasspath.bat

echo ======================================================================================================
echo Quick Analysis of the API calls in the specified file
echo ======================================================================================================

"%JAVA_HOME%/bin/java" -cp %KKADMIN_CLASSPATH% com.konakartadmin.utils.ApiAnalysis %*

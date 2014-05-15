@echo off

rem
rem Add arguments to pass to the utility on the command line
rem 
rem eg: -rn report-name  -on output-filename
rem
rem       Use the argument "-?" to get usage information on the utility.
rem

call ..\setReportsClasspath.bat

echo ======================================================================================================
echo KonaKart Run Report Utility
echo ======================================================================================================

"%JAVA_HOME%/bin/java" -cp %KK_REPORTS_CLASSPATH% com.konakartadmin.utils.RunReport %*

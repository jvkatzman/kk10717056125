@echo off

rem
rem Add arguments to pass to the utility on the command line
rem 
rem eg:   -f properties-file-name -k property-name de_DE -p new-value
rem
rem       Use the argument "-?" to get usage information on the utility.
rem

call ..\setClasspath.bat

echo ======================================================================================================
echo KonaKart Create Password Utility
echo ======================================================================================================

"%JAVA_HOME%/bin/java" -cp %KKADMIN_CLASSPATH% com.konakartadmin.utils.CreatePassword %*
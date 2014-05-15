@echo off

call setClasspath.bat

echo ======================================================================================================
echo Publish KonaKart Products in Google
echo For usage information enter ./PublishProducts.bat ?
echo ======================================================================================================

"%JAVA_HOME%\bin\java" -cp %PP_CLASSPATH% com.konakartadmin.bl.PublishProducts %*




@echo off

rem
rem delete the files created by these commands in case it's being run a second time
rem

if exist konakeystore    del konakeystore
if exist pubkeystore     del pubkeystore
if exist pubcert         del pubcert

rem
rem An example showing how to make the keys required to run the WS-Security Example
rem

echo.
echo Generate a key-pair to use as a certificate/public-key:

%JAVA_HOME%\bin\keytool -keyalg RSA -keysize 1024 -genkey -alias konakey -keystore konakeystore -dname "cn=konakey" -keypass SecretPassword -storepass SecretPassword

echo.
echo Self-sign the certificate (OK for testing only):

%JAVA_HOME%\bin\keytool -selfcert -alias konakey -keystore konakeystore -keypass SecretPassword -storepass SecretPassword

echo.
echo Export the public key to a certificate file:

%JAVA_HOME%\bin\keytool -export -keystore konakeystore -alias konakey -storepass SecretPassword -file pubcert

echo.
echo The public certificate:

%JAVA_HOME%\bin\keytool -printcert -file pubcert
   
echo.
echo Import the public certificate of the private key into the konakeystore:

%JAVA_HOME%\bin\keytool -import -alias pubcert -file pubcert -keystore pubkeystore -storepass SecretPassword -noprompt
 
echo.
echo konakeystore now contains:

%JAVA_HOME%\bin\keytool -list -keystore konakeystore -storepass SecretPassword

echo.
echo pubkeystore now contains:

%JAVA_HOME%\bin\keytool -list -keystore pubkeystore -storepass SecretPassword

echo.

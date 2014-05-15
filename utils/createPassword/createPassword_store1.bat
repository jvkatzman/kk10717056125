@echo off

rem
rem An example of using the CreatePassword Utility.
rem 
rem This creates an encrypted password for the store1 database connection.
rem
rem This is just an example;  you will need to modify this to suit your environment.
rem

rem If you don't specify the -p parameter the current password is encrypted
call createPassword.bat -f ..\..\webapps\konakart\WEB-INF\classes\konakart.properties           -k torque.dsfactory.store1.connection.password 
call createPassword.bat -f ..\..\webapps\konakartadmin\WEB-INF\classes\konakartadmin.properties -k torque.dsfactory.store1.connection.password 

rem You can specify a new value by using the -p parameter
rem call createPassword.bat -f ..\..\webapps\konakart\WEB-INF\classes\konakart.properties           -k torque.dsfactory.store1.connection.password -p prince 
rem call createPassword.bat -f ..\..\webapps\konakartadmin\WEB-INF\classes\konakartadmin.properties -k torque.dsfactory.store1.connection.password -p prince 


@echo off

rem
rem An example of using the kkMessages Utility.
rem 
rem This loads the default Messages files and assumes these are for en_GB.
rem
rem This is just an example;  you will need to modify this to suit your environment.
rem

rem Start by listing the languages
call kkMessages.bat -ll

rem Load the Messages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakart\WEB-INF\classes\Messages.properties -l en_GB -t 1 -u admin@konakart.com -p princess 

rem Load the AdminMessages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminMessages.properties -l en_GB -t 2 -u admin@konakart.com -p princess 

rem Load the AdminHelpMessages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminHelpMessages.properties -l en_GB -t 3 -u admin@konakart.com -p princess 


@echo off

rem
rem An example of using the kkMessages Utility.
rem 
rem This loads the default Messages files and assumes these are for en_GB, pt_BR, de_DE and es_ES.
rem
rem This is just an example;  you will need to modify this to suit your environment.
rem

rem Start by listing the languages
call kkMessages.bat -ll

echo ======================================================================================================
echo KonaKart Messages For en_GB
echo ======================================================================================================

rem Load the Messages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakart\WEB-INF\classes\Messages.properties -l en_GB -t 1 -u admin@konakart.com -p princess 

rem Load the AdminMessages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminMessages.properties -l en_GB -t 2 -u admin@konakart.com -p princess 

rem Load the AdminHelpMessages.properties file and assume this is for en_GB
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminHelpMessages.properties -l en_GB -t 3 -u admin@konakart.com -p princess 

echo ======================================================================================================
echo KonaKart Messages For de_DE
echo ======================================================================================================

rem Load the Messages.properties file and assume this is for de_DE
call kkMessages.bat -i ..\..\webapps\konakart\WEB-INF\classes\Messages_de.properties -l de_DE -t 1 -u admin@konakart.com -p princess 

rem Load the AdminMessages.properties file and assume this is for de_DE
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminMessages_de.properties -l de_DE -t 2 -u admin@konakart.com -p princess 

rem Load the AdminHelpMessages.properties file and assume this is for de_DE
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminHelpMessages_de.properties -l de_DE -t 3 -u admin@konakart.com -p princess 

echo ======================================================================================================
echo KonaKart Messages For pt_BR
echo ======================================================================================================

rem Load the Messages.properties file and assume this is for pt_BR
call kkMessages.bat -i ..\..\webapps\konakart\WEB-INF\classes\Messages_pt.properties -l pt_BR -t 1 -u admin@konakart.com -p princess 

rem Load the AdminMessages.properties file and assume this is for pt_BR
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminMessages_pt.properties -l pt_BR -t 2 -u admin@konakart.com -p princess 

rem Load the AdminHelpMessages.properties file and assume this is for pt_BR
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminHelpMessages_pt.properties -l pt_BR -t 3 -u admin@konakart.com -p princess 

echo ======================================================================================================
echo KonaKart Messages For es_ES
echo ======================================================================================================

rem Load the Messages.properties file and assume this is for es_ES
call kkMessages.bat -i ..\..\webapps\konakart\WEB-INF\classes\Messages_es.properties -l es_ES -t 1 -u admin@konakart.com -p princess 

rem Load the AdminMessages.properties file and assume this is for es_ES
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminMessages_es.properties -l es_ES -t 2 -u admin@konakart.com -p princess 

rem Load the AdminHelpMessages.properties file and assume this is for es_ES
call kkMessages.bat -i ..\..\webapps\konakartadmin\WEB-INF\classes\AdminHelpMessages_es.properties -l es_ES -t 3 -u admin@konakart.com -p princess 


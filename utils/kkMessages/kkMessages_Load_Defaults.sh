#!/bin/sh

#
# An example of using the kkMessages Utility.
# 
# This loads the default Messages files and assumes these are for en_GB.
#
# This is just an example;  you will need to modify this to suit your environment.
#

# Start by listing the languages
./kkMessages.sh -ll

echo "======================================================================================================"
echo "KonaKart Messages for en_GB"
echo "======================================================================================================"

# Load the Messages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakart/WEB-INF/classes/Messages.properties -l en_GB -t 1 -u admin@konakart.com -p princess 

# Load the AdminMessages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminMessages.properties -l en_GB -t 2 -u admin@konakart.com -p princess 

# Load the AdminHelpMessages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminHelpMessages.properties -l en_GB -t 3 -u admin@konakart.com -p princess 

echo "======================================================================================================"
echo "KonaKart Messages for de_DE"
echo "======================================================================================================"

# Load the Messages.properties file and assume this is for de_DE
./kkMessages.sh -i ../../webapps/konakart/WEB-INF/classes/Messages_de.properties -l de_DE -t 1 -u admin@konakart.com -p princess 

# Load the AdminMessages.properties file and assume this is for de_DE
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminMessages_de.properties -l de_DE -t 2 -u admin@konakart.com -p princess 

# Load the AdminHelpMessages.properties file and assume this is for de_DE
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminHelpMessages_de.properties -l de_DE -t 3 -u admin@konakart.com -p princess 

echo "======================================================================================================"
echo "KonaKart Messages for pt_BR"
echo "======================================================================================================"

# Load the Messages.properties file and assume this is for pt_BR
./kkMessages.sh -i ../../webapps/konakart/WEB-INF/classes/Messages_pt.properties -l pt_BR -t 1 -u admin@konakart.com -p princess 

# Load the AdminMessages.properties file and assume this is for pt_BR
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminMessages_pt.properties -l pt_BR -t 2 -u admin@konakart.com -p princess 

# Load the AdminHelpMessages.properties file and assume this is for pt_BR
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminHelpMessages_pt.properties -l pt_BR -t 3 -u admin@konakart.com -p princess 

echo "======================================================================================================"
echo "KonaKart Messages for es_ES"
echo "======================================================================================================"

# Load the Messages.properties file and assume this is for es_ES
./kkMessages.sh -i ../../webapps/konakart/WEB-INF/classes/Messages_es.properties -l es_ES -t 1 -u admin@konakart.com -p princess 

# Load the AdminMessages.properties file and assume this is for es_ES
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminMessages_es.properties -l es_ES -t 2 -u admin@konakart.com -p princess 

# Load the AdminHelpMessages.properties file and assume this is for es_ES
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminHelpMessages_es.properties -l es_ES -t 3 -u admin@konakart.com -p princess 


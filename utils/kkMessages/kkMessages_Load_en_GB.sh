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

# Load the Messages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakart/WEB-INF/classes/Messages.properties -l en_GB -t 1 -u admin@konakart.com -p princess 

# Load the AdminMessages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminMessages.properties -l en_GB -t 2 -u admin@konakart.com -p princess 

# Load the AdminHelpMessages.properties file and assume this is for en_GB
./kkMessages.sh -i ../../webapps/konakartadmin/WEB-INF/classes/AdminHelpMessages.properties -l en_GB -t 3 -u admin@konakart.com -p princess 


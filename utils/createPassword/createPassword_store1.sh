#!/bin/sh

#
# An example of using the CreatePassword Utility.
# 
# This creates an encrypted password for the store1 database connection.
#
# This is just an example;  you will need to modify this to suit your environment.
#

# If you don't specify the -p parameter the current password is encrypted
./createPassword.sh -f ../../webapps/konakart/WEB-INF/classes/konakart.properties           -k torque.dsfactory.store1.connection.password 
./createPassword.sh -f ../../webapps/konakartadmin/WEB-INF/classes/konakartadmin.properties -k torque.dsfactory.store1.connection.password 

# You can specify a new value by using the -p parameter
#./createPassword.sh -f ../../webapps/konakart/WEB-INF/classes/konakart.properties           -k torque.dsfactory.store1.connection.password -p prince 
#./createPassword.sh -f ../../webapps/konakartadmin/WEB-INF/classes/konakartadmin.properties -k torque.dsfactory.store1.connection.password -p prince 


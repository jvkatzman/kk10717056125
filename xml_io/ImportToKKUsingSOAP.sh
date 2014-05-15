#!/bin/sh

#
# $1 = Engine Mode - 0 (SingleStore),1 (MultiStore MultipleDBs) or 2 (MultiStore Single DB)
# $2 = storeId (use "store1" for single store mode)
# $3 = customers Shared (true or false)
# $4 = products shared (true or false)
# $5 = categories shared (true or false)
# $6 = user - KonaKart Admin user
# $7 = password - KonaKart Admin password
# $8 = root directory
# $9 = web service URL eg: http://localhost:8780/konakartadmin/services/KKWSAdmin
#
# NOTE: The arguments used here are just an example.  You may be able to leave some out and
#       assume default values in your environment.
#       Use the argument "-?" to get usage imformation on the XML_IO utility.
#

. ./setClasspath.sh

echo "======================================================================================================"
echo "Import XML IO data to the KonaKart database using a SOAP web service"
echo "======================================================================================================"

${JAVA_HOME}/bin/java -Xmx512m -cp ${IMP_EXP_CLASSPATH} com.konakart.importer.xml.Xml_io -i -r $8 -soap -m $1 -s $2 -c $3 -ps $4 -cas $5 -usr $6 -pwd $7 -ws $9




@echo off

rem
rem %1 = Engine Mode - 0 (SingleStore),1 (MultiStore MultipleDBs) or 2 (MultiStore Single DB)
rem %2 = storeId (use "store1" for single store mode)
rem %3 = customers Shared (true or false)
rem %4 = products shared (true or false)
rem %5 = categories shared (true or false)
rem %6 = user - KonaKart Admin user
rem %7 = password - KonaKart Admin password
rem %8 = root directory
rem
rem NOTE: The arguments used here are just an example.  You may be able to leave some out and
rem       assume default values in your environment.
rem       Use the argument "-?" to get usage imformation on the XML_IO utility.
rem

call setClasspath.bat

echo ======================================================================================================
echo Import XML IO data to the KonaKart database using the KK Engine
echo ======================================================================================================

"%JAVA_HOME%/bin/java" -Xmx512m -cp %IMP_EXP_CLASSPATH% com.konakart.importer.xml.Xml_io -i -r %8 -m %1 -s %2 -c %3 -ps %4 -cas %5 -usr %6 -pwd %7 

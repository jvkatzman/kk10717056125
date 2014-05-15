KonaKart SQL Analyzer
=====================

This feature was added in v6.0.0.0 of KonaKart.

It is not designed to replace SQL analysis tools that are provided by the 
respective RDBMS vendors since these are far more sophisticated.

This SQL Analysis tool is merely a utility to gain a quick insight into the 
performance of the SQL running in your KonaKart system.

The tool relies on a particular log flag being set (so set this in 
konakart-logging.properties in the classes directory of the webapp required):

log4j.logger.org.apache.torque.util.BasePeer = DEBUG

This log flag will enable SQL statements to be collected in the standard appserver 
log (different name on different platforms and appservers)

Once you have collected some data in your standard log file you can specify it as
an input to the SQL Analyzer utility.

For example:

${KonaKartHome}/utils/sqlAnalyzer/sqlAnalysis.sh     \
	-i ${KonaKartHome}/logs/catalina.out             \
	-o ${KonaKartHome}/logs/KonaKart-sql.html

This produces a simple report in the file specified by the -o (output) parameter.

Any KonaKart log file can be used as input but the SQL logging statements must be
present in their standard format.

Use the argument "-?" to get usage information on the utility.  For example:

C:\Program Files\KonaKart\utils\sqlAnalyzer>sqlAnalysis -?
==================================================================================
Quick Analysis of the SQL statements in the specified file
==================================================================================

Usage: SqlAnalysis
  -i  logFileName           - the file containing the SQL logging
  -o  resultsFileName       - the output file
 [-n  top n statements]     - show the top n sqls (default 10)
 [-s  starting-text]        - start from line starting with this text
 [-e  ending-text]          - end at line starting with this text
 [-?]                       - shows this usage information


 


KonaKart API Analyzer
=====================

This feature was added in v6.1.0.0 of KonaKart.

This tool gives an overview of the performance of the storefront APIs being
used in your system.

This API Analysis tool is designed as a utility to gain a quick insight into the 
performance of the API calls running in your KonaKart system.

The tool relies on a particular log flag being set (so set this in 
konakart-logging.properties in the classes directory of the webapp required):

log4j.logger.com.konakart.bl.KKApiMgr = DEBUG

This log flag will enable API call statistics to be collected in the standard appserver 
log (different name on different platforms and appservers)

Once you have collected some data in your standard log file you can specify it as
an input to the API Analyzer utility.

For example:

${KonaKartHome}/utils/apiAnalyzer/apiAnalysis.sh     \
	-i ${KonaKartHome}/logs/catalina.out             \
	-o ${KonaKartHome}/logs/KonaKart-api.html

This produces a simple report in the file specified by the -o (output) parameter.

Any KonaKart log file can be used as input but the SQL logging statements must be
present in their standard format.

Use the argument "-?" to get usage information on the utility.  For example:

C:\Program Files\KonaKart\utils\apiAnalyzer>apiAnalysis -?
==================================================================================
Quick Analysis of the API calls in the specified file
==================================================================================

Usage: SqlAnalysis
  -i  logFileName           - the file containing the API call logging
  -o  resultsFileName       - the output file
 [-n  top n statements]     - show the top n API calls (default 10)
 [-s  starting-text]        - start from line starting with this text
 [-e  ending-text]          - end at line starting with this text
 [-?]                       - shows this usage information


 


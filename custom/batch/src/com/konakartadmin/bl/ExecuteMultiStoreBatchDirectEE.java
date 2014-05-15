//
// (c) 2006 DS Data Systems UK Ltd, All rights reserved.
//
// DS Data Systems and KonaKart and their respective logos, are 
// trademarks of DS Data Systems UK Ltd. All rights reserved.
//
// The information in this document is the proprietary property of
// DS Data Systems UK Ltd. and is protected by English copyright law,
// the laws of foreign jurisdictions, and international treaties,
// as applicable. No part of this document may be reproduced,
// transmitted, transcribed, transferred, modified, published, or
// translated into any language, in any form or by any means, for
// any purpose other than expressly permitted by DS Data Systems UK Ltd.
// in writing.
//
package com.konakartadmin.bl;

import java.net.URL;
import java.util.StringTokenizer;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionException;

import com.konakart.app.KKException;
import com.konakart.util.KKConstants;
import com.konakart.util.PropertyFileFinder;
import com.konakartadmin.app.AdminEngineConfig;
import com.konakartadmin.app.AdminStore;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.ws.KKAdminEngineMgr;

/**
 * This is a utility for running batch jobs outside the Quartz environment. It uses the execute
 * interface on the KKAdminIf engine. This will call the batch job once for every store found in the
 * multi-store environment.
 */
public class ExecuteMultiStoreBatchDirectEE
{
    /** the log */
    protected static Log log = LogFactory.getLog(ExecuteMultiStoreBatchDirectEE.class);

    /**
     * Failure Code
     */
    public static final int ERROR_EXIT = 1;

    /**
     * Success Code
     */
    public static final int GOOD_EXIT = 0;

    // debug flag
    static boolean debug = false;

    // storeId
    static String storeId = null;

    static final String usage = "Usage: ExecuteBatchDirectEE\n"
            + "     -s   store_id                 - store Id                       \n"
            + "     -c   credentials file name    - credentials file name          \n"
            + "     -xc  execution class          - class to execute               \n"
            + "     -xm  execution method         - method on the class to execute \n"
            + "    [-p   parameter list]          - comma separated parameter list \n"
            + "    [-d]                           - debug (default is off)         \n";

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        String paramList = null;

        // credentials file name
        String credentialsFilename = null;

        // execution class name
        String exeClass = null;

        // execution method name
        String exeMethod = null;

        // parameter list
        String[] params = null;

        if (args == null || args.length < 2)
        {
            System.out.println("Insufficient arguments:\n\n" + usage);
            return;
        }

        for (int a = 0; a < args.length; a++)
        {
            if (args[a].equals("-s"))
            {
                storeId = args[a + 1];
                a++;
            } else if (args[a].equals("-c"))
            {
                credentialsFilename = args[a + 1];
                a++;
            } else if (args[a].equals("-xc"))
            {
                exeClass = args[a + 1];
                a++;
            } else if (args[a].equals("-xm"))
            {
                exeMethod = args[a + 1];
                a++;
            } else if (args[a].equals("-p"))
            {
                paramList = args[a + 1];
                a++;
            } else if (args[a].equals("-d"))
            {
                debug = true;
            } else if (args[a].equals("-?"))
            {
                log.warn(args[a] + "\n" + usage);
                System.exit(GOOD_EXIT);
            } else
            {
                log.warn("Unknown argument: " + args[a] + "\n" + usage);
                System.exit(ERROR_EXIT);
            }
        }

        if (log.isDebugEnabled())
        {
            log.debug("credsFileName        = " + credentialsFilename);
            log.debug("executionClassName   = " + exeClass);
            log.debug("executionMethodName  = " + exeMethod);
        }

        if (credentialsFilename == null)
        {
            if (log.isWarnEnabled())
            {
                log.warn("credentials file not specified");
            }
            System.exit(ERROR_EXIT);
        }

        if (exeClass == null)
        {
            if (log.isWarnEnabled())
            {
                log.warn("executionClassName not specified");
            }
            System.exit(ERROR_EXIT);
        }

        if (exeMethod == null)
        {
            if (log.isWarnEnabled())
            {
                log.warn("executionMethodName not specified");
            }
            System.exit(ERROR_EXIT);
        }

        // populate params with the parameters
        StringTokenizer st = new StringTokenizer(paramList, ",");

        params = new String[st.countTokens()];
        int p = 0;
        // pick out each parameter in turn
        while (st.hasMoreTokens())
        {
            params[p++] = st.nextToken().trim();
        }

        if (log.isDebugEnabled())
        {
            for (p = 0; p < params.length; p++)
            {
                log.debug("Parameter " + p + " = " + params[p]);
            }
        }

        System.exit(execute(credentialsFilename, exeClass, exeMethod, params, storeId));
    }

    /**
     * Execute the batch job outside the Quartz environment
     * 
     * @param credentialsFilename
     * @param exeClass
     * @param exeMethod
     * @param params
     * @param sId
     * 
     * @return an integer representing success or failure
     */
    public static int execute(String credentialsFilename, String exeClass, String exeMethod,
            String[] params, String sId)
    {
        URL credsFileURL = null;

        // Find the properties file which is guaranteed to return the URL of
        // the properties file or throw an exception. It can't send out an error message
        // since Log4j hasn't been initialised yet
        try
        {
            credsFileURL = PropertyFileFinder.findPropertiesURL(credentialsFilename);
        } catch (KKException e)
        {
            if (log.isWarnEnabled())
            {
                log.warn("Problems finding properties file: " + credentialsFilename);
            }
            return (ERROR_EXIT);
        }

        // Now let's read the properties file into our Configuration object
        Configuration conf = null;
        try
        {
            conf = new PropertiesConfiguration(credsFileURL);
        } catch (ConfigurationException CE)
        {
            if (log.isWarnEnabled())
            {
                log.warn("ConfigurationException reading " + credsFileURL + " - " + CE.getMessage());
            }
            return (ERROR_EXIT);
        }

        if (conf.isEmpty())
        {
            if (log.isWarnEnabled())
            {
                log.warn("The configuration file: " + credsFileURL
                    + " does not appear to contain any keys");
            }
            return (ERROR_EXIT);
        }

        // Look for properties that are in the "konakart" namespace.
        Configuration kkSubConf = conf.subset("konakart");
        if (kkSubConf == null || kkSubConf.isEmpty())
        {
            if (log.isWarnEnabled())
            {
                log.warn("The konakart section in the properties file is missing.");
            }
            return (ERROR_EXIT);
        }

        // Read the Configuration parameters from the batch job properties file

        // Check there's a valid mode property
        if (!kkSubConf.containsKey("mode"))
        {
            if (log.isWarnEnabled())
            {
                log.warn("The configuration file: " + credsFileURL
                    + " does not appear to contain the konakart.mode property");
            }
            return (ERROR_EXIT);
        }

        int kkEngineMode = kkSubConf.getInt("mode");

        String kkUser = kkSubConf.getString("user");
        String kkPassword = kkSubConf.getString("password");
        String kkAdminEngineClassName = kkSubConf.getString("adminEngineClass",
                KKAdminEngineMgr.DEFAULT_KKADMIN_ENGINE_CLASS_NAME);
        String kkAxisClientPropertiesFile = kkSubConf.getString("axisClientPropertiesFile",
                KKConstants.KONAKARTADMIN_WS_CLIENT_PROPERTIES_FILE);
        String kkEnginePropertiesFile = kkSubConf.getString("enginePropertiesFile",
                KKConstants.KONAKARTADMIN_PROPERTIES_FILE);
        String kkStoreId = kkSubConf.getString("storeId", KKConstants.KONAKART_DEFAULT_STORE_ID);

        boolean kkSharedCustomers = false;

        if (kkSubConf.containsKey("customersShared"))
        {
            kkSharedCustomers = kkSubConf.getBoolean("customersShared");
        } else
        {
            if (log.isInfoEnabled())
            {
                log.info("The configuration file: " + credsFileURL
                        + " does not appear to contain the konakart.customersShared property so "
                        + "we'll default this to false.");
            }
        }

        boolean kkSharedProducts = false;

        if (kkSubConf.containsKey("productsShared"))
        {
            kkSharedProducts = kkSubConf.getBoolean("productsShared");
        } else
        {
            if (log.isInfoEnabled())
            {
                log.info("The configuration file: " + credsFileURL
                        + " does not appear to contain the konakart.productsShared property so "
                        + "we'll default this to false.");
            }
        }

        boolean kkSharedCategories = false;

        if (kkSubConf.containsKey("categoriesShared"))
        {
            kkSharedCategories = kkSubConf.getBoolean("categoriesShared");
        } else
        {
            if (log.isInfoEnabled())
            {
                log.info("The configuration file: " + credsFileURL
                        + " does not appear to contain the konakart.categoriesShared property so "
                        + "we'll default this to false.");
            }
        }

        // Define the Admin Engine Configuration
        AdminEngineConfig adEngConf = new AdminEngineConfig();
        adEngConf.setMode(kkEngineMode);
        adEngConf.setStoreId(kkStoreId);
        adEngConf.setAxisClientFileName(kkAxisClientPropertiesFile);
        adEngConf.setPropertiesFileName(kkEnginePropertiesFile);
        adEngConf.setCustomersShared(kkSharedCustomers);
        adEngConf.setProductsShared(kkSharedProducts);
        adEngConf.setCategoriesShared(kkSharedCategories);
        KKAdminIf adminEng = null;

        try
        {
            adminEng = getAdminEngine(kkAdminEngineClassName, adEngConf);
        } catch (Exception e)
        {
            e.printStackTrace();
            if (log.isWarnEnabled())
            {
                log.warn("Problem creating an Admin Engine. Exception: " + e.getMessage());
            }
            return (ERROR_EXIT);
        }

        AdminStore[] stores = null;
        try
        {
            stores = adminEng.getStores();
        } catch (KKAdminException e)
        {
            if (log.isWarnEnabled())
            {
                log.warn("Problem getting a list of stores : " + e.getMessage());
            }
            e.printStackTrace();
            return (ERROR_EXIT);
        }

        if (log.isInfoEnabled())
        {
            log.info("Found " + stores.length + " stores to process");
        }

        for (int s = 0; s < stores.length; s++)
        {
            if (stores[s].isDeleted())
            {
                if (log.isInfoEnabled())
                {
                    log.info("Skip store with id " + stores[s].getStoreId()
                            + " because it has been deleted");
                }
                continue;
            }
            if (!stores[s].isEnabled())
            {
                if (log.isInfoEnabled())
                {
                    log.info("Skip store with id " + stores[s].getStoreId()
                            + " because it isn't enabled");
                }
                continue;
            }
            if (stores[s].isUnderMaintenance())
            {
                if (log.isInfoEnabled())
                {
                    log.info("Skip store with id " + stores[s].getStoreId()
                            + " because it is Under Mainteance");
                }
                continue;
            }

            adEngConf.setStoreId(stores[s].getStoreId());
            try
            {
                adminEng = getAdminEngine(kkAdminEngineClassName, adEngConf);
            } catch (Exception e)
            {
                e.printStackTrace();
                if (log.isWarnEnabled())
                {
                    log.warn("Problem creating an Admin Engine. Exception: " + e.getMessage());
                }
                return (ERROR_EXIT);
            }

            if (!kkSharedCustomers && kkEngineMode == AdminEngineConfig.MODE_MULTI_STORE_SHARED_DB)
            {
                kkUser = kkSubConf.getString(stores[s].getStoreId() + ".user");
                kkPassword = kkSubConf.getString(stores[s].getStoreId() + ".password");

                if (log.isInfoEnabled())
                {
                    if (kkUser == null)
                    {
                        log.info("Key konakart." + stores[s].getStoreId()
                                + ".user had a null value in " + credsFileURL.getFile());
                    }
                }
            }

            if (kkUser == null)
            {
                if (log.isWarnEnabled())
                {
                    log.warn("Not executing " + exeMethod + " on " + exeClass
                            + " because no userId is defined for store '" + adEngConf.getStoreId()
                            + "' in " + credentialsFilename);
                }
                continue;
            }

            if (log.isInfoEnabled())
            {
                log.info("Attempt to login to Admin Engine on store '" + adEngConf.getStoreId()
                        + "' with user " + kkUser);
            }

            String sessId = null;
            try
            {
                sessId = login(adminEng, kkUser, kkPassword);
            } catch (Exception e)
            {
                e.printStackTrace();
                if (log.isWarnEnabled())
                {
                    log.warn("Problem logging on to Admin Engine. Exception: " + e.getMessage());
                }
                continue;
            }

            if (log.isInfoEnabled())
            {
                log.info("Now call the execute method on the Admin Engine for "
                        + adEngConf.getStoreId() + " with sessionId = " + sessId);
            }

            // Finally we are ready to execute the job...
            try
            {
                adminEng.execute(sessId, exeClass, exeMethod, params);
            } catch (KKAdminException e)
            {
                if (log.isWarnEnabled())
                {
                    log.warn("Problem executing " + exeMethod + " on " + exeClass + ". Exception: "
                        + e.getMessage());
                }
                return (ERROR_EXIT);
            }

            // logout of the Admin Engine
            try
            {
                logout(adminEng, sessId);
            } catch (Exception e)
            {
                if (log.isWarnEnabled())
                {
                    log.warn("Problem logging out. Exception: " + e.getMessage());
                }
                return (ERROR_EXIT);
            }

            if (log.isInfoEnabled())
            {
                log.info(exeClass + "." + exeMethod + " executed successfully for "
                        + adEngConf.getStoreId());
            }
        }

        return (GOOD_EXIT);
    }

    /**
     * Log in to the Admin Engine and return a session Id
     * 
     * @param adminEng
     *            an Admin Engine
     * @param user
     *            username
     * @param password
     *            password
     * @return a session Id
     * @throws Exception
     * @throws JobExecutionException
     */
    private static String login(KKAdminIf adminEng, String user, String password) throws Exception
    {
        String sessId = null;

        try
        {
            sessId = adminEng.login(user, password);
            if (log.isDebugEnabled())
            {
                log.debug("Logged in " + user + " - got session Id = " + sessId);
            }
        } catch (Exception e)
        {
            String str = "Problem logging in to the Admin Engine (store: " + getStoreId(adminEng)
                    + ") as user " + user + " - " + e.getMessage();
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            throw e;
        }

        if (sessId == null)
        {
            String str = "Problem logging in to the Admin Engine (store: " + getStoreId(adminEng)
                    + ") as user " + user + " - "
                    + " could not get a valid session Id.\nEngine Config:\n"
                    + getEngConfStr(adminEng);
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            throw new Exception(str);
        }

        return sessId;
    }

    private static String getEngConfStr(KKAdminIf adminEng)
    {
        try
        {
            return adminEng.getEngConf().toString();
        } catch (KKAdminException e)
        {
            return "Exception getting EngineConfig: " + e.getMessage();
        }
    }

    /**
     * Get the storeId
     * 
     * @param adminEng
     * @return a String containing the storeId from the AdminEngingeConfig
     */
    private static String getStoreId(KKAdminIf adminEng)
    {
        if (adminEng == null)
        {
            return null;
        }

        AdminEngineConfig adEngConf = null;

        try
        {
            adEngConf = adminEng.getEngConf();
        } catch (KKAdminException e)
        {
            return null;
        }

        if (adEngConf == null)
        {
            return null;
        }

        return adEngConf.getStoreId();
    }

    /**
     * Logout of the Admin Engine
     * 
     * @param adminEng
     *            an Admin Engine
     * @param sessId
     *            a session Id
     * @throws Exception
     */
    private static void logout(KKAdminIf adminEng, String sessId) throws Exception
    {
        try
        {
            adminEng.logout(sessId);
            if (log.isDebugEnabled())
            {
                log.debug("Logged out of session " + sessId);
            }
        } catch (Exception e)
        {
            String str = "Problem logging out of the Admin Engine - " + e.getMessage();
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            throw e;
        }
    }

    private static KKAdminIf getAdminEngine(String kkAdminEngineClassName,
            AdminEngineConfig adEngConf) throws Exception
    {
        try
        {
            if (log.isDebugEnabled())
            {
                log.debug("Create Admin Engine (" + kkAdminEngineClassName
                        + ") with the following Engine Config:\n" + adEngConf.toString());
            }
            KKAdminEngineMgr kkAdminEngMgr = new KKAdminEngineMgr();
            return kkAdminEngMgr.getKKAdminByName(kkAdminEngineClassName, adEngConf);
        } catch (Exception e)
        {
            String str = "Problem creating an Admin Engine called " + kkAdminEngineClassName
                    + " - " + e.getMessage();
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            throw e;
        }
    }
}
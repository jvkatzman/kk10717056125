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

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.konakart.app.KKException;
import com.konakart.util.DateUtils;
import com.konakart.util.KKConstants;
import com.konakart.util.PropertyFileFinder;
import com.konakartadmin.app.AdminEngineConfig;
import com.konakartadmin.app.AdminStore;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.ws.KKAdminEngineMgr;

/**
 * This is a bridge between Quartz Jobs and the KonaKart Batch system which uses the execute
 * interface on the KKAdminIf engine. This will call the batch job once for every store found in the
 * multi-store environment.
 */
public class ExecuteMultiStoreBatchEE implements Job
{
    /** the log */
    protected static Log log = LogFactory.getLog(ExecuteMultiStoreBatchEE.class);

    /**
     * parameter key prefix constant
     */
    protected static final String PARAM_KEY_PREFIX = "param";

    /**
     * Constructor
     */
    public ExecuteMultiStoreBatchEE()
    {
    }

    /**
     * Called by the <code>{@link org.quartz.Scheduler}</code> when a
     * <code>{@link org.quartz.Trigger}</code> fires that is associated with the <code>Job</code>.
     * 
     * @param context
     *            a context for the job in a <code>{@link JobExecutionException}</code> object
     * 
     * @throws JobExecutionException
     *             if there is an exception while executing the job.
     */
    public void execute(JobExecutionContext context) throws JobExecutionException
    {
        // This job simply prints out its job name and the
        // date and time that it is running
        String jobName = context.getJobDetail().getKey().getName();

        if (log.isInfoEnabled())
        {
            log.info("Executing '" + jobName + "'");
        }

        JobDataMap jobData = context.getMergedJobDataMap();

        String credsFileName = jobData.getString("credentialsFile");
        String executionClassName = jobData.getString("executionClass");
        String executionMethodName = jobData.getString("executionMethod");

        if (log.isDebugEnabled())
        {
            log.debug("credsFileName        = " + credsFileName);
            log.debug("executionClassName   = " + executionClassName);
            log.debug("executionMethodName  = " + executionMethodName);
        }

        if (credsFileName == null)
        {
            JobExecutionException jee = new JobExecutionException("credentials file not specified");
            throw jee;
        }

        if (executionClassName == null)
        {
            JobExecutionException jee = new JobExecutionException(
                    "executionClassName not specified");
            throw jee;
        }

        if (executionMethodName == null)
        {
            JobExecutionException jee = new JobExecutionException(
                    "executionMethodName not specified");
            throw jee;
        }

        int paramCount = countParameters(jobData);

        String[] paramArray = new String[paramCount];

        for (int p = 0; p < paramCount; p++)
        {
            String paramKey = PARAM_KEY_PREFIX + p;
            paramArray[p] = jobData.getString(paramKey);

            if (log.isDebugEnabled())
            {
                log.debug("Param" + p + " = " + paramArray[p]);
            }
        }

        // By convention the log file is param0 and the append flag is param1

        if (paramCount >= 2 && paramArray[1].equalsIgnoreCase("true"))
        {
            // Appending the log file
            paramArray[0] += ".log";
        } else if (paramCount >= 2 && paramArray[1].equalsIgnoreCase("false"))
        {
            // Add a timestamp and ".log" to the log file
            paramArray[0] += "_" + DateUtils.getFriendlyFileTimestamp() + ".log";
        }

        if (paramCount >= 1)
        {
            context.put("logFileName", paramArray[0]);
        }

        URL credsFileURL;

        // Find the properties file which is guaranteed to return the URL of
        // the properties file or throw an exception. It can't send out an error message
        // since Log4j hasn't been initialised yet
        try
        {
            credsFileURL = PropertyFileFinder.findPropertiesURL(credsFileName);
        } catch (KKException e)
        {
            String str = "Problems finding properties file: " + credsFileName;
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            JobExecutionException jee = new JobExecutionException(str, e);
            throw jee;
        }

        // Now let's read the properties file into our Configuration object
        Configuration conf = null;
        try
        {
            conf = new PropertiesConfiguration(credsFileURL);
        } catch (ConfigurationException CE)
        {
            String str = "ConfigurationException reading " + credsFileURL + " - " + CE.getMessage();
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            JobExecutionException jee = new JobExecutionException(str, CE);
            throw jee;
        }

        if (conf.isEmpty())
        {
            String str = "The configuration file: " + credsFileURL
                    + " does not appear to contain any keys";
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            JobExecutionException jee = new JobExecutionException(str);
            throw jee;
        }

        // Look for properties that are in the "konakart" namespace.
        Configuration kkSubConf = conf.subset("konakart");
        if (kkSubConf == null || kkSubConf.isEmpty())
        {
            String str = "The konakart section in the properties file is missing.";
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            JobExecutionException jee = new JobExecutionException(str);
            throw jee;
        }

        // Read the Configuration parameters from the batch job properties file

        // Check there's a valid mode property
        if (!kkSubConf.containsKey("mode"))
        {
            String str = "The configuration file: " + credsFileURL
                    + " does not appear to contain the konakart.mode property";
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            JobExecutionException jee = new JobExecutionException(str);
            throw jee;
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
        KKAdminIf adminEng = getAdminEngine(kkAdminEngineClassName, adEngConf);

        AdminStore[] stores = null;
        try
        {
            stores = adminEng.getStores();
        } catch (KKAdminException e)
        {
            String str = "Problem getting a list of stores : " + e.getMessage();
            if (log.isWarnEnabled())
            {
                log.warn(str);
            }
            e.printStackTrace();
            JobExecutionException jee = new JobExecutionException(str, e);
            throw jee;
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
            adminEng = getAdminEngine(kkAdminEngineClassName, adEngConf);

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
                    log.warn("Not executing " + executionMethodName + " on " + executionClassName
                            + " because no userId is defined for store '" + adEngConf.getStoreId()
                            + "' in " + credsFileName);
                }
                continue;
            }

            if (log.isInfoEnabled())
            {
                log.info("Attempt to login to Admin Engine on store '" + adEngConf.getStoreId()
                        + "' with user " + kkUser);
            }

            String sessId;
            try
            {
                sessId = login(adminEng, kkUser, kkPassword);
            } catch (Exception e1)
            {
                // Problem logging in so we skip this store
                if (log.isWarnEnabled())
                {
                    log.warn("Failed to login to Admin Engine on store '" + adEngConf.getStoreId()
                            + "' with user " + kkUser + " - skipping store");
                }
                continue;
            }

            if (log.isInfoEnabled())
            {
                log.info("Now call the execute method on the Admin Engine for "
                        + adEngConf.getStoreId() + " for user " + kkUser + "with sessionId = "
                        + sessId);
            }

            try
            {
                adminEng.execute(sessId, executionClassName, executionMethodName, paramArray);
            } catch (KKAdminException e)
            {
                String str = "Problem executing " + executionMethodName + " on "
                        + executionClassName + ". Exception: " + e.getMessage();
                if (log.isWarnEnabled())
                {
                    log.warn(str);
                }
                e.printStackTrace();
                JobExecutionException jee = new JobExecutionException(str, e);
                throw jee;
            }

            // logout of the Admin Engine
            logout(adminEng, sessId);

            if (log.isInfoEnabled())
            {
                log.info(executionClassName + "." + executionMethodName
                        + " executed successfully for " + adEngConf.getStoreId());
            }
        }

        context.setResult("Job Completed Succesfully");
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
     * @throws JobExecutionException
     */
    protected String login(KKAdminIf adminEng, String user, String password)
            throws JobExecutionException
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
            JobExecutionException jee = new JobExecutionException(str, e);
            throw jee;
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
            JobExecutionException jee = new JobExecutionException(str);
            throw jee;
        }
        return sessId;
    }

    /**
     * @param adminEng
     * @return a String representing the AdminEngineConfig
     */
    protected String getEngConfStr(KKAdminIf adminEng)
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
    protected String getStoreId(KKAdminIf adminEng)
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
     * @throws JobExecutionException
     */
    protected void logout(KKAdminIf adminEng, String sessId) throws JobExecutionException
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
            JobExecutionException jee = new JobExecutionException(str, e);
            throw jee;
        }
    }

    /**
     * @param kkAdminEngineClassName
     * @param adEngConf
     * @return an Admin Engine from the specified class name and instantiated with the specified
     *         AdminEngineConfig.
     * @throws JobExecutionException
     */
    protected KKAdminIf getAdminEngine(String kkAdminEngineClassName, AdminEngineConfig adEngConf)
            throws JobExecutionException
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
            JobExecutionException jee = new JobExecutionException(str, e);
            throw jee;
        }
    }

    /**
     * Count the parameters which are names param0, param1 etc...
     * 
     * @param jobData
     * @return a count of the parameters defined for the job
     */
    protected int countParameters(JobDataMap jobData)
    {
        int paramCount = 0;
        String paramKey = PARAM_KEY_PREFIX + paramCount;

        while (jobData.containsKey(paramKey))
        {
            paramKey = PARAM_KEY_PREFIX + (++paramCount);
        }

        if (log.isDebugEnabled())
        {
            log.debug(paramCount + " parameters declared");
        }
        return paramCount;
    }
}
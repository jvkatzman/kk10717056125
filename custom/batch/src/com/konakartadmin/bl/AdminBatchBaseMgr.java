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

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.torque.TorqueException;
import org.apache.velocity.app.VelocityEngine;

import com.konakart.bl.ConfigConstants;
import com.konakart.util.FileUtils;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminLanguage;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.app.KKConfiguration;
import com.workingdogs.village.DataSetException;

/**
 * The BatchBaseMgr
 */
public class AdminBatchBaseMgr extends AdminBaseMgr
{
    /** the log */
    protected static Log log = LogFactory.getLog(AdminBatchBaseMgr.class);

    /**
     * Creates the name of the log depending on whether it has to be unique or not and appends it to
     * the log file directory.
     * 
     * @param logNameIn
     * @param appendLog
     * @return The name of the log
     * @throws Exception
     * @throws KKAdminException
     * @throws DataSetException
     * @throws TorqueException
     */
    protected String getLogName(String logNameIn, boolean appendLog) throws TorqueException,
            DataSetException, KKAdminException, Exception
    {
        String logName = null;
        if (logNameIn == null)
        {
            return null;
        }
        if (!appendLog)
        {
            logName = logNameIn + "-" + new SimpleDateFormat("yyMMddHHmmss").format(new Date())
                    + ".log";
        } else
        {
            logName = logNameIn + ".log";
        }

        String logFileDirectory = null;
        KKConfiguration conf = getAdminConfigMgr().getConfiguration(
                ConfigConstants.KONAKART_LOG_FILE_DIRECTORY);
        if (conf != null)
        {
            logFileDirectory = conf.getConfigurationValue() + FileUtils.FILE_SEPARATOR;
        } else
        {
            log.warn("The Configuration variable KONAKART_LOG_FILE_DIRECTORY is not set.");
        }
        if (logFileDirectory != null)
        {
            logName = logFileDirectory + logName;
        }

        return logName;
    }

    /**
     * Creates the name of the log depending on whether it has to be unique or not and appends it to
     * the log file directory. This is similar to the above getLogName but it does not append a
     * timestamp or ".log" and it uses the configuration variable BATCH_LOG_DIRECTORY to prefix the
     * name.
     * 
     * @param logNameIn
     * @param appendLog
     * @return The name of the log
     * @throws Exception
     * @throws KKAdminException
     * @throws DataSetException
     * @throws TorqueException
     */
    protected String getBatchLogName(String logNameIn, boolean appendLog) throws TorqueException,
            DataSetException, KKAdminException, Exception
    {
        String logName = null;
        if (logNameIn == null)
        {
            return null;
        }

        logName = logNameIn;

        String logFileDirectory = null;
        KKConfiguration conf = getAdminConfigMgr().getConfiguration(
                KKConstants.CONF_KEY_BATCH_LOG_FILE_DIRECTORY);

        if (conf != null)
        {
            logFileDirectory = conf.getConfigurationValue() + FileUtils.FILE_SEPARATOR;
        } else
        {
            log.warn("The Configuration variable " + KKConstants.CONF_KEY_BATCH_LOG_FILE_DIRECTORY
                    + " is not set.");
        }
        if (logFileDirectory != null)
        {
            // Create the batch log directory if it doesn't already exist

            File batchDir = new File(logFileDirectory);
            if (!batchDir.exists())
            {
                batchDir.mkdirs();
            }

            if (logFileDirectory.endsWith("/") || logFileDirectory.endsWith("\\"))
            {
                logName = logFileDirectory + logName;
            } else
            {
                logName = logFileDirectory + "/" + logName;
            }
        }

        return logName;
    }

    /**
     * Check that the Velocity template is valid
     * 
     * @param templateName
     *            Velocity template name to validate
     * @throws Exception
     */
    protected void validateTemplate(String templateName) throws Exception
    {
        /*
         * Check that template is valid
         */
        AdminLanguage lang = getAdminLanguageMgr().getDefaultLanguage();
        if (lang == null)
        {
            throw new KKAdminException("Cannot find default language in the database");
        }

        VelocityEngine ve = getAdminHtmlMgr().getVelocityEngine();

        getTemplate(ve, KKConstants.CONF_KEY_TEMPLATE_BASE_DIRECTORY,
                templateName + "_" + lang.getCode() + ".vm");
    }

    /**
     * Convert a String to an int, passing in a default value.
     * 
     * @param in
     * @param defValue
     * @param useDefault
     * @return Returns an int
     * @throws KKAdminException
     */
    protected int getInt(String in, int defValue, boolean useDefault) throws KKAdminException
    {
        try
        {
            int ret = Integer.parseInt(in);
            return ret;
        } catch (NumberFormatException e)
        {
            if (useDefault)
            {
                return defValue;
            }
            throw new KKAdminException("The string " + in + " cannot be converted to an int");
        }
    }

    /**
     * Convert a String to a boolean, passing in a default value.
     * 
     * @param in
     * @param defValue
     * @param useDefault
     * @return Returns a boolean
     * @throws KKAdminException
     */
    protected boolean getBoolean(String in, boolean defValue, boolean useDefault)
            throws KKAdminException
    {
        try
        {
            boolean ret = new Boolean(in).booleanValue();
            return ret;
        } catch (NumberFormatException e)
        {
            if (useDefault)
            {
                return defValue;
            }
            throw new KKAdminException("The string " + in + " cannot be converted to a boolean");
        }
    }

    /**
     * Convert a String to an int[]
     * 
     * @param in
     * @return Returns an int[]
     * @throws KKAdminException
     */
    protected int[] getIntArray(String in) throws KKAdminException
    {
        if (in == null)
        {
            return new int[0];
        }

        String[] strArray = in.split("-");
        int[] intArray = new int[strArray.length];
        for (int i = 0; i < strArray.length; i++)
        {
            String str = strArray[i];
            intArray[i] = getInt(str, 0, false);
        }
        return intArray;
    }
}
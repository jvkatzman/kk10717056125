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

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.konakart.util.PropertyFileFinder;
import com.konakart.util.PropertyFileNames;
import com.konakartadmin.app.AdminEngineConfig;
import com.konakartadmin.app.AdminStore;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.blif.AdminStoreIntegrationMgrInterface;

/**
 * Used to provide an integration point when a store is added or changed
 */
public class AdminStoreIntegrationMgr extends AdminBaseMgr implements
        AdminStoreIntegrationMgrInterface
{
    /** the log */
    protected static Log log = LogFactory.getLog(AdminStoreIntegrationMgr.class);

    /** Log file timestamp formatter */
    private SimpleDateFormat logTimestampFormat = null;
    
    /**
     * Constructor
     * 
     * @param eng
     *            KKAdmin engine
     * @throws Exception
     */
    public AdminStoreIntegrationMgr(KKAdminIf eng) throws Exception
    {
        super.init(eng);

        if (log.isDebugEnabled())
        {
            if (eng != null && eng.getEngConf() != null && eng.getEngConf().getStoreId() != null)
            {
                log.debug("AdminStoreIntegrationMgr instantiated for store id = "
                        + eng.getEngConf().getStoreId());
            }
        }
    }

    /**
     * Called whenever a new store is added
     * 
     * @param store
     *            The new store
     */
    public void storeAdded(AdminStore store)
    {
        if (log.isDebugEnabled())
        {
            log.debug("New Store Added:\n" + store.toString());
        }

        // As an example we'll add the new credentials to the konakart_jobs.properties file - it's
        // only relevant in multi-store shared db mode where customers aren't shared

        try
        {
            AdminEngineConfig adEngConf = getAdminEng().getEngConf();

            if (adEngConf.getMode() != AdminEngineConfig.MODE_MULTI_STORE_SHARED_DB
                    || adEngConf.isCustomersShared())
            {
                // Nothing to do if not multi-store shared DB or customers are shared
                return;
            }

            String storeId = store.getStoreId();

            // Locate the konakart_jobs.properties file

            String jobPropsFileName = "konakart_jobs.properties";
            PropertyFileNames pfn = new PropertyFileNames();
            jobPropsFileName = pfn.getFileName(PropertyFileNames.KONAKART_JOBS_PROPERTIES_FILE,
                    jobPropsFileName);
            URL fileURL = PropertyFileFinder.findPropertiesURL(jobPropsFileName);
            jobPropsFileName = fileURL.getFile().replace("%20", " ");

            if (log.isDebugEnabled())
            {
                log.debug("Add credentials to " + jobPropsFileName + " for store " + storeId);
            }

            // Open file for appending some text
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(jobPropsFileName,
                    true)));
            
            // Append the username and the default password

            out.println("# " + logTimeStamp() + " Added by StoreIntegrationMgr");
            out.println("konakart." + storeId + ".user     = " + storeId + "-admin@konakart.com");
            out.println("konakart." + storeId + ".password = princess");
            out.println("");
            out.close();

        } catch (Exception e)
        {
            // Recovery here is difficult...
            log.warn("Problem adding credentials to konakart_jobs.properties for new store ("
                    + store.getStoreId() + ") - " + e.getMessage());
            e.printStackTrace();
        }
    }

    private String logTimeStamp()
    {
        return getLogTimestampFormat().format(new Date());
    }

    private SimpleDateFormat getLogTimestampFormat()
    {
        if (logTimestampFormat == null)
        {
            logTimestampFormat = new SimpleDateFormat("dd-MMM HH:mm.ss");
        }

        return logTimestampFormat;
    }
    
    /**
     * Called whenever a new store is added
     * 
     * @param oldStore
     *            The store object before the change
     * @param newStore
     *            The new store object after the change
     */
    public void storeChanged(AdminStore oldStore, AdminStore newStore)
    {
        if (log.isDebugEnabled())
        {
            log.debug("Store:\n" + oldStore.toString() + "\nChanged To:\n" + newStore.toString());
        }
    }
}

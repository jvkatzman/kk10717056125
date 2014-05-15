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

package com.konakart.servlet;

import java.net.MalformedURLException;
import java.rmi.RemoteException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.konakart.al.KKAppEng;
import com.konakart.app.EngineConfig;
import com.konakart.app.KKException;
import com.konakart.appif.EngineConfigIf;
import com.konakart.bl.KKServletContextListener;
import com.konakart.blif.KKServletContextListenerIf;

/**
 * Instance of KonaKartApp engine started by application server on startup.
 */
public class AppEngServlet extends HttpServlet
{
    /**
     * Serial Version UID
     */
    private static final long serialVersionUID = 1L;

    protected static Log log = LogFactory.getLog(AppEngServlet.class);

    private String propertiesPath = null;

    private String appPropertiesPath = null;

    private int mode = 0;

    private String storeId = null;

    private boolean customersShared = false;

    private boolean productsShared = false;

    private boolean categoriesShared = false;

    private boolean portlet = false;

    /** Default StoreId as defined in the web.xml for the Servlet **/
    private static String defaultStoreId = null;

    /**
     * @throws RemoteException
     * @throws MalformedURLException
     * @throws KKException
     */
    public AppEngServlet() throws RemoteException, MalformedURLException, KKException
    {
        // beware... you cannot access the ServletConfig in this constructor - see init() below
    }

    /**
     * Initialise the servlet.
     * 
     * @param config
     * @throws ServletException
     */
    public void init(ServletConfig config) throws ServletException
    {
        // very important to call super.init() here
        super.init(config);

        if (config != null)
        {
            // Grab the init parameters from the web.xml
            try
            {
                mode = Integer.parseInt(config.getInitParameter("mode"));
            } catch (NumberFormatException e)
            {
                log.error("The mode parameter set in web.xml file for KonaKartAppEngineServlet must be numeric. The value from web.xml is "
                        + config.getInitParameter("mode")
                        + " ,which is invalid. A value of "
                        + mode + " will be used to instantiate the engine");
            }

            storeId = config.getInitParameter("storeId");
            if (storeId == null || storeId.length() == 0)
            {
                storeId = "store1";
                log.error("The storeId parameter set in web.xml file for KonaKartAppEngineServlet must be set. A value of "
                        + storeId + " will be used to instantiate the engine");
            }

            defaultStoreId = config.getInitParameter("defaultStoreId");
            if (defaultStoreId == null || defaultStoreId.length() == 0)
            {
                defaultStoreId = storeId;
                log.error("The defaultStoreId parameter set in web.xml file for KonaKartAppEngineServlet must be set. A value of "
                        + storeId + " will be used to instantiate the engine");
            }

            propertiesPath = config.getInitParameter("propertiesPath");
            if (propertiesPath == null || propertiesPath.length() == 0)
            {
                propertiesPath = "konakart.properties";
                log.error("The propertiesPath parameter set in web.xml file for KonaKartAppEngineServlet must be set. A value of "
                        + propertiesPath + " will be used to instantiate the engine");
            }

            appPropertiesPath = config.getInitParameter("appPropertiesPath");
            if (appPropertiesPath == null || appPropertiesPath.length() == 0)
            {
                appPropertiesPath = "konakart_app.properties";
                log.error("The appPropertiesPath parameter set in web.xml file for KonaKartAppEngineServlet must be set. A value of "
                        + appPropertiesPath + " will be used to instantiate the engine");
            }

            try
            {
                customersShared = Boolean.valueOf(config.getInitParameter("customersShared"));
            } catch (Exception e)
            {
                log.error("The customersShared parameter set in web.xml file for KonaKartAppEngineServlet must be set to true or false. The value from web.xml is "
                        + config.getInitParameter("customersShared")
                        + " ,which is invalid. A value of "
                        + customersShared
                        + " will be used to instantiate the engine");
            }

            try
            {
                productsShared = Boolean.valueOf(config.getInitParameter("productsShared"));
            } catch (Exception e)
            {
                log.error("The productsShared parameter set in web.xml file for KonaKartAppEngineServlet must be set to true or false. The value from web.xml is "
                        + config.getInitParameter("productsShared")
                        + " ,which is invalid. A value of "
                        + productsShared
                        + " will be used to instantiate the engine");
            }
            try
            {
                categoriesShared = Boolean.valueOf(config.getInitParameter("categoriesShared"));
            } catch (Exception e)
            {
                log.error("The categoriesShared parameter set in web.xml file for KonaKartAppEngineServlet must be set to true or false. The value from web.xml is "
                        + config.getInitParameter("categoriesShared")
                        + " ,which is invalid. A value of "
                        + categoriesShared
                        + " will be used to instantiate the engine");
            }
            try
            {
                portlet = Boolean.valueOf(config.getInitParameter("portlet"));
            } catch (Exception e)
            {
            }
            if (log.isDebugEnabled())
            {
                log.debug("mode                = " + mode);
                log.debug("storeId             = " + storeId);
                log.debug("defaultStoreId      = " + defaultStoreId);
                log.debug("propertiesPath      = " + propertiesPath);
                log.debug("appPropertiesPath   = " + appPropertiesPath);
                log.debug("customersShared     = " + customersShared);
                log.debug("productsShared      = " + productsShared);
                log.debug("categoriesShared    = " + categoriesShared);
                log.debug("portlet             = " + portlet);
            }

            if (productsShared && !customersShared)
            {
                log.error("Illegal Mode Specified.  "
                        + "If you specify shared products you must also specify shared customers");
                log.error("Setting customersShared Mode to true - may cause problems");
                customersShared = true;
            }

            if (categoriesShared && !productsShared)
            {
                log.error("Illegal Mode Specified.  "
                        + "If you specify shared categories you must also specify shared products");
                log.error("Setting productsShared Mode to true - may cause problems");
                productsShared = true;
            }

            // Instantiate an EngineConfig object
            EngineConfigIf engConf = new EngineConfig();
            engConf.setPropertiesFileName(propertiesPath);
            engConf.setAppPropertiesFileName(appPropertiesPath);
            engConf.setStoreId(storeId);
            engConf.setCustomersShared(customersShared);
            engConf.setProductsShared(productsShared);
            engConf.setCategoriesShared(categoriesShared);
            engConf.setMode(mode);
            engConf.setAppEngPortlet(portlet);

            try
            {
                KKAppEng eng = new KKAppEng(engConf);
                if (log.isDebugEnabled())
                {
                    log.debug("KKAppEng " + eng.getKkVersion() + " started with this config:\n"
                            + KKAppEng.getEngConf().toString());
                }
            } catch (Exception e)
            {
                log.error(
                        "Exception attempting to start the KonaKart Client Engine from a servlet",
                        e);
            }

        } else
        {
            log.error("Cannot start the KonaKartAppEngineServlet since there are no configuration parameters.");
        }

        if (log.isInfoEnabled())
        {
            String status = "AppEngServlet initialised : mode " + mode;

            if (customersShared)
            {
                status += " CUS-S";
            }

            if (productsShared)
            {
                status += " PRO-S";
            }

            if (categoriesShared)
            {
                status += " CAT-S";
            }

            log.info(status + " for store '" + storeId + "'");
        }

        // Register this thread with KKThreadManager
        try
        {
            KKServletContextListenerIf kkContextListener = KKServletContextListener.get();
            String threadName = this.getServletName() + " - " + getClass().getName();
            if (kkContextListener != null)
            {
                kkContextListener.registerThread(Thread.currentThread(), this.getServletName()
                        + " - " + getClass().getName());
                if (log.isInfoEnabled())
                {
                    log.info("Registered " + threadName + " for shutdown");
                }
            } else
            {
                if (log.isWarnEnabled())
                {
                    log.warn("Thread " + threadName
                            + " not registered for shutdown - no kkContextListener found");
                }
            }
        } catch (Throwable e)
        {
            if (log.isWarnEnabled())
            {
                log.warn("Thread not registered for shutdown - " + e.getMessage());
            }
        }
    }

    /**
     * @return the defaultStoreId
     */
    public static String getDefaultStoreId()
    {
        return defaultStoreId;
    }

    /**
     * @param defaultStoreId
     *            the defaultStoreId to set
     */
    public static void setDefaultStoreId(String defaultStoreId)
    {
        AppEngServlet.defaultStoreId = defaultStoreId;
    }
}

package com.konakartadmin.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.portlet.GenericPortlet;
import javax.portlet.PortletException;
import javax.portlet.PortletSecurityException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.konakart.bl.CustomerMgr;
import com.konakart.util.KKConstants;
import com.konakart.util.PropertyFileFinder;
import com.konakartadmin.app.AdminCountry;
import com.konakartadmin.app.AdminCountrySearch;
import com.konakartadmin.app.AdminCountrySearchResult;
import com.konakartadmin.app.AdminCustomer;
import com.konakartadmin.app.AdminCustomerRegistration;
import com.konakartadmin.app.AdminEngineConfig;
import com.konakartadmin.app.AdminRole;
import com.konakartadmin.app.AdminZone;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.app.KKConfiguration;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.ws.KKAdminEngineMgr;
import com.liferay.portal.kernel.exception.NestableException;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;

/**
 * KonaKart Liferay Admin portlet.<br>
 * <br>
 * Note that the customization made in the AdminLoginIntegrationMgr (so that the admin user can be
 * logged in automatically) overrides credential checking and so if the Admin App is available
 * directly from a URL rather than through Liferay then all security will be disabled. In order to
 * implement tighter security you should use an SSO system and pass a token through to this method
 * so that it can check with the SSO service whether the token is valid.
 */
public class KKAdminPortlet extends GenericPortlet
{
    // log
    private static Log log = LogFactory.getLog(KKAdminPortlet.class);

    // Constants
    private static final String PORTLET_PROPS_FILE = "konakartadmin_portlet.properties";

    private static final String GWT_PROPS_FILE = "konakartadmin_gwt.properties";

    private static final String PROP_SUPER_USER = "super_user";

    private static final String PROP_DEFAULT_STORE = "default_store";

    private static final String PROP_ENGINE_CLASS = "engineclass";

    private static final String PROP_ENGINE_MODE = "mode";

    private static final String PROP_CUSTOMERS_SHARED = "customersShared";

    private static final String PROP_PRODUCTS_SHARED = "productsShared";

    // Global variables
    private String mutex = "KKMutex";

    private String superUserId = null;

    private String defaultStoreId = null;

    private String adminEngClass = null;

    private int engMode = -1;

    private boolean customersShared = false;

    private boolean productsShared = false;

    /**
     * Init() called once by the portal
     * 
     * @throws PortletException
     */
    public void init() throws PortletException
    {
        System.out.println("KKAdminPortlet.init() starting");

        if (log.isDebugEnabled())
        {
            log.debug("KKAdminPortlet.init() starting");
        }

        getProperties();

        if (log.isDebugEnabled())
        {
            log.debug("KKAdminPortlet.init() gotProperties");
        }

        if (log.isDebugEnabled())
        {
            log.debug("defaultStoreId  = " + defaultStoreId);
            log.debug("superUserId     = " + superUserId);
            log.debug("adminEngClass   = " + adminEngClass);
            log.debug("adminEngMode    = " + engMode);
            log.debug("customersShared = " + customersShared);
            log.debug("productsShared  = " + productsShared);
        }
    }

    /**
     * This method actually embeds the GWT code within the portlet. It runs GWT generated javascript
     * with places the Admin App display widgets in the div with id = kkAdmin.
     */
    protected void doView(RenderRequest renderRequest, RenderResponse renderResponse)
            throws PortletException, IOException
    {
        if (log.isDebugEnabled())
        {
            log.debug("KKAdminPortlet.doView() starting");
        }

        UserAndStore uas = null;
        try
        {
            Principal userPrincipal = renderRequest.getUserPrincipal();
            if (userPrincipal == null)
            {
                throw new PortletSecurityException(
                        "Liferay returned a null userPrincipal. This probably means that the user isn't logged in.");
            }
            User user = getUserProfile(userPrincipal.getName());
            if (user == null)
            {
                throw new PortletSecurityException(
                        "Liferay returned a null user object from input of "
                                + userPrincipal.getName());
            }
            if (user.getEmailAddress() == null || user.getEmailAddress().length() == 0)
            {
                throw new KKAdminException("The Liferay user with id = " + user.getUserId()
                        + " and name = " + user.getFullName() + ", does not have an eMail address");
            }
            List<Role> roles = RoleLocalServiceUtil.getUserRoles(user.getUserId());
            if (roles == null || roles.size() == 0)
            {
                throw new PortletSecurityException("The user with id = " + user.getUserId()
                        + " and name = " + user.getFullName() + ", has no roles.");
            }

            /*
             * Get the KK User and KK Store by passing in the liferay user and liferay roles
             */
            uas = getKKUserAndStore(user, roles);

            if (log.isDebugEnabled())
            {
                log.debug("userPrincipal.getName = " + userPrincipal.getName());
                log.debug("user.getFullName      = " + user.getFullName());
                log.debug("user.getEmailAddress  = " + user.getEmailAddress());
                log.debug("user.getUserId        = " + user.getUserId());
                log.debug("KK UserName           = " + uas.getKkUserName());
                log.debug("KK StoreId            = " + uas.getStoreId());
            }

        } catch (PortletSecurityException pse)
        {
            throw pse;
        } catch (Exception e)
        {
            throw new PortletException(e);
        }

        renderResponse.setContentType("text/html");
        PrintWriter writer = renderResponse.getWriter();

        // k
        writer.println("<link rel='stylesheet' href='" + renderRequest.getContextPath()
                + "/KonakartAdmin.css'>");

        // GWT code
        writer.println("<div id='kkAdmin'></div>");
        writer.println("<script language='javascript' src='" + renderRequest.getContextPath()
                + "/konakartadmin.nocache.7.1.1.1.10247.js'></script>");
        writer.println("<iframe id='__gwt_historyFrame' style='width:0;height:0;border:0'></iframe>");
        writer.println("<iframe id='__printingFrame' style='width:0;height:0;border:0'></iframe>");

        // PortletURL url = renderResponse.createRenderURL();
        // writer.println("<a href=\"" + url.toString() + "\">Click here to start</a>");

        // Form for user info
        writer.println("<form id=\"kkUserForm\" action=\"http://somesite.com/prog/adduser\" method=\"post\">");
        writer.println("<input type=\"hidden\" name=\"user\" value=\"" + uas.getKkUserName()
                + "\"/>");
        writer.println("<input type=\"hidden\" name=\"store\" value=\"" + uas.getStoreId() + "\">");
        writer.println("</form>");

        writer.close();
    }

    /**
     * From the Liferay user and roles we create a KK user for a particular store, the id of which
     * is encoded within the Liferay roles.
     * 
     * @param user
     * @param roles
     * @return
     * @throws KKAdminException
     */
    private UserAndStore getKKUserAndStore(User user, List<Role> roles) throws Exception
    {
        /*
         * Get the KK roles matching the liferay roles and the store id. AN admin engine is also
         * returned for the correct store.
         */
        RolesAndStore ras = getKonaKartRolesAndStore(roles);

        /*
         * See whether this user already exists and delete the user if he exists. We always delete
         * and re-register the user just in case the user's roles have changed. We need to
         * synchronize this bit of code since Liferay often makes two overlapping calls to the
         * portlet when it is first dragged on to the portal.
         */
        synchronized (mutex)
        {
            AdminCustomer cust = ras.getKkAdminEng().getCustomerForEmail(ras.getSessionId(),
                    user.getEmailAddress());
            if (cust != null)
            {
                ras.getKkAdminEng().deleteCustomer(ras.getSessionId(), cust.getId());
            }

            // Register the user
            AdminCustomerRegistration custReg = getCustomerRegistration(ras.getKkAdminEng(),
                    ras.getSessionId(), user);

            int userId = ras.getKkAdminEng().registerCustomer(ras.getSessionId(), custReg);

            // Add roles to the user
            AdminRole[] roleArray = new AdminRole[ras.getKkRoles().size()];
            int i = 0;
            for (Iterator<AdminRole> iterator = ras.getKkRoles().iterator(); iterator.hasNext();)
            {
                AdminRole role = iterator.next();
                roleArray[i] = role;
                i++;
            }
            ras.getKkAdminEng().addRolesToUser(ras.getSessionId(), roleArray, userId);

            // Create the return object
            UserAndStore uas = new UserAndStore();
            uas.setStoreId(ras.getStoreId());
            uas.setKkUserName(user.getEmailAddress());
            return uas;
        }
    }

    /**
     * Return a customer registration object
     * 
     * @return Return a customer registration object
     * @throws KKAdminException
     */
    private AdminCustomerRegistration getCustomerRegistration(KKAdminIf kkAdminEng, String sessionId, User user)
            throws KKAdminException
    {
        AdminCountrySearch countrySearch = new AdminCountrySearch();
        countrySearch.setOnlyActiveCountries(true);

        // Use the StoreCountry for the new user's Country
        KKConfiguration storeCountryConf = kkAdminEng.getConfigurationByKey(sessionId, KKConstants.CONF_KEY_STORE_COUNTRY);       
        if (storeCountryConf != null)
        {
            String storeCountryStr = storeCountryConf.getConfigurationValue();
            try
            {
                countrySearch.setId(Integer.parseInt(storeCountryStr));
            } catch (NumberFormatException e)
            {
                // Unexpected
                e.printStackTrace();
            }
        }

        AdminCountrySearchResult countries = kkAdminEng.getCountries(countrySearch, 0, 1);
        if (countries.getCountries() == null || countries.getCountries().length == 0)
        {
            throw new KKAdminException("Unable to find any countries in the KonaKart database");
        }
        AdminCountry country = countries.getCountries()[0];

        String state = "x";
        AdminZone[] zones = kkAdminEng.getZonesById(country.getId());
        if (zones != null && zones.length > 0)
        {
            state = zones[0].getZoneCode();
        }

        AdminCustomerRegistration custReg = new AdminCustomerRegistration();

        custReg.setFirstName(user.getFirstName());
        custReg.setLastName(user.getLastName());
        custReg.setEmailAddr(user.getEmailAddress());
        custReg.setBirthDate((user.getBirthday() == null) ? new Date() : user.getBirthday());

        custReg.setStreetAddress("1 High Street");
        custReg.setCity("Large City");
        custReg.setState(state);
        custReg.setPostcode("ZIP CODE");
        custReg.setCountryId(country.getId());
        custReg.setEnabled(1);
        
        if (user.isMale())
        {
            custReg.setGender("m");
        } else
        {
            custReg.setGender("f");
        }
        custReg.setPassword("password"); // not used
        custReg.setTelephoneNumber("123456");
        custReg.setTelephoneNumber1("4567890");
        custReg.setType(CustomerMgr.CUST_TYPE_ADMIN_USER);

        return custReg;
    }

    /**
     * Compares the Liferay roles with the KK roles and attempts to match them.
     * 
     * @param roles
     * @return Returns an object containing a list of KK roles and the store id
     * @throws KKAdminException
     */
    private RolesAndStore getKonaKartRolesAndStore(List<Role> roles) throws Exception
    {
        String storeId = null;
        HashMap<String, String> roleHM = new HashMap<String, String>();

        /*
         * Put the liferay roles in a hash map. While iterating through the roles, save the store id
         * and ensure that if there are multiple roles, then they all have the same storeId. The
         * liferay roles are encoded like role_storeId.
         */
        for (Iterator<Role> iterator = roles.iterator(); iterator.hasNext();)
        {
            Role role = iterator.next();
            if (role.getName() != null)
            {
                String[] roleStore = role.getName().split("_");
                String roleStr = roleStore[0];
                String storeStr = null;
                if (roleStore.length > 1)
                {
                    storeStr = roleStore[1];
                }
                if (log.isDebugEnabled())
                {
                    log.debug("roleStr  = " + roleStr);
                    log.debug("storeStr = " + storeStr);
                }
                roleHM.put(roleStr, "");
                if (storeStr != null)
                {
                    if (storeId == null)
                    {
                        storeId = storeStr;
                    } else
                    {
                        if (!storeId.equals(storeStr))
                        {
                            throw new KKAdminException(
                                    "The Liferay roles for a user contain different KonaKart store ids : "
                                            + storeId + " and " + storeStr);
                        }
                    }
                }
            }
        }

        /*
         * Now that we have the store id we can create an Admin engine for that store and logging in
         * as a super user so that we can register this customer.
         */
        KKAdminIf kkAdminEng = null;
        if (storeId == null)
        {
            kkAdminEng = getSuperUserEng(defaultStoreId);
        } else
        {
            kkAdminEng = getSuperUserEng(storeId);
        }

        // log into the engine
        String sessionId = kkAdminEng.login(superUserId, "password");
        if (sessionId == null)
        {
            throw new KKAdminException("Unable to log into the KonaKart Admin Eng for store "
                    + ((storeId == null) ? defaultStoreId : storeId) + " with the SuperUser = "
                    + superUserId);
        }

        // Get kk roles for this store
        AdminRole[] kkRoles = kkAdminEng.getAllRoles(sessionId);
        if (kkRoles == null || kkRoles.length == 0)
        {
            throw new PortletSecurityException("No KonaKart roles were found for the store "
                    + storeId);
        }

        /*
         * Loop through the KK roles and look at the custom1 field to match the name of the Liferay
         * role.
         */
        boolean isSuperUser = false;
        List<AdminRole> retList = new ArrayList<AdminRole>();
        for (int i = 0; i < kkRoles.length; i++)
        {
            AdminRole kkRole = kkRoles[i];
            if (kkRole.getCustom1() != null)
            {
                if (roleHM.get(kkRole.getCustom1()) != null)
                {
                    retList.add(kkRole);
                    if (kkRole.isSuperUser())
                    {
                        isSuperUser = true;
                    }
                }
            }
        }

        // Check that at least one role matched
        if (retList.size() == 0)
        {
            StringBuffer sb = new StringBuffer();
            sb.append("No match between the Liferay roles and the KonaKart roles for store "
                    + storeId + " :\n");
            sb.append("Liferay roles:\n");
            for (Iterator<Role> iterator = roles.iterator(); iterator.hasNext();)
            {
                Role role = iterator.next();
                sb.append("\t" + role.getName() + "\n");
            }
            sb.append("Konakart roles:\n");
            for (int i = 0; i < kkRoles.length; i++)
            {
                AdminRole kkRole = kkRoles[i];
                sb.append("\t" + kkRole.getCustom1() + "\n");
            }
            throw new PortletSecurityException(sb.toString());
        }

        /*
         * Check that we have a store id if none of the KK roles are super user roles. If it is a
         * super user role then we use the default store id from the properties file.
         */
        if (storeId == null && !isSuperUser)
        {
            StringBuffer sb = new StringBuffer();
            sb.append("No store information could be found in the Liferay roles. "
                    + "A store must be defined unless the user is a super user.\n");
            sb.append("Liferay roles:\n");
            for (Iterator<Role> iterator = roles.iterator(); iterator.hasNext();)
            {
                Role role = iterator.next();
                sb.append("\t" + role.getName() + "\n");
            }
            throw new PortletSecurityException(sb.toString());
        }
        if (storeId == null && isSuperUser)
        {
            storeId = defaultStoreId;
        }

        // Create the return object
        RolesAndStore ras = new RolesAndStore();
        ras.setKkRoles(retList);
        ras.setStoreId(storeId);
        ras.setKkAdminEng(kkAdminEng);
        ras.setSessionId(sessionId);
        return ras;
    }

    /**
     * Initialize global variables from the properties file.
     * 
     * @throws PortletException
     */
    private void getProperties() throws PortletException
    {
        try
        {
            /*
             * Portlet properties file
             */
            URL propsFileURL = PropertyFileFinder.findPropertiesURL(PORTLET_PROPS_FILE);
            PropertiesConfiguration propsConfig = new PropertiesConfiguration(propsFileURL);
            Configuration subConf = propsConfig.subset("konakartadmin");
            superUserId = subConf.getString(PROP_SUPER_USER);
            if (superUserId == null)
            {
                throw new KKAdminException("The property " + PROP_SUPER_USER
                        + " cannot be found in the properties file " + PORTLET_PROPS_FILE);
            }
            defaultStoreId = subConf.getString(PROP_DEFAULT_STORE);
            if (defaultStoreId == null)
            {
                throw new KKAdminException("The property " + PROP_DEFAULT_STORE
                        + " cannot be found in the properties file " + PORTLET_PROPS_FILE);
            }

            /*
             * GWT properties file
             */
            propsFileURL = PropertyFileFinder.findPropertiesURL(GWT_PROPS_FILE);
            propsConfig = new PropertiesConfiguration(propsFileURL);
            subConf = propsConfig.subset("konakartadmin.gwt");
            adminEngClass = subConf.getString(PROP_ENGINE_CLASS);
            if (adminEngClass == null)
            {
                throw new KKAdminException("The property " + PROP_ENGINE_CLASS
                        + " cannot be found in the properties file " + GWT_PROPS_FILE);
            }
            engMode = subConf.getInt(PROP_ENGINE_MODE, -1);
            if (engMode == -1)
            {
                throw new KKAdminException("The property " + PROP_ENGINE_MODE
                        + " cannot be found in the properties file " + GWT_PROPS_FILE);
            }
            customersShared = subConf.getBoolean(PROP_CUSTOMERS_SHARED);
            productsShared = subConf.getBoolean(PROP_PRODUCTS_SHARED);
        } catch (Exception e)
        {
            throw new PortletException(e);
        }
    }

    /**
     * Initialize an engine for the Super User that can be used to register other users.
     * 
     * @throws KKAdminException
     */
    private KKAdminIf getSuperUserEng(String storeId) throws Exception
    {
        KKAdminEngineMgr kkAdminEngMgr = new KKAdminEngineMgr();
        AdminEngineConfig conf = new AdminEngineConfig();
        conf.setMode(engMode);
        conf.setStoreId(storeId);
        conf.setCustomersShared(customersShared);
        conf.setProductsShared(productsShared);
        KKAdminIf kkAdminEng = kkAdminEngMgr.getKKAdminByName(adminEngClass, conf);
        if (kkAdminEng == null)
        {
            throw new KKAdminException("Admin engine could not be created with Config parameter = "
                    + conf.toString());
        }

        return kkAdminEng;
    }

    /**
     * Get the liferay User object with details about the user
     * 
     * @param userId
     * @return Returns a User object
     */
    private User getUserProfile(String userId)
    {
        User liferayUser = null;
        if (userId == null)
        {
            // the user seems not to be logged in
            return liferayUser;
        }

        try
        {
            liferayUser = UserLocalServiceUtil.getUser(Long.parseLong(userId));
        } catch (NestableException e)
        {
            log.error(e);
        }
        if (liferayUser == null && log.isWarnEnabled())
        {
            log.warn("User with id " + userId + " could not be found");
        }
        return liferayUser;
    }

    /**
     * Private class to contain the KonaKart user name of the user and the store id
     */
    private class UserAndStore
    {
        String kkUserName;

        String storeId;

        /**
         * @return the kkUserName
         */
        public String getKkUserName()
        {
            return kkUserName;
        }

        /**
         * @param kkUserName
         *            the kkUserName to set
         */
        public void setKkUserName(String kkUserName)
        {
            this.kkUserName = kkUserName;
        }

        /**
         * @return the storeId
         */
        public String getStoreId()
        {
            return storeId;
        }

        /**
         * @param storeId
         *            the storeId to set
         */
        public void setStoreId(String storeId)
        {
            this.storeId = storeId;
        }
    }

    /**
     * Private object to contain a list of KonaKart roles and the storeId
     */
    private class RolesAndStore
    {
        List<AdminRole> kkRoles;

        String storeId;

        KKAdminIf kkAdminEng;

        String sessionId;

        /**
         * @return the kkRoles
         */
        public List<AdminRole> getKkRoles()
        {
            return kkRoles;
        }

        /**
         * @param kkRoles
         *            the kkRoles to set
         */
        public void setKkRoles(List<AdminRole> kkRoles)
        {
            this.kkRoles = kkRoles;
        }

        /**
         * @return the storeId
         */
        public String getStoreId()
        {
            return storeId;
        }

        /**
         * @param storeId
         *            the storeId to set
         */
        public void setStoreId(String storeId)
        {
            this.storeId = storeId;
        }

        /**
         * @return the kkAdminEng
         */
        public KKAdminIf getKkAdminEng()
        {
            return kkAdminEng;
        }

        /**
         * @param kkAdminEng
         *            the kkAdminEng to set
         */
        public void setKkAdminEng(KKAdminIf kkAdminEng)
        {
            this.kkAdminEng = kkAdminEng;
        }

        /**
         * @return the sessionId
         */
        public String getSessionId()
        {
            return sessionId;
        }

        /**
         * @param sessionId
         *            the sessionId to set
         */
        public void setSessionId(String sessionId)
        {
            this.sessionId = sessionId;
        }
    }
}